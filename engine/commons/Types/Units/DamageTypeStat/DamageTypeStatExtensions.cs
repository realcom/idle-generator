using System.Collections.Generic;
using Commons.Types.Players;
using Google.Protobuf.Collections;

namespace Commons.Types.Units.DamageTypeStat
{
    public static class DamageTypeStatExtensions
    {
        public static void Apply(this RepeatedField<AddDamageTypeStat> addStats, Dictionary<DamageType, DamageTypeStat> stats, int level)
        {
            foreach (var addStat in addStats)
            {
                if (!stats.TryGetValue(addStat.DamageType, out var stat))
                {
                    stat = new DamageTypeStat();
                    stats[addStat.DamageType] = stat;
                }
                stat.Apply(addStat, level);
            }
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, Dictionary<DamageType, DamageTypeStat> stats)
        {
            var resItem = item.GetData();
            if (resItem == null)
                return;
            foreach (var addStat in resItem.EquipAddDamageTypeStats)
            {
                if (!stats.TryGetValue(addStat.DamageType, out var stat))
                {
                    stat = new DamageTypeStat();
                    stats[addStat.DamageType] = stat;
                }
                stat.Apply(addStat, item.Level);
            }
        }
    }
}
