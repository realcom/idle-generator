using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Popup_BossAppearanceAlert : UIPopup
{
    protected override void RefreshByFlag()
    {
    }

    protected override void OnHideImpl()
    {
        gameObject.SetActive(false);
    }
}
