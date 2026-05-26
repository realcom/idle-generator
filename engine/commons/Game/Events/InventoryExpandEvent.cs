namespace Commons.Game.Events
{
    public partial class InventoryExpandEvent : BoardEvent
    {
        public override Type EventType => Type.InventoryExpand;

        public long PlayerId;
        public int Row;
        public int Index;
    }
}