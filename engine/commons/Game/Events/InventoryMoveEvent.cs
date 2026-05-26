namespace Commons.Game.Events
{
    public partial class InventoryMoveEvent : BoardEvent
    {
        public override Type EventType => Type.InventoryMove;
        
        public long PlayerId;
        public enum InventoryType
        {
            Inventory,
            Hold,
            Sell,
            Discard
        }
        public InventoryType SourceType;
        public int SourceRow;
        public int SourceIndex;
        public InventoryType TargetType;
        public int TargetRow;
        public int TargetIndex;
    }
}