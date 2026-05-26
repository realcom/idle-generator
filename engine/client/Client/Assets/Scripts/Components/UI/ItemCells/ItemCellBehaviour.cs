using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Components.UI.Toggle;
using Interfaces;
using Sirenix.Serialization;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class ItemCellBehaviour : MonoBehaviour
{
    [SerializeReference, OdinSerialize]
    private ItemCellBase m_ItemCell = null;
    public ItemCellBase ItemCell => m_ItemCell;
}

[Serializable]
public sealed class ItemCellBehaviourWrapperElement : UIElement
{
    [ForceCache] public ItemCellBehaviour cell;
    
    public TItemCell Get<TItemCell>() where TItemCell : ItemCellBase
    {
        return cell.ItemCell as TItemCell;
    }
}

[Serializable]
public class ItemCellBase : UIElement
{
    public RectTransform rtCell;
    public CustomButton btnCell;
    
    public Image imgIcon;

    public RectTransform rtEquipmentFrame;
    public Image imgEquipmentFrame;
    public Image imgEquipmentIcon;
    
    public MiniGrade miniGrade;
    public Image imgGrade;
    public Image imgGradeDetail;
    public TextMeshProUGUI txtGrade;

    public Image imgExtraGrade;
    
    public TextMeshProUGUI txtName;
    public TextMeshProUGUI txtDesc;
    public TextMeshProUGUI txtTier;

    public virtual ResourceItem Refresh(ResourceItem resItem, IItemModelViewFormatter formatter = null)
    {
        if (resItem == null)
        {
            SetActive(false);
            return null;
        }
        
        SetActive(true);

        if (imgIcon)
            imgIcon.SetActive(imgIcon.sprite = resItem.ClientSpriteIcon);
        if (imgGrade)
            imgGrade.SetActive(imgGrade.sprite = resItem.ClientSpriteBackground);
        if (imgGradeDetail)
            imgGradeDetail.SetActive(imgGradeDetail.sprite = resItem.ClientSpriteBackgroundDetail);
        if (imgExtraGrade)
            imgExtraGrade.SetActive(imgExtraGrade.sprite = CRC.Get().extraGradeIcons.GetClamped(resItem.ExtraGrade));
        if (txtGrade)
            txtGrade.text = resItem.Grade.ToLocalizedGradeString(resItem.ExtraGrade);
        
        if (txtName)
            txtName.text = resItem.ClientName;
        if (txtDesc)
            txtDesc.text = resItem.ClientDesc;
        if (txtTier)
            txtTier.text = resItem.Tier.ToLocalizedTierString();
        
        if (miniGrade)
            miniGrade.Refresh(resItem.Grade, resItem.ExtraGrade);

        if (rtEquipmentFrame)
        {
            var active = true;
            if (imgEquipmentFrame)
                active &= imgEquipmentFrame.sprite = CRC.Get().equipmentFrameSprites.GetClamped(resItem.Grade);
            if (imgEquipmentIcon)
                active &= imgEquipmentIcon.sprite = CRC.Get().itemTypeIcons.GetValueOrDefault(resItem.Type);
            rtEquipmentFrame.SetActive(active);
        }

        SetDefaultCallback(resItem, formatter);

        return resItem;
    }

    public virtual ResourceItem Refresh(IItemModelViewFormatter formatter)
    {
        return Refresh(formatter?.GetData(), formatter);
    }
    
    public virtual ResourceItem Refresh(PlayerItemMessage item)
    {
        return Refresh(item?.GetData(), item);
    }

    public virtual ResourceItem Refresh(AddItem addItem)
    {
        return Refresh(addItem?.GetData(), addItem);
    }

    public virtual ResourceItem Refresh(PlayerMailAddItem mailAddItem)
    {
        return Refresh(mailAddItem?.GetData(), mailAddItem);
    }

    public virtual ResourceItem Refresh(AddItemGroupExtensions.PredictionItem predictionItem)
    {
        return Refresh(predictionItem.GetData(), predictionItem);
    }
    
    private void SetDefaultCallback(ResourceItem resItem, IItemModelViewFormatter formatter)
    {
        if (resItem == null)
            return;

        if (btnCell)
            btnCell.SetOnClick(() =>
            {
                var popup = resItem.ShowInfoPopup();

                if (popup is IItemModelViewBasedPopup itemModelViewBasedPopup && formatter != null)
                    itemModelViewBasedPopup.Initialize(formatter);
            });
    }
    
    public virtual void SetActive(bool isActive)
    {
        if (elementRoot)
            elementRoot.SetActive(isActive);
    }
    
}

[Serializable]
public class ItemCell : ItemCellBase
{
    public TextMeshProUGUI txtCount;
    public TextMeshProUGUI txtLevel;

