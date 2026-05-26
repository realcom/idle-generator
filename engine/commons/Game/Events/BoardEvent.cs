namespace Commons.Game.Events
{
    public abstract partial class BoardEvent
    {
        public enum Type
        {
            EndGame,
            PlayFx,
            SetUpdateSpeed,
            TimerUpdated,
            BoardStateChanged,
            
            PlayerJoined,
            PlayerUpdated,
            PlayerLeft,
            PlayerMoveBoard,
            
            UnitAttacked,
            UnitHealed,
            UnitGetDropItem,
            UnitPlayAnimation,
            UnitDeath,
            
            IncreaseAchievement,
            IncreaseMission,
            CompleteMission,
            
            ToastMessage,
            ShowDialog,
            
            InventorySpawn,
            InventoryMerge,
            InventoryMove,
            InventoryExpand,
            InventoryResetHold,
            InventoryRooting,

            SelectTrait,
            CompleteSelectTrait,
            
            WaveQueued,
            WaveStarted,
            
            ResetMapScroll,
            
            ShowPopup,
            
            UseSkill,
        }

        public abstract Type EventType { get; }
    }
}
