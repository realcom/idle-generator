using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Google.Protobuf.Collections;

namespace Commons.Types.Units
{
    public static class UnitStatExtensions
    {
        public static void Flatten(this RepeatedField<AddUnitStat> addStats, IList<float> stats)
        {
            foreach (var addStat in addStats)
            {
                for (var i = 0; i < addStat.Value.Count; i++)
                {
                    if (stats.Count <= i)
                        break;
                    
                    stats[i] += addStat.Value[i];
                }
            }
        }
        
        public static void Apply(this RepeatedField<AddUnitStat> addStats, UnitStat stat, int level)
        {
            foreach (var addStat in addStats)
                stat.Apply(addStat, level);
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, UnitStat stat, ResourceItem? resItem = null)
        {
            resItem ??= item.GetData();
            if (resItem == null)
                return;
            
            foreach (var addStat in resItem.EquipAddStats)
                stat.Apply(addStat, item.Level);

            if (item.Option != null)
            {
                foreach (var (option, optionLevel) in item.Option.GetRerollOptions(resItem))
                {
                    foreach (var addStat in option.EquipAddStats)
                    {
                        stat.Apply(addStat, optionLevel);
                    }
                }    
            }
        }

        public static void ApplyEquipAddBuffAddStats(this PlayerItemMessage item, UnitStat stat, ResourceItem? resItem = null)
        {
            resItem ??= item.GetData();
            if (resItem == null)
                return;
            
            foreach (var addBuff in resItem.EquipAddBuffs)
            {
                var resBuff = ResourceBuff.Get(addBuff.BuffDataId);
                if (resBuff == null)
                    continue;

                foreach (var addStat in resBuff.AddStats)
                    stat.Apply(addStat, addBuff.Level);
            }
            
        }
        
        public static FixedFloat GetStat(this RepeatedField<AddUnitStat> addStats, UnitStatType type, int level)
        {
            return addStats.Sum(x => x.Type == type ? x.Value.GetClamped(level - 1) : 0f);
        }
    }
}
