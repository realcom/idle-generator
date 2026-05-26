namespace Commons.Game.Events
{
    public partial class TimerUpdatedEvent : BoardEvent
    {
        public override Type EventType => Type.TimerUpdated;

        public bool StartTimer;
        public float StartTimerDuration;
        public bool AddTimer;
        public float AddTimerDuration;
        public bool PauseTimer;
        public bool ResumeTimer;
        public bool StopTimer;
    }
}
