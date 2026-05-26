using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Utility;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class SquadDeploymentCell : MonoBehaviour
{
    public RectTransform rtDragDropRoot;
    public UnitUIRenderer unitUIRenderer;
    public Image imgFloor;
    public ZButton btnCell;

    public RectTransform rtSelected;
    public RectTransform rtOverlapPanel;
    
    private Sprite[] spriteFloors = Array.Empty<Sprite>();

    private void Start()
    {
        rtSelected.localScale = Vector3.zero;
        rtOverlapPanel.localScale = Vector3.zero;
    }
    
    public void ShowSelected(bool show)
    {
        if (show)
        {
            rtSelected.DOKill();
            rtSelected.DOScale(1f, 0.2f).SetEase(Ease.OutBack);
        }
        else
        {
            rtSelected.DOKill();
            rtSelected.DOScale(0f, 0.2f).SetEase(Ease.InBack);
        }
    }

    public void ShowOverlapPanel(bool show)
    {
        if (show)
        {
            rtOverlapPanel.DOKill();
            rtOverlapPanel.DOScale(1f, 0.2f).SetEase(Ease.OutBack);
        }
        else
        {
            rtOverlapPanel.DOKill();
            rtOverlapPanel.localScale = Vector3.zero;
        }
    }

    public void Refresh(Sprite[] sprites)
    {
        spriteFloors = sprites;
    }

    public void RefreshFloor(long Id, bool showOverlapSprite = false)
    {
        if (showOverlapSprite)
        {
            imgFloor.sprite = spriteFloors.GetClamped(2);
            return;
        }

        imgFloor.sprite = spriteFloors.GetClamped(Id == 0 ? 0 : 1);
    }

}
