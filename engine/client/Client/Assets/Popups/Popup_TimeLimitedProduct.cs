using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class Popup_TimeLimitedProduct : UIPopup
{
    public TextTimer timerUntilAt;
    
    [FormerlySerializedAs("rewards")] public UIElementContainer<ItemCellBehaviourWrapperElement> rewardCells = new();
    
    public List<Image> colorChangeImages = new();
    public PurchaseProductCell PurchaseProductCell = new();
    public TextMeshProUGUI txtDesc;
    
    protected ResourceItem resProductItem;

    protected override void RefreshByFlag()
    {
        
    }
    
    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var itemDataId))
            {
                Initialize(ResourceItem.Get(itemDataId));
            }
            else
            {
                OnCancel();   
            }
        }
    }

    public virtual void Initialize(ResourceItem productItem)
    {
        resProductItem = productItem;
        //var color = Utility.HexToColor(resProductItem.GetLocalizedString("EffectColor", "FFFFFF"));
        //foreach (var image in colorChangeImages)
        //    image.color = color;
        txtDesc.text = resProductItem.ClientDesc;
    }
    public override void Refresh()
    {
        base.Refresh();
        var product = MyPlayer.GetItemByDataID(resProductItem.Id);
        
        PurchaseProductCell.Refresh(resProductItem);
        PurchaseProductCell.btnPurchaseProduct.SetPurchaseCallback(OnCancel);
        timerUntilAt.SetByItem(product);

        foreach (var (element, index, item) in rewardCells.GetElements(resProductItem.AddItemGroups.GetAddItems((i) => !i.HideInRewardPreview)))
        {
            var cell = element.Get<ItemCell>();
            cell.Refresh(item);
        }
    }
}
