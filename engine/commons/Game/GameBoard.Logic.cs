using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public const uint TicksPerSecond = 30;
        public static readonly FixedFloat FixedFloatTicksPerSecond = 30;
        public const float TickDuration = 1f / TicksPerSecond;
        public static readonly FixedFloat FixedFloatTickDuration = TickDuration;
        
        public bool AutoProgress = true;
        public uint LastUnhandledTick;
        public float GameSpeedMultiplier { get; set; } = ResourceItem.MinGameSpeedMultiplier;
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static uint TimeToTicks(FixedFloat time)
        {
            return (uint)(time * FixedFloatTicksPerSecond + FixedFloat.Half);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static uint TimeToTicksDuration(FixedFloat duration)
        {
            return Math.Max(1, (uint)(duration * FixedFloatTicksPerSecond + FixedFloat.Half));
        }
        
        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public static FixedFloat TicksToTime(uint ticks)
        {
            return ticks * FixedFloatTickDuration;
        }

        public float GetEffectiveGameSpeedMultiplier()
        {
            return ResourceItem.NormalizeGameSpeedMultiplier(GameSpeedMultiplier);
        }

        public TimeSpan GetRealTimeForTick(uint tick)
        {
            return TimeSpan.FromSeconds((float)TicksToTime(tick) / GetEffectiveGameSpeedMultiplier());
        }

        public bool IsTickInFuture(uint tick, DateTime now, float graceSeconds = 60f)
        {
            if (CreatedAt == null)
                return false;

            return now - CreatedAt.ToDateTime() < GetRealTimeForTick(tick) - TimeSpan.FromSeconds(graceSeconds);
        }

        private bool _inited;
        private ResourceTrigger? _triggerOnUpdate;

        public ResourceMap ResMap { private set; get; }
        
        private readonly List<Action> _postActions = new();

        partial void OnConstruction()
        {
            variables_ = new ResourceTrigger.Types.Variables();
            InitSeed();
        }

        public GameBoard Init()
        {
            if (_inited)
                return this;
            _inited = true;
            ResMap = ResourceMap.Get(dataId_)!;
            
            _triggerOnUpdate = ResMap.GetTrigger(ResourceTrigger.Types.Type.OnUpdate);

            if (tick_ == 0)
            {
                foreach (var initVariable in ResMap.InitVariables)
                    variables_.Set(initVariable.CallerKey, initVariable.Value);
            }
            
            InitTeamInteraction();
            InitUnits();
            InitSkills();
            InitDropItems();
            RefreshPlayerActiveInventory(false);

            return this;
        }

        public string ToDebugString()
        {
            return $"GameBoard[{Id}]({ResMap.Id}:{ResMap.Name}):{Tick}";
        }

        public void CacheResMap()
        {
            if (dataId_ != 0)
                ResMap = ResourceMap.Get(dataId_)!;
        }
        
        internal void QueuePostAction(Action action)
        {
            _postActions.Add(action);
        }

        public void EndGame(int winningTeam)
        {
            if (state_ == Types.State.Ended)
                return;
            
            winningTeam_ = winningTeam;
            QueueEvent(new EndGameEvent
            {
                WinningTeam = winningTeam,
            });
            
            state_ = Types.State.Ended;
            QueueEvent(new BoardStateChangedEvent());
        }

        private void RunTriggerOnUpdate()
        {
            if (_triggerOnUpdate == null)
                return;
            if (Tick % _triggerOnUpdate.Period != 0)
                return;
            
            using var state = ResourceTrigger.Types.State.Rent(variables_);
            _triggerOnUpdate.Run(this, state);
        }

        private void RunLogic()
        {
            try
            {
                RunLogicInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.RunLogic failed: {ex}");
            }
        }

        private void RunLogicInternal()
        {
            Init();
            
            if (Tick == 1)
            {
                var triggerOnStart = ResMap.GetTrigger(ResourceTrigger.Types.Type.OnStart);

                using var state = ResourceTrigger.Types.State.Rent(variables_);
                triggerOnStart?.Run(this, state);
            }
            
            Tick += 1;
            RunTriggerOnUpdate();
        }

        public void EarlyUpdate()
        {
            try
            {
                EarlyUpdateInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.EarlyUpdate failed: {ex}");
            }
        }

        private void EarlyUpdateInternal()
        {
            ClearEvents();
        }

        public void HandleInput()
        {
            try
            {
                HandleInputInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.HandleInput failed: {ex}");
            }
        }

        private void HandleInputInternal()
        {
            HandleUpdates();
            HandleActions();
        }
        
        public void Update()
        {
            try
            {
                UpdateInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.Update failed: {ex}");
            }
        }

        private void UpdateInternal()
        {
            RunLogic();
            
            foreach (var unit in units_.Values)
                unit.RunLogic();
            foreach (var skill in skills_.Values)
                skill.RunLogic();
            foreach (var unit in units_.Values)
            {
                if (unit.Destroyed)
                    continue;
                
                foreach (var buff in unit.Buffs.Values)
                    buff.RunLogic();
            }
            foreach (var unit in units_.Values)
            {
                if (!unit.Destroyed)
                    unit.Update();
            }
            
            var positionDirty = false;
            foreach (var unit in units_.Values)
            {
                if (!unit.Destroyed)
                    positionDirty |= unit.FlushPosition();
            }

            if (positionDirty)
            {
                _unitRTree.Clear();

                using var envelopes = ConcurrentObjectPool<PooledList<GameUnit.UnitBoundingBoxEnvelope>>.StaticPool.Pop();
                foreach (var unit in units_.Values)
                    envelopes.Add(unit.HitBoundingBoxEnvelope);
                
                _unitRTree.BulkLoad(envelopes);
            }

            foreach (var dropItem in dropItems_.Values)
            {
                if (!dropItem.Destroyed)
                    dropItem.Update();
            }
            
            foreach (var skill in skills_.Values)
            {
                if (!skill.Destroyed)
                    skill.Update();
            }

            foreach (var unit in units_.Values)
            {
                if (unit.Destroyed)
                    continue;
                
                foreach (var buff in unit.Buffs.Values)
                    buff.Update();
            }
        }

        public void PostUpdate()
        {
            try
            {
                PostUpdateInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.PostUpdate failed: {ex}");
            }
        }

        private void PostUpdateInternal()
        {
            foreach (var action in _postActions)
                action();
            _postActions.Clear();

            var positionDirty = false;
            HandleAddUnits();
            HandleAddSkills();
            HandleAddDropItems();
            
            positionDirty |= RemoveDestroyedUnits();
            RemoveDestroyedSkills();
            RemoveDestroyedDropItems();

            foreach (var unit in units_.Values)
            {
                unit.HandleAddBuffs();
                unit.RemoveDestroyedBuffs();
                unit.FinalizeBuffState();
                positionDirty |= unit.FlushPosition();
            }

            if (positionDirty)
            {
                _unitRTree.Clear();
                
                using var envelopes = ConcurrentObjectPool<PooledList<GameUnit.UnitBoundingBoxEnvelope>>.StaticPool.Pop();
                foreach (var unit in units_.Values)
                    envelopes.Add(unit.HitBoundingBoxEnvelope);
                
                _unitRTree.BulkLoad(envelopes);
            }
        }

        public void PostprocessUpdatesAndActions()
        {
            try
            {
                PostprocessUpdatesAndActionsInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameBoard.PostprocessUpdatesAndActions failed: {ex}");
            }
        }

        private void PostprocessUpdatesAndActionsInternal()
        {
            if (_playerActiveInventoryDirty)
                RefreshPlayerActiveInventory();
        }
    }
}
