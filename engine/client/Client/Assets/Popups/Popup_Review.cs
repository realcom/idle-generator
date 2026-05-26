using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Review : UIPopup
{
    [Serializable]
    public class StarCell : UIElement
    {   
        public CustomToggle toggleCell;
    }
    
    private const int StarRatingGoodThreshold = 4;
    private const int StarMaxCount = 5;
    
    public CustomButton btnOk;
    private int _starRatingIndex = -1;

    public CustomToggle toggleRatingGood;
    
    public UIElementContainer<StarCell> starCells = new();
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag != RefreshFlag.NONE)
            Refresh();
    }

    protected override void Start()
    {
        foreach (var (element, i) in starCells.GetElements(StarMaxCount))
        {
            element.toggleCell.SetOnClick(() =>
            {
                _starRatingIndex = i;
                AddRefreshAll();
            });
        }
        
        btnOk.SetOnClick(() =>
        {
            var starRating = _starRatingIndex + 1;
            if (starRating >= StarRatingGoodThreshold)
            {
                InAppReviewManager.Get().Request(true);
                OnCancel();
            }
            else
            {
                ShowFeedbackPopup();
            }
        });
        
        base.Start();
    }
    
    public void ShowFeedbackPopup()
    {
        var popup = GameManager.Get().ShowPopup<Popup_Feedback>();
        popup.onHide.AddListener(OnCancel);
    }

    public override void Refresh()
    {
        base.Refresh();

        foreach (var (element, i) in starCells.GetElements(StarMaxCount))
        {
            element.toggleCell.isOn = i <= _starRatingIndex;
        }
        
        var starRating = _starRatingIndex + 1;
        toggleRatingGood.isOn = starRating >= StarRatingGoodThreshold;

        btnOk.interactable = _starRatingIndex != -1;
    }
}
