using Commons.Packets.Updates;

namespace Commons.Game.Events
{
    public partial class InventoryRootingEvent : BoardEvent
    {
        public override Type EventType => Type.InventoryRooting;

        public long PlayerId;
        public bool Rooted;
    }
}