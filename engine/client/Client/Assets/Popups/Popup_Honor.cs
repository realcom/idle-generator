using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Components.UI.Toggle;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Honor : UIPopup, IGoodsViewer
{
    public GoodsContainer goodsContainer;
    public UITabBar tabBar;
    
    private const int TAB_BONUS = 0;
    private const int TAB_GIFT = 1;

    [Serializable]
    public class BonusEffectTableElement : UITableElement<Utility.TextCell>
    {
    }

    public CustomButton btnGuideInfo;
    public Slider sliderHonorProgress;
    public TextMeshProUGUI txtHonorProgressDetail;
    public TextMeshProUGUI txtHonorProgress;
    public Image imgHonorChestIcon;
    public TextMeshProUGUI txtRewardLevel;
    public ClaimAchievementRewardButton btnClaimReward;

    [FoldoutGroup("BonusTab")] public BonusEffectTableElement bonusEffectTableElement = new();
    [FoldoutGroup("BonusTab")] public TextMeshProUGUI txtHonorLevelFootnote;
    [FoldoutGroup("BonusTab")] public TextMeshProUGUI txtHonorLevel;
    [FoldoutGroup("BonusTab")] public CustomToggle toggleHonorEffectActivation;

    [FoldoutGroup("GiftTab")] public RedDot redDotGiftTab;
    [FoldoutGroup("GiftTab")] public Popup_TimeLimitedMission.MissionTableElement missionTableElement = new();

    private ResourceItem resHonorItem => ResourceItem.GetAllByType(ResourceItem.Types.Type.Honor).First(x => x.IsValid);
    private PlayerItemMessage honorItem => MyPlayer.GetItemByDataID(resHonorItem.Id, true)!;
    
    private static List<ResourceAchievement> _honorAchievements = new();
    protected override void Start()
    {
        _honorAchievements.Clear();
        foreach (var resAch in ResourceAchievement.GetAllByTargetPopupNameWithArgs(nameof(Popup_Honor), resHonorItem.Id))
            _honorAchievements.Add(resAch);
        redDotGiftTab.Register(_honorAchievements);

        _honorLevel = ClampHonorLevelForDisplay(honorItem.Level);

        btnGuideInfo.SetOnClick(() =>
        {
            Popup_Contents_Guide.Show()
                .SetTitle("Popup_Honor_Guide".L())
                .SetDesc("Popup_Honor_GuideDesc".L());
        });
        
        tabBar.onTabSelected.RemoveAllListeners();
        tabBar.onTabSelected.AddListener(_ => AddRefreshAll());

        base.Start();
    }

    public override void Refresh()
    {
        base.Refresh();

        RefreshHonorProgress();
        RefreshTab();
        RefreshGoods();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }

    private void RefreshTab()
    {
        switch (tabBar.selectedIndex)
        {
            case TAB_BONUS:
                RefreshBonusTab();
                break;
            case TAB_GIFT:
                RefreshGiftTab();
                break;
        }
    }

    private void RefreshHonorProgress()
    {
        var _resHonorItem = resHonorItem;
        var _honorItem = honorItem;
        
        var isMaxLevel = _honorItem.Level >= _resHonorItem.MaxLevel;

        //명예 레벨 표기 시에는 -1
        var requiredExp = _resHonorItem.RequiredExps.GetClamped(_honorItem.Level - 1);
        sliderHonorProgress.value = isMaxLevel ? 1f : (float)_honorItem.Exp / requiredExp;
        txtHonorProgress.text = isMaxLevel ? "MAX".L() : $"{_honorItem.Exp} / {requiredExp}";
        txtHonorProgressDetail.text = isMaxLevel ? "Popup_Honor_MaxLevel".L() : "Popup_Honor_ExpToNextLevel".L(requiredExp - _honorItem.Exp, _honorItem.Level);

        imgHonorChestIcon.sprite = _resHonorItem.GetSpriteByKey("ChestIcon");
        
        txtRewardLevel.text = _honorItem.Level > 1 ? "Popup_Honor_RewardLevel".L(_honorItem.Level - 1) : "Popup_Honor_RewardDisabled".L();

        using var interactor = btnClaimReward.EnterRefreshScope(_resHonorItem.TargetAchievementDataIds.FirstOrDefault(), this, "Popup_Honor_AlreadyClaimed".L());
        interactor.Update(_honorItem.Level > 1, "Popup_Honor_NeedLevelUpHonor".L());
        
    }

    private int _honorLevel = 2;
    private void RefreshBonusTab()
    {
        var honorLevelForDisplay = _honorLevel - 1;
        txtHonorLevelFootnote.text = "Popup_Honor_HonorLevelEffect".L(honorLevelForDisplay);
        txtHonorLevel.text = "Popup_Honor_HonorLevel".L(honorLevelForDisplay);


        toggleHonorEffectActivation.isOn = _honorLevel == honorItem.Level;

        bonusEffectTableElement.table.Initialize<string, Utility.TextCell>(resHonorItem.GetLocalizedStrings($"HonorEffect_{honorLevelForDisplay}"), (texts, idx, element) =>
        {
            var text = texts[idx];
            element.txtString.text = text;
        });
    }

    public void DownHonorLevel()
    {
        SetHonorLevel(_honorLevel - 1);
    }
    
    public void UpHonorLevel()
    {
        SetHonorLevel(_honorLevel + 1);
    }
    
    private void SetHonorLevel(int level)
    {

        var prevLevel = _honorLevel;
        _honorLevel = ClampHonorLevelForDisplay(level);

        if (prevLevel != _honorLevel)
        {
            AddRefreshAll();
        }
    }
    
    private int ClampHonorLevelForDisplay(int level)
    {
        return Math.Clamp(level, 2, resHonorItem.MaxLevel);
    }

    private void RefreshGiftTab()
    {
        _honorAchievements.Sort(ResourceAchievement.comparer);
        missionTableElement.table.Initialize<ResourceAchievement, Popup_TimeLimitedMission.MissionCell>(_honorAchievements, (achievements, idx, cell) =>
        {
            cell.Refresh(achievements[idx], this);
        });
    }

    public void RefreshGoods()
    {
        RefreshGoods(CRC.Get().GetGoodsItemDataIds(nameof(Popup_Honor)));
    }

    public void RefreshGoods(IList<int> goodsIds)
    {
        goodsContainer.RefreshGoods(goodsIds);
    }

    public void MoveToShop()
    {
        
        OnCancel();
        GameBoardManager.Get().GetModeManager<ZModeManagerLobby>().ClickBottomButton(ZModeManagerLobby.BottomButtonType.SHOP);
        GameManager.Get().DispatchEvent(GameEventType.LobbyHUDPageUpdated, "Shop");
    }
}
