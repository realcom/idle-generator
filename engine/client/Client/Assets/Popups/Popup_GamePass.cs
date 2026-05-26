using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_GamePass : UIPopup
{
    [Serializable]
    public class Background : UIElement
    {
        public Image imgBackground;
    }

    [Serializable]
    public class TitleCell : UIElement
    {
        public Image imgTitleCell;
        public TextMeshProUGUI txtName;
    }
    
    [Serializable]
    public class Cell : UIElement
    {
        public UIElementContainer<ItemCellBehaviourWrapperElement> rewards = new();
    }

    [Serializable]
    public class Row : UIElement
    {
        public UIElementContainer<Cell> cells = new();
        public Image imgStep;
        public TextMeshProUGUI txtStep;
        public GameObject goDim;
    }

    [Serializable]
    public class TableElement : UITableElement<Row>
    {
        
    }
    
    public UIElementContainer<Background> backgrounds = new();
    public UIElementContainer<TitleCell> titleCells = new();
    
    public TableElement tableElement = new();
    
    public GameObject goBackPad;
    public GameObject goFrontPad;

    public GameObject goPaddingDim;
    
    public Slider sliderProgress;
    
    public TextMeshProUGUI txtPassName;
    public TextMeshProUGUI txtPassShortName;
    public TextMeshProUGUI txtPassDesc;
    public TextMeshProUGUI txtPassCoreRewards;
    
    public RectTransform rtPassUntilAt;
    public TextTimer txtPassUntilAt;

    public Image imgBanner;
    
    public GoodsContainer goodsContainer;
    
    public PurchaseProductCell premiumPassProductCell = new();
    
    [Serializable]
    public class PassTab : UIElement
    {
        public RedDot redDot;
        public TextMeshProUGUI txtShortName;
        public CustomToggle toggleTab;
        public CanvasGroup cgTab;
    }
    
    [Serializable]
    public class PassTabTableElement : UITableElement<PassTab>
    {
    }

    public RectTransform rtPassTabParent;
    public PassTabTableElement passTabTableElement = new();
    
    public UITabBar passGroupTabBar;
    public UIElementContainer<UITabBar.IconTabElement> passGroupTabs = new();

    private static List<ResourceItem> _passGroupItems = new();
    private static List<ResourceItem> _passRootItemsByGroup = new();
    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length < 1)
        {
            OnCancel();
            return;
        }
        
        var subTokens = tokens[^1].Split(';');
        tokens[^1] = subTokens[0];

        if (!int.TryParse(subTokens.Last(), out var targetPassGroup))
            targetPassGroup = 0;
        
        _passGroupItems.Clear();
        foreach (var token in tokens)
        {
            var passGroup = int.Parse(token);
            var resPassGroup = ResourceItem.Get(passGroup)!;

            var passGroupItem = MyPlayer.GetItemByDataID(resPassGroup.Id, checkCount: true);
            if (passGroupItem == null)
                continue;

            if (GetMainPassItems(resPassGroup).All(x => MyPlayer.GetItemByDataID(x.Id, checkCount: true) == null))
                continue;
            
            _passGroupItems.Add(resPassGroup);
        }
        
        foreach (var (element, _, resPassGroup) in passGroupTabBar.AllocateTabs(passGroupTabs, _passGroupItems, OnGroupTabChanged))
        {
            element.redDot.Register(resPassGroup);
            element.imgIcon.sprite = resPassGroup.ClientSpriteIcon;
            element.txtName.text = resPassGroup.ClientName;
        }

        passGroupTabBar.selectedIndex = Math.Max(0, _passGroupItems.FindIndex(x => x.Group == targetPassGroup));
        passGroupTabBar.RefreshTab();
    }

    private bool initialized = false;
    public void Initialize(int passRootItemDataId)
    {
        if (m_ResRootPassItem?.Id == passRootItemDataId)
            return;
        
        m_ResRootPassItem = ResourceItem.Get(passRootItemDataId);
        if (m_ResRootPassItem == null)
        {
            OnCancel();
            return;
        }

        initialized = true;
        
        foreach (var (element, _, passItemDataId) in backgrounds.GetElements(m_ResRootPassItem.TargetItemDataIds))
        {
            element.imgBackground.sprite = ResourceItem.Get(passItemDataId)!.ClientSpriteBackground;
        }
        
        foreach (var (element, _, passItemDataId) in titleCells.GetElements(m_ResRootPassItem.TargetItemDataIds))
        {
            var resPassItem = ResourceItem.Get(passItemDataId)!;
            element.imgTitleCell.sprite = resPassItem.GetSpriteByKey("TitleCell");
            element.txtName.text = resPassItem.ClientName;
        }
        
        foreach (var _ in goBackPad.GetRecycleChildren(m_ResRootPassItem.TargetItemDataIds.Count, useTemplateCell: true))
        {
        }
        
        //foreach (var _ in goFrontPad.GetRecycleChildren(m_ResRootPassItem.TargetItemDataIds.Count, useTemplateCell: true))
        //{
        //}

        txtPassName.text = m_ResRootPassItem.ClientName;
        txtPassShortName.text = m_ResRootPassItem.ClientShortName;
        txtPassDesc.text = m_ResRootPassItem.ClientDesc;
        txtPassCoreRewards.text = m_ResRootPassItem.GetLocalizedString("CoreRewards");
        
        imgBanner.sprite = m_ResRootPassItem.GetSpriteByKey("Banner");
        
        var passItem = MyPlayer.GetItemByDataID(m_ResRootPassItem.Id, checkTimeValid: false);
        rtPassUntilAt.SetActive(passItem?.UntilAt != null);
        txtPassUntilAt.Stop();
        if (passItem?.UntilAt != null)
            txtPassUntilAt.targetTimeAt = passItem.UntilAt.ToSeconds();

        goodsContainer.RefreshGoods(CRC.Get().GetGoodsItemDataIds($"{nameof(Popup_GamePass)}_{m_ResRootPassItem.Group}"));
        
        AddRefreshFlag(RefreshFlag.ALL);
    }

    private ResourceItem m_ResRootPassItem = null;
    private void Refresh(ResourceItem resRootPassItem)
    {
        var firstSubPassItem = ResourceItem.Get(resRootPassItem.TargetItemDataIds.First())!;

        var currentStep = firstSubPassItem.TargetAchievementDataIds.Count(x => MyPlayer.GetAchievementByDataID(x)?.IsAchievementCompletedOrRewarded() == true);
        var maxStep = Math.Max(1, firstSubPassItem.TargetAchievementDataIds.Count);
        var maxStepForSlider = maxStep + 2; //Table에 패딩이 두개 분만큼 들어있음

        sliderProgress.value = (currentStep - 0.5f) / maxStepForSlider;

        goPaddingDim.SetActive(currentStep != maxStep);
        if (currentStep == maxStep)
            sliderProgress.value = 1f;

        premiumPassProductCell.Refresh(ResourceItem.GetProductsByAddItem(resRootPassItem.TargetItemDataIds.Last()).FirstOrDefault(x => x.IsValid));
        premiumPassProductCell.elementRoot.SetActive(premiumPassProductCell.elementRoot.activeSelf && MyPlayer.GetItemByDataID(resRootPassItem.Id, checkCount: true) != null);

        tableElement.table.Initialize<Row>(maxStep, (step, row) =>
        {
            row.imgStep.sprite = resRootPassItem.GetSpriteByKey("StepIcon");
            
            foreach (var (cell, i, subPassItemDataId) in row.cells.GetElements(resRootPassItem.TargetItemDataIds))
            {
                var resSubPassItem = ResourceItem.Get(subPassItemDataId)!;
                var subPassItem = MyPlayer.GetItemByDataID(subPassItemDataId);
                var achievementDataId = resSubPassItem.TargetAchievementDataIds.GetClamped(step);
                var resAchievement = ResourceAchievement.Get(achievementDataId)!;
                var achievement = MyPlayer.GetAchievementByDataID(achievementDataId)!;
                var passValid = subPassItem?.IsValid() == true;

                if (i == 0)
                {
                    row.elementRoot.SetActive(true);
                    row.txtStep.text = resAchievement.ClientName;
                    row.goDim.SetActive(step >= currentStep);
                }
                
                foreach (var (element, _, addItem)  in cell.rewards.GetElements(resAchievement.RewardAddItemGroups.GetAddItems()))
                {
                    var rewardCell = element.Get<GamePassRewardCell>();
                    var resItem = addItem.GetData()!;
                    rewardCell.Refresh(addItem);

                    rewardCell.txtCount.text = addItem.GetClientCountString(resItem.ClientName);
                    rewardCell.ShowCompleted(passValid && achievement.IsAchievementCompleted());
                    rewardCell.ShowDim(achievement.IsAchievementRewarded());
                    rewardCell.ShowLocked(!passValid || step >= currentStep);

                    rewardCell.btnCell.SetOnClick(() =>
                    {
                        switch (achievement.State)
                        {
                            case PlayerAchievementMessage.Types.State.Completed:
                                if (subPassItem == null || subPassItem.IsValid() == false)
                                {
                                    resItem.ShowInfoPopup();
                                    return;
                                }
                                
                                SendClaimAchievementRewardRequest();
                                break;
                            default:
                                resItem.ShowInfoPopup();
                                break;
                        }
                    });
                }
            }
        });

        if (!initialized)
            return;
        initialized = false;
        
        var focusStep = 0;
        var hasCompletedStep = false;
        foreach (var targetItemDataId in resRootPassItem.TargetItemDataIds)
        {
            if (MyPlayer.GetItemByDataID(targetItemDataId) == null)
                continue;
            
            var resSubPassItem = ResourceItem.Get(targetItemDataId)!;
            for (var i = 0; i < resSubPassItem.TargetAchievementDataIds.Count; i++)
            {
                var achievementDataId = resSubPassItem.TargetAchievementDataIds[i];
                var achievement = MyPlayer.GetAchievementByDataID(achievementDataId);
                if (achievement.IsAchievementCompleted())
                {
                    hasCompletedStep = true;
                    focusStep = i;
                    break;
                }
            }
        }

        if (!hasCompletedStep)
            focusStep = ResourceItem.Get(resRootPassItem.TargetItemDataIds[0])!.TargetAchievementDataIds.Count(MyPlayer.IsAchievementRewarded);

        tableElement.table.ScrollToIndex(focusStep);
    }
    
    public void SendClaimAchievementRewardRequest()
    {
        SendPacket(Packet.Pop(0, new ClaimAchievementRewardRequest()
        {
            AchievementDataIds = { GetClaimableAchievementDataIds() }
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }
    
    private IEnumerable<int> GetClaimableAchievementDataIds()
    {
        foreach (var targetItemDataId in m_ResRootPassItem.TargetItemDataIds)
        {
            var resSubPassItem = ResourceItem.Get(targetItemDataId)!;
            var myItem = MyPlayer.GetItemByDataID(targetItemDataId)!;
            if (myItem == null || !myItem.IsValid())
                continue;
            foreach (var targetAchievementDataId in resSubPassItem.TargetAchievementDataIds)
            {
                var achievement = MyPlayer.GetAchievementByDataID(targetAchievementDataId);
                if (achievement?.IsAchievementCompleted() == true)
                    yield return targetAchievementDataId;
            }
        }
    }
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED) || refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
        {
            Refresh(m_ResRootPassItem);
        }
    }
    
    private void OnGroupTabChanged(int index)
    {
        var passGroup = _passGroupItems.GetClamped(index);
        
        tableElement.table.scrollRect.StopMovement();
        
        _passRootItemsByGroup.Clear();
        _passRootItemsByGroup.AddRange(GetMainPassItems(passGroup));

        if (_passRootItemsByGroup.Count == 1)
        {
            rtPassTabParent.SetActive(false);
            Initialize(_passRootItemsByGroup.First().Id);
            return;
        }
        
        rtPassTabParent.SetActive(true);
        passTabTableElement.table.Initialize<ResourceItem, PassTab>(_passRootItemsByGroup, (list, idx, element) =>
        {
            var resPassItem = list[idx];
            element.redDot.Register(resPassItem);
            element.txtShortName.text = resPassItem.GetLocalizedString("TabName");
            
            element.toggleTab.onValueChanged.RemoveAllListeners();
            element.toggleTab.onValueChanged.AddListener(isOn =>
            {
                if (isOn)
                {
                    Initialize(resPassItem.Id);
                }
            });
            
            //element.cgTab.alpha = MyPlayer.GetItemByDataID(resPassItem.Id, checkCount: true) != null ? 1f : 0.5f;
        });

        var focusIndex = Math.Max(0, _passRootItemsByGroup.FindLastIndex(x => MyPlayer.GetItemByDataID(x.Id, checkCount: true) != null));
        passTabTableElement.table.ScrollToIndex(focusIndex);
        passTabTableElement.table.RefreshElements<PassTab>((idx, element) =>
        {
            if (idx == focusIndex)
                element.toggleTab.SetIsOnWithoutNotify(true);
        });
        Initialize(_passRootItemsByGroup[focusIndex].Id);
    }

    public static IEnumerable<ResourceItem> GetMainPassItems(ResourceItem resPassGroup)
    {
        using var list = PooledList<ResourceItem>.Get();
        foreach (var resPassItem in ResourceItem.GetAllByGroup(resPassGroup.Group))
        {
            if (!resPassItem.IsValid || resPassItem.Type != ResourceItem.Types.Type.GamePassMain)
                continue;

            var passItem = MyPlayer.GetItemByDataID(resPassItem.Id, checkCount: false, checkTimeValid: false, checkDeprecated: false);
            var canDisplay = passItem?.IsValid() == true || resPassGroup.ContainsTag(Tag.EnableGamePassPreview) && (passItem == null || passItem.CheckUntilAt()); 
            if (!canDisplay)
                continue;
            
            var isValidPassItem = false;
            foreach (var subPassItemDataId in resPassItem.TargetItemDataIds)
            {
                //패스에서 안받은 보상이 있으면 유효한 패스
                if (!ResourceItem.Get(subPassItemDataId)!.TargetAchievementDataIds.All(MyPlayer.IsAchievementRewarded))
                {
                    isValidPassItem = true;
                    break;
                }
            }

            if (isValidPassItem)
                list.Add(resPassItem);
        }
        
        list.Sort((x, y) => x.Order.CompareTo(y.Order));
        
        foreach (var resourceItem in list)
        {
            yield return resourceItem;
        }
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.PURCHASE_COMPLETED:
            {
                AddRefreshFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED);
                break;
            }
        }
    }
}
