namespace Commons.Game.Events
{
    public partial class WaveQueuedEvent : BoardEvent
    {
        public override Type EventType => Type.WaveQueued;

        public long PlayerId;
    }
}