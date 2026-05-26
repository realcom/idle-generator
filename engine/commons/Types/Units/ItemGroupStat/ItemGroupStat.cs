using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Commons.Utility;

namespace Commons.Types.Units.ItemGroupStat
{
    public class ItemGroupStat
    {
        private readonly FixedFloat[] _values = new FixedFloat[(int)ItemGroupStatType.Count];
        
        public FixedFloat this[ItemGroupStatType type]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => _values[(int)type];
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            internal set => _values[(int)type] = value;
        }

        public FixedFloat DamagePercent => this[ItemGroupStatType.DamagePercent];
        public FixedFloat CooldownPercent => this[ItemGroupStatType.CooldownPercent];
        public FixedFloat CriticalPercent => this[ItemGroupStatType.CriticalPercent];
        public FixedFloat CriticalDamagePercent => this[ItemGroupStatType.CriticalDamagePercent];
        public FixedFloat KnockbackPercent => this[ItemGroupStatType.KnockbackPercent];
        public FixedFloat AdditionalAttackPercent => this[ItemGroupStatType.AdditionalAttackPercent];
        
        public void Clear()
        {
            Array.Clear(_values, 0, _values.Length);
        }
        
        public void Clear(IList<float> values)
        {
            for (var i = 0; i < values.Count; i++)
                _values[i] = values[i];
        }

        public void Apply(AddItemGroupStat addStat, int level)
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
    }
}
