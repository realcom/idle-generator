using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using TMPro;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.UI;

public class Page_Shop : ZModePage
{
    [Serializable]
    public class ShopBlock : UIElement
    {
        public TextMeshProUGUI txtShopBlockTitle;
        
        public UIElementContainer<ShopItemCell> shopProductGridLayouts = new();
        public UIElementContainer<ShopBannerPackageCell> shopBannerPackages = new();
        public UIElementContainer<ShopMultiPackageCell> shopGachaPackages = new();
        public UIElementContainer<ShopSpecialGachaPackageCell> shopSpecialGachaPackages = new();

        [Serializable]
        public class ShopItemCell : PurchaseProductCell
        {
            public Image imgFrame;
            public RectTransform rtShortDesc;
            public TextMeshProUGUI txtShortDesc;
            public TextMeshProUGUI txtShortName;

            public CustomButton btnProbabilityInfo;

            public override bool Refresh(ResourceItem resProduct)
            {
                if (!base.Refresh(resProduct))
                    return false;
                
                if (imgFrame)
                    imgFrame.sprite = resProduct.ClientSpriteFrame;
                if (rtShortDesc)
                    rtShortDesc.SetActive(!string.IsNullOrEmpty(resProduct.ClientShortDesc));
                if (txtShortDesc)
                    txtShortDesc.text = resProduct.ClientShortDesc;
                if (txtShortName)
                    txtShortName.text = resProduct.ClientShortName;

                if (btnProbabilityInfo)
                    btnProbabilityInfo.SetOnClick(resProduct.ShowProbabilityPopup);
                
                return true;
            }
            
        }
        
        [Serializable]
        public class ShopMultiPackageCell : ShopItemCell
        {
            public UIElementContainer<PurchaseProductCell> purchaseCells = new();
            public override bool Refresh(ResourceItem resProduct)
            {
                if (!base.Refresh(resProduct))
                    return false;

                using var validProducts = PooledList<ResourceItem>.Get();
                foreach (var product in ResourceItem.GetAllByParentId(resProduct.Id))
                {
                    if (!product.CanDisplay || resProduct.Id == product.Id)
                        continue;
                    
                    validProducts.Add(product);
                }

                using var validProductOrder = PooledHashSet<int>.Get();
                using var orderGroup = PooledDictionary<int, int>.Get();
                var maxOrderKey = int.MinValue;
                foreach (var (element,i,product) in purchaseCells.GetElements(validProducts))
                {
                    if (element.Refresh(product))
                    {
                        validProductOrder.Add(product.Order);
                        var (group, order) = ToOrderGroup(product.Order);
                        orderGroup[group] = Math.Max(orderGroup.GetValueOrDefault(group, int.MinValue), order);
                    }
                }
                
                foreach (var (element,i,product) in purchaseCells.GetElements(validProducts))
                {
                    var (group, order) = ToOrderGroup(product.Order);
                    var existingOrder = orderGroup.GetValueOrDefault(group, int.MinValue);
                    
                    if (orderGroup.TryGetValue(0, out var setOrder))
                        existingOrder = Math.Max(existingOrder, setOrder);
                    
                    element.elementRoot.SetActive(validProductOrder.Contains(product.Order) && order == existingOrder);
                }
                
                return validProducts.Count > 0;
                
                (int group, int order) ToOrderGroup(int rawOrder)
                {
                    // 상품 오더는 101, 102, 201 이런 식으로 우선 순위 지정
                    return (rawOrder % 100, rawOrder / 100);
                }
            }
        }
        
        [Serializable]
        public class ShopSpecialGachaPackageCell : UIElement
        {
            public CustomButton btnGuideInfo;
            public TextMeshProUGUI txtSelectableBoxInfo;
            public Slider sliderSelectableBoxAcquireProgress;
            public TextMeshProUGUI txtSelectableBoxAcquireProgress;
            public CustomToggle toggleSelectableBoxAcquireProgress;
            public Image imgSelectableBox;
            public CustomButton btnSelectableBox;
            public RedDot redDotSelectableBox;

