using Commons.Game;
using Commons.Game.Events;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Utility;

namespace Commons.Types.Units
{
    public partial class AddDamage
    {
        public long GetDamageLong(GameUnit attacker, GameUnit target, int level, FixedFloat addDamageRatio)
        {
            var damage = damages_.GetClamped(level - 1);
            var attackPercentDamage = (FixedFloat)attackPercentDamages_.GetClamped(level - 1);
            if (attackPercentDamage != FixedFloat.Zero)
            {
                var attackDamage = LongFixedFloatMath.ScaleSaturated(
                    LongFixedFloatMath.ToLongSaturated(attacker.Attack),
                    attackPercentDamage);
                attackDamage = LongFixedFloatMath.ScaleSaturated(attackDamage, addDamageRatio);
                damage = LongFixedFloatMath.AddSaturated(damage, attackDamage);
            }

            var hpPercentDamage = (FixedFloat)hpPercentDamages_.GetClamped(level - 1);
            if (hpPercentDamage != FixedFloat.Zero)
                damage = LongFixedFloatMath.AddSaturated(damage, LongFixedFloatMath.ScaleSaturated(target.Hp, hpPercentDamage));

            var maxHpPercentDamage = (FixedFloat)maxHpPercentDamages_.GetClamped(level - 1);
            if (maxHpPercentDamage != FixedFloat.Zero)
                damage = LongFixedFloatMath.AddSaturated(damage, LongFixedFloatMath.ScaleSaturated(target.MaxHp, maxHpPercentDamage));

            return damage;
        }

        public FixedFloat GetDamage(GameUnit attacker, GameUnit target, int level, FixedFloat addDamageRatio)
        {
            return LongFixedFloatMath.ToFixedFloatSaturated(GetDamageLong(attacker, target, level, addDamageRatio));
        }

        public bool TryApplyKnockback(GameUnit target, IAttackSource attackSource)
        {
            if (knockbackDistance_ == FixedFloat.Zero)
                return false;

            if (target.ResUnit.ContainsTag(Tag.IgnoreKnockbackByDamage) || target.HasBuffByTag(Tag.IgnoreKnockbackByDamage))
                return false;

            target.Knockback(-(FixedVector2)target.Direction, GameBoard.TimeToTicksDuration(knockbackDuration_), knockbackDistance_, attackSource);
            
            return true;
        }
        
    }
}
