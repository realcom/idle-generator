using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameUnit
    {
        public readonly Dictionary<int, SortedDictionary<int, int>> ReplaceSkillDataIds = new();
        public int GetReplaceSkillDataId(int sourceSkillDataId)
        {
            var skillDataId = sourceSkillDataId;
            for (var i = 0; i < 5; ++i)
            {
                if (!ReplaceSkillDataIds.TryGetValue(skillDataId, out var replaceSkillDataIds))
                    return skillDataId;
                if (replaceSkillDataIds.Count == 0)
                    return skillDataId;
                skillDataId = replaceSkillDataIds.First().Key;
            }

            return skillDataId;
        }
        
        internal void AddReplaceSkillDataId(int sourceSkillDataId, int targetSkillDataId)
        {
            if (!ReplaceSkillDataIds.TryGetValue(sourceSkillDataId, out var replaceSkillDataIds))
                ReplaceSkillDataIds[sourceSkillDataId] = replaceSkillDataIds =
                    new SortedDictionary<int, int>(Comparer<int>.Create((a, b) => b.CompareTo(a)));
            replaceSkillDataIds[targetSkillDataId] = replaceSkillDataIds.GetValueOrDefault(targetSkillDataId) + 1;
        }
        
        internal void RemoveReplaceSkillDataId(int sourceSkillDataId, int targetSkillDataId)
        {
            if (!ReplaceSkillDataIds.TryGetValue(sourceSkillDataId, out var replaceSkillDataIds))
                return;
            if (replaceSkillDataIds.TryGetValue(targetSkillDataId, out var count))
            {
                if (count > 1)
                    replaceSkillDataIds[targetSkillDataId] = count - 1;
                else
                    replaceSkillDataIds.Remove(targetSkillDataId);
            }
        }
        
        private void ClearReplaceSkillDataIds()
        {
            ReplaceSkillDataIds.Clear();
        }
        
        public FixedFloat GetSkillCooldown(int skillDataId, long itemId = 0L)
        {
            skillDataId = GetReplaceSkillDataId(skillDataId);
            return GetSkillCooldown(ResourceSkill.Get(skillDataId)!, itemId);
        }

        public void ReduceSkillCooldownByPercent(int skillDataId, long itemId = 0L, float percent = 0f)
        {
            skillDataId = GetReplaceSkillDataId(skillDataId);
            var resSkill = ResourceSkill.Get(skillDataId)!;
            uint cooldownUntil;
            if (itemId == 0L & cooldowns_.TryGetValue(skillDataId, out cooldownUntil))
            {
                cooldowns_[skillDataId] = cooldownUntil - (uint)((cooldownUntil - tick_) * percent / FixedFloat.Hundred);
            }
            else
            {
                if (itemCooldowns_.TryGetValue(itemId, out cooldownUntil))
                    itemCooldowns_[itemId] = cooldownUntil - (uint)((cooldownUntil - tick_) * percent / FixedFloat.Hundred);
            }
        }
        
        public void ResetSkillCooldown(int skillDataId, long itemId = 0L)
        {
            skillDataId = GetReplaceSkillDataId(skillDataId);
            var resSkill = ResourceSkill.Get(skillDataId)!;
            if (itemId == 0L & cooldowns_.TryGetValue(skillDataId, out var _))
            {
                cooldowns_[skillDataId] = tick_;
            }
            else
            {
                if (itemCooldowns_.TryGetValue(itemId, out var _))
                    itemCooldowns_[itemId] = tick_;
            }
        }
        
        private FixedFloat GetSkillCooldown(ResourceSkill resSkill, long itemId = 0L)
        {
            if (itemId == 0L)
            {
                if (!cooldowns_.TryGetValue(resSkill.Id, out var cooldownUntil) && resSkill.InitCooldown > 0f)
                    cooldownUntil = GameBoard.TimeToTicks(resSkill.InitCooldown);
                if (cooldownUntil > tick_)
                    return GameBoard.TicksToTime(cooldownUntil - tick_);
            }
            else
            {
                if (!itemCooldowns_.TryGetValue(itemId, out var cooldownUntil) && resSkill.InitCooldown > 0f)
                    cooldownUntil = GameBoard.TimeToTicks(resSkill.InitCooldown);
                if (cooldownUntil > tick_)
                    return GameBoard.TicksToTime(cooldownUntil - tick_);
            }
            return FixedFloat.Zero;
        }
        
        public bool CanUseSkill(int skillDataId, long targetUnitId = 0L, long itemId = 0L, bool ignoreActable = false, bool checkCooldownBySkillId = false)
        {
            skillDataId = GetReplaceSkillDataId(skillDataId);
            
            var parameter = UseSkillParameter.Default;
            parameter.SkillDataId = skillDataId;
            parameter.TargetUnitId = targetUnitId;
            parameter.ItemId = itemId;
            parameter.IgnoreActable = ignoreActable;
            parameter.CheckCooldownBySkillId = checkCooldownBySkillId;
            
            return CanUseSkill(ResourceSkill.Get(skillDataId)!, parameter);
        }
        
        private bool CanUseSkill(ResourceSkill resSkill, UseSkillParameter parameter)
        {
            if (!resSkill.ContainsTag(Tag.IgnoreAlive) && !IsAlive)
                return false;
            if (resSkill.Priority > 0)
            {
                if (resSkill.Priority <= actionDisabledPriority_)
                    return false;
                
                if (!parameter.IgnoreActable && !resSkill.ContainsTag(Tag.IgnoreActable) && !IsActable)
                    return false;
                
                if (Board.HasBlockedAction(GameBoard.Types.BlockActionFlag.Skill) && !resSkill.ContainsTag(Tag.MovementSkill))
                    return false;
                
                if (Board.HasBlockedAction(GameBoard.Types.BlockActionFlag.Move) && resSkill.ContainsTag(Tag.MovementSkill))
                    return false;
            }
            
            if (resSkill.ContainsTag(Tag.AutoAim) && (Board.GetUnitById(parameter.TargetUnitId) ?? Target) == null)
                return false;

            if (parameter.CheckCooldown)
            {
                uint cooldownUntil;
                if (parameter.CheckCooldownBySkillId || parameter.ItemId == 0L)
                {
                    if (!cooldowns_.TryGetValue(resSkill.Id, out cooldownUntil) && resSkill.InitCooldown > 0f)
                        cooldownUntil = GameBoard.TimeToTicks(resSkill.InitCooldown);
                }
                else
                {
                    if (!itemCooldowns_.TryGetValue(parameter.ItemId, out cooldownUntil) && resSkill.InitCooldown > 0f)
                        cooldownUntil = GameBoard.TimeToTicks(resSkill.InitCooldown);
                }

                if (cooldownUntil > 0 && cooldownUntil >= tick_)
                    return false;
            }
            
            return true;
        }

        internal void UseSkill(UseSkill? useSkill, FixedVector2? position = null, FixedVector2? direction = null,
            long targetUnitId = 0L, float timelineSpeed = 0f, long itemId = 0, int itemDataId = 0, int level = 1,
            bool ignoreActable = false, bool checkCooldownBySkillId = false, bool checkCooldown = true)
        {
            // useSKill의 position은 offset 개념. 파라미터의 position은 절대 좌표.
            // useSkill의 toTarget은 caller에서 전처리해줘야 함.
            if (useSkill == null)
                return;

            if (position == null && useSkill.Position != null)
                position = position_;
            
            direction ??= direction_;
            
            if (useSkill.Position != null)
                position += ((FixedVector2)useSkill.Position).Rotate(direction.Value);
            if (useSkill.Rotation != 0f)
                direction = direction.Value.Rotate(FixedFloatMath.Deg2Rad * useSkill.Rotation);

            UseSkill(new UseSkillParameter
            {
                SkillDataId = useSkill.SkillDataId,
                Position = position,
                Direction = direction,
                TargetUnitId = targetUnitId,
                TimelineSpeed = timelineSpeed,
                ItemId = itemId,
                ItemDataId = itemDataId,
                Level = level,
                IgnoreActable = ignoreActable,
                CheckCooldown = checkCooldown,
                CheckCooldownBySkillId = checkCooldownBySkillId
            });
        }
        
        internal void UseSkill(int skillDataId, FixedVector2? position = null, FixedVector2? direction = null,
            long targetUnitId = 0L, float timelineSpeed = 0f, long itemId = 0, int itemDataId = 0, int level = 0,
            bool ignoreActable = false, bool checkCooldownBySkillId = false, bool checkCooldown = true)
        {
            UseSkill(new UseSkillParameter
            {
                SkillDataId = skillDataId,
                Position = position,
                Direction = direction,
                TargetUnitId = targetUnitId,
                TimelineSpeed = timelineSpeed,
                ItemId = itemId,
                ItemDataId = itemDataId,
                Level = level,
                IgnoreActable = ignoreActable,
                CheckCooldown = checkCooldown,
                CheckCooldownBySkillId = checkCooldownBySkillId
            });
        }

        internal void UseSkill(UseSkillParameter parameter, bool fromAdditionalAttack = false)
        {
            parameter.SkillDataId = GetReplaceSkillDataId(parameter.SkillDataId);
            var resSkill = ResourceSkill.Get(parameter.SkillDataId);
            
            if (resSkill == null)
            {
                Config.LogError($"Invalid skill data id: {parameter.SkillDataId}");
                return;
            }

            // If defined, use the item data id from the skill data
            if (resSkill.ItemDataId != 0)
            {
                parameter.ItemDataId = resSkill.ItemDataId;
            }

            if (parameter.TargetUnitId == 0L && resSkill.ContainsTag(Tag.UseToTarget))
                parameter.TargetUnitId = targetUnitId_;
            
            if(resSkill.TargetRefreshType != ResourceSkill.Types.TargetRefreshType.NoRefresh)
                parameter.TargetUnitId = GetTargetUnitIdUsingTargetRefreshType(resSkill.TargetRefreshType, parameter.TargetUnitId);
            
            if (!CanUseSkill(resSkill, parameter))
                return;
            
            if (resSkill.Cooldown > 0f)
            {
                FixedFloat cooldown = resSkill.Cooldown;
                var cooldownPercent = Stat.CooldownPercent;
                if (parameter.ItemDataId != 0)
                {
                    var resItem = ResourceItem.Get(parameter.ItemDataId)!;
                    cooldownPercent += ItemGroupStats.GetValueOrDefault(resItem.Group)?.CooldownPercent ?? FixedFloat.Zero;
                }

                if (parameter.ItemId != 0)
                {
                    if (Board.PlayerActiveInventoryData.TryGetValue(playerId_, out var activeInventoryData) &&
                        activeInventoryData.SlotsByItemId.TryGetValue(parameter.ItemId, out var slots))
                    {
                        foreach (var slot in slots)
                        {
                            cooldownPercent += SlotStats.GetValueOrDefault(slot)?.CooldownPercent ?? FixedFloat.Zero;
                        }
                    }
                }

                cooldown *= FixedFloat.One - cooldownPercent / (FixedFloat.Fifty + cooldownPercent);
                
                var cooldownTick = GameBoard.TimeToTicksDuration(cooldown);
                if (parameter.ItemId == 0L)
                    cooldowns_[parameter.SkillDataId] = tick_ + cooldownTick;
                else
                    itemCooldowns_[parameter.ItemId] = tick_ + cooldownTick;
            }

            if (parameter.Position == null)
            {
                parameter.Position = position_;
                if (resSkill.ContainsTag(Tag.TargetPosition))
                {
                    var target = Board.GetUnitById(parameter.TargetUnitId);
                    if (target != null)
                        parameter.Position = target.Center;
                }
            }
            
            if (resSkill.ContainsTag(Tag.AbsoluteRotation))
                parameter.Direction = FixedVector2.right;
            else
                parameter.Direction ??= direction_;
            
            if (parameter.TargetUnitId != 0L)
            {
                var target = Board.GetUnitById(parameter.TargetUnitId);
                if (target != null)
                {
                    var targetPosition = target.Center;
                    LookAt(targetPosition);
                    parameter.Direction = (targetPosition - Center).normalized;
                }
            }

            if (parameter.TimelineSpeed == 0f)
                parameter.TimelineSpeed = (float)AttackSpeed;
            
            if (parameter.Level <= 0)
                parameter.Level = 1;
            
            var skill = new GameSkill
            {
                DataId = parameter.SkillDataId,
                ItemId = parameter.ItemId,
                ItemDataId = parameter.ItemDataId,
                Team = team_,
                TimelineSpeed = parameter.TimelineSpeed,
                Level = parameter.Level,
                SenderUnitId = id_,
                TargetUnitId = parameter.TargetUnitId,
                Position = (Vector2Message)parameter.Position,
                Direction = (Vector2Message)parameter.Direction,
                Velocity = new Vector2Message(),
                Acceleration = new Vector2Message()
            };
            Board.QueueAddSkill(skill);

            if (resSkill.ContainsTag(Tag.AdditionalAttackPossible) && !fromAdditionalAttack)
            {
                var additionalAttackPercent = Stat.AdditionalAttackPercent;

                if (parameter.ItemDataId != 0)
                {
                    var resItem = ResourceItem.Get(parameter.ItemDataId)!;
                    additionalAttackPercent += ItemGroupStats.GetValueOrDefault(resItem.Group)?.AdditionalAttackPercent ?? FixedFloat.Zero;
                }
                
                if (parameter.ItemId != 0)
                {
                    if (Board.PlayerActiveInventoryData.TryGetValue(playerId_, out var activeInventoryData) &&
                        activeInventoryData.SlotsByItemId.TryGetValue(parameter.ItemId, out var slots))
                    {
                        foreach (var slot in slots)
                        {
                            additionalAttackPercent += SlotStats.GetValueOrDefault(slot)?.AdditionalAttackPercent ?? FixedFloat.Zero;
                        }
                    }
                }

                additionalAttackPercent /= FixedFloat.Hundred;
                var additionalAttackCount = (int)FixedFloatMath.Max(FixedFloat.Zero, additionalAttackPercent / FixedFloat.One);

                additionalAttackPercent = FixedFloatMath.Max(FixedFloat.Zero, additionalAttackPercent % FixedFloat.One);
                var hasAdditionalAttack = additionalAttackPercent > FixedFloat.Zero && Board.RandomFloat() < additionalAttackPercent;
                if (hasAdditionalAttack)
                    additionalAttackCount++;

                var additionalParameter = parameter;
                // not use cooldown for additional attack
                additionalParameter.CheckCooldown = false;
                for (var i = 0; i < additionalAttackCount; i++)
                {
                    QueueAdditionalAttackSkill(additionalParameter);
                }
            }
            
            if (resSkill.Priority >= 0)
                CancelSkillsByPriority(resSkill.Priority);
                
            if (resSkill.DisableMove > 0f)
                DisableMove(GameBoard.TimeToTicksDuration(resSkill.DisableMove));
            if (resSkill.DisableAction > 0f)
                DisableAction(GameBoard.TimeToTicksDuration(resSkill.DisableAction), resSkill.DisableActionPriority);

            if (resSkill.ContainsTag(Tag.SelfRespawn))
            {
                if (resSkill.ContainsTag(Tag.PurchasedSkill))
                {
                    HandlePurchaseRespawn();   
                }
                else
                {
                    HandleRespawn();
                }
            }
            if (resSkill.ContainsTag(Tag.SelfRespawnWhenDead) && !IsAlive)
            {
                if (resSkill.ContainsTag(Tag.PurchasedSkill))
                {
                    HandlePurchaseRespawn();   
                }
                else
                {
                    HandleRespawn();
                }
            }
            if (resSkill.ContainsTag(Tag.RemoveUnitBuffs))
            {
                var target = Board.GetUnitById(parameter.TargetUnitId);
                target?.RemoveAllBuffs();
            }
            if (resSkill.ContainsTag(Tag.SelfRemoveUnitDebuffs))
                RemoveAllDebuffs();

            if (resSkill.ContainsTag(Tag.CopyRandomInventoryItem))
            {
                Board.CopyRandomInventoryItem(playerId_);   
            }

            if (resSkill.ContainsTag(Tag.CopyRandomInventoryItemToFirstGrade))
            {
                Board.CopyRandomInventoryItem(playerId_, grade: 1);
            }
        }

        public long GetTargetUnitIdUsingTargetRefreshType(ResourceSkill.Types.TargetRefreshType targetRefreshType, long targetUnitId)
        {
            switch (targetRefreshType)
            {
                case ResourceSkill.Types.TargetRefreshType.ClearTarget:
                {
                    return 0L;
                }
                case ResourceSkill.Types.TargetRefreshType.Random:
                {
                    return GetRandomTarget()?.Id ?? targetUnitId;
                }
                case ResourceSkill.Types.TargetRefreshType.LowestHp:
                {
                    return FindTarget((a, b) => a.Unit.hp_.CompareTo(b.Unit.hp_))?.Id ?? targetUnitId;
                }
                case ResourceSkill.Types.TargetRefreshType.HighestHp:
                {
                    return FindTarget((a, b) => b.Unit.hp_.CompareTo(a.Unit.hp_))?.Id ?? targetUnitId;
                }
                case ResourceSkill.Types.TargetRefreshType.Nearest:
                {
                    return FindTarget((x, y) =>
                    {
                        var squaredDistanceX = ((FixedVector2)x.Unit.position_ - position_).sqrMagnitude;
                        var squaredDistanceY = ((FixedVector2)y.Unit.position_ - position_).sqrMagnitude;
                        return squaredDistanceX.CompareTo(squaredDistanceY);
                    })?.Id ?? targetUnitId;
                }
                case ResourceSkill.Types.TargetRefreshType.Furthest:
                {
                    return FindTarget((x, y) =>
                    {
                        var squaredDistanceX = ((FixedVector2)x.Unit.position_ - position_).sqrMagnitude;
                        var squaredDistanceY = ((FixedVector2)y.Unit.position_ - position_).sqrMagnitude;
                        return squaredDistanceY.CompareTo(squaredDistanceX);
                    })?.Id ?? targetUnitId;
                }
                default:
                    return targetUnitId;
            }
        }

        internal struct UseSkillParameter
        {
            public int SkillDataId;
            public FixedVector2? Position;
            public FixedVector2? Direction;
            public long TargetUnitId;
            public float TimelineSpeed;
            public long ItemId;
            public int ItemDataId;
            public int Level;
            public bool IgnoreActable;
            public bool CheckCooldown;
            public bool CheckCooldownBySkillId;
            
            public static UseSkillParameter Default => new()
            {
                SkillDataId = 0,
                Position = null,
                Direction = null,
                TargetUnitId = 0L,
                TimelineSpeed = 0f,
                ItemId = 0L,
                ItemDataId = 0,
                Level = 1,
                IgnoreActable = false,
                CheckCooldown = true,
                CheckCooldownBySkillId = false
            };
        }
        
        internal struct QueuedUseSkillParameter
        {
            public UseSkillParameter UseSkillParameter;
            public uint Tick;
        }
        
        private readonly Queue<QueuedUseSkillParameter> _queuedUseSkillParameters = new();
        private void QueueAdditionalAttackSkill(UseSkillParameter parameter)
        {
            var delay = Math.Max(ResourceSkill.Global.Value.AdditionalAttackDelay, GameBoard.TickDuration);
            var queuedParameter = new QueuedUseSkillParameter
            {
                UseSkillParameter = parameter,
                Tick = tick_ + GameBoard.TimeToTicksDuration(delay)
            };
            _queuedUseSkillParameters.Enqueue(queuedParameter);
        }
        
        private void UpdateAdditionalAttackSkill()
        {
            while (_queuedUseSkillParameters.Count > 0)
            {
                var queuedParameter = _queuedUseSkillParameters.Peek();
                if (queuedParameter.Tick > tick_)
                    break;
                _queuedUseSkillParameters.Dequeue();
                UseSkill(queuedParameter.UseSkillParameter, fromAdditionalAttack: true);
            }
        }

        internal void CancelSkillsByPriority(int priority)
        {
            foreach (var skill in Board.GetSkillsBySenderId(id_))
            {
                if (skill.ResSkill.Priority > 0 && (priority == 0 || skill.ResSkill.Priority < priority))
                    skill.Destroy();
            }
        }
    }
}
