using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Utility.ObjectPool;
using TMPro;
using UnityEngine;

public class Popup_Gacha_Probability : UIPopup
{
    [Serializable]
    public class ProbabilityPerGradeCell : UIElement
    {
        [Serializable]
        public sealed class ProbabilityItemCell : ItemCell
        {
            public TextMeshProUGUI txtProbability;

            public ResourceItem Refresh(AddItem addItem, float parentWeight, float totalWeight)
            {
                var resItem = addItem.GetData();
                if (base.Refresh(resItem, addItem) == null)
                    return null;

                if (addItem.Weight <= 0f)
                {
                    elementRoot.SetActive(false);
                    return null;
                }

                var weight = addItem.Weight * parentWeight / totalWeight;

                if (txtProbability)
                    txtProbability.text = $"{weight:0.00}%";

                if (txtCount)
                    txtCount.text = addItem.FormatCount("", int.MaxValue);

                return resItem;
            }
        }
        
        public MiniGrade miniGrade;
        public TextMeshProUGUI txtProbability;
        public UIElementContainer<ItemCellBehaviourWrapperElement> cells = new();

        public void Refresh(ResourceItem gachaItem, float weight)
        {
            if (miniGrade)
                miniGrade.Refresh(gachaItem);

            if (txtProbability)
                txtProbability.text = "TotalProbability".L($"{weight:0.00}");
            
            var aig = gachaItem.AddItemGroups.First();
            var totalWeight = aig.TotalWeight;
            var addItems = aig.AddItems;
            foreach (var (cell, i, addItem) in cells.GetElements(addItems))
            {
                cell.Get<ProbabilityItemCell>().Refresh(addItem, weight, totalWeight);
            }
        }
    }
    
    public TextMeshProUGUI txtTitle;
    public UIElementContainer<ProbabilityPerGradeCell> cells = new();

    public override void Refresh()
    {
        base.Refresh();
        
        RefreshTable(resGachaItem.AddItemGroups.First());
    }

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
                Initialize(ResourceItem.Get(itemDataId));
            }
            else
            {
                OnCancel();   
            }
        }
    }

    protected ResourceItem resGachaItem;
    public virtual void Initialize(ResourceItem gachaItem)
    {
        txtTitle.text = gachaItem.ClientName;
        resGachaItem = gachaItem;
    }

    protected void RefreshTable(AddItemGroup aig)
    {
        using var addItems = PooledList<AddItem>.Get();
        foreach (var addItem in aig.AddItems)
        {
            if (addItem.Weight <= 0f)
                continue;
            addItems.Add(addItem);
        }
        
        foreach (var (element, i , addItem) in cells.GetElements(addItems))
        {
            element.Refresh(ResourceItem.Get(addItem.ItemDataId), addItem.Weight);
        }
    }
    
}
