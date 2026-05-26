using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
using System.Linq;
#endif

namespace Commons.Game
{
    public partial class GameUnit
    {
        public class UnitBoundingBoxEnvelope : BoundingBoxEnvelope
        {
            public readonly GameUnit Unit;

            public UnitBoundingBoxEnvelope(GameUnit unit) : base(unit.HitGeometry.GetBoundingBox())
            {
                Unit = unit;
            }
        }
        
        private bool _inited;
        
        public GameBoard Board { private set; get; }
        private ResourceTrigger? _triggerOnUpdate;
        private ResourceTrigger? _triggerOnAttack;
        private ResourceTrigger? _triggerOnAttacked;
        private ResourceTrigger? _triggerOnAttackedPost;
        private ResourceTrigger? _triggerOnHeal;
        private ResourceTrigger? _triggerOnHealed;
        private ResourceTrigger? _triggerOnBuffApply;
        private ResourceTrigger? _triggerOnKill;
        private ResourceTrigger? _triggerOnOwnerKill;
        private ResourceTrigger? _triggerOnDead;
        private ResourceTrigger? _triggerOnDestroy;

        public ResourceUnit ResUnit { private set; get; }

        public Circle HitGeometry { get; private set; } = new(FixedVector2.zero, 0f);
        internal UnitBoundingBoxEnvelope HitBoundingBoxEnvelope { get; private set; }
        public FixedVector2 Center => (FixedVector2)position_ + ShotOffset;
        internal FixedFloat HitSize => ResUnit.HitSize * Scale;
        internal FixedFloat CollideSize => ResUnit.CollideSize * Scale;

        internal FixedVector2 CollideOffset => (ResUnit.CollideOffset ?? FixedVector2.zero) * Scale;
        internal FixedVector2 ShotOffset => (ResUnit.ShotOffset ?? FixedVector2.zero) * Scale;
        internal FixedVector2 HitOffset => (ResUnit.HitOffset ?? FixedVector2.zero) * Scale;

        public GameUnit? Target
        {
            get => Board.GetUnitById(targetUnitId_);
            internal set => targetUnitId_ = value?.id_ ?? 0L;
        }

        public bool Destroyed { private set; get; }
        
        public bool IsEnemyWith(GameUnit other)
        {
            return Board.IsEnemyWith(team_, other.team_);
        }
        
        public bool IsValidTarget(GameUnit other)
        {
            return !other.Destroyed && IsEnemyWith(other) && other.IsAlive && !other.ResUnit.ContainsTag(Tag.Untargetable);
        }

        partial void OnConstruction()
        {
            variables_ = new ResourceTrigger.Types.Variables();
        }

