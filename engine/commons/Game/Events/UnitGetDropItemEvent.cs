namespace Commons.Game.Events
{
    public partial class UnitGetDropItemEvent : BoardEvent
    {
        public override Type EventType => Type.UnitGetDropItem;
        
        public long UnitId;
        public long PlayerId;
        public long DropItemId;
        public int ItemDataId;
        public long Count;
        public int Level;
        public long Exp;
    }
}
