using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;

public class Popup_ScoutReward : UIPopup
{
    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>>
    {
    }
    
    public UIElementContainer<Utility.TextCell> acquiredItemsPerHour = new();

    public CustomButton btnGetReward;
    public TextTimer txtScoutAccumulatedTime;
    
    public PremiumLandingBanner premiumLandingBanner;

    public TableElement tableElement = new();
    
    public PurchaseProductCell purchaseProductCellByAdWatch;
    public PurchaseProductCell purchaseProductCellByMaterial;
    public PurchaseProductCell purchaseProductCellByMaterialNoBuyLimit;

    public TextMeshProUGUI[] txtQuickScoutRewardDescs;
    private ResourceItem m_ResScoutItem = null;
    private PlayerItemMessage ScoutItem => MyPlayer.GetItemByDataID(m_ResScoutItem.Id);
    
    protected override void Start()
    {
        btnGetReward.SetOnClick(OnClickGetReward);

        m_ResScoutItem = GlobalResourceItem.ScoutNormalItem;
        
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED) || refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            Refresh();
        }
    }
    
    public void OnClickQuickScout()
    {
        GameManager.Get().ShowPopup<Popup_ScoutReward_Quick>();
    }
    
    public void OnClickGetReward()
    {
        RequestUseCashItem().Forget();
    }

    private async UniTask RequestUseCashItem()
    {
        if (ScoutItem == null)
            return;
        
        var response = await SendPacket<UseCashItemRequest.Types.Response>(Packet.Pop(0, new UseCashItemRequest()
        {
            ItemDataId = ScoutItem.ItemDataId,
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
        }
        
    }

    public override void Refresh()
    {
        base.Refresh();

        premiumLandingBanner.Refresh(CRC.Get().premiumItemDataIdByKey.GetValueOrDefault(nameof(Popup_ScoutReward)));

        var scoutItem = ScoutItem;
        var currentTargetMap = ResourceMap.Get(scoutItem.Param1)!;
        var lastOffsetTime = scoutItem.Param2;
        var minMinutes = currentTargetMap.ScoutAddItemGroups.Min(x => x.Minutes);
        var maxMinutes = currentTargetMap.ScoutAddItemGroups.Max(x => x.MaxMinutes);
        var bonusMinutes = GetScoutBonusMinutes(currentTargetMap.Group);

        txtScoutAccumulatedTime.targetTimeAt = Utility.OffsetSecondsToSeconds(lastOffsetTime +
                                                                              (maxMinutes + bonusMinutes) * 60); 
        txtScoutAccumulatedTime.startTimeAt = Utility.OffsetSecondsToSeconds(lastOffsetTime);
        
        var pendingMinutes = (TimeSystem.offsetTime - lastOffsetTime) / 60;
        
        var rng = new Rng((uint) scoutItem.Param4);

        using var items = PooledList<AddItemGroupExtensions.PredictionItem>.Get();
        using var acquiredItemsPerHourDict = PooledDictionary<int, long>.Get();
        foreach (var addItemGroup in currentTargetMap.ScoutAddItemGroups)
        {
            var count = Math.Min(addItemGroup.MaxMinutes + bonusMinutes, pendingMinutes) / addItemGroup.Minutes;
            items.AddRange(addItemGroup.GetPredictionItems(count, rng, GetScountRewardBonusMultiplier(currentTargetMap.Group)));
        }

        foreach (var txtQuickScoutRewardDesc in txtQuickScoutRewardDescs)
        {
            txtQuickScoutRewardDesc.text = "Popup_ScoutReward_QuickScoutRewardDesc".L((maxMinutes / 60).ToString());
        }
        foreach (var aig in currentTargetMap.ScoutAddItemGroups)
        {
            foreach (var addItem in aig.AddItems)
            {
                acquiredItemsPerHourDict[addItem.ItemDataId] = acquiredItemsPerHourDict.GetValueOrDefault(addItem.ItemDataId) + (60 * addItem.Count / aig.Minutes);
            }
        }
        
        foreach (var (element, _, itemDataId) in acquiredItemsPerHour.GetElements(CRC.Get().GetGoodsItemDataIds(nameof(Popup_ScoutReward))))
        {
            var count = acquiredItemsPerHourDict.GetValueOrDefault(itemDataId);
            var bonusCount = (long)(count * (GetScountRewardBonusMultiplier(currentTargetMap.Group) - 1));

            var key = bonusCount > 0 ? "Popup_ScoutReward_AcquiredItemsPerHour_HasBonus" : "Popup_ScoutReward_AcquiredItemsPerHour";
            element.txtString.text = key.L(ResourceItem.Get(itemDataId)!.ClientSpriteIconString, count.ToString(), bonusCount.ToString());
        }

        items.Shrink();
        
        const int columnCount = 5;
        tableElement.table.Initialize<AddItemGroupExtensions.PredictionItem, UITableRow<ItemCellBehaviourWrapperElement>>(items, (itemList, row, rows) =>
        {
            foreach (var (element, i) in rows.cells.GetElements(columnCount))
            {
                var index = row * columnCount + i;
                var item = itemList.GetSafe(index);
                
                element.Get<ItemCell>().Refresh(item);
            }
        }, Mathf.CeilToInt(items.Count / (float)columnCount));
        
        using var getRewardInteractor = new ButtonInteractor(btnGetReward);
        getRewardInteractor.Update(pendingMinutes >= minMinutes, "Popup_ScoutReward_NotSpendEnoughTime".L());

        RefreshQuickScout();
    }

    private int GetScoutBonusMinutes(int mapGroup)
    {
        return MyPlayer.GetItemsByTag(Tag.BoostScoutMaxMinutes)
            .Sum(i =>
            {
                if(!i.IsValid())
                    return 0;
                
                var resItem = i.GetData()!;
                if (resItem.MapGroup != mapGroup)
                    return 0;

                return resItem.BoostScoutMaxMinutes;
            });
    }
    
    private float GetScountRewardBonusMultiplier(int mapGroup)
    {
        var bonusPercent = MyPlayer.GetItemsByTag(Tag.BoostScoutReward)
            .Sum(i =>
            {
                if(!i.IsValid())
                    return 0;
                
                var resItem = i.GetData()!;
                if (resItem.MapGroup != mapGroup)
                    return 0;

                return resItem.BoostScoutRewardPercent;
            });
        return 1f + bonusPercent / 100f;
    }

    private void RefreshQuickScout()
    {
        var mapMeta = ResourceMap.GetAllByTag(Tag.Main).FirstOrDefault(e => e.ContainsTag(Tag.Meta))!;
        foreach (var resourceItem in ResourceItem.GetAllByParentId(mapMeta.ProductScoutQuickItemDataId))
        {
            if (resourceItem.ParentId == resourceItem.Id)
                continue;

            PurchaseProductCell cell = null;
            if (resourceItem.Type == ResourceItem.Types.Type.MaterialAd)
            {
                cell = purchaseProductCellByAdWatch;
            }
            else if (resourceItem.ProductMaterialItemGroups.Count > 0)
            {
                cell = resourceItem.GetProductBuyLimitAchievement() == null ? purchaseProductCellByMaterialNoBuyLimit : purchaseProductCellByMaterial;
            }
            else
            {
                continue;
            }

            if (!resourceItem.CanDisplay)
            {
                cell!.elementRoot.SetActive(false);
                continue;
            }

            cell!.Refresh(resourceItem);
        }
    }
    
}
