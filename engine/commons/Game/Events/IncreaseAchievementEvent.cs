namespace Commons.Game.Events
{
    public partial class IncreaseAchievementEvent : BoardEvent
    {
        public override Type EventType => Type.IncreaseAchievement;
        
        public long PlayerId;
        public int AchievementDataId;
        public int Progress;
    }
}
