using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using UnityEngine;

public class ClaimAchievementRewardButton : CustomButton
{
    public void Refresh(ResourceAchievement resAchievement, UIPopup parentPopup, string notInteractableMessage = null)
    {
        using var _ = EnterRefreshScope(resAchievement, parentPopup);
    }

    public ButtonInteractor EnterRefreshScope(int achievementDataId, UIPopup parentPopup, string notInteractableMessage = null)
    {
        return EnterRefreshScope(ResourceAchievement.Get(achievementDataId), parentPopup, notInteractableMessage);
    }
    
    public ButtonInteractor EnterRefreshScope(ResourceAchievement resAchievement, UIPopup parentPopup, string notInteractableMessage = null)
    {
        var interactor = new ButtonInteractor(this);
        if (resAchievement == null)
            return interactor;

        notInteractableMessage ??= resAchievement.ClientUnlockToast;
        interactor.Update(MyPlayer.IsAchievementCompleted(resAchievement), notInteractableMessage);
        SetOnClick(() =>
        {
            parentPopup.SendPacket(Packet.Pop(0, new ClaimAchievementRewardRequest()
            {
                AchievementDataId = resAchievement.Id,
            }), this.GetCancellationTokenOnDestroy()).Forget();
        });
        
        return interactor;
    }

    private readonly List<int> _achievementDataIds = new();
    public void Refresh(IEnumerable<int> achievementDataIds, UIPopup parentPopup, string notInteractableMessage = null)
    {
        if (string.IsNullOrEmpty(notInteractableMessage))
            notInteractableMessage = "AlreadyClaimRewards".L();
        
        using var _ = EnterRefreshScope(achievementDataIds, parentPopup, notInteractableMessage);
    }
    
    public ButtonInteractor EnterRefreshScope(IEnumerable<int> achievementDataIds, UIPopup parentPopup, string notInteractableMessage = null)
    {
        _achievementDataIds.Clear();

        var canClaim = false;
        foreach (var achievementDataId in achievementDataIds)
        {
            var resAchievement = ResourceAchievement.Get(achievementDataId);
            if (resAchievement == null)
                continue;

            _achievementDataIds.Add(resAchievement.Id);
            if (MyPlayer.IsAchievementCompleted(resAchievement))
                canClaim = true;
        }
        
        var interactor = new ButtonInteractor(this);
        interactor.Update(canClaim, notInteractableMessage);
        
        SetOnClick(() =>
        {
            parentPopup.SendPacket(Packet.Pop(0, new ClaimAchievementRewardRequest()
            {
                AchievementDataIds = { _achievementDataIds },
                Count = 0,
            }), this.GetCancellationTokenOnDestroy()).Forget();
        });
        
        return interactor;
    }
    
}
