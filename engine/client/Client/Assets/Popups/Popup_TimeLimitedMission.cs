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
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class Popup_TimeLimitedMission : UIPopup
{
    public TextMeshProUGUI txtName;
    public TextMeshProUGUI txtDesc;
    public TextTimer timerUntilAt;

    public Image imgBackground;
    public Image imgBanner;

    public RedDot redDotMission;
    public RedDot redDotProduct;

    public Popup_Quest.QuestPointCell pointCell = new();
    
    [Serializable]
    public class DayTabBarElement : UITabBar.BasicTabElement
    {
        public CustomToggle toggleTab; 
    }

    [Serializable]
    public class DayTabTableElement : UITableElement<DayTabBarElement>
    {
    }

    public DayTabTableElement dayTabBarTableElement = new();

    [Serializable]
    public class MissionCell : UIElement
    {
        public TextMeshProUGUI txtName;
        public TextMeshProUGUI txtProgress;
        
        public UIElementContainer<ItemCellBehaviourWrapperElement> rewards = new();
        
        public ClaimAchievementRewardButton btnClaimReward;
        public CustomButton btnMove;
        
        public GameObject goDimmed;

        public void Refresh(ResourceAchievement resAch, UIPopup popup)
        {
            var ach = MyPlayer.GetAchievementByDataID(resAch.Id);
            txtName.text = resAch.ClientName;
            txtProgress.text = resAch.GetProgressText(ach, useColor: false);
            goDimmed.SetActive(ach.IsAchievementRewarded());

            foreach (var (element, _, addItem) in rewards.GetElements(resAch.RewardAddItemGroups.GetAddItems()))
                element.Get<ItemCell>().Refresh(addItem);
            
            var hasLandingPopup = !string.IsNullOrEmpty(resAch.ProgressLandingPopupArgs);
            var canMoveToLandingPopup = hasLandingPopup && ach.State == PlayerAchievementMessage.Types.State.InProgress;

            btnClaimReward.Refresh(resAch, popup);
            btnClaimReward.SetActive(!canMoveToLandingPopup);
            
            btnMove.SetActive(canMoveToLandingPopup);
            btnMove.SetOnClick(() =>
            {
                resAch.ShowLandingPopup();
                popup.OnCancel();
            });
        }
    }
    
    [Serializable]
    public class MissionTableElement : UITableElement<MissionCell>
    {
    }
    
    public MissionTableElement missionTableElement = new();

    [Serializable]
    public class ProductCell : PurchaseProductCell
    {
        public UIElementContainer<ItemCellBehaviourWrapperElement> rewards = new();
        public GameObject goDimmed;
    }

    [Serializable]
    public class ProductTableElement : UITableElement<ProductCell>
    {
        
    }
    
    public ProductTableElement productTableElement = new();

    public UITabBar tabBar;
    private const int TAB_MISSION = 0;
    private const int TAB_PRODUCT = 1;
    
    protected override void Start()
    {
        tabBar.onTabSelected.RemoveAllListeners();
        tabBar.onTabSelected.AddListener(_ => { AddRefreshAll(); });
        
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();

        if (refreshFlag.ContainsFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            dayTabBarTableElement.table.RefreshElements();
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.DayReset:
                AddRefreshAll();
                break;
        }
    }

    public override void Refresh()
    {
        base.Refresh();

        RefreshTable();
        RefreshPointCell();
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var missionItemDataId))
                Initialize(missionItemDataId);
            else
                OnCancel();
        }
    }

    private ResourceItem _resMissionItem = null;
    private PlayerItemMessage missionItem => MyPlayer.GetItemByDataID(_resMissionItem.Id, checkCount: true);
    public void Initialize(int missionItemDataId)
    {
        _resMissionItem = ResourceItem.Get(missionItemDataId);
        if (_resMissionItem == null)
        {
            OnCancel();
            return;
        }
        
        var _missionItem = missionItem;
        if (_missionItem == null)
        {
            OnCancel();
            return;
        }
        
        txtName.text = _resMissionItem.ClientName;
        txtDesc.text = _resMissionItem.ClientDesc;
        
        timerUntilAt.SetTargetTime(_missionItem.UntilAt);

        imgBackground.sprite = _resMissionItem.ClientSpriteBackground;
        imgBanner.sprite = _resMissionItem.GetSpriteByKey("Banner");
        
        _resPointItem = ResourceItem.Get(_resMissionItem.TimeLimitedMissionPointItemDataId);

        InitDayTabTable();
    }

    private static Dictionary<int, ResourceAchievement> _dayCheckAchievements = new();
    
    private static Dictionary<int, List<ResourceAchievement>> _achievementsByDay = new();
    private static Dictionary<int, List<ResourceItem>> _productsByDay = new();

    private int _day = 1;
    private void InitDayTabTable()
    {
        _dayCheckAchievements.Clear();
        
        _achievementsByDay.Clear();
        foreach (var resAch in ResourceAchievement.GetAllByTargetPopupNameWithArgs(nameof(Popup_TimeLimitedMission), _resMissionItem.Id))
        {
            if (!resAch.IsValid)
                continue;
            
            var day = resAch.GetTargetPopupArgument(1);
            if (resAch.ContainsTag(Tag.ForDayCheck))
            {
                _dayCheckAchievements[day] = resAch;
            }
            else
            {
                if (!_achievementsByDay.TryGetValue(day, out var list))
                    list = _achievementsByDay[day] = new();
                list.Add(resAch);
            }
        }
        
        _productsByDay.Clear();
        foreach (var resItem in ResourceItem.GetAllByTargetPopupNameWithArgs(nameof(Popup_TimeLimitedMission), _resMissionItem.Id))
        {
            if (!resItem.IsValid || resItem.Category != ResourceItem.Types.Category.Product)
                continue;

            var day = resItem.GetTargetPopupArgument(1);
            if (!_productsByDay.TryGetValue(day, out var list))
                list = _productsByDay[day] = new();
            
            list.Add(resItem);
        }
        
        using var missionCandidates = PooledList<ResourceAchievement>.Get();
        using var productCandidates = PooledList<ResourceItem>.Get();
        
        foreach (var (day, resAch) in _dayCheckAchievements)
        {
            if (!MyPlayer.IsAchievementCompletedOrRewarded(resAch))
                continue;

            if (_achievementsByDay.TryGetValue(day, out var achievements))
                missionCandidates.AddRange(achievements);
            if (_productsByDay.TryGetValue(day, out var products))
                productCandidates.AddRange(products);
        }

        redDotMission.Register(missionCandidates);
        redDotProduct.Register(productCandidates);

        dayTabBarTableElement.table.Initialize<KeyValuePair<int, ResourceAchievement>, DayTabBarElement>(_dayCheckAchievements, (datas, idx, element) =>
        {
            var (day, dayCheckAchievement) = datas[idx];
            element.txtName.text = $"Popup_TimeLimitedMission_Day_F".L(day);
            
            var dayPassed = MyPlayer.IsAchievementCompletedOrRewarded(dayCheckAchievement);
            element.toggleTab.onValueChanged.RemoveAllListeners();
            element.toggleTab.onValueChanged.AddListener(isOn =>
            {
                if (isOn)
                {
                    _day = day;
                    missionTableElement.table.ScrollToStart();
                    productTableElement.table.ScrollToStart();
                    AddRefreshAll();
                }
            });

            element.toggleTab.SetOnClickDisabled(() =>
            {
                "Popup_TimeLimitedMission_DayNotYet".ToToast(day);
            });

            element.toggleTab.interactable = dayPassed;
        });
    }

    private void RefreshTable()
    {
        switch (tabBar.selectedIndex)
        {
            case TAB_MISSION:
                RefreshMissions();
                break;
            case TAB_PRODUCT:
                RefreshProducts();
                break;
        }
    }

    private void RefreshMissions()
    {
        Debug.Log($"Popup_TimeLimitedMission.RefreshMissions: Day {_day}");
        _achievementsByDay[_day].Sort(ResourceAchievement.comparer);
        missionTableElement.table.Initialize<ResourceAchievement, MissionCell>(_achievementsByDay[_day], (achievements, idx, cell) =>
        {
            cell.Refresh(achievements[idx], this);
        });
        
        dayTabBarTableElement.table.Initialize<KeyValuePair<int, List<ResourceAchievement>>, DayTabBarElement>(_achievementsByDay, (datas, idx, element) =>
        {
            var (day, achievements) = datas[idx];
            var dayCheckAchievement = _dayCheckAchievements[day];

            using var noticeScope = new NoticeSystem.RegisterScope(element.redDot);
            
            noticeScope.AddPrerequisitesCondition(dayCheckAchievement);
            noticeScope.AddNoticeRelevanceEntities(achievements);
        });
    }

    private void RefreshProducts()
    {
        Debug.Log($"Popup_TimeLimitedMission.RefreshProducts: Day {_day}");
        _productsByDay[_day].Sort((a, b) =>
        {
            if (a == null && b == null) return 0;
            if (a == null) return 1;
            if (b == null) return -1;

            var aPurchased = MyPlayer.IsAchievementCompletedOrRewarded(a.GetProductBuyLimitAchievement());
            var bPurchased = MyPlayer.IsAchievementCompletedOrRewarded(b.GetProductBuyLimitAchievement());
            if (aPurchased != bPurchased)
                return aPurchased ? 1 : -1;

            var oderA = a.Order;
            var oderB = b.Order;
            return oderA.CompareTo(oderB);
        });
        
        productTableElement.table.Initialize<ResourceItem, ProductCell>(_productsByDay[_day], (products, idx, cell) =>
        {
            var resProduct = products[idx];
            if (!cell.Refresh(resProduct))
                return;
            foreach (var (element, _, addItem) in cell.rewards.GetElements(resProduct.AddItemGroups.GetAddItems()))
                element.Get<ItemCell>().Refresh(addItem);
            cell.goDimmed.SetActive(MyPlayer.IsAchievementCompletedOrRewarded(resProduct.GetProductBuyLimitAchievement()));
        });
        
        dayTabBarTableElement.table.Initialize<KeyValuePair<int, List<ResourceItem>>, DayTabBarElement>(_productsByDay, (datas, idx, element) =>
        {
            var (day, products) = datas[idx];
            var dayCheckAchievement = _dayCheckAchievements[day];

            using var noticeScope = new NoticeSystem.RegisterScope(element.redDot);
            
            noticeScope.AddPrerequisitesCondition(dayCheckAchievement);
            noticeScope.AddNoticeRelevanceEntities(products);
        });
    }

    private ResourceItem _resPointItem = null;
    private void RefreshPointCell()
    {
        if (_resPointItem == null)
            return;
        
        var pointItem = MyPlayer.GetItemByDataID(_resPointItem.Id, checkCount: false);
        pointCell.Refresh(pointItem, _resPointItem);
        pointCell.btnGetItAll.Refresh(_resPointItem.TargetAchievementDataIds, this);
    }

}
