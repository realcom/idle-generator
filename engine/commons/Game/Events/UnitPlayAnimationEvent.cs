namespace Commons.Game.Events
{
    public partial class UnitPlayAnimationEvent : BoardEvent
    {
        public override Type EventType => Type.UnitPlayAnimation;

        public long UnitId;
        public int SkillDataId;
        public string? Animation;
        public float Speed = 1f;
    }
}
