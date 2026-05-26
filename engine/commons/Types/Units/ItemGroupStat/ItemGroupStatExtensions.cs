using System.Collections.Generic;
using Commons.Types.Players;
using Google.Protobuf.Collections;

namespace Commons.Types.Units.ItemGroupStat
{
    public static class ItemGroupStatExtensions
    {
        public static void Apply(this RepeatedField<AddItemGroupStat> addStats, Dictionary<int, ItemGroupStat> stats, int level)
        {
            foreach (var addStat in addStats)
            {
                foreach (var itemGroup in addStat.ItemGroups)
                {
                    if (!stats.TryGetValue(itemGroup, out var stat))
                    {
                        stat = new ItemGroupStat();
                        stats[itemGroup] = stat;
                    }
                    stat.Apply(addStat, level);
                }
            }
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, Dictionary<int, ItemGroupStat> stats)
        {
            var resItem = item.GetData();
            if (resItem == null)
                return;
            foreach (var addStat in resItem.EquipAddItemGroupStats)
            {
                foreach (var itemGroup in addStat.ItemGroups)
                {
                    if (!stats.TryGetValue(itemGroup, out var stat))
                    {
                        stat = new ItemGroupStat();
                        stats[itemGroup] = stat;
                    }
                    stat.Apply(addStat, item.Level);
                }
            }
        }
    }
}
