using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;

public class Popup_Select_Reward : UIPopup
{
    public TextMeshProUGUI txtTitle;
    
    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>>
    {
    }
    
    public TableElement tableElement = new();
    public CustomButton btnSelectReward;
    
    protected override void RefreshByFlag()
    {
        
    }

    private ResourceItem _resSelectableBox = null;
    public void Initialize(ResourceItem resSelectableBox, string title = null)
    {
        if (string.IsNullOrEmpty(title))
            title = resSelectableBox.ClientName;
        txtTitle.text = title;
        
        if (resSelectableBox is not { Category: ResourceItem.Types.Category.SelectableBox })
        {
            OnCancel();
            return;
        }
        
        _resSelectableBox = resSelectableBox;
        btnSelectReward.SetOnClick(() =>
        {
            RequestUseItem().Forget();
        });
        
        RefreshTable();
    }

    private async UniTask RequestUseItem()
    {
        if (selectedIndex == -1)
        {
            "HasNotSelectedReward".ToToast();
            return;
        }
        
        var resSelectablePool = _resSelectableBox.GetSelectableBoxPool();
        var addItemGroups = resSelectablePool.AddItemGroups;
        var rewardItem = addItemGroups[selectedIndex].AddItems.First().GetData()!;

        var ok = await Popup_Alert.Show().SetDesc("SelectRewardConfirm".L(_resSelectableBox.ClientName, rewardItem.ClientName))
            .WaitResultAsync();

        if (!ok)
            return;

        var response = await SendPacket<UseCashItemRequest.Types.Response>(Packet.Pop(0, new UseCashItemRequest()
        {
            ItemDataId = _resSelectableBox.Id,
            Slot = selectedIndex
        }), this.GetCancellationTokenOnDestroy());

        if (!response.Status.IsSuccess())
            return;
        
        ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
        OnCancel();

    }
    
    private int selectedIndex = -1;
    private void RefreshTable()
    {
        var resSelectablePool = _resSelectableBox.GetSelectableBoxPool();
        var addItemGroups = resSelectablePool.AddItemGroups;

        using (var interactor = new ButtonInteractor(btnSelectReward))
        {
            interactor.Update(selectedIndex != -1, "HasNotSelectedReward".L());
        }
        
        tableElement.table.Initialize<AddItemGroup, UITableRow<ItemCellBehaviourWrapperElement>>(addItemGroups, (datas, row, rowElement) =>
        {
            foreach (var (element, i) in rowElement.cells.GetElements(4))
            {
                var idx = row * 4 + i;

                var cell = element.Get<InfoViewableItemTableCell>();
                if (cell.Refresh(datas.GetSafe(idx)?.AddItems.First()) == null)
                    continue;

                cell.ShowSelected(idx == selectedIndex);
                cell.btnCell.SetOnClick(() =>
                {
                    if (selectedIndex != idx)
                        selectedIndex = idx;
                    else
                        selectedIndex = -1;
                    
                    RefreshTable();
                });
            }
        }, Mathf.CeilToInt(addItemGroups.Count / 4f));
    }

}
