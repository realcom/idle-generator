namespace Commons.Game.Events
{
    public partial class ResetMapScrollEvent : BoardEvent
    {
        public override Type EventType => Type.ResetMapScroll;
        
        public long PlayerId;
    }
}