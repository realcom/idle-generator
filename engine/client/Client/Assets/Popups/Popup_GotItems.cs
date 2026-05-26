using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Interfaces;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class Popup_GotItems : UIPopup, IAcquiredItemViewer
{
    public TextMeshProUGUI txtHeader;

    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>>
    {
        
    }

    public TableElement tableElement = new();

    public static Popup_GotItems Show(string header = null)
    {
        header ??= "Rewards".L();

        var popup = GameManager.Get().ShowPopup<Popup_GotItems>();
        popup.SetHeader(header);
        return popup;
    }
    
    public Popup_GotItems SetHeader(string header)
    {
        txtHeader.text = header;
        return this;
    }

    public Popup_GotItems SetTable(IList<PlayerItemMessage> items)
    {
        if (items.Count == 0)
        {
            OnCancel();
            return null;
        }
        
        const int countPerRow = 5;
        var count = items.Count;
        tableElement.table.Initialize<PlayerItemMessage, UITableRow<ItemCellBehaviourWrapperElement>>(items, (list, row, element) =>
        {
            for (var i = 0; i < countPerRow; i++)
            {
                var index = row * countPerRow + i;
                var item = list.GetSafe(index);
                var cell = element.cells[i];
                cell.Get<ItemCell>().Refresh(item);
            }
        }, Mathf.CeilToInt(count / (float)countPerRow));

        return this;
    }
    
    public Popup_GotItems SetTableParams(params PlayerItemMessage[] items)
    {
        return SetTable(items);
    }
    
    protected override void RefreshByFlag()
    {
    }

    public IAcquiredItemViewer Initialize(IList<PlayerItemMessage> items, string title = null, ResourceItem resAcquiredItemSource = null)
    {
        SetHeader(title);
        SetTable(items);

        return this;
    }
}
