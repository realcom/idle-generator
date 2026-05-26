using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Commons.Utility;

namespace Commons.Types.Units
{
    public class UnitStat : IEquatable<UnitStat>
    {
        private readonly FixedFloat[] _values = new FixedFloat[(int)UnitStatType.Count];
        
        public FixedFloat this[UnitStatType type]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => _values[(int)type];
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            internal set => _values[(int)type] = value;
        }

        public FixedFloat this[int index]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => _values[index];
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            internal set => _values[index] = value;
        }

        public virtual FixedFloat MaxHp => FixedFloatMath.Max(FixedFloat.One,
            ScaleByPercents(this[UnitStatType.Hp], this[UnitStatType.HpPercent], GameplayHpPercent));
        public virtual FixedFloat GameplayHpPercent => this[UnitStatType.GameplayHpPercent];
        public virtual FixedFloat HpRegenPerSecond => this[UnitStatType.HpRegen];

        public virtual FixedFloat MaxMp => FixedFloatMath.Max(FixedFloat.One,
            ScaleByPercent(this[UnitStatType.Mp], this[UnitStatType.MpPercent]));
        public virtual FixedFloat MpRegenPerSecond => this[UnitStatType.MpRegen];
        public virtual FixedFloat MaxSp => FixedFloatMath.Max(FixedFloat.Zero, this[UnitStatType.Sp]);
        public virtual FixedFloat SpRegenPerSecond => this[UnitStatType.SpRegen];
        public virtual FixedFloat GuardRatio => FixedFloatMath.Max(FixedFloat.Zero, RatioFromPercent(this[UnitStatType.GuardPercent]));
        public virtual FixedFloat MoveSpeed => FixedFloatMath.Max(FixedFloat.Zero, ScaleByPercent(this[UnitStatType.MoveSpeed], this[UnitStatType.MoveSpeedPercent]));
        public virtual FixedFloat MoveSpeedPercent => this[UnitStatType.MoveSpeedPercent];
        public virtual FixedFloat AttackSpeed => FixedFloatMath.Max(FixedFloat.Zero, ScaleByPercent(this[UnitStatType.AttackSpeed], this[UnitStatType.AttackSpeedPercent]));
        public virtual FixedFloat Weight => this[UnitStatType.Weight];
        public virtual FixedFloat Attack => ScaleByPercents(this[UnitStatType.Attack], this[UnitStatType.AttackPercent], GameplayAttackPercent);
        public virtual FixedFloat GameplayAttackPercent => this[UnitStatType.GameplayAttackPercent];
        public virtual FixedFloat Defense => ScaleByPercents(this[UnitStatType.Defense], this[UnitStatType.DefensePercent], this[UnitStatType.GamePlayDefensePercent]);
        public virtual FixedFloat MagicResist => ScaleByPercent(this[UnitStatType.MagicResist], this[UnitStatType.MagicResistPercent]);
        public virtual FixedFloat SellPriceRatio => RatioFromPercent(this[UnitStatType.SellPricePercent]);
        public virtual FixedFloat CooldownPercent => Sum(this[UnitStatType.CooldownPercent], this[UnitStatType.GameplayCooldownPercent]);
        public virtual FixedFloat CriticalPercent => Sum(this[UnitStatType.CriticalPercent], this[UnitStatType.GameplayCriticalPercent]);
        public virtual FixedFloat CriticalDamagePercent => Sum(this[UnitStatType.CriticalDamagePercent], this[UnitStatType.GameplayCriticalDamagePercent]);
        public virtual FixedFloat KnockbackPercent => Sum(this[UnitStatType.KnockbackPercent], this[UnitStatType.GameplayKnockbackPercent]);
        public virtual FixedFloat KnockbackEfficiencyPercent => Sum(this[UnitStatType.KnockbackEfficiencyPercent], this[UnitStatType.GameplayKnockbackEfficiencyPercent]);
        public virtual FixedFloat AdditionalAttackPercent => Sum(this[UnitStatType.AdditionalAttackPercent], this[UnitStatType.GameplayAdditionalAttackPercent]);
        public virtual FixedFloat BuffApplyResistancePercent => Sum(this[UnitStatType.BuffApplyResistancePercent], this[UnitStatType.GameplayBuffApplyResistancePercent]);
        public virtual FixedFloat BuffApplyAmplifyPercent => Sum(this[UnitStatType.BuffApplyAmplifyPercent], this[UnitStatType.GameplayBuffApplyAmplifyPercent]);
        public virtual FixedFloat BuffApplyResistanceReducePercent => Sum(this[UnitStatType.BuffApplyResistanceReducePercent], this[UnitStatType.GameplayBuffApplyResistanceReducePercent]);
        public virtual FixedFloat Luck => Sum(this[UnitStatType.Luck], this[UnitStatType.GameplayLuck]);
        public virtual FixedFloat Scale => RatioFromPercent(Sum(this[UnitStatType.ScalePercent], this[UnitStatType.GameplayScalePercent]));
        public virtual FixedFloat SkillScale => RatioFromPercent(Sum(this[UnitStatType.SkillScalePercent], this[UnitStatType.GameplaySkillScalePercent]));
        
        public virtual FixedFloat BuffDurationEfficiencyPercent => Sum(this[UnitStatType.BuffDurationEfficiencyPercent], this[UnitStatType.GameplayBuffDurationEfficiencyPercent]);
        public virtual FixedFloat SelfBuffDurationEfficiencyPercent => Sum(this[UnitStatType.SelfBuffDurationEfficiencyPercent], this[UnitStatType.GameplaySelfBuffDurationEfficiencyPercent]);
        public virtual FixedFloat TeamBuffDurationEfficiencyPercent => Sum(this[UnitStatType.TeamBuffDurationEfficiencyPercent], this[UnitStatType.GameplayTeamBuffDurationEfficiencyPercent]);
        public virtual FixedFloat EnemyBuffDurationEfficiencyPercent => Sum(this[UnitStatType.EnemyBuffDurationEfficiencyPercent], this[UnitStatType.GameplayEnemyBuffDurationEfficiencyPercent]);
        public virtual FixedFloat ShieldEfficiency => RatioFromPercent(Sum(this[UnitStatType.ShieldEfficiencyPercent], this[UnitStatType.GamePlayShieldEfficiencyPercent]));
        public virtual FixedFloat DamageTakenEfficiency => RatioFromPercent(Sum(this[UnitStatType.DamageTakenEfficiencyPercent], this[UnitStatType.GamePlayDamageTakenEfficiencyPercent]));
        
        public virtual FixedFloat MonsterDamageEfficiencyPercent => RatioFromPercent(Sum(this[UnitStatType.MonsterDamageEfficiencyPercent], this[UnitStatType.GameplayMonsterDamageEfficiencyPercent]));
        public virtual FixedFloat BossDamageEfficiencyPercent => RatioFromPercent(Sum(this[UnitStatType.BossDamageEfficiencyPercent], this[UnitStatType.GameplayBossDamageEfficiencyPercent]));
        
        public virtual FixedFloat MonsterDamageTakenEfficiencyPercent => RatioFromPercent(Sum(this[UnitStatType.MonsterDamageTakenEfficiencyPercent], this[UnitStatType.GameplayMonsterDamageTakenEfficiencyPercent]));
        public virtual FixedFloat BossDamageTakenEfficiencyPercent => RatioFromPercent(Sum(this[UnitStatType.BossDamageTakenEfficiencyPercent], this[UnitStatType.GameplayBossDamageTakenEfficiencyPercent]));
        
        // public virtual FixedFloat B => FixedFloat.One + (this[UnitStatType.BossDamageTakenEfficiencyPercent] + this[UnitStatType.GameplayMonsterDamagePercent])  / FixedFloat.Hundred;
        // public virtual FixedFloat BossDamagePercent => FixedFloat.One + (this[UnitStatType.BossDamagePercent] + this[UnitStatType.GameplayBossDamagePercent])  / FixedFloat.Hundred;
        
        
        
        public virtual FixedFloat HealEfficiencyPercent => RatioFromPercent(Sum(this[UnitStatType.HealEfficiencyPercent], this[UnitStatType.GameplayHealEfficiencyPercent]));
        
        public virtual FixedFloat ExpPercent => RatioFromPercent(this[UnitStatType.ExpPercent]);
        
        

        public void Clear()
        {
            Array.Clear(_values, 0, _values.Length);
        }

        private static FixedFloat Sum(FixedFloat a, FixedFloat b)
        {
            return FixedFloatMath.AddSaturated(a, b);
        }

        private static FixedFloat RatioFromPercent(FixedFloat percent)
        {
            return FixedFloatMath.RatioFromPercentSaturated(percent);
        }

        private static FixedFloat ScaleByPercent(FixedFloat value, FixedFloat percent)
        {
            return FixedFloatMath.MultiplySaturated(value, RatioFromPercent(percent));
        }

        private static FixedFloat ScaleByPercents(FixedFloat value, FixedFloat percent, FixedFloat gameplayPercent)
        {
            return FixedFloatMath.MultiplySaturated(
                ScaleByPercent(value, percent),
                RatioFromPercent(gameplayPercent));
        }
        
        public void Clear(IList<float> values)
        {
            for (var i = 0; i < values.Count; i++)
                _values[i] = values[i];
        }

        public void Apply(AddUnitStat addStat, int level)
        {
            this[addStat.Type] += addStat.Value.GetClamped(level - 1);
        }

        public void CopyTo(IList<float> values)
        {
            if (values.Count == 0)
            {
                for (var i = 0; i < _values.Length; i++)
                    values.Add((float)_values[i]);
            }
            else
            {
                for (var i = 0; i < _values.Length; i++)
                    values[i] = (float)_values[i];
            }
        }
        
        public void CopyTo(UnitStat stat)
        {
            for (var i = 0; i < _values.Length; i++)
                stat._values[i] = _values[i];
        }

        public bool Equals(UnitStat other)
        {
            if (ReferenceEquals(null, other)) return false;
            if (ReferenceEquals(this, other)) return true;

            if (_values.Length != other._values.Length)
                return false;
            
            for (var i = 0; i < _values.Length; i++)
            {
                if (_values[i] != other._values[i])
                    return false;
            }
            
            return true;
        }
        
        public static bool operator ==(UnitStat left, UnitStat right)
        {
            if (ReferenceEquals(left, right))
                return true;
            if (left is null || right is null)
                return false;
            return left.Equals(right);
        }

        public static bool operator !=(UnitStat left, UnitStat right)
        {
            return !(left == right);
        }
        
        public Dictionary<string, double> ToDoubleDictionary()
        {
            var dict = new Dictionary<string, double>();

            foreach (UnitStatType type in Enum.GetValues(typeof(UnitStatType)))
            {
                if (type == UnitStatType.Count) break; // sentinel 값 스킵
                dict[type.ToString()] = (double) _values[(int)type]; // 또는 (float)stat[type]
            }

            return dict;
        }
        
    }
}
