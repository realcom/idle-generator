namespace Commons.Game.Events
{
    public partial class SetUpdateSpeedEvent : BoardEvent
    {
        public override Type EventType => Type.SetUpdateSpeed;
        
        public float BoardSpeed;
        public float EditorSpeed;
        public float Duration;
    }
}