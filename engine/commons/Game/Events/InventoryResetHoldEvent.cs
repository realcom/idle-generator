namespace Commons.Game.Events
{
    public partial class InventoryResetHoldEvent : BoardEvent
    {
        public override Type EventType => Type.InventoryResetHold;

        public long PlayerId;
    }
}