using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using Interfaces;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.UI;

public class Popup_EquipInfo : UIPopup, IViewModePopup, IItemModelViewBasedPopup
{
    public ItemCellBehaviourWrapperElement selectedItemElement = new();
    public TextMeshProUGUI txtMainStatName;
    public TextMeshProUGUI txtMainStatValue;
    public CustomButton btnReset;
    
    [Serializable]
    public class AdditionalStatCell : UIElement
    {
        public TextMeshProUGUI txtDesc;
        public Image imgGradeIcon;
        public GameObject goLocked;
    }
    
    public UIElementContainer<AdditionalStatCell> additionalStatCells = new();

    public RectTransform rtPrices;
    public TextMeshProUGUI txtPriceInfo;
    
    public CustomButton btnLevelUp;
    public CustomButton btnLevelUpAll;
    public CustomButton btnEquip;
    public CustomButton btnUnEquip;
    
    [SerializeField] protected GameObject[] viewOnlyExcludeObjects = new GameObject[0];
    
    private IItemModelViewFormatter _initializedItemModelView;
    public IItemModelViewFormatter formatter => selectedItem ?? _initializedItemModelView;
    private long _itemId;
    private PlayerItemMessage selectedItem => MyPlayer.GetItem(_itemId);
    private ResourceItem _resItem;

    private ResourceItem GetLevelUpSourceItem()
    {
        return _resItem.GetLevelUpSourceItem();
    }

    private PlayerItemMessage GetLevelUpSourcePlayerItem()
    {
        var levelUpSourceItem = GetLevelUpSourceItem();
        return levelUpSourceItem.Id == _resItem.Id
            ? selectedItem
            : MyPlayer.GetItemByDataID(levelUpSourceItem.Id);
    }

    public void Initialize(PlayerItemMessage playerItem)
    {
        OnInitialized(playerItem);
    }

    public void Initialize(IItemModelViewFormatter itemModelViewFormatter)
    {
        viewMode = IViewModePopup.ViewMode.ViewOnly;
        OnInitialized(itemModelViewFormatter);
    }

    public void OnInitialized(IItemModelViewFormatter itemModelViewFormatter)
    {
        _itemId = itemModelViewFormatter.Id;
        _initializedItemModelView = itemModelViewFormatter;
        _resItem = itemModelViewFormatter.GetData()!;
        btnReset.SetActive(_resItem.DecomposeAddItemGroups.Count > 0);
        AddRefreshFlag(RefreshFlag.ALL);
    }

    public override void Refresh()
    {
        base.Refresh();
        
        RefreshSelectedItem();
        RefreshAdditionalStats();
        RefreshEquipButton();
        UpdateView();
    }

