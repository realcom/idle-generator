namespace Commons.Game.Events
{
    public partial class WaveStartedEvent : BoardEvent
    {
        public override Type EventType => Type.WaveStarted;
        
        public long PlayerId;
    }
}