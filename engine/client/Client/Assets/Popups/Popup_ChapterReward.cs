using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;

public class Popup_ChapterReward : UIPopup, IGoodsViewer
{
    public GoodsContainer goodsContainer;
    
    [Serializable]
    public class RewardCell : UIElement
    {
        public TextMeshProUGUI txtAchName;
        public TextMeshProUGUI txtAchDesc;

        public GameObject objRewarded;
        public GameObject objDim;

        public void Refresh(ResourceAchievement resAch, bool showDim)
        {
            if (resAch == null)
            {
                elementRoot.SetActive(false);
                return;
            }
            
            var ach = MyPlayer.GetAchievementByDataID(resAch.Id);
            if (ach == null)
            {
                elementRoot.SetActive(false);
                return;
            }

            elementRoot.SetActive(true);

            txtAchName.text = resAch.ClientName;
            txtAchDesc.text = resAch.ClientDesc;
            objRewarded.SetActive(ach.IsAchievementRewarded());
            objDim.SetActive(showDim);
        }
    }

    [SerializeField] private RewardCell m_PrevCell;
    [SerializeField] private RewardCell m_CurrentCell;
    [SerializeField] private RewardCell m_NextCell;
    
    public CustomButton btnGetReward;
    
    [Serializable]
    public class RewardTableElement : UITableElement<RewardCell>
    {
    }
    
    public UIElementContainer<ItemCellBehaviourWrapperElement> rewardItems = new();

    public static IEnumerable<ResourceAchievement> GetChapterRewardAchievements()
    {
        using var maps = PooledList<ResourceMap>.Get();
        maps.AddRange(ResourceMap.GetAllByTag(Tag.Main));
        maps.Sort((x, y) => x.Id.CompareTo(y.Id));
        
        foreach (var resourceMap in maps)
        {
            using var refAchievements = PooledList<ResourceAchievement>.Get();
            
            foreach (var achievementDataId in resourceMap.ReferenceAchievementDataIds)
            {
                var resAch = ResourceAchievement.Get(achievementDataId);
                if (resAch == null)
                    continue;
                
                if (resAch.CompareTargetPopupName(nameof(Popup_ChapterReward)))
                {
                    refAchievements.Add(resAch);
                }
            }
            
            refAchievements.Sort((x, y) => x.Condition == ResourceAchievement.Types.Condition.WinGame ? 1 : 0);
            
            foreach (var resourceAchievement in refAchievements)
            {
                yield return resourceAchievement;
            }
        }
    }
    
    public override void Refresh()
    {
        using var achievements = PooledList<ResourceAchievement>.Get();
        achievements.AddRange(GetChapterRewardAchievements());

        if (achievements.Count == 0)
        {
            OnCancel();
            return;
        }

        var currentIndex = achievements.FindIndex(x => MyPlayer.GetAchievementByDataID(x.Id)?.State < PlayerAchievementMessage.Types.State.Rewarded);
        if (currentIndex == -1 && MyPlayer.GetAchievementByDataID(achievements[^1].Id)?.State == PlayerAchievementMessage.Types.State.Rewarded)
        {
            currentIndex = achievements.Count - 1;
        }
        
        var prevIndex = currentIndex - 1;
        var nextIndex = currentIndex + 1;

        var currentResAchievement = achievements.GetSafe(currentIndex);
        var currentAchievement = MyPlayer.GetAchievementByDataID(currentResAchievement.Id);
        
        m_PrevCell.Refresh(achievements.GetSafe(prevIndex), true);
        m_CurrentCell.Refresh(currentResAchievement, false);
        m_NextCell.Refresh(achievements.GetSafe(nextIndex), true);

        foreach (var (cellWrapper, rowIndex, addItem) in rewardItems.GetElements(currentResAchievement.RewardAddItemGroups.GetAddItems()))
        {
            cellWrapper.Get<ItemCell>().Refresh(addItem);
        }

        using var interactor = new ButtonInteractor(btnGetReward);
        interactor.Update(currentAchievement.State == PlayerAchievementMessage.Types.State.Completed);
        btnGetReward.SetOnClick(() =>
        {
            OnClickReward(currentResAchievement.Id);  
        });

        //btnGetReward.SetOnClickDisabled(() =>
        //{
        //    if (currentAchievement.State == PlayerAchievementMessage.Types.State.InProgress)
        //    {
        //
        //    }
        //});

    }
    
    private void OnClickReward(int resAchId)
    {
        var req = new ClaimAchievementRewardRequest { AchievementDataId = resAchId };
        var packet = Packet.Pop(0, req);
        SendPacket(packet, this.GetCancellationTokenOnDestroy()).Forget();
    }
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            Refresh();
        }

        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            RefreshGoods();
        }
    }

    public void RefreshGoods()
    {
        RefreshGoods(CRC.Get().GetGoodsItemDataIds(nameof(Popup_ChapterReward)));
    }

    public void RefreshGoods(IList<int> goodsIds)
    {
        goodsContainer.RefreshGoods(goodsIds);
    }
}
