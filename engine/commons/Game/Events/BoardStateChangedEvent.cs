namespace Commons.Game.Events
{
    public partial class BoardStateChangedEvent : BoardEvent
    {
        public override Type EventType => Type.BoardStateChanged;
    }
}