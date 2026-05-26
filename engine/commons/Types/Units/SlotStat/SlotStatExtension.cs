using System;
using System.Collections.Generic;
using Commons.Types.Players;
using Commons.Utility;
using Google.Protobuf.Collections;

namespace Commons.Types.Units.SlotStat
{
    public static class SlotStatExtension
    {
        public static void Apply(this RepeatedField<AddSlotStat> addStats, Dictionary<Slot, SlotStat> stats, int level)
        {
            foreach (var addStat in addStats)
            {
                var count = Math.Max(addStat.Rows.Count, addStat.Slots.Count);
                for (var i = 0; i < count; i++)
                {
                    var slot = new Slot(addStat.Rows.GetClamped(i), addStat.Slots.GetClamped(i));
                    if (!stats.TryGetValue(slot, out var stat))
                    {
                        stats[slot] = stat = new SlotStat();
                    }
                    stat.Apply(addStat, level);
                }
            }
        }
        
        public static void ApplyEquipAddStats(this PlayerItemMessage item, Dictionary<Slot, SlotStat> stats)
        {
            var resItem = item.GetData();
            if (resItem == null)
                return;
            
            foreach (var addStat in resItem.EquipAddSlotStats)
            {
                var count = Math.Max(addStat.Rows.Count, addStat.Slots.Count);
                for (var i = 0; i < count; i++)
                {
                    var slot = new Slot(addStat.Rows.GetClamped(i), addStat.Slots.GetClamped(i));
                    if (!stats.TryGetValue(slot, out var stat))
                    {
                        stats[slot] = stat = new SlotStat();
                    }
                    stat.Apply(addStat, item.Level);
                }
            }
        }
    }
}