        internal GameUnit Init(GameBoard board, GameUnit? owner = null)
        {
            if (_inited)
                return this;
            _inited = true;
            Board = board;
            
            ResUnit = ResourceUnit.Get(dataId_)!;
            
            if (Config.IsDebug && ResUnit == null)
            {
                Config.LogError($"GameUnit.Init failed: ResourceUnit [{dataId_}] doesn't exist");
                throw new InvalidOperationException();
            }
            
            _triggerOnUpdate = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnUpdate);
            _triggerOnAttack = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnAttack);
            _triggerOnAttacked = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnAttacked);
            _triggerOnAttackedPost = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnAttackedPost);
            _triggerOnHeal = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnHeal);
            _triggerOnHealed = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnHealed);
            _triggerOnBuffApply = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnBuffApply);
            _triggerOnKill = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnKill);
            _triggerOnOwnerKill = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnOwnerKill);
            _triggerOnDead = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnDead);
            _triggerOnDestroy = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnDestroy);

            if (tick_ == 0)
            {
                if (level_ == 0)
                    level_ = 1;

                initPosition_ = position_.Clone();
                
                targetMode_ = ResUnit.TargetMode;
                targetAwareDistance_ = ResUnit.TargetAwareDistance;
                targetResetDistance_ = ResUnit.TargetResetDistance;

                ArmorType = ResUnit.ArmorType;
            }

            //생성된 이후 Init이 호출 될 때에는 기존 Owner를 참조하여 Owner.children에 Caching
            SetOwner(owner ?? Owner);

            HitBoundingBoxEnvelope = new UnitBoundingBoxEnvelope(this);
            
            InitBuffs();
            ClearReplaceSkillDataIds();
            RecalculateStat(tick_ == 0);
            ApplyAddShield();
            RefreshHitGeometry();

            return this;
        }

        internal void SetLevel(int level)
        {
            level_ = level;
            exp_ = 0L;
            SetStatDirty();
        }
        
        internal void AddExp(long exp, bool applyExpStat = true)
        {
            if (applyExpStat)
                exp = (long)(exp * Stat.ExpPercent);
            exp_ += exp;
            RefreshExp();
        }

        internal void IncreaseLevel(int count)
        {
            var exp = 0L;
            var currentLevel = level_;
            for (int i = 0; i < count; i++)
            {
                exp += Board.ResMap.RequiredExps.GetSafe(level_ - 1 + i);    
            }
            AddExp(exp);
        }
        
        private int RefreshExp()
        {
            var levelUp = 0;
            var prevLevel = level_;
            while (true)
            {
                var requiredExp = Board.ResMap.RequiredExps.GetSafe(level_ - 1);
                if (requiredExp == 0L || exp_ < requiredExp)
                    break;
                exp_ -= requiredExp;
                level_ += 1;
                levelUp += 1;
            }
            var newLevel = level_;

            HandleLevelUpAddItems(prevLevel, newLevel);

            return levelUp;
        }

        private void HandleLevelUpAddItems(int prevLevel, int newLevel)
        {
            var levelUp = newLevel - prevLevel;
            if (levelUp > 0)
            {

                Player?.IncreaseMission(ResourceAchievement.Types.Condition.MissionUnitLevelUp, levelUp);
            }
            
        }
        
        private ResourceTrigger.Types.State CreateState()
        {
            var state = ResourceTrigger.Types.State.Rent(variables_);
            state.callerUnit = this;
            return state;
        }

        private void RefreshTarget()
        {
            if (targetMode_ == ResourceUnit.Types.TargetMode.Chaser)
            {
                var position = (FixedVector2)position_;
                
                using var targets = ConcurrentObjectPool<PooledList<GameUnit?>>.StaticPool.Pop();
                targets.AddRange(FindTargets());
                targets.Sort((x, y) =>
                {
                    var squaredDistanceX = ((FixedVector2)x.position_ - position).sqrMagnitude;
                    var squaredDistanceY = ((FixedVector2)y.position_ - position).sqrMagnitude;
                    return squaredDistanceX.CompareTo(squaredDistanceY);
                });
                
                var closestUnit = targets.FirstOrDefault();

                if (closestUnit != null)
                    Target = closestUnit;
                else
                {
                    var target = Target;
                    if (target != null)
                    {
                        if (!IsValidTarget(target))
                            Target = null;
                        else if (!position.IsCloserThan(target.position_, targetResetDistance_))
                            Target = null;
                    }
                }
            }
        }

        
        private GameUnit? FindTarget(Comparison<UnitBoundingBoxEnvelope> func)
        {
            var targetAwareDistance = (FixedFloat)targetAwareDistance_;
            var position = (FixedVector2)position_;
            using var envelops = 
                Board.GetUnitsInBound(new BoundingBox(position, new FixedVector2(targetAwareDistance, targetAwareDistance)));
            envelops.RemoveAll(envelop => !IsValidTarget(envelop.Unit));

            switch (envelops.Count)
            {
                case 0:
                    return null;
                case 1:
                    return envelops[0].Unit;
                default:
                    envelops.Sort(func);
                    return envelops[0].Unit;
            }
        }
        
        private IEnumerable<GameUnit?> FindTargets()
        {
            var targetAwareDistance = (FixedFloat)targetAwareDistance_;
            var position = (FixedVector2)position_;
            using var envelops = 
                Board.GetUnitsInBound(new BoundingBox(position, new FixedVector2(targetAwareDistance, targetAwareDistance)));

            foreach (var envelope in envelops)
            {
                if (!IsValidTarget(envelope.Unit))
                    continue;
                
                yield return envelope.Unit;
            }
        }

        private GameUnit? GetRandomTarget()
        {
            var targetAwareDistance = (FixedFloat)targetAwareDistance_;
            var position = (FixedVector2)position_;
            using var envelops = 
                Board.GetUnitsInBound(new BoundingBox(position, new FixedVector2(targetAwareDistance, targetAwareDistance)));
            envelops.RemoveAll(envelop => !IsValidTarget(envelop.Unit));
            
            switch (envelops.Count)
            {
                case 0:
                    return null;
                case 1:
                    return envelops[0].Unit;
                default:
                    return envelops.PickOne(Board)!.Unit;
            }
        }

        private void RunTriggerOnUpdate()
        {
            if (_triggerOnUpdate == null)
                return;
            if ((tick_ + tickOffset_) % _triggerOnUpdate.Period != 0)
                return;
            
            using var state = CreateState();
            _triggerOnUpdate.Run(Board, state);
        }
        
        internal void RunLogic()
        {
            try
            {
                RunLogicInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameUnit.RunLogic failed: {ex}");
            }
        }

        private void RunLogicInternal()
        {
            if (Destroyed)
                return;

            if (tick_ == 0)
            {
                SetPosition(position_);
                SetDirection(direction_);
                DisableAction(GameBoard.TimeToTicks(ResUnit.WarmupDelay));
                
                if (_triggerOnUpdate != null)
                    tickOffset_ = (uint)Board.Random((int)_triggerOnUpdate.Period);
                
                foreach (var initVariable in ResUnit.InitVariables)
                    variables_.Set(initVariable.CallerKey, initVariable.Value);

                // foreach (var (skillDataId, skillLevel) in InitSkills)
                // {
                //     UseSkill(skillDataId, level: skillLevel);
                // }
                
                if (playerAvatar_ != null)
                {
                    foreach (var equipment in playerAvatar_.Equipments)
                    {
                        if(equipment.ItemDataId == 0) continue;
                        var data = equipment.GetData()!;
                        foreach (var dataEquipAddBuff in data.EquipAddBuffs)
                        {
                            
                            QueueAddBuff(new QueuedAddBuff(null, dataEquipAddBuff));    
                        }
            
                        if (data.SkillDataId != 0)
                            UseSkill(data.SkillDataId, level: equipment.Level);
                    }
                }

                if (Player != null)
                {
                    // init buff for passive traits
                    foreach (var trait in Player.AppliedTraits)
                    {
                        if(trait.ItemDataId == 0) continue;
                        var data = trait.GetData()!;
                        if (data.Type != ResourceItem.Types.Type.Passive) continue;
                        foreach (var dataEquipAddBuff in data.EquipAddBuffs)
                        {
                            QueueAddBuff(new QueuedAddBuff(null, dataEquipAddBuff.BuffDataId, Math.Max((int) trait.Count, dataEquipAddBuff.Level)));
                        }

                        if (data.SkillDataId != 0)
                            UseSkill(data.SkillDataId, level: (int) trait.Count);
                    }
                }
            
                
                var triggerOnStart = ResUnit.GetTrigger(ResourceTrigger.Types.Type.OnStart);
                using var state = CreateState();
                triggerOnStart?.Run(Board, state);
            }
            
            tick_ += 1;
            
            if (IsAlive)
            {
                RegenStat();
                RefreshTarget();
                RunTriggerOnUpdate();
                RunEquipSkillLogic();
                switch (ResUnit.Type)
                {
                    case ResourceUnit.Types.Type.Player:
                        RunPlayerLogic();
                        break;
                }
            }

            if (_statDirty)
            {
                _statDirty = false;
                RecalculateStat();
                ApplyAddShield();
            }
        }

        private void RunPlayerLogic()
        {
            var prevLevel = variables_.GetIntPredefinedVariable(Board, PredefinedVariable.Types.Type.Level);
            if (prevLevel != level_)
            {
                variables_.SetPredefinedVariable(Board, PredefinedVariable.Types.Type.Level, level_);
                if (prevLevel > 0 && prevLevel < level_ && ResourceSkill.Global.DataId.PlayerLevelUp != 0)
                    UseSkill(ResourceSkill.Global.DataId.PlayerLevelUp, ignoreActable: true);
            }

            ++noDamageTick_;
        }

        private void RunEquipSkillLogic()
        {
            foreach (var skillDataId in equipSkillDataIds_)
            {
                var resourceSkill = ResourceSkill.Get(skillDataId);
                if (resourceSkill == null)
                    continue;
                if (ResUnit.ContainsTag(Tag.UseSkillWhenHasTarget) && targetUnitId_ == 0L)
                    continue;
                
                UseSkill(skillDataId);
            }
        }
        
        internal void Update()
        {
            try
            {
                UpdateInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameUnit.Update failed: {ex}");
            }
        }

        private void UpdateInternal()
        {
            UpdateDestroy();
            if (Destroyed)
                return;
            
            UpdateRespawn();
            UpdateState();
            UpdateMove();
            GetDropItems();
            UpdatePlayer();
            UpdateAdditionalAttackSkill();
        }

        public void Destroy()
        {
            if (Destroyed)
                return;
            Destroyed = true;
            SetOwner(null);
            Board.QueueDestroyUnit(this);
            using var state = CreateState();
            _triggerOnDestroy?.Run(Board, state);
        }
        
        public void DestroyWithDelay(uint delay)
        {
            if (Destroyed)
                return;
            destroyTick_ = delay;
        }

        private void UpdateDestroy()
        {
            if (destroyTick_ > 0 && --destroyTick_ == 0)
                Destroy();
        }
        
        public void RespawnWithDelay(uint delay)
        {
            if (Destroyed)
                return;
            respawnTick_ = respawnTick_ > 0 ? Math.Min(respawnTick_, delay) : delay;
        }
        
        private void UpdateRespawn()
        {
            if (respawnTick_ > 0 && --respawnTick_ == 0)
                HandleRespawn();
        }
    }
}
