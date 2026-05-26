namespace Commons.Game.Events
{
    public partial class PlayerMoveBoardEvent : BoardEvent
    {
        public override Type EventType => Type.PlayerMoveBoard;

        public long PlayerId;
        public int MapDataId;
    }
}