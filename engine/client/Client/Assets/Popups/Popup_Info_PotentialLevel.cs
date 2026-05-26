using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using TMPro;
using UnityEngine;

public class Popup_Info_PotentialLevel : UIPopup
{
    public TextMeshProUGUI txtLevel;
    
    public CustomButton btnPrevLevel;
    public CustomButton btnNextLevel;
    
    private int level = 1;
    private ResourceItem resLevelItem;

    [Serializable]
    public class ProbabilityCell : UIElement
    {
        public MiniGrade miniGrade;
        public TextMeshProUGUI txtProbability;

        public void Refresh(int grade, float weight)
        {
            miniGrade.Refresh(grade);
            miniGrade.RefreshGradeToPotentialGrade(grade);

            if (txtProbability)
                txtProbability.text = $"{weight * 100:0.00}%";
        }
    }
    
    public UIElementContainer<ProbabilityCell> cells = new();
    
    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var itemDataId))
            {
                Initialize(ResourceItem.Get(itemDataId));
            }
            else
            {
                OnCancel();   
            }
        }
    }
    
    public void Initialize(ResourceItem resItem)
    {
        resLevelItem = resItem;
        level = MyPlayer.GetItemByDataID(resLevelItem.Id)?.Level ?? 1;
    }

    protected override void Start()
    {
        btnNextLevel.SetOnClick(() =>
        {
            level++;
            Refresh();
        });
        
        btnPrevLevel.SetOnClick(() =>
        {
            level--;
            Refresh();
        });
        
        base.Start();
    }

    public override void Refresh()
    {
        base.Refresh();
        
        btnPrevLevel.SetActive(level > 1);
        btnNextLevel.SetActive(level < resLevelItem.MaxLevel);
        
        txtLevel.text = "Level".L(level);

        var options = resLevelItem.Options.GetClamped(level - 1);

        using var dict = PooledDictionary<int, float>.Get();
        var totalWeight = options.TotalWeight;
        foreach (var option in options.Options)
        {
            dict[option.Grade] = dict.GetValueOrDefault(option.Grade) + option.Weight;
        }
        
        foreach (var (element, i, (grade, weight)) in cells.GetElements(dict))
        {
            element.Refresh(grade, weight / totalWeight);
        }
    }
    
    protected override void RefreshByFlag()
    {
    }
}