    public void OnClickEquipButton()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        var item = selectedItem;
        SendPacket(Packet.Pop(0, new UseCashItemRequest()
        {
            ItemId = item.Id,
            Param1 = item.IsEquipped() ? 1 : 0,
            Slot = _resItem.Type switch
            {
                ResourceItem.Types.Type.Ring => PlayerAvatar.EquipmentSlot.Ring1,
                _ => PlayerAvatar.ToEquipmentSlot(_resItem.Type)
            },
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }

    public void OnClickLevelUpButton()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;

        var levelUpItem = GetLevelUpSourcePlayerItem();
        if (levelUpItem == null)
            return;

        SendPacket(Packet.Pop(0, new LevelUpItemRequest()
        {
            ItemId = levelUpItem.Id,
            Count = 1,
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }

    public void OnClickLevelUpAllButton()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        var levelUpSourceItem = GetLevelUpSourceItem();
        var levelUpItem = GetLevelUpSourcePlayerItem();
        if (levelUpItem == null)
            return;
        
        var levelUpRequestCount = MyPlayer.GetMaxQuickLevelUpCount(levelUpItem, levelUpSourceItem);
        SendPacket(Packet.Pop(0, new LevelUpItemRequest()
        {
            ItemId = levelUpItem.Id,
            Count = levelUpRequestCount,
        }), this.GetCancellationTokenOnDestroy()).Forget();
    }

    protected override void Start()
    {
        btnEquip.SetOnClick(OnClickEquipButton);
        btnUnEquip.SetOnClick(OnClickEquipButton);
        btnReset.SetOnClick(() =>
        {
            GameManager.Get().ShowPopup<Popup_DecomposeItem>().Initialize(selectedItem);
        });
        btnLevelUp.SetOnClick(OnClickLevelUpButton);
        btnLevelUpAll.SetOnClick(OnClickLevelUpAllButton);
        
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_AVATAR_UPDATED))
        {
            Refresh();
        }
    }

    private void RefreshSelectedItem()
    {
        var formatterItem = formatter;
        var itemLevel = formatterItem.GetLevel();
        selectedItemElement.Get<ItemCell>().Refresh(formatterItem);
        
        var levelUpSourceItem = GetLevelUpSourceItem();
        var levelUpItem = GetLevelUpSourcePlayerItem();
        var levelUpLevel = levelUpItem?.GetLevel() ?? itemLevel;

        var info = _resItem.EquipAddStats.AsSorted().FirstOrDefault();
        txtMainStatName.text = info.GetNameString(false);
        txtMainStatValue.text = info.GetFormatString(itemLevel);
        
        var hasLevelUpItem = levelUpItem != null;
        var isMaxLevel = levelUpSourceItem.MaxLevel <= levelUpLevel;

        var materialGroup = hasLevelUpItem && !isMaxLevel ? levelUpSourceItem.GetMaterialItemGroupByLevel(levelUpLevel) : null;
        var (hasEnoughMaterial, notEnoughMaterial) = MyPlayer.HasEnoughMaterial(materialGroup, levelUpSourceItem.GetPurchaseUnit());
        using (var interactor = new ButtonInteractor(btnLevelUp))
        {
            interactor.Update(hasLevelUpItem && hasEnoughMaterial, () =>
            {
                notEnoughMaterial?.ShowAcquisitionablePopup();
            });
            interactor.Update(hasLevelUpItem && !isMaxLevel, "MaxLevel".L());
        }
        
        using (var interactor = new ButtonInteractor(btnLevelUpAll))
        {
            interactor.Update(hasLevelUpItem && hasEnoughMaterial, () =>
            {
                notEnoughMaterial?.ShowAcquisitionablePopup();
            });
            interactor.Update(hasLevelUpItem && !isMaxLevel, "MaxLevel".L());
        }
        
        rtPrices.SetActive(hasLevelUpItem && !isMaxLevel);
        txtPriceInfo.RefreshRequirements(materialGroup?.MaterialItems);
        //priceCells.RefreshRequirements(materialGroup?.MaterialItems);
    }

    private void RefreshEquipButton()
    {
        if (viewMode == IViewModePopup.ViewMode.ViewOnly)
            return;
        
        var isEquipped = selectedItem?.IsEquipped() ?? false;
        btnUnEquip.SetActive(isEquipped);
        btnLevelUp.SetActive(isEquipped);
        btnLevelUpAll.SetActive(isEquipped);
        btnEquip.SetActive(!isEquipped);
    }
    
    private void RefreshAdditionalStats()
    {
        var highestGradeResItem = GetHighestGradeResItemByGroup(_resItem.Type, _resItem.Group);
        if (highestGradeResItem == null)
        {
            Debug.LogError($"Highest grade item not found. Type: {_resItem.Type}, Group: {_resItem.Group}");
            return;
        }

        var highestGrade = highestGradeResItem.Grade;
        
        using var addBuffList = PooledList<AddBuff>.Get();
        for (var i = 0; i < highestGrade; i++)
        {
            addBuffList.Add(highestGradeResItem.EquipAddBuffs.GetSafe(i));
        }
        
        foreach (var (cell, index, addBuff) in additionalStatCells.GetElements(addBuffList))
        {
            cell.imgGradeIcon.sprite = CRC.Get().gradeSymbolSprites.GetClamped(index + 1);
            cell.goLocked.SetActive(index > _resItem.Grade - 1);
            
            if (addBuff == null || addBuff.BuffDataId == 0)
            {
                cell.txtDesc.text = "Empty".L();
                continue;
            }
            var resBuff = ResourceBuff.Get(addBuff.BuffDataId)!;
            cell.txtDesc.text = resBuff.ClientDesc;
        }
    }
    
    public static ResourceItem GetHighestGradeResItemByGroup(ResourceItem.Types.Type type, int group)
    {
        using var equipments = PooledList<ResourceItem>.Get();
        
        foreach (var resItem in ResourceItem.GetAllByGroup(group))
        {
            if (resItem.Category != ResourceItem.Types.Category.Equipment)
                continue;

            if (resItem.Type != type)
                continue;

            if (!resItem.IsValid)
                continue;
            
            equipments.Add(resItem);
        }
        
        equipments.Sort((a, b) => b.Grade.CompareTo(a.Grade));
        
        return equipments.FirstOrDefault();
    }

    public IViewModePopup.ViewMode viewMode { get; set; }
    
    public void UpdateView()
    {
        foreach (var viewOnlyExcludeObject in viewOnlyExcludeObjects)
        {
            if (viewOnlyExcludeObject)
                viewOnlyExcludeObject.SetActive(viewOnlyExcludeObject.activeSelf && viewMode != IViewModePopup.ViewMode.ViewOnly);
        }
    }

}
