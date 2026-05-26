using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;

namespace Commons.Game
{
    public partial class GameBuff
    {
        private class BuffDurationOutOfRangeException : Exception
        {
            public BuffDurationOutOfRangeException(string message) : base(message) { }
            
            public BuffDurationOutOfRangeException(string message, Exception innerException) : base(message, innerException) { }
        }
        
        private static readonly FixedFloat MaxBuffDuration = 86400f; // Maximum duration for a buff, to prevent infinite durations
        
        private bool _inited;

        public GameBoard Board { private set; get; }
        public GameUnit Unit { private set; get; }
        private ResourceTrigger? _triggerOnUpdate;
        private ResourceTrigger? _triggerOnAttack;
        private ResourceTrigger? _triggerOnAttacked;
        private ResourceTrigger? _triggerOnAttackedPost;
        private ResourceTrigger? _triggerOnHeal;
        private ResourceTrigger? _triggerOnDestroy;
        private ResourceTrigger? _triggerOnKill;
        private ResourceTrigger? _triggerOnOwnerKill;
        private ResourceTrigger? _triggerOnBuffApply;
        

        public ResourceBuff ResBuff { private set; get; }
        private uint _delay;
        private uint _periodDefine;

        public bool Destroyed { private set; get; }

        partial void OnConstruction()
        {
            variables_ = new ResourceTrigger.Types.Variables();
        }
        
