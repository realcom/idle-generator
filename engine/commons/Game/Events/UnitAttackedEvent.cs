using Commons.Types.Units;

namespace Commons.Game.Events
{
    public partial class UnitAttackedEvent : BoardEvent
    {
        public override Type EventType => Type.UnitAttacked;
        
        public long UnitId;
        public long Damage;
        public long ValidDamage;
        public long SpDamage;
        public int SkillDataId;
        public int BuffDataId;
        public bool IsCritical;
        public DamageType DamageType;
        public ArmorType ArmorType;
    }
}