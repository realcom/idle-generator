using System;
using System.Collections;
using System.Collections.Generic;
using Components.UI.Toggle;
using UnityEngine;

[RequireComponent(typeof(CustomToggle))]
public class ToggleNoticeListener : NoticeListener
{
    [SerializeField] private CustomToggle _toggle;

    private void Start()
    {
        _toggle.interactable = false;
    }

    public override void RefreshNotice(bool bActive)
    {
        _toggle.isOn = bActive;
    }

    public void OnDestroy()
    {
        NoticeSystem.UnregisterListener(this);
    }
    
}
