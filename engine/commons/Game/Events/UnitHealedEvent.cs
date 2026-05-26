namespace Commons.Game.Events
{
    public partial class UnitHealedEvent : BoardEvent
    {
        public override Type EventType => Type.UnitHealed;
        
        public long UnitId;
        public long Heal;
        public long ValidHeal;
        public long SpHeal;
        public long GuardHeal;
        public long ShieldHeal;
        public long SkillDataId;
        public long BuffDataId;
    }
}