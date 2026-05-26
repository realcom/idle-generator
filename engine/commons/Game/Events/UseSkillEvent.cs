namespace Commons.Game.Events
{
    public partial class UseSkillEvent : BoardEvent
    {
        public override Type EventType => Type.UseSkill;

        public long SenderUnitId;
        public long SenderPlayerId;
        public long SkillId;
        public int SkillDataId;
    }    
}