            public Image imgGachaSpecialRewardFrameLeft;
            public Image imgGachaSpecialRewardFrameRight;
            public Image imgGachaSpecialRewardTitleFrame;
            public TextTimer txtGachaSpecialRewardTitle;
            
            public UIElementContainer<ItemCellBehaviourWrapperElement> specialRewardItems = new();
            
            public UIElementContainer<ShopMultiPackageCell> gachaPackageCells = new();
            
            public bool Refresh(ResourceItem resProduct)
            {
                var resAchievement =
                    ResourceAchievement.GetAllByConditionQuery(new ResourceAchievement.ConditionQuery(
                        ResourceAchievement.Types.Condition.BuyItemProduct,
                        ResourceAchievement.ConditionQuery.Comparer.Equal,
                        resProduct.AchievementItemDataId)).First();
                
                var resChestReward = resAchievement.RewardAddItemGroups.GetAddItem().GetData()!;
                var seasonalSelectableBoxPool = resChestReward.GetSelectableBoxPool();
                if (seasonalSelectableBoxPool == null)
                    return false;
                
                txtSelectableBoxInfo.text = seasonalSelectableBoxPool.ClientDesc;
                imgSelectableBox.sprite = seasonalSelectableBoxPool.ClientSpriteIcon;
                txtGachaSpecialRewardTitle.formatKey  = seasonalSelectableBoxPool.GetLocalizedString("GachaSpecialRewardTitleFormat", "GachaSpecialRewardTitleFormat");
                txtGachaSpecialRewardTitle.targetTimeAt = seasonalSelectableBoxPool.UntilAt.ToSeconds();
                
                imgGachaSpecialRewardFrameLeft.sprite = imgGachaSpecialRewardFrameRight.sprite = seasonalSelectableBoxPool.GetSpriteByKey("GachaSpecialRewardFrame");
                imgGachaSpecialRewardTitleFrame.color = Utility.HexToColor(seasonalSelectableBoxPool.GetLocalizedString("GachaSpecialRewardTitleFrameColor", "FFFFFF"));

                
                var chestRewardItem = MyPlayer.GetItemByDataID(resChestReward.Id);
                var achievement = MyPlayer.GetAchievementByDataID(resAchievement.Id);
                var progress = achievement.Progress + (int)(chestRewardItem?.GetCount() ?? 0) * resAchievement.TargetProgress;
                sliderSelectableBoxAcquireProgress.value = progress / (float)resAchievement.TargetProgress;
                txtSelectableBoxAcquireProgress.text = $"{progress}/{resAchievement.TargetProgress}";
                toggleSelectableBoxAcquireProgress.isOn = progress >= resAchievement.TargetProgress;

                btnGuideInfo.SetOnClick(() =>
                {
                    Popup_Contents_Guide.Show()
                        .SetTitle(resProduct.GetLocalizedString("GuideTitle"))
                        .SetDesc(resProduct.GetLocalizedString("GuideDesc"));
                });
                
                btnSelectableBox.SetOnClick(() =>
                {
                    if (chestRewardItem?.GetCount() > 0)
                    {
                        GameManager.Get().ShowPopup<Popup_Select_Reward>().Initialize(resChestReward);   
                    }
                    else
                    {
                        "GachaSpecialRewardNotAvailable".ToToast();
                    }
                });
                redDotSelectableBox.Register(resChestReward);
                
                foreach (var (element, i, addItemGroup) in specialRewardItems.GetElements(seasonalSelectableBoxPool.AddItemGroups))
                {
                    element.Get<ItemCell>().Refresh(addItemGroup.AddItems.First());
                }
                
                using var packageItems = PooledList<ResourceItem>.Get();
                foreach (var package in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Product))
                {
                    if (!package.IsValid)
                        continue;

                    //같은 AchievementItemDataId를 가진 상품 중에서 루트 상품들 찾기
                    if (package.AchievementItemDataId == resProduct.AchievementItemDataId && package.ParentId == package.Id)
                    {
                        packageItems.Add(package);
                    }
                }

