using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Commons.Utility;

namespace Commons.Types.Units.BuffGroupStat
{
    public class BuffGroupStat
    {
        private readonly FixedFloat[] _values = new FixedFloat[(int)BuffGroupStatType.Count];
        
        public FixedFloat this[BuffGroupStatType type]
        {
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            get => _values[(int)type];
            [MethodImpl(MethodImplOptions.AggressiveInlining)]
            internal set => _values[(int)type] = value;
        }

        public FixedFloat BuffApplyResistancePercent => this[BuffGroupStatType.BuffApplyResistancePercent];
        public FixedFloat BossBuffApplyResistancePercent => this[BuffGroupStatType.BossBuffApplyResistancePercent];
        public FixedFloat BuffApplyAmplifyPercent => this[BuffGroupStatType.BuffApplyAmplifyPercent];
        public FixedFloat BuffApplyResistanceReducePercent => this[BuffGroupStatType.BuffApplyResistanceReducePercent];
        public FixedFloat BossBuffApplyResistanceReducePercent => this[BuffGroupStatType.BossBuffApplyResistanceReducePercent];
        
        public FixedFloat BuffDurationEfficiencyPercent => this[BuffGroupStatType.BuffDurationEfficiencyPercent];
        public FixedFloat SelfBuffDurationEfficiencyPercent => this[BuffGroupStatType.SelfBuffDurationEfficiencyPercent];
        public FixedFloat TeamBuffDurationEfficiencyPercent => this[BuffGroupStatType.TeamBuffDurationEfficiencyPercent];
        public FixedFloat EnemyBuffDurationEfficiencyPercent => this[BuffGroupStatType.EnemyBuffDurationEfficiencyPercent];
        
        public void Clear()
        {
            Array.Clear(_values, 0, _values.Length);
        }
        
        public void Clear(IList<float> values)
        {
            for (var i = 0; i < values.Count; i++)
                _values[i] = values[i];
        }

        public void Apply(AddBuffGroupStat addStat, int level)
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
