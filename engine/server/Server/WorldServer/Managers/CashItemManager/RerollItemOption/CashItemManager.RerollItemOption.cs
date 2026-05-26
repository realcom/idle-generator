using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode RerollItemOption(PlayerItemModel? item, int slot, IList<PlayerItemMessage> consumedItemMessages)
    {
        if (item == null)
            return StatusCode.ItemNotFound;
        
        var resItem = item.Data;

        var optionItem = GetItemByDataId(resItem.TargetItemDataIds.First(), checkCount: true, checkUntilAt: true, checkDeprecated: true);
        if (optionItem == null)
            return StatusCode.BadRequest;

        if (resItem.RerollLimit > 0 && item.param2 >= resItem.RerollLimit)
            return StatusCode.BadRequest; // Reroll limit reached

        using var optionScope = item.GetOptionScope();
        var itemOption = optionScope.Option;
        itemOption.RerollOptions.ResizeAndFillNew(resItem.OptionCounts.Max(x => x));

        var optionCount = resItem.OptionCounts.GetClamped(optionItem.level - 1);

        var priceMultiplier = 1f - GetItemsByTag(Tag.DiscountPetOptionRerollMaterialPrice, checkCount: true, checkUntilAt: true, checkDeprecated: true)
            .Sum(x => x.Data.DiscountMaterialPricePercent) / 100f;
        priceMultiplier = float.Max(0f, priceMultiplier);

        var consumeStatus = TryConsumeMaterials(out var selectedMaterialItemModels,
            resItem.RerollMaterialItemGroups.Where(x => x.Level == optionItem.level).ElementAt(item.param3.CountBits()),
            priceMultiplier: priceMultiplier);
        
        if (!consumeStatus.IsSuccess())
            return consumeStatus; // Failed to consume materials;

        foreach (var (materialItemModel, materialItemCount) in selectedMaterialItemModels)
        {
            RemoveItem(materialItemModel, materialItemCount, checkCanRemove: false);
            
            var itemMessage = materialItemModel.ToMessage();
            itemMessage.Count = materialItemCount;
            consumedItemMessages.Add(itemMessage);
        }

        if (slot < 0)
        {
            //Reroll all options.
            var optionGroup = resItem.Options.GetClamped(optionItem.level - 1)!;
            for (var i = 0; i < itemOption.RerollOptions.Count; i++)
            {
                // Skip locked options.
                if (item.param3.IsBitSet(i))
                    continue;

                if (i >= optionCount)
                    continue;

                var option = itemOption.RerollOptions[i];
                var optionData = optionGroup.Sample();
                if (optionData == null)
                    return StatusCode.BadRequest;

                option.Id = optionData.Id;
                option.Level = optionData.GetLevel();

                option.PoolId = optionItem.level;
            }
        }
        else
        {
            // Not implemented yet.
        }
        
        foreach (var (_, materialItemCount) in selectedMaterialItemModels)
        {
            //소모한 재화만큼 옵션 아이템에 경험치 추가
            AddExp(optionItem, materialItemCount);
        }

        return StatusCode.Ok;
    }
}