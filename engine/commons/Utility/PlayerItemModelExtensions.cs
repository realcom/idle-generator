using System;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;

namespace Commons.Utility
{
    public static class PlayerItemModelExtensions
    {
        public static int CalculateRegenValue(int prevValue, int maxValue, int regenPerSecond, int refreshOffsetTime, out int offsetTime)
        {
            offsetTime = DateTime.UtcNow.ToOffsetTime();
            if (offsetTime <= refreshOffsetTime)
                return prevValue;
            return Math.Min(maxValue, prevValue + (offsetTime - refreshOffsetTime) * regenPerSecond);
        }

        public static int CalculateRegenValueFromPeriod(int count, int prevRegenCount, int maxValue, int regenPeriod, int refreshOffsetTime,
            out int offsetTime)
        {
            var prevTotalCount = count + prevRegenCount;
            offsetTime = DateTime.UtcNow.ToOffsetTime();
            if (prevTotalCount >= maxValue)
                return prevRegenCount;
            
            var regenCount = Math.Min( maxValue - prevTotalCount, (offsetTime - refreshOffsetTime) / regenPeriod);
            offsetTime = (int)(refreshOffsetTime + regenPeriod * regenCount);

            return prevRegenCount + regenCount;

            // offsetTime = DateTime.UtcNow.ToOffsetTime();
            //
            // // not refreshed
            // if (regenPeriod > (offsetTime - refreshOffsetTime))
            // {
            //     offsetTime = refreshOffsetTime;
            //     return prevValue;
            // }
            //
            // var regenCount = (offsetTime - refreshOffsetTime) / regenPeriod;
            //
            // var count = Math.Min(maxValue, prevValue + regenCount);
            // if (count < prevValue) count = prevValue;
            // if (count < maxValue)
            //     offsetTime -= (offsetTime - refreshOffsetTime) % regenPeriod;
            //
            // return count;
        }
        
        //Calculate stats from here many ResourceItem.AddStats
        public static void ApplyItemStats(Func<int, IReadOnlyPlayerItem?> getModelFunc, UnitStat itemStat)
        {
            foreach (var resItem in ResourceItem.HasAddStatsItems)
            {
                var item = getModelFunc(resItem.Id);
                if (item == null)
                    continue;
                
                ApplyAddStats(resItem, item);
            }

            return;

            void ApplyAddStats( ResourceItem resItem, IReadOnlyPlayerItem item)
            {
                foreach (var addStat in resItem.AddStats)
                    itemStat.Apply(addStat, item.Level);

                if (item.PlayerItemOption != null)
                {
                    foreach (var (option, optionLevel) in item.PlayerItemOption.GetRerollOptions(resItem))
                    {
                        foreach (var addStat in option.AddStats)
                        {
                            itemStat.Apply(addStat, optionLevel);
                        }
                    }   
                }
            }

        }
    }
}