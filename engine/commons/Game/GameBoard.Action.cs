using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using Commons.Game.Actions;
using Commons.Types.Geometry;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameBoard
    {
        public const int MaxQueuedActions = 10800;
        public const int MaxQueuedActionTickGap = 10800;
        
        private readonly ConcurrentQueue<UnitMoveDirectionAction> _unitMoveDirectionActions = new();
        private readonly ConcurrentQueue<UnitMovePositionAction> _unitMovePositionActions = new();
        private readonly ConcurrentQueue<UnitUseSkillAction> _unitUseSkillActions = new();
        private readonly ConcurrentQueue<UnitUseTargetSkillAction> _unitUseTargetSkillActions = new();
        private readonly ConcurrentQueue<UnitChangePlayerAvatarWeaponSlotAction> _unitChangePlayerAvatarWeaponSlotActions = new();

        public void ClearActions()
        {
            _unitMoveDirectionActions.Clear();
            _unitMovePositionActions.Clear();
            _unitUseSkillActions.Clear();
            _unitUseTargetSkillActions.Clear();
            _unitChangePlayerAvatarWeaponSlotActions.Clear();
        }

        private void CheckActionTick<T>(ConcurrentQueue<T> queue, object action, uint tick)
        {
            if (queue.Count > MaxQueuedActions)
                throw new InvalidOperationException($"{ToDebugString()} {action.GetType()} queue.Count > MaxQueuedActions ({queue.Count} > {MaxQueuedActions})");
            
            if (AutoProgress)
            {
                if (tick != 0)
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {action.GetType()}.Tick must be 0 when AutoProgress is enabled");
            }
            else
            {
                if (tick < tick_)
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {action.GetType()}.Tick < tick_ ({tick} < {tick_})");
                if (tick - tick_ > MaxQueuedActionTickGap)
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {action.GetType()}.Tick - tick_ > MaxQueuedActionTickGap ({tick} - {tick_} > {MaxQueuedActionTickGap})");
                if (IsTickInFuture(tick, DateTime.UtcNow))
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {action.GetType()}.Tick {tick} is in the future ({TicksToTime(tick)} s, speed={GetEffectiveGameSpeedMultiplier()})");
                
                if (tick > LastUnhandledTick)
                    LastUnhandledTick = tick;
            }
        }

        public void QueueAction(UnitMoveDirectionAction action)
        {
            CheckActionTick(_unitMoveDirectionActions, action, action.Tick);
            _unitMoveDirectionActions.Enqueue(action);
        }

        private bool HandleAction(UnitMoveDirectionAction action)
        {
            if (AutoProgress)
                action.MutateTick(tick_);
            else
            {
                if (action.Tick < tick_)
                {
                    Config.LogError($"{ToDebugString()} {action.GetType()}.Tick < tick_ ({action.Tick} < {tick_})");
                    return true;
                }
                if (action.Tick != tick_)
                    return false;
            }
            var unit = GetUnitById(action.UnitId);
            unit?.SetMoveDirection(new FixedVector2(action.DirX, action.DirY));
            ServerHandleAction(action);
            return true;
        }

        partial void ServerHandleAction(UnitMoveDirectionAction action);
        
        public void QueueAction(UnitMovePositionAction action)
        {
            CheckActionTick(_unitMovePositionActions, action, action.Tick);
            _unitMovePositionActions.Enqueue(action);
        }
        
        private bool HandleAction(UnitMovePositionAction action)
        {
            if (AutoProgress)
                action.MutateTick(tick_);
            else
            {
                if (action.Tick < tick_)
                {
                    Config.LogError($"{ToDebugString()} {action.GetType()}.Tick < tick_ ({action.Tick} < {tick_})");
                    return true;
                }
                if (action.Tick != tick_)
                    return false;
            }
            var unit = GetUnitById(action.UnitId);
            unit?.SetMoveDestination(new FixedVector2(action.PosX, action.PosY));
            ServerHandleAction(action);
            return true;
        }
        
        partial void ServerHandleAction(UnitMovePositionAction action);
        
        public void QueueAction(UnitUseSkillAction action)
        {
            CheckActionTick(_unitUseSkillActions, action, action.Tick);
            _unitUseSkillActions.Enqueue(action);
        }
        
        private bool HandleAction(UnitUseSkillAction action)
        {
            if (AutoProgress)
                action.MutateTick(tick_);
            else
            {
                if (action.Tick < tick_)
                {
                    Config.LogError($"{ToDebugString()} {action.GetType()}.Tick < tick_ ({action.Tick} < {tick_})");
                    return true;
                }
                if (action.Tick != tick_)
                    return false;
            }
            var unit = GetUnitById(action.UnitId);
            unit?.UseSkill(action.SkillDataId);
            ServerHandleAction(action);
            return true;
        }
        
        partial void ServerHandleAction(UnitUseSkillAction action);
        
        public void QueueAction(UnitUseTargetSkillAction action)
        {
            CheckActionTick(_unitUseTargetSkillActions, action, action.Tick);
            _unitUseTargetSkillActions.Enqueue(action);
        }
        
        private bool HandleAction(UnitUseTargetSkillAction action)
        {
            if (AutoProgress)
                action.MutateTick(tick_);
            else
            {
                if (action.Tick < tick_)
                {
                    Config.LogError($"{ToDebugString()} {action.GetType()}.Tick < tick_ ({action.Tick} < {tick_})");
                    return true;
                }
                if (action.Tick != tick_)
                    return false;
            }
            var unit = GetUnitById(action.UnitId);
            unit?.UseSkill(action.SkillDataId, targetUnitId: action.TargetUnitId);
            ServerHandleAction(action);
            return true;
        }
        
        partial void ServerHandleAction(UnitUseTargetSkillAction action);
        
        public void QueueAction(UnitChangePlayerAvatarWeaponSlotAction action)
        {
            CheckActionTick(_unitChangePlayerAvatarWeaponSlotActions, action, action.Tick);
            _unitChangePlayerAvatarWeaponSlotActions.Enqueue(action);
        }
        
        private bool HandleAction(UnitChangePlayerAvatarWeaponSlotAction action)
        {
            if (AutoProgress)
                action.MutateTick(tick_);
            else
            {
                if (action.Tick < tick_)
                {
                    Config.LogError($"{ToDebugString()} {action.GetType()}.Tick < tick_ ({action.Tick} < {tick_})");
                    return true;
                }
                if (action.Tick != tick_)
                    return false;
            }
            var unit = GetUnitById(action.UnitId);
            unit?.ChangePlayerAvatarWeaponSlot(action.WeaponSlot);
            ServerHandleAction(action);
            return true;
        }
        
        partial void ServerHandleAction(UnitChangePlayerAvatarWeaponSlotAction action);

        private void HandleActions()
        {
            try
            {
                HandleActionsInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.HandleActions failed: {ex}");
            }
        }

        partial void PostHandleActionsInternal();

        private void HandleActionsInternal()
        {
            while (_unitMoveDirectionActions.TryPeek(out var action))
            {
                if (HandleAction(action))
                    _unitMoveDirectionActions.TryDequeue(out _);
                else
                    break;
            }
            
            while (_unitMovePositionActions.TryPeek(out var action))
            {
                if (HandleAction(action))
                    _unitMovePositionActions.TryDequeue(out _);
                else
                    break;
            }
            
            while (_unitUseSkillActions.TryPeek(out var action))
            {
                if (HandleAction(action))
                    _unitUseSkillActions.TryDequeue(out _);
                else
                    break;
            }
            
            while (_unitUseTargetSkillActions.TryPeek(out var action))
            {
                if (HandleAction(action))
                    _unitUseTargetSkillActions.TryDequeue(out _);
                else
                    break;
            }
            
            while (_unitChangePlayerAvatarWeaponSlotActions.TryPeek(out var action))
            {
                if (HandleAction(action))
                    _unitChangePlayerAvatarWeaponSlotActions.TryDequeue(out _);
                else
                    break;
            }

            PostHandleActionsInternal();
        }
    }
}
