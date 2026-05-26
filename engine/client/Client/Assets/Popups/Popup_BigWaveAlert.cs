using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Popup_BigWaveAlert : UIPopup
{
    protected override void RefreshByFlag()
    {
        
    }

    protected override void OnHideImpl()
    {
        gameObject.SetActive(false);
    }
}
