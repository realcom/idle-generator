using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_BuyItem_Goods : UIPopup
{
    public TextMeshProUGUI txtGoodsName;
    public UIElementContainer<PurchaseProductCell> cells = new();
    
    private int goodsItemDataId;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var goodsItemDataId))
            {
                Initialize(goodsItemDataId);
            }
            else
            {
                OnCancel();   
            }
        }
    }

    public void Initialize(int goodsItemDataId)
    {
        var resGoods = ResourceItem.Get(goodsItemDataId);
        if (resGoods == null)
        {
            OnCancel();
            return;
        }
        
        this.goodsItemDataId = goodsItemDataId;
    }

    public override void Refresh()
    {
        base.Refresh();
        
        var resGoods = ResourceItem.Get(goodsItemDataId);
        
        using var products = PooledList<ResourceItem>.Get();
        foreach (var resProduct in ResourceItem.GetAllByTargetPopupName(nameof(Popup_BuyItem_Goods)))
        {
            if (resProduct.Category != ResourceItem.Types.Category.Product)
                continue;

            if (!resProduct.CanDisplay)
                continue;

            var itemDataId = resProduct.GetTargetPopupArgument();
            if (itemDataId != goodsItemDataId)
                continue;
            
            products.Add(resProduct);
        }
        
        txtGoodsName.text = resGoods.Name;
        
        foreach (var (cell, index, resProduct) in cells.GetElements(products))
        {
            cell.Refresh(resProduct);
            cell.btnPurchaseProduct.SetPurchaseCallback(Refresh);
        }
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED) || refreshFlag.HasFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED))
            Refresh();
    }
    
}
