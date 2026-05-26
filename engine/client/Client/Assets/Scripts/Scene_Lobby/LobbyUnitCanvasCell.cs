using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class LobbyUnitCanvasCell : UnitCanvasCell
{
    public RectTransform rtMergeablePanel;
    
    public RectTransform rtWorkStatus;
    public Image imgStaminaFill;
    
    public float duration = 0.3f;

    public override void Initialize(GameUnitObject unit)
    {
        base.Initialize(unit);
        
        rtWorkStatus.SetActive(false);
    }

    private bool bShowMergeablePanel = false;
    public void ShowMergeablePanel(bool bShow)
    {
        if (bShowMergeablePanel == bShow)
            return;
        bShowMergeablePanel = bShow;
        rtMergeablePanel.SetActive(bShow);
        rtMergeablePanel.DOKill();
        if (bShow)
        {
            rtMergeablePanel.DOScale(1.3f, 1f).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutSine);
        }
    }
    
    private bool bShowWorkStatus = false;
    public void ShowWorkStatus()
    {
        if (bShowWorkStatus)
            return;
        bShowWorkStatus = true;
        
        rtWorkStatus.SetActive(true);
        rtWorkStatus.DOKill();
        rtWorkStatus.localScale = Vector3.zero;
        rtWorkStatus.DOScale(1f, duration).SetEase(Ease.OutBack);
    }
    
    public void HideWorkStatus()
    {
        if (!bShowWorkStatus)
            return;
        bShowWorkStatus = false;
        
        rtWorkStatus.DOKill();
        rtWorkStatus.DOScale(0f, duration).SetEase(Ease.InBack)
            .OnComplete(() => rtWorkStatus.SetActive(false));
    }

    public void RefreshStamina(float ratio)
    {
        imgStaminaFill.DOFillAmount(ratio, 0.1f);
        imgStaminaFill.sprite = CRC.Get().GetStaminaCircleFillSprite(ratio);
    }
    
}
