using System.Collections.Generic;
using Commons.Types.Players;
using Google.Protobuf.Collections;

namespace Commons.Types.Units.SkillGroupStat
{
    public static class SkillGroupStatExtensions
    {
        public static void Apply(this RepeatedField<AddSkillGroupStat> addStats, Dictionary<int, SkillGroupStat> stats, int level)
        {
            foreach (var addStat in addStats)
            {
                foreach (var group in addStat.SkillGroups)
                {
                    if (!stats.TryGetValue(group, out var stat))
                    {
                        stat = new SkillGroupStat();
                        stats[group] = stat;
                    }
                    stat.Apply(addStat, level);
                }
            }
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, Dictionary<int, SkillGroupStat> stats)
        {
            var resItem = item.GetData();
            if (resItem == null)
                return;
            
            foreach (var addStat in resItem.EquipAddSkillGroupStats)
            {
                foreach (var itemGroup in addStat.SkillGroups)
                {
                    if (!stats.TryGetValue(itemGroup, out var stat))
                    {
                        stat = new SkillGroupStat();
                        stats[itemGroup] = stat;
                    }
                    stat.Apply(addStat, item.Level);
                }
            }
        }
    }
}