using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mime;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Interfaces;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using ZLinq;

public class Popup_Quest : UIPopup
{
    [Serializable]
    public class QuestPointCell : UIElement
    {
        [Serializable]
        public class RewardCell : UIElement
        {
            public TextMeshProUGUI txtPoint;
            public ItemCellBehaviourWrapperElement rewardCell;
        }

        public UIElementContainer<RewardCell> cells = new();
        public Slider sliderProgress;
        public Image imgIcon;
        public TextMeshProUGUI txtPoint;
        public ClaimAchievementRewardButton btnGetItAll;

        public void Refresh(PlayerItemMessage pointItem, ResourceItem resPointItem = null)
        {
            resPointItem ??= pointItem.GetData()!;
            
            imgIcon.sprite = resPointItem.ClientSpriteIcon;
            
            var point = pointItem?.GetCount() ?? 0;
            txtPoint.text = ItemModelViewFormatterExtensions.DefaultFormatCount(point);
            sliderProgress.value = resPointItem.TargetAchievementDataIds
                .AsValueEnumerable()
                .Select(x => ResourceAchievement.Get(x)!.TargetProgress)
                .Append(0)
                .Order()
                .ToArray()
                .NormalizeStep((int)point);

            using var achievements = PooledList<PlayerAchievementMessage>.Get();
            foreach (var achievementDataId in resPointItem.TargetAchievementDataIds)
            {
                var achievement = MyPlayer.GetAchievementByDataID(achievementDataId);
                if (achievement.GetData()?.TargetProgress > resPointItem.MaxCount)
                    continue;
                
                achievements.Add(achievement);
            }
            
            foreach (var (element, i, achievement) in cells.GetElements(achievements))
            {
                element.txtPoint.text = achievement.GetData()!.TargetProgress.ToString();
                var cell = element.rewardCell.Get<AchievementRewardItemCell>();
                cell.Refresh(achievement);
            }
            
        }
    }
    
    public QuestPointCell cellDailyQuestPoint = new();
    public TextTimer txtTimerDailyResetTime;
    public QuestPointCell cellWeeklyQuestPoint = new();
    public TextMeshProUGUI txtWeeklyResetTime;
    
    private PlayerItemMessage DailyQuestPoint => MyPlayer.GetItemsByType(ResourceItem.Types.Type.DailyQuestPoint).FirstOrDefault(x => x.IsValid(checkCount: false));
    private PlayerItemMessage WeeklyQuestPoint => MyPlayer.GetItemsByType(ResourceItem.Types.Type.WeeklyQuestPoint).FirstOrDefault(x => x.IsValid(checkCount: false));

    [Serializable]
    public class QuestCell : UIElement
    {
        public Slider sliderProgress;
        public TextMeshProUGUI txtProgress;
        public TextMeshProUGUI txtAchName;
        public TextMeshProUGUI txtAchDesc;
        public ItemCellBehaviourWrapperElement cell;
        
        public ClaimAchievementRewardButton btnClaimReward;
        public CustomButton btnMove;
    }
    
    [Serializable]
    public class QuestTableElement : UITableElement<QuestCell>
    {
    }

    public QuestTableElement questTableElement = new();
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            RefreshQuestTable();
            RefreshQuestPointCells();
        }

        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED))
        {
            RefreshQuestPointCells();
        }

        if (refreshFlag.ContainsFlag(RefreshFlag.ALL))
        {
            RefreshTimes();
        }
    }
    
    protected override void Start()
    {
        _quests.Clear();
        
        foreach (var resAchievement in ResourceAchievement.GetAllByTargetPopupName(nameof(Popup_Quest)))
        {
            if (!resAchievement.CanDisplay)
                continue;
            
            _quests.Add(resAchievement);
        }
        
        _quests.Sort(ResourceAchievement.comparer);
        
        base.Start();
    }

    private void RefreshTimes()
    {
        txtTimerDailyResetTime.targetTimeAt = MyPlayer.World.GetNextDayResetTime().ToSeconds();
        txtWeeklyResetTime.text = $"WeeklyResetTime_{MyPlayer.World.UtcOffsetHours}".L();
    }

    private readonly List<ResourceAchievement> _quests = new();
    private void RefreshQuestTable()
    {
        _quests.Sort(ResourceAchievement.comparer);
        questTableElement.table.Initialize<ResourceAchievement, QuestCell>(_quests, (quests, idx, element) =>
        {
            var resAchievement = quests[idx];
            if (resAchievement == null)
                return;
            
            var achievement = MyPlayer.GetAchievementByDataID(resAchievement.Id);
            if (achievement == null)
                return;
            
            var currentProgress = achievement.Progress;
            var maxProgress = Math.Max(1, resAchievement.TargetProgress);

            element.sliderProgress.value = currentProgress / (float)maxProgress;
            element.txtProgress.text = resAchievement.GetProgressText(useColor: false);
            element.txtAchName.text = resAchievement.ClientName;
            element.txtAchDesc.text = resAchievement.ClientDesc;
            
            element.cell.Get<AchievementRewardItemCell>().Refresh(achievement);

            var hasLandingPopup = !string.IsNullOrEmpty(resAchievement.ProgressLandingPopupArgs);
            var canMoveToLandingPopup = hasLandingPopup && achievement.State == PlayerAchievementMessage.Types.State.InProgress;

            element.btnClaimReward.Refresh(resAchievement, this);
            element.btnClaimReward.SetActive(!canMoveToLandingPopup);
            
            element.btnMove.SetActive(canMoveToLandingPopup);
            element.btnMove.SetOnClick(() =>
            {
                resAchievement.ShowLandingPopup();
                OnCancel();
            });
            //element.btnMove.SetActive(resAchievement.ContainsPopupArgsFor());
        });
    }

    private void RefreshQuestPointCells()
    {
        cellDailyQuestPoint.Refresh(DailyQuestPoint);
        cellDailyQuestPoint.btnGetItAll.Refresh(DailyQuestPoint.GetData()!.TargetAchievementDataIds, this);
        cellWeeklyQuestPoint.Refresh(WeeklyQuestPoint);
        cellWeeklyQuestPoint.btnGetItAll.Refresh(WeeklyQuestPoint.GetData()!.TargetAchievementDataIds, this);
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.DayReset:
            {
                AddRefreshAll();
                break;
            }
        }
    }
}
