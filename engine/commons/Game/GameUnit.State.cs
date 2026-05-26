using System;
using Commons.Game.Events;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type;

namespace Commons.Game
{
    public partial class GameUnit
    {
        public static class StateFlag
        {
            public const uint Clear          = 0b00000000_00000000_00000000_00000000;

            public const uint Alive          = 0b00000000_00000000_00000000_00000001;
            public const uint Exhaustion     = 0b00000000_00000000_00000000_00000010;

            public const uint CollidedWall   = 0b00000000_00000000_00000001_00000000;
            public const uint CollidedUnit   = 0b00000000_00000000_00000010_00000000;

            public const uint MoveDisabled   = 0b00000000_00000001_00000000_00000000;
            public const uint ActionDisabled = 0b00000000_00000010_00000000_00000000;
            public const uint Running        = 0b00000000_00000100_00000000_00000000;
            public const uint Charging       = 0b00000000_00001000_00000000_00000000;
            public const uint Knockback      = 0b00000000_00010000_00000000_00000000;
            
            // Buff States
            public const uint BuffMask       = 0b11111111_00000000_00000000_00000000;
            public const uint Ghost          = 0b00000001_00000000_00000000_00000000;

            public const uint Movable = Exhaustion | MoveDisabled | Charging | Knockback;
            public const uint Actable = Exhaustion | ActionDisabled | Charging | Knockback;
        }
        
        public bool IsAlive => (state_ & StateFlag.Alive) != 0;
        
        public bool IsCollidedWall => (state_ & StateFlag.CollidedWall) != 0;
        public bool IsCollidedUnit => (state_ & StateFlag.CollidedUnit) != 0;

        public bool IsMovable => IsAlive && !HasBuffByTag(Tag.DisableMove) && (state_ & StateFlag.Movable) == 0;
        public bool IsActable => IsAlive && !HasBuffByTag(Tag.DisableAction) && (state_ & StateFlag.Actable) == 0;
        public bool IsRunning => (state_ & StateFlag.Running) != 0;
        public bool IsCharging => (state_ & StateFlag.Charging) != 0;
        public bool IsKnockback => (state_ & StateFlag.Knockback) != 0;
        public bool IsGhost => !IsAlive || (state_ & StateFlag.Ghost) != 0;

        internal void DisableMove(uint duration)
        {
            if (duration == 0)
                return;
            moveDisabledTick_ = Math.Max(moveDisabledTick_, duration);
            state_ |= StateFlag.MoveDisabled;
            Stop();
        }
        
        internal void DisableAction(uint duration, int priority = 0)
        {
            if (duration == 0)
                return;
            if (actionDisabledTick_ > 0)
            {
                if (actionDisabledPriority_ == 0)
                {
                    if (priority == 0)
                        actionDisabledTick_ = Math.Max(actionDisabledTick_, duration);
                    else
                        return;
                }
                else
                {
                    if (priority == 0)
                    {
                        actionDisabledPriority_ = 0;
                        actionDisabledTick_ = duration;
                    }
                    else if (priority == actionDisabledPriority_)
                        actionDisabledTick_ = Math.Max(actionDisabledTick_, duration);
                    else if (priority > actionDisabledPriority_)
                    {
                        actionDisabledPriority_ = priority;
                        actionDisabledTick_ = duration;
                    }
                    else
                        return;
                }
            }
            else
            {
                actionDisabledPriority_ = priority;
                actionDisabledTick_ = duration;
            }
            state_ |= StateFlag.ActionDisabled;
        }

        private void UpdateState()
        {
            if (moveDisabledTick_ > 0 && --moveDisabledTick_ == 0)
                state_ &= ~StateFlag.MoveDisabled;
            if (actionDisabledTick_ > 0 && --actionDisabledTick_ == 0)
            {
                state_ &= ~StateFlag.ActionDisabled;
                actionDisabledPriority_ = 0;
            }
        }

        internal void HandleExhaustion(GameUnit? attacker = null)
        {
            Sp = 0L;
            Stop();
            StopCharge();
            state_ |= StateFlag.Exhaustion;
            
            QueueAddBuff(new QueuedAddBuff(attacker, ResourceBuff.Global.DataId.Exhaustion, 1));
        }