    public override ResourceItem Refresh(ResourceItem resItem, IItemModelViewFormatter formatter = null)
    {
        if (base.Refresh(resItem, formatter) == null)
        {
            return resItem;
        }

        if (formatter == null)
            return resItem;

        if (txtCount)
            txtCount.text = formatter.FormatCount(null, int.MaxValue);
        if (txtLevel)
            txtLevel.text = formatter.FormatLevel();
        if (txtDesc)
            txtDesc.text = resItem.ClientDesc.SFormat(formatter.GetLevel());

        return resItem;
    }
    
}

[Serializable]
public class PetCell : ItemCell
{
    public LevelStars levelStars;

    public override ResourceItem Refresh(ResourceItem resItem, IItemModelViewFormatter formatter = null)
    {
        if (base.Refresh(resItem, formatter) == null)
            return null;
        
        if (levelStars)
            levelStars.Refresh(formatter);

        return resItem;
    }
    
}

[Serializable]
public abstract class DimmableItemCell : ItemCell
{
    public CanvasGroup cgCell;
    
    public GameObject goDimmed;
    public Image imgDimBack;

    public override ResourceItem Refresh(ResourceItem resItem, IItemModelViewFormatter formatter = null)
    {
        if (base.Refresh(resItem, formatter) == null)
            return null;

        if (imgDimBack)
            imgDimBack.sprite = imgGrade.sprite;

        return resItem;
    }

    public void ShowDim(bool bShow)
    {
        if (goDimmed)
            goDimmed.SetActive(bShow);

        if (cgCell)
            cgCell.alpha = bShow ? 0.5f : 1f;
    }
}

[Serializable]
public class AchievementRewardItemCell : DimmableItemCell
{
    public GameObject goCompleted;
    public CustomToggle toggleCompleted;

    public ResourceItem Refresh(PlayerAchievementMessage achievement)
    {
        var resAchievement = achievement?.GetData();
        var reward = resAchievement?.RewardAddItemGroups.GetAddItem();
        if (reward == null)
            return null;

        var resItem = reward.GetData();
        if (base.Refresh(resItem, reward) == null)
            return null;

        ShowCompleted(achievement.IsAchievementCompleted());
        ShowDim(achievement.IsAchievementRewarded());

        return resItem;
    }

    public void ShowCompleted(bool bShow)
    {
        if (goCompleted)
            goCompleted.SetActive(bShow);

        if (toggleCompleted)
            toggleCompleted.isOn = bShow;
    }
}

[Serializable]
public class GamePassRewardCell : AchievementRewardItemCell
{
    public CustomToggle toggleLocked;
    
    public void ShowLocked(bool bShow)
    {
        if (toggleLocked)
            toggleLocked.isOn = bShow;
    }
    
}

[Serializable]
public class PlacedItemCell : ItemCell
{
    public GameObject goEmpty;
    public Image imgDimBack;

    public override ResourceItem Refresh(ResourceItem resItem, IItemModelViewFormatter formatter = null)
    {
        if (base.Refresh(resItem, formatter) == null)
            return null;

        if (imgDimBack)
            imgDimBack.SetActive(imgDimBack.sprite = imgGrade.sprite);

        return resItem;
    }

    public override void SetActive(bool isActive)
    {
        if (rtCell)
            rtCell.SetActive(isActive);
        if (goEmpty)
            goEmpty.SetActive(!isActive);
    }
}

[Serializable]
public class ItemTableCell : DimmableItemCell
{
    [ForceCache] public CustomToggle toggleSelected;
    
    public void ShowSelected(bool isSelected)
    {
        if (toggleSelected)
            toggleSelected.isOn = isSelected;
    }
}

[Serializable]
public class InfoViewableItemTableCell : ItemTableCell
{
    public CustomButton btnInfo;

    public override ResourceItem Refresh(ResourceItem resItem, IItemModelViewFormatter formatter = null)
    {
        if (base.Refresh(resItem, formatter) == null)
            return null;

        btnInfo.SetOnClick(() => resItem.ShowInfoPopup());
        
        return resItem;
    }
}

[Serializable]
public class EquippableItemTableCell : ItemTableCell
{
    public GameObject goEquipped;

    public override ResourceItem Refresh(PlayerItemMessage item)
    {
        var resItem = base.Refresh(item);
        ShowEquipped(item?.IsEquipped() == true);
        return resItem;
    }

    public void ShowEquipped(bool bShow)
    {
        if (goEquipped)
            goEquipped.SetActive(bShow);
    }
}

[Serializable]
public class EquippablePetTableCell : ItemTableCell
{
    public GameObject goEquipped;

    public override ResourceItem Refresh(PlayerItemMessage item)
    {
        var resItem = base.Refresh(item);
        ShowEquipped(item?.IsDeployed() == true);
        return resItem;
    }

    public void ShowEquipped(bool bShow)
    {
        if (goEquipped)
            goEquipped.SetActive(bShow);
    }
}