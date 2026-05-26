using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Interfaces;
using UnityEngine;

public class ClaimDailyRewardCell : MonoBehaviour
{
    [SerializeField] private CustomButton _btnClaim;
    
    [SerializeField] private UIElementContainer<ItemCellBehaviourWrapperElement> _rewards = new();
    
    public CustomButton ClaimButton => _btnClaim;

    private void Awake()
    {
        _btnClaim.SetOnClick(ClaimDailyReward);
    }

    private PlayerItemMessage _includeDailyRewardItem = null;
    private IPacketSender _packetSender = null;
    private Action<ClaimDailyRewardRequest.Types.Response> _callback = null;
    public ClaimDailyRewardCell Refresh(PlayerItemMessage includeDailyRewardItem, IPacketSender packetSender = null, Action<ClaimDailyRewardRequest.Types.Response> callback = null)
    {
        _btnClaim.SetActive(includeDailyRewardItem != null);
        
        using (var interactor = new ButtonInteractor(_btnClaim))
        {
            interactor.Update(includeDailyRewardItem?.CanClaimDailyReward() == true, "CanNotClaimDailyReward".L());
        }
        
        var resItem = includeDailyRewardItem?.GetData();
        if (resItem == null || resItem.DailyRewardAddItemGroups.Count == 0)
            return this;
        
        _includeDailyRewardItem = includeDailyRewardItem;
        
        if (_rewards is { Length: > 0 })
        {
            foreach (var (element, _, addItem) in _rewards.GetElements(resItem.DailyRewardAddItemGroups.GetAddItems()))
                element.Get<ItemCell>().Refresh(addItem);
        }

        SetPacketSender(packetSender);
        SetCallback(callback);
        
        return this;
    }
    
    public ClaimDailyRewardCell SetPacketSender(IPacketSender packetSender)
    {
        _packetSender = packetSender;
        return this;
    }
    
    public ClaimDailyRewardCell SetCallback(Action<ClaimDailyRewardRequest.Types.Response> callback)
    {
        _callback = callback;
        return this;
    }
    
    private void ClaimDailyReward()
    {
        RequestClaimDailyReward().Forget();
    }
    
    private async UniTask RequestClaimDailyReward()
    {
        if (_includeDailyRewardItem == null)
            return;

        if (_packetSender == null)
            return;

        var response = await _packetSender.SendPacket<ClaimDailyRewardRequest.Types.Response>(Packet.Pop(0, new ClaimDailyRewardRequest()
        {
            ItemId = _includeDailyRewardItem.Id
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            _callback?.Invoke(response);
        }
    }
    
}
