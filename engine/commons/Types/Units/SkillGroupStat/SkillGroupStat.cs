using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using Commons.Utility;

namespace Commons.Types.Units.SkillGroupStat
{
    public class SkillGroupStat
    {
        private readonly FixedFloat[] _values = new FixedFloat[(int)SkillGroupStatType.Count];
        
        public FixedFloat this[SkillGroupStatType type]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => _values[(int)type];
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            internal set => _values[(int)type] = value;
        }
        
        public FixedFloat DamagePercent => this[SkillGroupStatType.DamagePercent];
        public FixedFloat SkillScalePercent => this[SkillGroupStatType.SkillScalePercent];
        
        public void Clear()
        {
            Array.Clear(_values, 0, _values.Length);
        }
        
        public void Clear(IList<float> values)
        {
            for (var i = 0; i < values.Count; i++)
                _values[i] = values[i];
        }

        public void Apply(AddSkillGroupStat addStat, int level)
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