        internal GameBuff Init(GameBoard board, GameUnit unit)
        {
            if (_inited)
                return this;
            _inited = true;
            Board = board;
            Unit = unit;
            
            ResBuff = ResourceBuff.Get(dataId_)!;
            
            _triggerOnUpdate = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnUpdate);
            _triggerOnAttack = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnAttack);
            _triggerOnAttacked = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnAttacked);
            _triggerOnAttackedPost = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnAttackedPost);
            _triggerOnHeal = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnHeal);
            _triggerOnDestroy = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnDestroy);
            _triggerOnKill = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnKill);
            _triggerOnOwnerKill = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnOwnerKill);
            _triggerOnBuffApply = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnBuffApply);
            
            _delay = GameBoard.TimeToTicks(ResBuff.Delay);
            _periodDefine = GameBoard.TimeToTicks(ResBuff.Period);

            if (tick_ == 0)
            {
                if (ttl_ == 0 && !ResBuff.ContainsTag(Tag.NoExpiration))
                    ttl_ = GameBoard.TimeToTicksDuration(ResBuff.Duration);

                if (level_ == 0)
                    level_ = 1;
            }

            return this;
        }
        
        internal void ApplyDuration(GameUnit.QueuedAddBuff addBuff)
        {
            if (ResBuff.ContainsTag(Tag.NoExpiration))
            {
                ttl_ = 0;
                return;
            }
            
            var buffApplicant = addBuff.Attacker;
            
            FixedFloat duration = ResBuff.Duration;
            if (addBuff.Duration > 0f)
                duration = addBuff.Duration;

            if (duration == FixedFloat.Zero || duration >= MaxBuffDuration)
            {
                throw new BuffDurationOutOfRangeException(
                    $"Buff duration is out of range: {duration}. Buff: {ResBuff.Id}, Applicant: {buffApplicant?.Id ?? 0L}, Unit: {Unit.Id}");
            }
            
            var durationEfficiencyPercent = Unit.Stat.BuffDurationEfficiencyPercent;
            durationEfficiencyPercent += Unit.BuffGroupStats.GetValueOrDefault(ResBuff.Group)?.BuffDurationEfficiencyPercent ?? FixedFloat.Zero;

            if (buffApplicant != null)
            {
                if (Unit.Id == buffApplicant.Id)
                {
                    durationEfficiencyPercent += buffApplicant.Stat.SelfBuffDurationEfficiencyPercent;
                    durationEfficiencyPercent += buffApplicant.BuffGroupStats.GetValueOrDefault(ResBuff.Group)?.SelfBuffDurationEfficiencyPercent ?? FixedFloat.Zero;
                }
                else if (Unit.IsEnemyWith(buffApplicant))
                {
                    durationEfficiencyPercent += buffApplicant.Stat.EnemyBuffDurationEfficiencyPercent;
                    durationEfficiencyPercent += buffApplicant.BuffGroupStats.GetValueOrDefault(ResBuff.Group)?.EnemyBuffDurationEfficiencyPercent ?? FixedFloat.Zero;
                }
                else
                {
                    durationEfficiencyPercent += buffApplicant.Stat.TeamBuffDurationEfficiencyPercent;
                    durationEfficiencyPercent += buffApplicant.BuffGroupStats.GetValueOrDefault(ResBuff.Group)?.TeamBuffDurationEfficiencyPercent ?? FixedFloat.Zero;
                }
            }
            
            duration *= FixedFloat.One + durationEfficiencyPercent / FixedFloat.Hundred;

            ttl_ = Math.Max(ttl_, GameBoard.TimeToTicksDuration(duration));
        }
        
        private ResourceTrigger.Types.State CreateState()
        {
            var state = ResourceTrigger.Types.State.Rent(variables_); 
            state.callerUnit = Unit;
            state.callerBuff = this;
            state.slotUnit = Attacker;
            return state;
        }

        internal void HandleBuffApply(GameUnit? buffApplicant, GameBuff appliedBuff)
        {
            if (_triggerOnBuffApply == null)
                return;
            
            using var state = CreateState();
            state.slotUnit = buffApplicant ?? state.slotUnit;
            state.slotBuff = appliedBuff;

            _triggerOnBuffApply.Run(Board, state);
        }
        
        internal void HandleOwnerKill(GameUnit owner, IAttackSource? attackSource = null)
        {
            if (_triggerOnOwnerKill == null)
                return;
            
            using var state = CreateState();
            state.slotUnit = owner;

            var gameBuff = attackSource as GameBuff;
            var gameSkill = attackSource as GameSkill;

            state.slotBuff = gameBuff;
            state.slotSkill = gameSkill;

            _triggerOnOwnerKill.Run(Board, state);
        }

        private void RunTriggerOnUpdate()
        {
            if (_triggerOnUpdate == null)
                return;
            if ((Tick - 1) % _triggerOnUpdate.Period != 0)
                return;
            
            using var state = CreateState();
            _triggerOnUpdate.Run(Board, state);
        }

        internal void OverrideBuff(GameUnit.QueuedAddBuff queuedAddBuff, GameUnit? buffApplicant)
        {
            team_ = buffApplicant?.Team ?? 0;
            attackerUnitId_ = buffApplicant?.Id ?? 0L;
            var level = queuedAddBuff.Level;
            if (ResBuff.ContainsTag(Tag.LevelUpOnStacked))
                level_ = Math.Min(ResBuff.MaxLevel, level_ + level);
            else
                level_ = Math.Max(level_, level);
            
            stack_ = Math.Min(ResBuff.MaxStack, stack_ + ResBuff.Stack);

            ApplyDuration(queuedAddBuff);

            pendingPeriod_ = 0;
            RunInitialLogic();
            //RunPeriodicLogic();
            RunMaxStackLogic();
        }

        private void ProgressPeriod()
        {
            while (_periodDefine != 0 && tick_ >= _delay && pendingPeriod_ >= _periodDefine)
            {
                pendingPeriod_ -= _periodDefine;
                RunPeriodicLogic();
                RunPeriodicStackLogic();
            }
        }

        private void RunPeriodicLogic()
        {
            var isMaxLevel = ResBuff.MaxLevel > 0 && level_ == ResBuff.MaxLevel;

            if (isMaxLevel && ResBuff.MaxLevelPeriodicAddDamage != null)
                Unit.AddDamage(this, ResBuff.MaxLevelPeriodicAddDamage);
            else if (ResBuff.PeriodicAddDamage != null)
                Unit.AddDamage(this, ResBuff.PeriodicAddDamage);
            
            if (isMaxLevel && ResBuff.MaxLevelPeriodicAddHeal != null)
                Unit.AddHeal(this, ResBuff.MaxLevelPeriodicAddHeal);
            else if (ResBuff.PeriodicAddHeal != null)
                Unit.AddHeal(this, ResBuff.PeriodicAddHeal);
            
            if (isMaxLevel && ResBuff.MaxLevelPeriodicUseSkill != null)
                Unit.UseSkill(ResBuff.MaxLevelPeriodicUseSkill);
            else if (ResBuff.PeriodicUseSkill != null)
                Unit.UseSkill(ResBuff.PeriodicUseSkill);
        }

        private void RunPeriodicStackLogic()
        {
            if (ResBuff.PeriodicAddStack > 0)
            {
                if (stack_ < ResBuff.MaxStack)
                    stack_ = Math.Min(stack_ + ResBuff.PeriodicAddStack, ResBuff.MaxStack);
            }
        }
        
        internal void RunLogic()
        {
            try
            {
                RunLogicInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBuff.RunLogic failed: {ex}");
            }
        }

        private void RunLogicInternal()
        {
            if (Destroyed)
                return;

            if (tick_ == 0)
            {
                foreach (var initVariable in ResBuff.InitVariables)
                    variables_.Set(initVariable.CallerKey, initVariable.Value);
                
                var triggerOnStart = ResBuff.GetTrigger(ResourceTrigger.Types.Type.OnStart);
                
                using var state = CreateState();
                triggerOnStart?.Run(Board, state);

                RunInitialLogic();
            }
            
            tick_ += 1;
            RunTriggerOnUpdate();

            pendingPeriod_ += 1;
            ProgressPeriod();

            RunMaxStackLogic();

            if (ttl_ > 0 && --ttl_ == 0)
                Destroy(true);
        }
        
        private void RunInitialLogic()
        {
            if (ResBuff.InitialAddDamage != null)
                Unit.AddDamage(this, ResBuff.InitialAddDamage);
            if (ResBuff.InitialAddHeal != null)
                Unit.AddHeal(this, ResBuff.InitialAddHeal);
        }
        
        private void RunMaxStackLogic()
        {
            if (ResBuff.MaxStack > 0 && stack_ == ResBuff.MaxStack)
            {
                if (ResBuff.MaxStackUseSkill != null)
                    Unit.UseSkill(ResBuff.MaxStackUseSkill);
                foreach (var resBuffMaxStackAddBuff in ResBuff.MaxStackAddBuffs)
                {
                    Unit.QueueAddBuff(new GameUnit.QueuedAddBuff(Attacker, resBuffMaxStackAddBuff));
                }
                
                if (ResBuff.ContainsTag(Tag.ResetStackOnMaxStack))
                    stack_ = 0;
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
                Config.LogError($"GameBuff.Update failed: {ex}");
            }
        }

        private void UpdateInternal()
        {
            if (Destroyed)
                return;
        }

        public void Destroy(bool expired = false)
        {
            if (Destroyed)
                return;
            
            Destroyed = true;
            Unit.QueueDestroyBuff(this);
            
            using var state = CreateState();
            _triggerOnDestroy?.Run(Board, state);

            if (expired)
            {
                if (ResBuff.ExpirationAddDamage != null)
                    Unit.AddDamage(this, ResBuff.ExpirationAddDamage);
                if (ResBuff.ExpirationAddHeal != null)
                    Unit.AddHeal(this, ResBuff.ExpirationAddHeal);
            }
        }
        
        public void SetLevel(int level)
        {
            level = Math.Max(1, level);
            if (level_ == level)
                return;
            
            level_ = level;

            if (ResBuff.HasAddStats())
                Unit.SetStatDirty();
        }
        
        public void SetEnabled(bool isEnabled)
        {
            if (Enabled == isEnabled)
                return;
            
            Enabled = isEnabled;

            if (ResBuff.HasAddStats())
                Unit.SetStatDirty();
        }


    }
}
