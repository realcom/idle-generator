using Commons.Packets.Updates;

namespace Commons.Game.Events
{
    public partial class InventorySpawnEvent : BoardEvent
    {
        public override Type EventType => Type.InventorySpawn;

        public BoardPlayerInventorySpawnUpdate.Types.Type TargetType;

        public long PlayerId;
        public int Row = -1;
        public int Index;
        public int ItemDataId;
        public bool ResetHold;
        public bool LuckApplied = false;
    }
}
