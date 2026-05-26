using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Commons.Types.Units.ItemGroupStat;
using Commons.Utility;

namespace Commons.Types.Units.SlotStat
{
    public readonly struct Slot : IEquatable<Slot>
    {
        public readonly int row;
        public readonly int slot;

        public Slot(int row, int slot)
        {
            this.row = row;
            this.slot = slot;
        }

        public bool Equals(Slot other)
        {
            return row == other.row && slot == other.slot;
        }
    }
    
    public class SlotStat
    {
        private readonly FixedFloat[] _values = new FixedFloat[(int)SlotStatType.Count];

        public FixedFloat this[SlotStatType type]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => _values[(int)type];
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            internal set => _values[(int)type] = value;
        }

        public FixedFloat DamagePercent => this[SlotStatType.DamagePercent];
        public FixedFloat CooldownPercent => this[SlotStatType.CooldownPercent];
        public FixedFloat CriticalPercent => this[SlotStatType.CriticalPercent];
        public FixedFloat CriticalDamagePercent => this[SlotStatType.CriticalDamagePercent];
        
        public FixedFloat KnockbackPercent => this[SlotStatType.KnockbackPercent];
        public FixedFloat AdditionalAttackPercent => this[SlotStatType.AdditionalAttackPercent];

        public void Clear()
        {
            Array.Clear(_values, 0, _values.Length);
        }
        
        public void Clear(IList<float> values)
        {
            for (var i = 0; i < values.Count; i++)
                _values[i] = values[i];
        }

        public void Apply(AddSlotStat addStat, int level)
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