                packageItems.Sort((x, y) => x.Order.CompareTo(y.Order));
                foreach (var (element, i, multiPackageProduct) in gachaPackageCells.GetElements(packageItems))
                {
                    element.Refresh(multiPackageProduct);
                }

                return true;
            }

        }
        
        [Serializable]
        public class ShopBannerPackageCell : ShopItemCell
        {
            public UIElementContainer<ItemCellBehaviourWrapperElement> itemsIncluded = new();

            public CustomButton btnPrev;
            public CustomButton btnNext;
            
            public override bool Refresh(ResourceItem resProduct)
            {
                if (!base.Refresh(resProduct))
                    return false;

                foreach (var (cell, _, addItem) in itemsIncluded.GetElements(resProduct.AddItemGroups.GetAddItems(i => !i.HideInRewardPreview)))
                {
                    cell.Get<ItemCell>().Refresh(addItem);
                }

                return true;
            }

            public bool Refresh(List<ResourceItem> bannerProducts, int index = -1)
            {
                if (bannerProducts.Count == 0)
                {
                    btnPrev.SetActive(false);
                    btnNext.SetActive(false);
                    return false;
                }
                
                bannerProducts.Sort((x, y) => x.Id.CompareTo(y.Id));

                if (index == -1)
                {
                    var order = -1;
                    for (var i = 0; i < bannerProducts.Count; i++)
                    {
                        var resItem = bannerProducts[i];
                        if (resItem.Order > order)
                        {
                            order = resItem.Order;
                            index = i;
                        }
                    }
                }

                Refresh(bannerProducts[index]);

                btnPrev.SetActive(index > 0);
                btnPrev.SetOnClick(() =>
                {
                    Refresh(bannerProducts, --index);
                });

                btnNext.SetActive(index < bannerProducts.Count - 1);
                btnNext.SetOnClick(() =>
                {
                    Refresh(bannerProducts, ++index);
                });

                return true;
            }
            
        }
        
    }

    public RectTransform parentRect;

    public GameObject goMarginBox;
    public GameObject goBannerBox;
    public Image imgBanner;
    
    public UITabBar tabBar;
    public UIElementContainer<UITabBar.BasicTabElement> tabBarElements = new();
    
    public UIElementContainer<ShopBlock> shopBlockContainer = new();
    
    public static IEnumerable<ResourceItem> GetNoticeRelevanceEntities()
    {
        return GetValidProducts();
    }

    private static IEnumerable<ResourceItem> GetValidProducts(int tab = -1)
    {
        foreach (var resItem in ResourceItem.GetAllByTargetPopupName(nameof(Page_Shop)))
        {
            if (!resItem.CanDisplay || resItem.Category != ResourceItem.Types.Category.Product || !resItem.IsValidByRequiredAndExclusive())
                continue;

            if (tab != -1 && resItem.Tab != tab)
                continue;

            yield return resItem;
        }
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var tabIndex))
                tabBar.selectedIndex = tabIndex;
        }
    }

    public override void OnVisible()
    {
        using var tabDesigns = PooledList<KeyValuePair<int, PageShopDesignDefinition.TabDesign>>.Get();
        tabDesigns.AddRange(CRCExtension.Get().pageShopDesignDefinition.tabDesigns);
        tabDesigns.Sort((x, y) => x.Key.CompareTo(y.Key));
        foreach (var (element, _, (tab, design)) in tabBar.AllocateTabs(tabBarElements, tabDesigns, OnTabSelected))
        {
            element.txtName.text = design.titleStringKey.L();
            element.redDot.Register(GetValidProducts(tab));
        }
        
        tabBar.RefreshTab();
        
        refreshDirty = true;
    }

    public override void OnHide()
    {
    }

    public override void Refresh()
    {
        using var dict = PooledDictionary<int, List<ResourceItem>>.Get();
        foreach (var validProduct in GetValidProducts(tabBar.selectedIndex + 1))
        {
            if (!dict.TryGetValue(validProduct.Group, out var list))
                list = dict[validProduct.Group] = PooledList<ResourceItem>.Get();
            list.Add(validProduct);
        }
        
        //foreach (var (group, products) in dict)
        //{
        //    products.Sort((x, y) => y.Order.CompareTo(x.Order));
        //}

        var groupDesigns =
            CRCExtension.Get().pageShopDesignDefinition.groupDesigns.GetSafe(tabBar.selectedIndex) ??
            Enumerable.Empty<PageShopDesignDefinition.GroupDesign>();
        foreach (var (shopBlock, _, groupDesign) in shopBlockContainer.GetElements(groupDesigns))
        {
            var group = groupDesign.group;
            var products = dict.GetValueOrDefault(group);
            if (products == null)
            {
                shopBlock.elementRoot.SetActive(false);
                continue;
            }
            
            shopBlock.txtShopBlockTitle.text = groupDesign.titleStringKey.L();
            
            shopBlock.shopProductGridLayouts.elementParent.SetActive(false);
            shopBlock.shopBannerPackages.elementParent.SetActive(false);
            shopBlock.shopGachaPackages.elementParent.SetActive(false);
            shopBlock.shopSpecialGachaPackages.elementParent.SetActive(false);
            
            var validProductCount = 0;
            switch (groupDesign.packageType)
            {
                case PageShopDesignDefinition.GroupDesign.PackageType.SimpleGrid:
                    products.Sort((x, y) => x.Order.CompareTo(y.Order));
                    foreach (var (element, i, product) in shopBlock.shopProductGridLayouts.GetElements(products))
                    {
                        if (element.Refresh(product))
                            validProductCount++;
                    }
                    break;
                case PageShopDesignDefinition.GroupDesign.PackageType.BannerPackage:
                    foreach (var (element, i) in shopBlock.shopBannerPackages.GetElements(1))
                    {
                        if (element.Refresh(products))
                            validProductCount++;
                    }
                    break;
                case PageShopDesignDefinition.GroupDesign.PackageType.ChestGacha:
                    foreach (var (element, i, product) in shopBlock.shopGachaPackages.GetElements(products))
                    {
                        if (element.Refresh(product))
                            validProductCount++;
                    }
                    break;
                case PageShopDesignDefinition.GroupDesign.PackageType.SpecialGacha:
                    foreach (var (element, i, product) in shopBlock.shopSpecialGachaPackages.GetElements(products))
                    {
                        if (element.Refresh(product))
                            validProductCount++;
                    }
                    break;
            }

            if (validProductCount == 0)
                shopBlock.elementRoot.SetActive(false);
        }
        
        LayoutRebuilder.ForceRebuildLayoutImmediate(parentRect);
    }

    private bool refreshDirty = false;
    private void LateUpdate()
    {
        if (refreshDirty)
        {
            refreshDirty = false;
            Refresh();
        }
    }

    private void OnTabSelected(int index)
    {
        // set banner or margin
        //var tabDesign = CRCExtension.Get().pageShopDesignDefinition.GetTabDesignByTabIndex(itemTabIndex);
        //goMarginBox.SetActive(!tabDesign.spriteBanner);
        //goBannerBox.SetActive(tabDesign.spriteBanner);
        //imgBanner.sprite = tabDesign.spriteBanner;

        refreshDirty = true;
    }
        
    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);
        
        if (!gameObject.activeInHierarchy)
            return;
        
        switch (e.type)
        {
            case GameEventType.AcquiredItemsUpdated:
            {
                if (e.args[0] is not PlayerAcquiredItemsUpdate acquiredUpdate)
                    return;
                if (acquiredUpdate.Type == PlayerAcquiredItemsUpdate.Types.Type.BuyProduct)
                {
                    refreshDirty = true;
                }
                break;
            }
            case GameEventType.MyPlayerAchievementUpdated:
            case GameEventType.MyPlayerItemUpdated:
            {
                refreshDirty = true;
                break;
            }
        }
    }
    
}
