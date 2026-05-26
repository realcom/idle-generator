using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Types.Players;
using TMPro;
using UnityEngine;

public class Popup_Tooltip : Popup_FloatingUIBase<Popup_Tooltip>
{
    public TextMeshProUGUI txtHeader;
    public RectTransform rtPanelDesc;
    public TextMeshProUGUI txtDesc;
    
    public CanvasGroup canvasGroup;
    
    public static Popup_Tooltip Show(ResourceItem resItem, Vector2? screenPoint = null)
    {
        if (resItem == null)
            return null;

        if (string.IsNullOrEmpty(resItem.ClientName) && string.IsNullOrEmpty(resItem.ClientDesc))
            return null;
        
        var popup = ShowInternal(screenPoint);
        popup.SetHeader(resItem.ClientName);
        popup.SetDesc(resItem.ClientDesc);
        return popup;
    }
    
    public static Popup_Tooltip Show(ResourceBuff resBuff, Vector2? screenPoint = null)
    {
        if (resBuff == null)
            return null;

        if (string.IsNullOrEmpty(resBuff.ClientName) && string.IsNullOrEmpty(resBuff.ClientDesc))
            return null;
        
        var popup = ShowInternal(screenPoint);
        popup.SetHeader(resBuff.ClientName);
        popup.SetDesc(resBuff.ClientDesc);
        return popup;
    }
    
    public static Popup_Tooltip Show(PlayerItemMessage item, Vector2? screenPoint = null)
    {
        if (item == null)
            return null;
        
        var resItem = item.GetData()!;
        var popup = Show(resItem, screenPoint);
        return popup;
    }

    protected override void Clear()
    {
        SetHeader("");
        SetDesc("");
    }
    

    protected override void RefreshByFlag()
    {
    }
    
    public  Popup_Tooltip SetHeader(string header)
    {
        txtHeader.text = header;
        return this;
    }
    
    public Popup_Tooltip SetDesc(string desc)
    {
        rtPanelDesc.SetActive(!string.IsNullOrEmpty(desc));
        txtDesc.text = desc;
        return this;
    }
    
}
