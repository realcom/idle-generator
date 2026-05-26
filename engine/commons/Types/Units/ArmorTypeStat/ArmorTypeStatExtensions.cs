using System.Collections.Generic;
using Commons.Types.Players;
using Google.Protobuf.Collections;

namespace Commons.Types.Units.ArmorTypeStat
{
    public static class ArmorTypeStatExtensions
    {
        public static void Apply(this RepeatedField<AddArmorTypeStat> addStats, Dictionary<ArmorType, ArmorTypeStat> stats, int level)
        {
            foreach (var addStat in addStats)
            {
                if (!stats.TryGetValue(addStat.ArmorType, out var stat))
                {
                    stat = new ArmorTypeStat();
                    stats[addStat.ArmorType] = stat;
                }
                stat.Apply(addStat, level);
            }
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, Dictionary<ArmorType, ArmorTypeStat> stats)
        {
            var resItem = item.GetData();
            if (resItem == null)
                return;
            foreach (var addStat in resItem.EquipAddArmorTypeStats)
            {
                if (!stats.TryGetValue(addStat.ArmorType, out var stat))
                {
                    stat = new ArmorTypeStat();
                    stats[addStat.ArmorType] = stat;
                }
                stat.Apply(addStat, item.Level);
            }
        }
    }
}
