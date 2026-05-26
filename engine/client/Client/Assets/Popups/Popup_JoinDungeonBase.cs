using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public abstract class Popup_JoinDungeonBase : UIPopup
{
    public Image imgBanner;
    
    [Serializable]
    public class DetailInfoCell : UIElement
    {
        public TextMeshProUGUI txtDetailInfo;
        public Image imgCell;
    }
    
    public TextMeshProUGUI txtDungeonStep;
    
    public UIElementContainer<DetailInfoCell> detailInfoCells = new();
    public UIElementContainer<ItemCellBehaviourWrapperElement> rewardCells = new();
    
    public TextMeshProUGUI txtDungeonThemaName;
    
    protected ResourceMap _resMap;
    protected ResourceMap _resMapMeta;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            Initialize(ResourceMap.Get(int.Parse(tokens[0])));
        }
        else
        {
            OnCancel();
            return;
        }
    }

    public virtual bool Initialize(ResourceMap resMap)
    {
        if (resMap == null || resMap.ContainsTag(Tag.Meta))
        {
            OnCancel();
            return false;
        }
        
        _resMap = resMap;
        _resMapMeta = ResourceMap.Get(resMap.Group)!;
        
        imgBanner.sprite = _resMapMeta.GetSpriteByKey("DetailedBanner");
        txtDungeonThemaName.text = _resMapMeta.ClientName;
        
        foreach (var (element, i, inText) in detailInfoCells.GetElements(_resMap.GetLocalizedStrings("DetailInfo")))
        {
            element.txtDetailInfo.text = inText;
        }
        
        foreach (var (element, index, addItem) in rewardCells.GetElements(_resMap.RewardAddItemGroups.GetAddItems()))
        {
            element.Get<ItemCell>().Refresh(addItem);
        }

        return true;
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED) || refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }
}
