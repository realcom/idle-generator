using Commons.Utility;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private static void AddItemPostProcessEquipment(PlayerItemModel item)
    {
        var resItem = item.Data;
        if (!resItem.Unstackable || resItem.OptionCounts.Count == 0 || resItem.Options.Count == 0)
            return;

        var optionSlotCount = resItem.OptionCounts.Max(x => x);
        if (optionSlotCount <= 0)
            return;

        var optionPoolIndex = Math.Min(resItem.Options.Count - 1, Math.Max(0, item.level - 1));
        var optionPoolId = optionPoolIndex + 1;
        var optionCount = resItem.OptionCounts.GetClamped(item.level - 1);
        if (optionCount <= 0)
            return;

        var optionGroup = resItem.Options[optionPoolIndex];
        using var optionScope = item.GetOptionScope();
        var itemOption = optionScope.Option;
        itemOption.RerollOptions.ResizeAndFillNew(optionSlotCount);

        for (var i = 0; i < itemOption.RerollOptions.Count && i < optionCount; i++)
        {
            var optionData = optionGroup.Sample();
            if (optionData == null)
                continue;

            itemOption.RerollOptions[i].Id = optionData.Id;
            itemOption.RerollOptions[i].Level = optionData.GetLevel();
            itemOption.RerollOptions[i].PoolId = optionPoolId;
        }
    }
}
