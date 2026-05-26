using Commons.Resources;
using Commons.Utility;
using Server.Models;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public void DayReset(DateTime prevDate, DateTime date)
    {
        var startOfWeek = date.StartOfWeek();
        var weekPassed = startOfWeek != prevDate.StartOfWeek();
        var boostState = BuildBoostState();

        foreach (var item in GetItemsByTag(Tag.RegenDaily))
        {
            RegenItemCount(item, boostState);
        }

        foreach (var item in GetItemsByTag(Tag.ResetDaily))
        {
            item.count = 0;

            var data = item.Data;
            if (data.ContainsTag(Tag.AddParam1ToCount))
                item.param1 = 0;
        }

        if (weekPassed)
        {
            foreach (var item in GetItemsByTag(Tag.RegenWeekly))
            {
               RegenItemCount(item, boostState);
            }

            foreach (var item in GetItemsByTag(Tag.ResetWeekly))
            {
                item.count = 0;

                var data = item.Data;
                if (data.ContainsTag(Tag.AddParam1ToCount))
                    item.param1 = 0;
            }
        }

        RetroactiveDailyRewards(date.Date);
    }

    private void RegenItemCount(PlayerItemModel item, BoostState boostState)
    {
        var data = item.Data;
        var maxCount = data.MaxCount + boostState.GetRegenMaxCountBonus(item.item_data_id);
        var regenCount = data.RegenCount + boostState.GetRegenCountBonus(item.item_data_id);
        if (item.count >= maxCount) return;
        item.count = Math.Min(maxCount, regenCount + item.count);
    }
}
