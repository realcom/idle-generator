using System.Collections;
using System.Collections.Generic;
using Commons.Packets;
using Commons.Packets.Requests;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_ContentsOpen : UIPopup
{
    public TextMeshProUGUI txtHeader;
    public Image imgContentsIcon;
    public TextMeshProUGUI txtContentsName;
    public TextMeshProUGUI txtDesc;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length < 1)
        {
            OnCancel();
            return;
        }
        
        var nameKey = tokens[0];
        txtContentsName.text = nameKey.L();
        
        var descKey = tokens.GetSafe(1);
        txtDesc.text = string.IsNullOrEmpty(descKey) ? string.Empty : descKey.L();
        
        var iconPath = tokens.GetSafe(2);
        imgContentsIcon.sprite = string.IsNullOrEmpty(iconPath) ? null : new LazyLoad<Sprite>(iconPath).Get();

        var headerKey = tokens.GetSafe(3) ?? nameof(Popup_ContentsOpen);
        txtHeader.text = headerKey.L();

    }

    protected override void RefreshByFlag()
    {
    }
    
}
