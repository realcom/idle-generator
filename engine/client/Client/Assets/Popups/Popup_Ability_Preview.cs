using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Ability_Preview : UIPopup
{
    [Serializable]
    public class GoToMyTrainingCell : UIElement
    {
        public Image imgIcon;
        public TextMeshProUGUI txtRankName;

        public void Refresh(PlayerAchievementMessage achievement)
        {
            var resAchievement = achievement.GetData()!;
            
            var reward = resAchievement.RewardAddItemGroups.GetAddItem();
            var resItem = reward.GetData();
            imgIcon.sprite = resItem.GetSpriteByKey($"UnitTrainingRank_{reward.Level}", resItem.ClientSpriteIcon);
            txtRankName.text = reward.GetClientCountString(resItem.GetLocalizedString($"UnitTrainingRank_{reward.Level}", resItem.ClientName));
        }
    }
    
    [SerializeField] private GoToMyTrainingCell cellGoToMyTrainingTop;
    [SerializeField] private GoToMyTrainingCell cellGoToMyTrainingBottom;
    
    [Serializable]
    public class TrainingUnitStepCell : UIElement
    {
        public CanvasGroup cgPanel;
        public TextMeshProUGUI txtLevel;

        [ForceCache] public CustomButton btnLevelButton;
        [ForceCache] public CustomToggle toggleLevelButton;
    }

    public UIElementContainer<TrainingUnitStepCell> stepCells = new();

    [SerializeField] private Slider sliderProgress;

    [Serializable]
    public class AbilityRankCell : UIElement
    {
        public GameObject goReward;
        public GameObject goMainStepInfo;

        public Image imgStepIcon;
        public TextMeshProUGUI txtStepName;

        public TextMeshProUGUI txtLevel;
        public CustomToggle toggleLevel;
        public CanvasGroup cgLevel;
        
        [ForceCache] public ItemCellBehaviourWrapperElement rewardCell;
        public GameObject goCompleted;
    }

    [Serializable]
    public class TableElement : UITableElement<AbilityRankCell>
    {
    }
    
    public TableElement tableElement = new();
    [SerializeField] private float scrollDuration = 1f;
    [SerializeField] private Ease scrollEase = Ease.OutExpo;
    
    private readonly List<Page_Ability.AbilityStepInfo> _stepInfos = new();
    private int _maxAbilityLevel;
    
    private int myTrainingLevel => MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Stat).Sum(statItem =>
    {
        if (!statItem.IsValid(checkRequiredAndExclusive: true))
            return 0;
        
        var resStat = statItem.GetData()!;
        if (resStat.Tab != Page_Ability.AbilityStatItemTab)
            return 0;

        return statItem.Level - 1;
    });

    protected override void Start()
    {
        var resAbilityRootAchievement = ResourceAchievement.Get(ResourceAchievement.Global.DataId.AbilityRoot);
        _maxAbilityLevel = 0;
        _stepInfos.Clear();
        for (var resAchievement = resAbilityRootAchievement; resAchievement != null;)
        {
            _maxAbilityLevel += resAchievement.TargetProgress;
            _stepInfos.Add(new()
            {
                resAchievement = resAchievement,
                level = _maxAbilityLevel,
            });
            resAchievement = ResourceAchievement.Get(resAchievement.ChildAchievementDataIds.FirstOrDefault());
        }
        
        base.Start();

        tableElement.table.ScrollToRatio(sliderProgress.value);
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED))
        {
            Refresh();
        }
    }

    public override void Refresh()
    {
        base.Refresh();
        
        RefreshTrainingUnitSteps();
        RefreshTables();
        RefreshGoToMyTrainingCells();
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.MyPlayerItemUpdated:
            {
                if (e.PickItemFromArguments(x => x.ItemDataId == ResourceItem.Global.DataId.AbilityRank))
                {
                    AddRefreshAll();
                }
                break;
            }
            case GameEventType.MyPlayerAchievementUpdated:
            {
                AddRefreshAll();
                break;
            }
        }
    }
    
    private int FindFocusIndex()
    {
        var myTrainingLevel = this.myTrainingLevel;
        var index = _stepInfos.FindLastIndex(x => x.level <= myTrainingLevel && x.resAchievement.ContainsTag(Tag.Main));
        return Mathf.Max(0, index) + 1;
    }
    
    private void RefreshGoToMyTrainingCells()
    {
        var myTrainingLevel = this.myTrainingLevel;
        var infoIndex = _stepInfos.FindLastIndex(x => x.level <= myTrainingLevel && x.resAchievement.ContainsTag(Tag.Main));
        if (infoIndex < 0)
            infoIndex = 0;
        var info = _stepInfos[infoIndex];
        var achievement = MyPlayer.GetAchievementByDataID(info.resAchievement.Id);
        
        cellGoToMyTrainingBottom.Refresh(achievement);
        cellGoToMyTrainingTop.Refresh(achievement);
    }

    private void RefreshTables()
    {
        var myTrainingLevel = this.myTrainingLevel;
        sliderProgress.value = myTrainingLevel / (float)_maxAbilityLevel;
        
        tableElement.table.Initialize<Page_Ability.AbilityStepInfo, AbilityRankCell>(_stepInfos, (steps, idx, element) =>
        {
            var stepInfo = steps[idx];
            var resAchievement = stepInfo.resAchievement;
            var achievementState = MyPlayer.GetAchievementByDataID(resAchievement.Id)?.State ?? PlayerAchievementMessage.Types.State.Disabled;
            
            var isSpecial = resAchievement.ContainsTag(Tag.Main);
            element.goReward.SetActive(!isSpecial);
            element.goMainStepInfo.SetActive(isSpecial);
            
            var reward = resAchievement.RewardAddItemGroups.GetAddItem();
            var resItem = reward.GetData();

            element.txtLevel.text = stepInfo.level.ToString();
            element.toggleLevel.isOn = myTrainingLevel >= stepInfo.level;
            element.cgLevel.alpha = achievementState != PlayerAchievementMessage.Types.State.Disabled ? 1f : 0.5f;
            
            element.imgStepIcon.sprite = resItem.GetSpriteByKey($"UnitTrainingRank_{reward.Level}", resItem.ClientSpriteIcon);
            element.txtStepName.text = reward.GetClientCountString(resItem.GetLocalizedString($"UnitTrainingRank_{reward.Level}", resItem.ClientName));
            
            var cell = element.rewardCell.Get<ItemCell>();
            cell.Refresh(reward);
            cell.txtCount.text = reward.FormatCount(resItem.ClientName, int.MaxValue);
            element.goCompleted.SetActive(achievementState == PlayerAchievementMessage.Types.State.Rewarded);
        });
        
        tableElement.table.FocusHandleIndex = FindFocusIndex();
    }

    private void RefreshTrainingUnitSteps()
    {
        foreach (var (element, i, data) in stepCells.GetElements(CRC.Get().abilityTrainingUnitSteps))
        {
            element.txtLevel.text = data.stepNameKey.L();
            element.cgPanel.alpha = MyPlayer.IsAchievementCompletedOrRewarded(data.openAchievementDataId) ? 1f : 0.5f;
            element.toggleLevelButton.isOn = MyPlayer.IsAchievementCompletedOrRewarded(data.completeAchievementDataId);

            element.btnLevelButton.SetOnClick(() =>
            {
                FocusStep(data.focusAchievementDataId);
            });
        }
    }

    private void FocusStep(int achievementDataId)
    {
        var index = _stepInfos.FindIndex(x => x.resAchievement.Id == achievementDataId);
        tableElement.table
            .DoScrollToIndex(index + 1, scrollDuration)
            ?.SetEase(scrollEase);
    }

    public void ScrollToFocus()
    {
        tableElement.table
            .DoScrollToIndex(FindFocusIndex(), scrollDuration)
            ?.SetEase(scrollEase);
    }
    
}
