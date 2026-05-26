namespace Commons.Game.Events
{
    public partial class InventoryMergeEvent : BoardEvent
    {
        public override Type EventType => Type.InventoryMerge;

        public long PlayerId;
        public enum InventoryType
        {
            Inventory,
            Hold
        }
        public InventoryMergeEvent.InventoryType SourceType;
        public int SourceRow;
        public int SourceIndex;
        public InventoryMergeEvent.InventoryType TargetType;
        public int TargetRow;
        public int TargetIndex;
        public int PrevItemDataId;
        public int NextItemDataId;
    }
}