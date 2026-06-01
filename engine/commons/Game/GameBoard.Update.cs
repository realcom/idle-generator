using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using Commons.Game.Actions;
using Commons.Game.Events;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;

using Commons.Types.Geometry;
using Commons.Utility;
using System.Linq;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using SelectTraitEvent = Commons.Game.Events.SelectTraitEvent;
#if UNITY_5_3_OR_NEWER
using UnityEngine;

#endif

namespace Commons.Game
{
    public partial class GameBoard
    {
        private const int MaxQueuedUpdates = int.MaxValue;
        private const int MaxQueuedUpdateTickGap = int.MaxValue;

        private readonly ConcurrentQueue<IBoardUpdate> _boardUpdates = new();

        public void ClearUpdates()
        {
            _boardUpdates.Clear();
        }

        private void CheckUpdateTick(IBoardUpdate update, uint tick)
        {
            if (_boardUpdates.Count > MaxQueuedUpdates)
                throw new InvalidOperationException($"{ToDebugString()} {update.GetType()} queue.Count > MaxQueuedUpdates({_boardUpdates.Count} > {MaxQueuedUpdates})");
            
            if (AutoProgress)
            {
                if (tick != 0)
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {update.GetType()}.Tick must be 0 when AutoProgress is enabled");
            }
            else
            {
                if (tick < tick_)
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {update.GetType()}.Tick < tick_ ({tick} < {tick_})");
                if (tick - tick_ > MaxQueuedUpdateTickGap)
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {update.GetType()}.Tick - tick_ > MaxQueuedUpdateTickGap ({tick} - {tick_} > {MaxQueuedUpdateTickGap})");
                if (IsTickInFuture(tick, DateTime.UtcNow))
                    throw new InvalidOperationException(
                        $"{ToDebugString()} {update.GetType()}.Tick {tick} is in the future ({TicksToTime(tick)} s, speed={GetEffectiveGameSpeedMultiplier()})");
                
                if (tick > LastUnhandledTick)
                    LastUnhandledTick = tick;
            }
        }

        public void QueueUpdate(IBoardUpdate update)
        {
            CheckUpdateTick(update, update.Tick);
            _boardUpdates.Enqueue(update);
        }
        
        private void HandleUpdates()
        {
            try
            {
                HandleUpdatesInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.HandleUpdates failed: {ex}");
            }
        }
        
        private void HandleUpdatesInternal()
        {
            while (_boardUpdates.TryPeek(out var update))
            {
                if (HandleUpdate(update))
                    _boardUpdates.TryDequeue(out _);
                else
                    break;
            }

            PostHandleUpdatesInternal();
        }
        
        private bool HandleUpdate(IBoardUpdate update)
        {
            if (AutoProgress)
                update.Tick = tick_;
            else
            {
                var tick = update.Tick;
                if (tick < tick_)
                {
                    Config.LogError($"{ToDebugString()} {update.GetType()}.Tick < tick_ ({tick} < {tick_})");
                    return true;
                }
                
                if (tick != tick_)
                    return false;
            }

            var beforeHash = 0;
            if (Config.IsDebug)
                beforeHash = GetHashCode();
            
            var result = HandleUpdateInternal(update);

            if (Config.IsDebug)
                Config.LogInfo($"{ToDebugString()} {update.GetType()} Handle. Compare Hash [Before: {beforeHash} | After: {GetHashCode()}]");

            return result;
        }

        private partial bool HandleUpdateInternal(IBoardUpdate update);
        
        partial void PostHandleUpdatesInternal();
    }
}
