using System.Collections.Generic;
using Commons.Types.Players;
using Google.Protobuf.Collections;

namespace Commons.Types.Units.BuffGroupStat
{
    public static class BuffGroupStatExtensions
    {
        public static void Apply(this RepeatedField<AddBuffGroupStat> addStats, Dictionary<int, BuffGroupStat> stats, int level)
        {
            foreach (var addStat in addStats)
            {
                foreach (var group in addStat.BuffGroups)
                {
                    if (!stats.TryGetValue(group, out var stat))
                    {
                        stat = new BuffGroupStat();
                        stats[group] = stat;
                    }
                    stat.Apply(addStat, level);
                }
            }
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, Dictionary<int, BuffGroupStat> stats)
        {
            var resItem = item.GetData();
            if (resItem == null)
                return;
            foreach (var addStat in resItem.EquipAddBuffGroupStats)
            {
                foreach (var itemGroup in addStat.BuffGroups)
                {
                    if (!stats.TryGetValue(itemGroup, out var stat))
                    {
                        stat = new BuffGroupStat();
                        stats[itemGroup] = stat;
                    }
                    stat.Apply(addStat, item.Level);
                }
            }
        }
    }
}
