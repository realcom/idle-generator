namespace Commons.Game.Events
{
    public partial class UnitDeathEvent : BoardEvent
    {
        public override Type EventType => Type.UnitDeath;
        
        public long UnitId;
        public int UnitDataId;
        public long AttackerUnitId;
        public long AttackerPlayerId;
        public bool RespawnReserved;
    }
}
