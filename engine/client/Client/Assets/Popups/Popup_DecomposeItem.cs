using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Types;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class Popup_DecomposeItem : UIPopup
{
    public ItemCellBehaviourWrapperElement cellDecomposeTarget = new();
    
    public UIElementContainer<ItemCellBehaviourWrapperElement> cellDecomposeResults = new();
    
    public CustomButton btnDecompose;
    
    protected override void RefreshByFlag()
    {
        
    }

    public void Initialize(PlayerItemMessage item)
    {
        var resItem = item.GetData()!;
        if (resItem == null || resItem.DecomposeAddItemGroups.Count == 0)
        {
            OnCancel();
            return;
        }

        cellDecomposeTarget.Get<ItemCellBase>().Refresh(item);
        
        foreach (var (element, i, addItem) in cellDecomposeResults.GetElements(resItem.DecomposeAddItemGroups.GetAddItems()))
        {
            element.Get<ItemCell>().Refresh(addItem);
        }

        btnDecompose.SetOnClick(() =>
        {
            RequestDecompose(item.Id).Forget();
        });
    }

    private async UniTask RequestDecompose(long itemId)
    {
        var response = await SendPacket<DecomposeItemRequest.Types.Response>(Packet.Pop(0, new DecomposeItemRequest()
        {
            ItemId = itemId
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
                    
            if (this)
                OnCancel();
                    
            GameManager.Get().GetPopup<Popup_EquipInfo>()?.OnCancel();
        }
    }
    
}