        public void HandleRespawn()
        {
            var respawnHpMultiplier 
                = FixedFloatMath.Clamp01(variables_.GetAndClear((int)RespawnHpPercent, FixedFloat.Hundred) / FixedFloat.Hundred);
            Hp = (long)(MaxHp * respawnHpMultiplier);
            var respawnMpMultiplier
                = FixedFloatMath.Clamp01(variables_.GetAndClear((int)RespawnMpPercent, FixedFloat.Hundred) / FixedFloat.Hundred);
            Mp = (long)(MaxMp * respawnMpMultiplier);
            respawnTick_ = 0;
            state_ |= StateFlag.Alive;
            
            foreach (var gameUnit in Children)
            {
                gameUnit.HandleRespawn();
            }
            
            if (ResUnit.ContainsTag(Tag.RespawnAtInitPosition))
                SetPosition(initPosition_);

            var respawnCount = variables_.GetInt((int)RespawnCount);
            variables_.SetInt((int)RespawnCount, respawnCount + 1);
        }
        
        public void HandlePurchaseRespawn()
        {
            HandleRespawn();
            
            var purchaseRespawnCount = variables_.Get((int)PurchaseRespawnCount, FixedFloat.Zero);
            variables_.Set((int)PurchaseRespawnCount, purchaseRespawnCount + FixedFloat.One);
        }

        private void HandleKill(GameUnit target, IAttackSource? attackSource = null)
        {
            using var state = CreateState();
            state.slotUnit = target;
            
            var gameBuff = attackSource as GameBuff;
            var gameSkill = attackSource as GameSkill;
            
            state.slotBuff = gameBuff;
            state.slotSkill = gameSkill;
            
            _triggerOnKill?.Run(Board, state);
            
            foreach (var child in Children)
            {
                child.HandleOwnerKill(target, attackSource);
            }
            
            foreach (var skill in Board.GetSkillsBySenderId(id_))
            {
                skill.HandleOwnerKill(target, attackSource);
            }
            
            foreach (var buff in buffs_.Values)
            {
                buff.HandleOwnerKill(target, attackSource);
            }
        }

        private void HandleOwnerKill(GameUnit target, IAttackSource? attackSource = null)
        {
            if (_triggerOnOwnerKill == null)
                return;
            
            using var state = CreateState();
            state.slotUnit = target;
            
            var gameBuff = attackSource as GameBuff;
            var gameSkill = attackSource as GameSkill;
            
            state.slotBuff = gameBuff;
            state.slotSkill = gameSkill;
            
            _triggerOnOwnerKill.Run(Board, state);
        }

        public void HandleDead(IAttackSource? attackSource = null)
        {
            Hp = 0L;
            Stop();
            StopCharge();
            state_ &= ~StateFlag.Alive;

            foreach (var skill in Board.GetSkillsBySenderId(id_))
            {
                if (!skill.ResSkill.ContainsTag(Tag.IgnoreDestroyWhenDead))
                    skill.Destroy();
            }

            var attacker = attackSource?.Attacker;
            AddDeadDropItems(attacker);
            
            if (ResUnit.DeadUseSkill != null)
                UseSkill(ResUnit.DeadUseSkill, ignoreActable: true);

            foreach (var buff in buffs_.Values)
            {
                if (!buff.ResBuff.ContainsTag(Tag.IgnoreDestroyWhenDead))
                    buff.Destroy();
            }

            if (ResUnit.Type == ResourceUnit.Types.Type.Player && Board.ResMap.PlayerUnitRespawnDelay > 0f)
                RespawnWithDelay(GameBoard.TimeToTicksDuration(Board.ResMap.PlayerUnitRespawnDelay));
            
            var respawnReserved = respawnTick_ > 0;
            if (!respawnReserved && ResUnit.DeadDestroyDelay > 0)
                DestroyWithDelay(ResUnit.DeadDestroyDelay);

            var boardVariables = Board.Variables;
            var predefinedKey = UnitDeath + ResUnit.Id;
            var death = boardVariables.GetIntPredefinedVariable(Board, predefinedKey);
            boardVariables.SetPredefinedVariable(Board, predefinedKey, death + 1);

            attacker?.HandleKill(this, attackSource);
            attackSource?.HandleKill(this);
            
            using var state = CreateState();
            _triggerOnDead?.Run(Board, state);

            var player = Player;
            if (player != null)
                player.Deaths += 1;

            var attackerPlayer = attacker?.Player;
            if (attackerPlayer != null)
                attackerPlayer.Kills += 1;
            
            Board.QueueEvent(new UnitDeathEvent
            {
                UnitId = id_,
                UnitDataId = ResUnit.Id,
                AttackerUnitId = attacker?.id_ ?? 0,
                AttackerPlayerId = attacker?.playerId_ ?? 0,
                RespawnReserved = respawnReserved
            });
            
            foreach (var gameUnit in Children)
            {
                gameUnit.HandleDead(attackSource);
            }
        }
    }
}
