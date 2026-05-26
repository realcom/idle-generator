using Commons.Game;
using Commons.Utility;

namespace Commons.Types.Units
{
    public partial class AddHeal
    {
        public long GetHeal(GameUnit healer, GameUnit target, int level)
        {
            var heal = heals_.GetClamped(level - 1);
            var attackPercentHeal = (FixedFloat)attackPercentHeals_.GetClamped(level - 1);
            heal = LongFixedFloatMath.AddSaturated(
                heal,
                LongFixedFloatMath.ScaleSaturated(LongFixedFloatMath.ToLongSaturated(healer.Attack), attackPercentHeal));
            var maxHpPercentHeals = maxHpPercentHeals_.GetClamped(level - 1);
            heal = LongFixedFloatMath.AddSaturated(
                heal,
                LongFixedFloatMath.ScaleSaturated(target.MaxHp, (FixedFloat)maxHpPercentHeals / 100));
            return heal;
        }
        
        public long GetShieldHeal(GameUnit healer, GameUnit target, int level)
        {
            var shieldHeal = 0L;
            var maxHpPercentShieldHeals = maxHpPercentShieldHeals_.GetClamped(level - 1);
            shieldHeal = LongFixedFloatMath.AddSaturated(
                shieldHeal,
                LongFixedFloatMath.ScaleSaturated(target.MaxHp, (FixedFloat)maxHpPercentShieldHeals / 100));
            return shieldHeal;
        }
        
    }
}
