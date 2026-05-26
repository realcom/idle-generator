using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Promotion : UIPopup
{
    public UnitUIRenderer unitUIRenderer;
    public TextMeshProUGUI txtPreviousRank;
    public TextMeshProUGUI txtCurrentRank;

    [Serializable]
    public class StatCell : UIElement
    {
        public Image imgStatIcon;
        public TextMeshProUGUI txtStatName;
        public TextMeshProUGUI txtPreviousValue;
        public TextMeshProUGUI txtCurrentValue;
        public TextMeshProUGUI txtDiffValue;

        public void Refresh(CRC.StatInfo info, float previousValue, float currentValue)
        {
            imgStatIcon.sprite = info.GetSprite();
            txtStatName.text = info.GetName();
            txtPreviousValue.text = info.Format(previousValue);
            txtCurrentValue.text = info.Format(currentValue);
            txtDiffValue.text = info.Format(currentValue - previousValue);
        }
    }

    public UIElementContainer<StatCell> statCells = new();
    
    protected override void RefreshByFlag()
    {
        
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens.GetSafe(0), out var itemDataId))
            {
                Initialize(itemDataId);
            }
            else
            {
                OnCancel();
            }
        }
    }

    public void Initialize(int itemDataId)
    {
        Initialize(MyPlayer.GetItemByDataID(itemDataId));
    }

    public void Initialize(PlayerItemMessage item)
    {
        if (item == null)
        {
            OnCancel();
            return;
        }
        
        var itemDataId = item.ItemDataId;
        var resItem = ResourceItem.Get(itemDataId);
        if (resItem == null)
        {
            OnCancel();
            return;
        }
        
        unitUIRenderer.Initialize(MyPlayer.PlayerAvatar.Character.GetData());

        var itemLevel = item.Level;
        txtPreviousRank.text = resItem.GetLocalizedString($"UnitTrainingRank_{itemLevel - 1}");
        txtCurrentRank.text = resItem.GetLocalizedString($"UnitTrainingRank_{itemLevel}");
        
        foreach (var (element, index, info) in statCells.GetElements(resItem.AddStats.AsSorted(itemLevel)))
        {
            var curValue = MyPlayer.PlayerUnitStat[info.type];
            var prevValue = curValue - info.stat.Value.GetClamped(itemLevel - 1);
            element.Refresh(info.info, (float)prevValue, (float)curValue);
        }
        
        PlatformManager.Get().LogEvent("promotion", value: itemLevel);
    }
    
}
