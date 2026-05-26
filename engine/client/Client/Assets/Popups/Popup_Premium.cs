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
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Premium : UIPopup, IGoodsViewer
{
    public GoodsContainer goodsContainer;

    public UIElementContainer<ItemCellBehaviourWrapperElement> dailyRewards = new();
    public ClaimAchievementRewardButton btnClaimDailyReward;
    public TextTimer txtDailyRewardTimer;

    [Serializable]
    public class PremiumCell : PurchaseProductCell
    {
        public Image imgFrame;
        [ForceCache] public ClaimDailyRewardCell claimDailyRewardCell;
        public CustomToggle toggleActivation;
        public TextTimer txtRemainTime;
        
        public UIElementContainer<ItemCellBehaviourWrapperElement> addItems = new();
        public UIElementContainer<ItemCellBehaviourWrapperElement> dailyAddItems = new();

        public TextMeshProUGUI txtEffect;

        public override bool Refresh(ResourceItem resProduct)
        {
            if (!base.Refresh(resProduct))
                return false;

            var resPremiumItem = resProduct.AddItemGroups.GetAddItem().GetData();
            var premiumItem = MyPlayer.GetItemByDataID(resPremiumItem.Id, checkCount: false, checkTimeValid: false);
            
            imgFrame.sprite = resProduct.ClientSpriteFrame;

            var hasPremium = premiumItem?.GetCount() > 0;
            toggleActivation.isOn = hasPremium;

            if (!hasPremium)
            {
                txtRemainTime.text.text = "HasNotPremiumItem".L();
            }
            else if (premiumItem.UntilAt == null)
            {
                txtRemainTime.text.text = "EverlastingPremiumItem".L();
            }
            txtRemainTime.targetTimeAt = premiumItem?.UntilAt.ToSeconds() ?? 0;

            txtEffect.text = resProduct.GetLocalizedString("PremiumEffect");
            
            foreach (var (element, _, addItem) in addItems.GetElements(resProduct.AddItemGroups[1].AddItems))
                element.Get<ItemCell>().Refresh(addItem);
            
            foreach (var (element, _, addItem) in dailyAddItems.GetElements(resPremiumItem.DailyRewardAddItemGroups.GetAddItems()))
                element.Get<ItemCell>().Refresh(addItem);

            return true;
        }
    }
    
    public UIElementContainer<PremiumCell> premiumCells = new();

    public CustomButton btnGetAll;

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            Refresh();
        }
    }

    public override void Refresh()
    {
        base.Refresh();

        RefreshFixedDailyReward();
        RefreshPremiumProducts();
        RefreshGoods();
    }
    
    private int _landingTargetProductItemDataId;

    public void SetLandingTargetProductItemDataId(int dataId)
    {
        _landingTargetProductItemDataId = dataId;
    }

    private void RefreshFixedDailyReward()
    {
        var resAchievement = ResourceAchievement.Get(ResourceAchievement.Global.DataId.PremiumDailyReward)!;
        var achievement = MyPlayer.GetAchievementByDataID(resAchievement);

        var rewards = resAchievement.RewardAddItemGroups.GetAddItems();
        foreach (var (element, _, addItem) in dailyRewards.GetElements(rewards))
        {
            var cell = element.Get<AchievementRewardItemCell>();
            cell.Refresh(addItem);
            
            cell.ShowCompleted(achievement.IsAchievementCompleted());
            cell.ShowDim(achievement.IsAchievementRewarded());
        }
        
        btnClaimDailyReward.Refresh(resAchievement, this);
        txtDailyRewardTimer.targetTimeAt = MyPlayer.World.GetNextDayResetTime().ToSeconds();
    }

    private void RefreshPremiumProducts()
    {
        using var premiumProducts = PooledList<ResourceItem>.Get();

        foreach (var resItem in ResourceItem.GetAllByTargetPopupName(nameof(Popup_Premium)))
        {
            if (resItem.Category != ResourceItem.Types.Category.Product)
                continue;

            if (!resItem.IsValid)
                continue;
            
            premiumProducts.Add(resItem);
        }

        premiumProducts.Sort((x, y) => x.Order.CompareTo(y.Order));
        
        foreach (var (cell, _, resProduct) in premiumCells.GetElements(premiumProducts))
        {
            if (!cell.Refresh(resProduct))
                continue;
            
            var resPremiumItem = resProduct.AddItemGroups.GetAddItem().GetData();
            var premiumItem = MyPlayer.GetItemByDataID(resPremiumItem.Id, checkCount: false, checkTimeValid: false);

            cell.claimDailyRewardCell.Refresh(premiumItem, this);
            
            // 상품 자체로 표기 가능하고, 받기 불가능할 때 표기
            cell.btnPurchaseProduct.SetActive(cell.btnPurchaseProduct.isActiveAndEnabled && !cell.claimDailyRewardCell.ClaimButton.interactable);
        }

        var canGetAll = MyPlayer.IsAchievementCompleted(ResourceAchievement.Global.DataId.PremiumDailyReward);
        foreach (var resProduct in premiumProducts)
        {
            var item = MyPlayer.GetItemByDataID(resProduct.AddItemGroups.GetAddItem().ItemDataId, checkCount: false, checkTimeValid: false);
            canGetAll |= item?.CanClaimDailyReward() == true;
        }

        using (var interactor = new ButtonInteractor(btnGetAll))
        {
            interactor.Update(canGetAll, "NoClaimableReward".L());
        }
        
        btnGetAll.SetOnClick(() =>
        {
            OnClickGetAll().Forget();
        });
    }
    
    private async UniTask OnClickGetAll()
    {
        FreezeInteraction();
        
        using var acquiredItems = PooledList<PlayerItemMessage>.Get();
        
        var bWaitClaimDailyRewardAchievement = MyPlayer.IsAchievementCompleted(ResourceAchievement.Global.DataId.PremiumDailyReward);
        if (bWaitClaimDailyRewardAchievement)
        {
            var response = await SendPacket<ClaimAchievementRewardRequest.Types.Response>(Packet.Pop(0, new ClaimAchievementRewardRequest()
            {
                AchievementDataId = ResourceAchievement.Global.DataId.PremiumDailyReward,
                AcquiredItemUpdateSilently = true
            }), this.GetCancellationTokenOnDestroy(), freezeInteraction: false);

            bWaitClaimDailyRewardAchievement = false;

            if (response.Status.IsSuccess())
            {
                acquiredItems.AddRange(response.Items);
            }
        }
        
        using var claimableItemIds = PooledList<long>.Get();
        foreach (var resItem in ResourceItem.GetAllByTargetPopupName(nameof(Popup_Premium)))
        {
            if (resItem.Category != ResourceItem.Types.Category.Product)
                continue;

            if (!resItem.IsValid)
                continue;
            
            var item = MyPlayer.GetItemByDataID(resItem.AddItemGroups.GetAddItem().ItemDataId, checkCount: false, checkTimeValid: false);
            if (item?.CanClaimDailyReward() == true)
                claimableItemIds.Add(item.Id);
        }
        
        var bWaitClaimDailyRewardItems = claimableItemIds.Count > 0;
        if (bWaitClaimDailyRewardItems)
        {
            var response = await SendPacket<ClaimDailyRewardRequest.Types.Response>(Packet.Pop(0, new ClaimDailyRewardRequest()
            {
                ItemIds = { claimableItemIds },
                AcquiredItemUpdateSilently = true
            }), this.GetCancellationTokenOnDestroy(), freezeInteraction: false);
            
            bWaitClaimDailyRewardItems = false;

            if (response.Status.IsSuccess())
            {
                acquiredItems.AddRange(response.Items);
            }
        }
        
        await UniTask.WaitUntil(() => !bWaitClaimDailyRewardAchievement && !bWaitClaimDailyRewardItems);

        ZModeManagerLobby.EnqueueAcquiredItems(acquiredItems);
        
        UnfreezeInteraction();
    }

    public void RefreshGoods()
    {
        RefreshGoods(CRC.Get().GetGoodsItemDataIds(nameof(Popup_Premium)));
    }

    public void RefreshGoods(IList<int> goodsIds)
    {
        goodsContainer.RefreshGoods(goodsIds);
    }
}
