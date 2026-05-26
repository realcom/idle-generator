using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using UnityEngine;

public class Popup_ScoutReward_Quick : UIPopup
{
    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>>
    {
    }
    
    public PurchaseProductCell purchaseProductCellByAdWatch;
    public PurchaseProductCell purchaseProductCellByMaterial;

    public TableElement tableElement = new();
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED) || refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            Refresh();
        }
    }

    protected override void Start()
    {
        purchaseProductCellByAdWatch.btnPurchaseProduct.SetPurchaseCallback(Refresh);
        purchaseProductCellByMaterial.btnPurchaseProduct.SetPurchaseCallback(Refresh);
        
        base.Start();
    }

    public override void Refresh()
    {
        base.Refresh();

        var mapMeta = ResourceMap.GetAllByTag(Tag.Main).FirstOrDefault(e => e.ContainsTag(Tag.Meta))!;
        
        var scoutMinutes = 0L;
        var resScoutItem = ResourceItem.Get(mapMeta.ScoutQuickItemDataId);
        foreach (var resourceItem in ResourceItem.GetAllByParentId(mapMeta.ProductScoutQuickItemDataId))
        {
            if (!resourceItem.CanDisplay)
                continue;
            
            if(resourceItem.ParentId == resourceItem.Id)
                continue;

            if (resourceItem.Type == ResourceItem.Types.Type.MaterialAd)
            {
                purchaseProductCellByAdWatch.Refresh(resourceItem);
                //두 타입의 보상이 동일하다는 전제
                var addItem = resourceItem.AddItemGroups.GetAddItem();
                scoutMinutes = addItem.GetCount();
            }
            else if (resourceItem.ProductMaterialItemGroups.Count > 0)
            {
                purchaseProductCellByMaterial.Refresh(resourceItem);
            }
        }

        if (resScoutItem == null)
        {
            OnCancel();
            return;
        }

        var scoutItem = MyPlayer.GetItemByDataID(resScoutItem.Id);
        var currentTargetMap = ResourceMap.Get(scoutItem.Param1)!;
        
        var rng = new Rng((uint) scoutItem.Param4);

        using var items = PooledList<AddItemGroupExtensions.PredictionItem>.Get();
        foreach (var addItemGroup in currentTargetMap.ScoutAddItemGroups)
        {
            var count = Math.Min(addItemGroup.MaxMinutes, scoutMinutes) / addItemGroup.Minutes;
            items.AddRange(addItemGroup.GetPredictionItems(count, rng));
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
    }
    
}
