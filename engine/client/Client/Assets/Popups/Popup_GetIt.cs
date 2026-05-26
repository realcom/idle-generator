using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Utility;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_GetIt : UIPopup
{
    public SmartItemIcon imgIcon;
    public TextMeshProUGUI txtName;
    public TextMeshProUGUI txtDesc;
    
    protected override void RefreshByFlag()
    {
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var itemDataId))
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
        var resItem = ResourceItem.Get(itemDataId);
        if (resItem == null)
        {
            OnCancel();
            return;
        }
        
        imgIcon.Set(resItem);
        txtName.text = resItem.ClientName;
        txtDesc.text = resItem.ClientDesc;
        
    }
    
}
