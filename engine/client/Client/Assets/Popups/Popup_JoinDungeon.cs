using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class Popup_JoinDungeon : Popup_JoinDungeonBase
{
    public Image imgIllustLeft;
    public Image imgIllustRight;
    
    public TextMeshProUGUI txtTicketCount;

    public CustomButton btnJoin;
    public PurchaseProductCell cellProductConquer;
    public PurchaseProductCell cellProductTickBuy;

    public override bool Initialize(ResourceMap resMap)
    {
        if (!base.Initialize(resMap))
            return false;
        
        imgIllustLeft.sprite = _resMap.GetSpriteByKey("DetailedIllustLeft") ?? _resMapMeta.GetSpriteByKey("DetailedIllust");
        imgIllustRight.sprite = _resMap.GetSpriteByKey("DetailedIllustRight") ?? _resMapMeta.GetSpriteByKey("DetailedIllust");
        
        txtDungeonStep.text = "Popup_JoinDungeon_DungeonName".L(_resMap.Stage.ToString());

        btnJoin.SetOnClick(() =>
        {
            GameBoardManager.Get().GoToMapLocalToNet(_resMap.Id).Forget();
        });
        
        cellProductConquer.btnPurchaseProduct.SetPurchaseCallback(() =>
        {
            if (this)
                AddRefreshFlag(RefreshFlag.ALL);
        });

        cellProductTickBuy.btnPurchaseProduct.SetPurchaseCallback(() =>
        {
            if (this)
                AddRefreshFlag(RefreshFlag.ALL);
        });

        return true;
    }

    public override void Refresh()
    {
        base.Refresh();

        var resTicket = _resMap.EntryMaterialItemGroups.First().MaterialItems.First().GetData();
        var ticket = MyPlayer.GetItemByDataID(resTicket.Id);
        var ticketCount = ticket?.GetCount() ?? 0;
        txtTicketCount.text = "Format_Count_Of_MaxCount".L(resTicket.ClientSpriteIconString, ticketCount, resTicket.MaxCount);
        
        var productQuickScoutMeta = ResourceItem.Get(_resMapMeta.ProductScoutQuickItemDataId)!;
        var productQuickScout = ResourceItem.GetAllByParentId(productQuickScoutMeta.Id).PickMaterialProduct();
        cellProductConquer.Refresh(productQuickScout);
        cellProductConquer.btnPurchaseProduct.interactable &= _resMap.Stage > 1;
        
        var productBuyTicket = ResourceItem.GetAllByParentId(_resMapMeta.ProductBuyTicketItemDataId).PickAdWatchProduct();
        cellProductTickBuy.Refresh(productBuyTicket);
        
        var hasTicket = ticketCount > 0;
        
        using (var interactor = new ButtonInteractor(btnJoin))
        {
            var cleared = MyPlayer.IsAchievementCompletedOrRewarded(_resMap.GetClearAchievement());
            interactor.Update(!cleared,
                _resMapMeta.GetLastStageMap().Id == _resMap.Id ?
                "PreparingNextStage".L() :
                "AlreadyClearedStage".L());
        }
        
        cellProductConquer.elementRoot.SetActive(hasTicket);
        cellProductTickBuy.elementRoot.SetActive(!hasTicket);
    }
}
