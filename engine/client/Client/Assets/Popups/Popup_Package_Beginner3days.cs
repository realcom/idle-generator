using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Components.UI.Toggle;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Package_Beginner3days : UIPopup
{
    [Serializable]
    public class ProductCell : PurchaseProductCell
    {
        [Serializable]
        public class DayRewardCell : UIElement
        {
            public Image imgBackground;
            public CustomToggle toggleCompleted;
            public TextMeshProUGUI txtDay;
            public UIElementContainer<ItemCellBehaviourWrapperElement> rewards = new();

            public void Refresh(ResourceAchievement resAchievement)
            {
                if (resAchievement == null)
                    return;
                var achievement = MyPlayer.GetAchievementByDataID(resAchievement.Id);
                
                txtDay.text = "Day_F".L(resAchievement.TargetProgress);
                
                var rewardItems = resAchievement.RewardAddItemGroups.GetAddItems();
                foreach (var (element, _, addItem) in rewards.GetElements(rewardItems))
                {
                    var cell = element.Get<AchievementRewardItemCell>(); 
                    cell.Refresh(addItem);
                    cell.ShowCompleted(achievement.IsAchievementCompleted());
                    cell.ShowDim(achievement.IsAchievementRewarded());
                }

                toggleCompleted.isOn = achievement.IsAchievementCompleted();
            }
        }

        public Image imgNameRibbonTail_L;
        public Image imgNameRibbonTail_R;
        public Image imgRibbonFrame_L;
        public Image imgRibbonFrame_R;

        public Image imgBackground;
        
        public DayRewardCell day1RewardCell = new();
        public DayRewardCell day2RewardCell = new();
        public DayRewardCell day3RewardCell = new();

        public ClaimAchievementRewardButton btnClaimReward;

        public override bool Refresh(ResourceItem resProduct)
        {
            if (base.Refresh(resProduct) == false)
                return false;

            imgBackground.sprite = resProduct.ClientSpriteBackground;
            
            imgRibbonFrame_L.sprite = imgRibbonFrame_R.sprite = resProduct.GetSpriteByKey("RibbonTail");
            imgNameRibbonTail_L.sprite = imgNameRibbonTail_R.sprite = resProduct.GetSpriteByKey("RibbonHalf");

            var productAddItem = resProduct.AddItemGroups.GetAddItem().GetData()!;
            
            day1RewardCell.Refresh(ResourceAchievement.Get(productAddItem.TargetAchievementDataIds[0]));
            day2RewardCell.Refresh(ResourceAchievement.Get(productAddItem.TargetAchievementDataIds[1]));
            day3RewardCell.Refresh(ResourceAchievement.Get(productAddItem.TargetAchievementDataIds[2]));

            day1RewardCell.imgBackground.sprite =
                day2RewardCell.imgBackground.sprite =
                    day3RewardCell.imgBackground.sprite = resProduct.GetSpriteByKey("DayCellBackground");

            return true;
        }
    }
    
    public List<UnitUIRenderer> unitRenderers = new();
    public List<Image> colorChangeImages = new();
    
    public UITabBar tabBar;
    public UIElementContainer<UITabBar.BasicTabElement> tabElements = new();

    public ProductCell productCell = new();
    
    private List<ResourceItem> _products = new();
    protected override void Start()
    {
        _products.Clear();
        _products.AddRange(ResourceItem.GetAllByTargetPopupName(nameof(Popup_Package_Beginner3days)));

        if (_products.Count == 0)
        {
            Debug.LogError("No products found for Popup_Package_Beginner3days");
            OnCancel();
            return;
        }
        
        foreach (var (element, i, product) in tabBar.AllocateTabs(tabElements, _products, _ => AddRefreshAll()))
        {
            element.redDot.Register(product.AddItemGroups.GetAddItem().GetData());
        }
        
        foreach (var unitUIRenderer in unitRenderers)
        {
            unitUIRenderer.Initialize(ResourceItem.Get(ResourceItem.Global.DataId.DefaultCharacter),"Dance1");
        }
        
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }
    
    public override void Refresh()
    {
        foreach (var (element, i, resProduct) in tabElements.GetElements(_products))
            element.txtName.text = resProduct.GetPriceString();
        
        var product = _products[tabBar.selectedIndex];

        var productAddItem = product.AddItemGroups.GetAddItem().GetData()!;
        
        productCell.Refresh(product);
        productCell.btnClaimReward.Refresh(productAddItem.TargetAchievementDataIds, this);
        productCell.btnClaimReward.SetActive(MyPlayer.GetItemByDataID(productAddItem.Id, checkCount: true) != null);
        
        var color = Utility.HexToColor(product.GetLocalizedString("EffectColor", "FFFFFF"));
        foreach (var image in colorChangeImages)
            image.color = color;
    }
}