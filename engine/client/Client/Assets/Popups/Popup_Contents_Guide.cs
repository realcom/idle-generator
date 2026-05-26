using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Popup_Contents_Guide : UIPopup
{
    public static Popup_Contents_Guide Show()
    {
        return GameManager.Get().ShowPopup<Popup_Contents_Guide>();
    }
    
    [SerializeField] private TextMeshProUGUI txtTitle;
    [SerializeField] private TextMeshProUGUI txtDesc;
    
    public Popup_Contents_Guide SetTitle(string inTitleText)
    {
        txtTitle.text = inTitleText;
        return this;
    }
    
    public Popup_Contents_Guide SetDesc(string inDescText)
    {
        txtDesc.text = inDescText;
        return this;
    }
    

    protected override void RefreshByFlag()
    {
    }
    
}
