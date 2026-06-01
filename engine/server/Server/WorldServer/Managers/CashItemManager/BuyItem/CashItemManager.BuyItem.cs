using Commons;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Events;
using Server.Models;
using Server.Stuffs;
using Server.Utility;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private const float AchievementProgressiveSummonTierWeightBonusPerLevel = 0.22f;

    public StatusCode BuyItem(int productItemDataId, int count, out int multiplier, IList<PlayerItemMessage> consumedItemMessages, List<PlayerItemModel>? selectedMaterialItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resProductItem = ResourceItem.Get(productItemDataId);
        return BuyItem(resProductItem!, count, out multiplier, consumedItemMessages, selectedMaterialItems, addedItemStuffs);
    }

    public (StatusCode status, IEnumerable<(PlayerItemModel, int)> selectedMaterialItemModels) GetBuyItemPredictionResult(ResourceItem resProductItem, int count, List<PlayerItemModel>? selectedMaterialItems = null)
    {
        if (resProductItem.Category != ResourceItem.Types.Category.Product)
            return (StatusCode.BadRequest, []);
        if (resProductItem.PriceUsd != 0 || resProductItem.PriceXtr != 0)
            return (StatusCode.ItemNotBuyable, []);

        var status = ValidationAchievements(resProductItem, StatusCode.ItemNotBuyable);
        if (!status.IsSuccess())
            return (status, []);
        
        if (resProductItem.ReprocessableDelayMinutes > 0)
        {
            var productItemDataId = resProductItem.Id;
            var productItem = GetOrCreateItem(productItemDataId, out _, 0);
            if (productItem.param2 > DateTime.UtcNow.ToOffsetTime())
                return (StatusCode.ItemNotBuyable, []);
        }
        
        var (materialItemGroups, materialCount) = GetProductMaterialItemGroupsForBuy(resProductItem, count);
        status = TryConsumeMaterials(out var selectedMaterialItemModels, materialItemGroups, selectedMaterialItems, materialCount);
        if (!status.IsSuccess())
            return (status, []);

        return (StatusCode.Ok, selectedMaterialItemModels);
    }

    public StatusCode BuyItem(ResourceItem resProductItem, int count, out int multiplier,
        IList<PlayerItemMessage> consumedItemMessages,
        List<PlayerItemModel>? selectedMaterialItems = null,
        IList<AddedItemStuff>? addedItemStuffs = null)
    {
        multiplier = 1;

        var (status, selectedMaterialItemModels) = GetBuyItemPredictionResult(resProductItem, count, selectedMaterialItems);
        if (!status.IsSuccess())
            return status;
        
        foreach (var (materialItemModel, materialItemCount) in selectedMaterialItemModels)
        {
            RemoveItem(materialItemModel, materialItemCount, checkCanRemove: false);
            
            var itemMessage = materialItemModel.ToMessage();
            itemMessage.Count = materialItemCount;
            consumedItemMessages.Add(itemMessage);
        }

        addedItemStuffs ??= new List<AddedItemStuff>();
        status = ProcessBuyItem(resProductItem, count, out multiplier, addedItemStuffs: addedItemStuffs);
        if (!status.IsSuccess())
            return status;

        IncreaseProgressiveProductPurchaseCount(resProductItem, count);

        var updateMultiplier = multiplier;
        Player.SendAcquiredItemsUpdate(addedItemStuffs.ToPlayerItemMessages(),
            PlayerAcquiredItemsUpdate.Types.Type.BuyProduct,
            productItemDataId: resProductItem.Id,
            handleUpdateAction: update => { update.Multiplier = updateMultiplier; });

        return StatusCode.Ok;
    }

    private (IEnumerable<MaterialItemGroup> materialItemGroups, int count) GetProductMaterialItemGroupsForBuy(ResourceItem resProductItem, int count)
    {
        if (!UsesProgressiveProductPrice(resProductItem) || count <= 0)
            return (resProductItem.ProductMaterialItemGroups, count);

        var scaledGroups = new List<MaterialItemGroup>();
        if (UsesAchievementProgressiveProductPrice(resProductItem))
        {
            var completedTierCount = GetProgressiveProductCompletedAchievementCount(resProductItem);
            foreach (var materialItemGroup in resProductItem.ProductMaterialItemGroups)
            {
                var scaledGroup = materialItemGroup.Clone();
                foreach (var materialItem in scaledGroup.MaterialItems)
                    materialItem.Count = (materialItem.Count + completedTierCount * resProductItem.RegenCount) * count;
                scaledGroups.Add(scaledGroup);
            }

            return (scaledGroups, 1);
        }

        var purchasedBefore = GetProgressiveProductPurchaseCount(resProductItem);
        foreach (var materialItemGroup in resProductItem.ProductMaterialItemGroups)
        {
            var scaledGroup = materialItemGroup.Clone();
            foreach (var materialItem in scaledGroup.MaterialItems)
            {
                materialItem.Count = GetProgressiveProductMaterialCount(
                    materialItem.Count,
                    purchasedBefore,
                    count,
                    resProductItem.RegenPeriod,
                    resProductItem.RegenCount);
            }
            scaledGroups.Add(scaledGroup);
        }

        return (scaledGroups, 1);
    }

    private static bool UsesProgressiveProductPrice(ResourceItem resProductItem)
    {
        return resProductItem.Category == ResourceItem.Types.Category.Product
               && resProductItem.RegenCount > 0
               && (resProductItem.RegenPeriod > 0 || resProductItem.TargetAchievementDataIds.Count > 0)
               && resProductItem.ProductMaterialItemGroups.Count > 0;
    }

    private static bool UsesAchievementProgressiveProductPrice(ResourceItem resProductItem)
    {
        return resProductItem.TargetAchievementDataIds.Count > 0;
    }

    private int GetProgressiveProductCompletedAchievementCount(ResourceItem resProductItem)
    {
        return resProductItem.TargetAchievementDataIds.Count(Player.AchievementManager.IsAchievementCompleted);
    }

    private int GetAchievementProgressiveSummonLevel(ResourceItem resProductItem)
    {
        return GetProgressiveProductCompletedAchievementCount(resProductItem) + 1;
    }

    private int GetProgressiveProductPurchaseCount(ResourceItem resProductItem)
    {
        var productItemDataId = resProductItem.ProductItemDataId != 0 ? resProductItem.ProductItemDataId : resProductItem.Id;
        var productItem = GetItemByDataId(productItemDataId, checkCount: false, checkUntilAt: false);
        return productItem?.ToMessage().Option?.ProductOption?.MultiplyBonusCount ?? 0;
    }

    private void IncreaseProgressiveProductPurchaseCount(ResourceItem resProductItem, int count)
    {
        if (!UsesProgressiveProductPrice(resProductItem) || UsesAchievementProgressiveProductPrice(resProductItem) || count <= 0)
            return;

        var productItemDataId = resProductItem.ProductItemDataId != 0 ? resProductItem.ProductItemDataId : resProductItem.Id;
        var productItem = GetOrCreateItem(productItemDataId, out _, 0);
        using var optionScope = productItem.GetOptionScope();
        var productOption = optionScope.Option.GetProductOption();
        productOption.MultiplyBonusCount += count;
    }

    private static int GetProgressiveProductMaterialCount(int baseCount, int purchasedBefore, int buyCount, int stepInterval, int stepAdd)
    {
        var totalCount = 0;
        for (var i = 0; i < buyCount; i++)
            totalCount += baseCount + ((purchasedBefore + i) / stepInterval) * stepAdd;
        return totalCount;
    }

    public StatusCode ProcessBuyItem(ResourceItem resProductItem, int count, out int multiplier,
        IList<AddedItemStuff>? addedItemStuffs = null)
    {
        multiplier = 1;
        
        if (resProductItem.ContainsTag(Tag.MultiplyChance))
        {
            var productItemDataId = resProductItem.ProductItemDataId;
            var productItem = GetOrCreateItem(productItemDataId, out _, 0);
            using var optionScope = productItem.GetOptionScope();
            var productOption = optionScope.Option.GetProductOption();
            if (productOption.MultiplyBonusCount >= productItem.Data.BonusCount)
            {
                productOption.MultiplyBonusCount = 0;
                multiplier = productItem.Data.Multipliers.Max();
            }
            else
            {
                productOption.MultiplyBonusCount += 1;
                multiplier =  productItem.Data.Multipliers.CryptoPickWeighted(resProductItem.MultiplierWeights);
            }
        }

        if (resProductItem.ReprocessableDelayMinutes > 0)
        {
            var productItemDataId = resProductItem.Id;
            var productItem = GetOrCreateItem(productItemDataId, out _, 0);
            productItem.param2 = Math.Max(productItem.param2, DateTime.UtcNow.AddMinutes(resProductItem.ReprocessableDelayMinutes).ToOffsetTime());
        }

        var levelReferenceItemDataId = 0;
        if (resProductItem.TargetItemDataIds.Count > 0)
            levelReferenceItemDataId = resProductItem.TargetItemDataIds.First();
        if (resProductItem.AddItemLevelReferenceItemDataId != 0)
            levelReferenceItemDataId = resProductItem.AddItemLevelReferenceItemDataId;

        var baseAddItemGroups = resProductItem.AddItemGroups.FilterByLevel(GetItemLevelWithBonusLevel, levelReferenceItemDataId).ToList();
        baseAddItemGroups = ApplyAchievementProgressiveSummonWeights(resProductItem, baseAddItemGroups);
        if (resProductItem.ContainsTag(Tag.Pity))
        {
            // 천장 체크를 baseAddItemGroups.Count * count * multiplier 만큼 하게되므로 의도와 다르게 동작하게 됨.
            if (Config.IsDebug && resProductItem.ContainsTag(Tag.Pity) && baseAddItemGroups.Count > 1)
            {
                throw new InvalidOperationException ($"천장 아이템의 AddItemGroups가 2개 이상 정의되어있습니다. 확인해주세요. {resProductItem.Id}");
            }
            
            for (var i = 0; i < count * multiplier; i++)
            {
                var status = ProcessBuyPity(resProductItem, baseAddItemGroups, addedItemStuffs);
                if (!status.IsSuccess())
                    return status;
            }
        }
        else
        {
            for (var i = 0; i < count * multiplier; i++)
            {
                var status = AddItem(baseAddItemGroups, 1, addedItemStuffs: addedItemStuffs);
                if (!status.IsSuccess())
                    return status;
            }
        }
        
        if (resProductItem.Exp > 0)
        {
            foreach (var itemDataId in resProductItem.TargetItemDataIds)
            {
                var itemModel = GetOrCreateItem(itemDataId, out _);
                AddExp(itemModel, resProductItem.Exp * count);
            }
        }
        
        Player.PublishEvent(new ItemBuyEvent
        {
            ResProductItem = resProductItem,
            Count = count,
        });

        if (resProductItem.ProductExpiredPushDays > 0)
            Player.QueueSave(
                new PlayerPushModel
                {
                    type = PlayerPushModel.PushType.Scheduled,
                    publish_at = DateTime.UtcNow.AddDays(resProductItem.ProductExpiredPushDays),
                    player_id = Player.Id,
                    message = Player.GetString($"Push/ProductExpired/{resProductItem.Id}"),
                }.SaveAsync);

        return StatusCode.Ok;
    }

    private List<AddItemGroup> ApplyAchievementProgressiveSummonWeights(ResourceItem resProductItem, List<AddItemGroup> addItemGroups)
    {
        if (!UsesAchievementProgressiveProductPrice(resProductItem) || addItemGroups.Count == 0)
            return addItemGroups;

        var summonLevel = GetAchievementProgressiveSummonLevel(resProductItem);
        if (summonLevel <= 1)
            return addItemGroups;

        var hasEquipmentReward = addItemGroups.Any(addItemGroup =>
            addItemGroup.AddItems.Any(addItem => ResourceItem.Get(addItem.ItemDataId)?.Category == ResourceItem.Types.Category.Equipment));
        if (!hasEquipmentReward)
            return addItemGroups;

        var scaledGroups = new List<AddItemGroup>(addItemGroups.Count);
        foreach (var addItemGroup in addItemGroups)
        {
            var scaledGroup = addItemGroup.Clone();
            foreach (var addItem in scaledGroup.AddItems)
            {
                var resItem = ResourceItem.Get(addItem.ItemDataId);
                if (resItem?.Category != ResourceItem.Types.Category.Equipment)
                    continue;

                addItem.Weight = GetAchievementProgressiveSummonWeight(addItem.Weight, resItem, summonLevel);
            }
            scaledGroups.Add(scaledGroup);
        }

        return scaledGroups;
    }

    private static float GetAchievementProgressiveSummonWeight(float baseWeight, ResourceItem resItem, int summonLevel)
    {
        if (baseWeight <= 0f || summonLevel <= 1)
            return baseWeight;

        var tierRank = resItem.Tier > 0 ? resItem.Tier :
            resItem.Grade > 0 ? resItem.Grade :
            resItem.Rarity > 0 ? resItem.Rarity : 1;
        var tierLift = Math.Max(0, tierRank - 1);
        if (tierLift == 0)
            return baseWeight;

        return baseWeight * (1f + (summonLevel - 1) * tierLift * AchievementProgressiveSummonTierWeightBonusPerLevel);
    }

    private StatusCode ProcessBuyPity(ResourceItem resProductItem, List<AddItemGroup> addItemGroups, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var productItemDataId = resProductItem.ProductItemDataId;
        var productItem = GetOrCreateItem(productItemDataId, out _, 0);
        var data = productItem.Data;
        
        using var optionScope = productItem.GetOptionScope();
        var productOption = optionScope.Option.GetProductOption();

        productOption.PityCounts.ResizeAndFillNew(data.BonusCounts.Count);
        for (var i = data.BonusCounts.Count - 1; i >= 0; i--)
        {
            if (productOption.PityCounts[i] + 1 >= data.BonusCounts[i])
            {
                //Reset all pity count less than or equal to current index
                for (var resetPityIndex = i; resetPityIndex >= 0; resetPityIndex--)
                    productOption.PityCounts[resetPityIndex] = 0;
                
                for (var increasePityIndex = i + 1; increasePityIndex < productOption.PityCounts.Count; increasePityIndex++)
                    productOption.PityCounts[increasePityIndex] += 1;
                
                return AddPityItemGroup(ResourceItem.Get(data.BonusItemDataIds[i])!);
            }
        }

        var status = AddItem(addItemGroups, addedItemStuffs: addedItemStuffs, onItemAdded: (item, _) =>
        {
            //Add all pity count greater than or equal to PityGroup
            for (var i = item.PityGroup; i < productOption.PityCounts.Count; i++)
            {
                productOption.PityCounts[i] += 1;
            }
        });
        
        if (!status.IsSuccess())
            return status;

        return StatusCode.Ok;
        
        StatusCode AddPityItemGroup(ResourceItem pityResItem)
        {
            var levelReferenceItemDataId = 0;
            if (pityResItem.TargetItemDataIds.Count > 0)
                levelReferenceItemDataId = resProductItem.TargetItemDataIds.First();
            if (pityResItem.AddItemLevelReferenceItemDataId != 0)
                levelReferenceItemDataId = resProductItem.AddItemLevelReferenceItemDataId;
            
            addItemGroups = pityResItem.AddItemGroups.FilterByLevel(GetItemLevelWithBonusLevel, levelReferenceItemDataId).ToList();
            return AddItem(addItemGroups, addedItemStuffs: addedItemStuffs);
        }
    }
    
}
