using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Events;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class Popup_WeaponInfo : UIPopup
{
    public TextMeshProUGUI txtWeaponName;
    public TextMeshProUGUI txtWeaponDesc;
    public TextMeshProUGUI txtWeaponLevel;
    public TextMeshProUGUI txtWeaponRarity;
    
    public TextMeshProUGUI txtWeaponCategory;

    public Image imgRarityCell;
    public Image imgWeaponCategoryCell;
    
    [Serializable]
    public class WeaponPortraitCell : UIElement
    {
        public BoardWeaponImage imgWeaponPortrait;
        
        public void Refresh(Popup_WeaponInfo parent, ResourceItem selectedItem)
        {
            if (selectedItem == null)
            {
                elementRoot.SetActive(false);
                return;
            }

            elementRoot.SetActive(true);
            imgWeaponPortrait.Refresh(selectedItem);
            imgWeaponPortrait.FitScaleByRatio(1.5f);
        }
    }

    public WeaponPortraitCell prevGradeWeaponCell = new();
    public WeaponPortraitCell gradeWeaponCell = new();
    public WeaponPortraitCell nextGradeWeaponCell = new();

    [Serializable]
    public class WeaponStatDetailCell : UIElement
    {
        public TextMeshProUGUI txtStatName;
        public TextMeshProUGUI txtStatValue;
    }

    public UIElementContainer<WeaponStatDetailCell> statDetailContainer = new();
    
    public override void Refresh()
    {
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0 && int.TryParse(tokens[0], out var itemId))
        {
            Initialize(ResourceItem.Get(itemId));
        }
    }

    public void Initialize(ResourceItem selectedItem)
    {
        if (selectedItem == null)
        {
            OnCancel();
            return;
        }
        
        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.PauseBoard(nameof(Popup_WeaponInfo));
        
        txtWeaponName.text = selectedItem.ClientName;
        txtWeaponDesc.text = selectedItem.ClientDesc;
        txtWeaponLevel.text = selectedItem.Grade.ToLocalizedLevelString();
        txtWeaponRarity.text = selectedItem.Rarity.ToLocalizedRarityString();
        txtWeaponCategory.text = selectedItem.WeaponCategory.ToLocalizedString();

        imgRarityCell.color = CRC.Get().GetRarityCellColor(selectedItem.Rarity);
        imgWeaponCategoryCell.color = CRC.Get().GetWeaponCategoryCellColor(selectedItem.WeaponCategory);
        
        var groupItems = ResourceItem.GetAllByGroup(selectedItem.Group);
        prevGradeWeaponCell.Refresh(this, groupItems.FirstOrDefault(item => item.Grade == selectedItem.Grade - 1));
        gradeWeaponCell.Refresh(this, selectedItem);
        nextGradeWeaponCell.Refresh(this, groupItems.FirstOrDefault(item => item.Grade == selectedItem.Grade + 1));

        using (ListPool<(string Name, string Value)>.Get(out var pairs))
        {
            pairs.AddRange(selectedItem.GetLocalizedStrings("DetailStatName", "DetailStatValue"));

            foreach (var (element, _, (statName, statValue)) in statDetailContainer.GetElements(pairs))
            {
                element.txtStatName.text = statName;
                element.txtStatValue.text = statValue;
            }
        }
    }

    protected override void RefreshByFlag()
    {
    }

    public override void OnCancel()
    {
        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.ResumeBoard(nameof(Popup_WeaponInfo));
        base.OnCancel();
    }
}
