using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Types;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;

public class Popup_RankingRewards : UIPopup
{

    [Serializable]
    public class RewardTableElement : UITableElement<Utility.TextCell>
    {
        
    }

    public RewardTableElement element = new();
    public UITableViewEx table;

    public UIElementContainer<Utility.TextCell> rules = new();

    private ResourceItem rankItem;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        var token = tokens.GetSafe(0);
        if (int.TryParse(token, out var rankItemId))
        {
            rankItem = ResourceItem.Get(rankItemId);
        }
    }

    public void Initialize(ResourceItem inRankItem)
    {
        rankItem = inRankItem;
    }

    protected override void Start()
    {
        RefreshRewards();
        RefreshRules();
        
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        
    }

    private void RefreshRewards()
    {
        using var _ = ListPool<(int prevRank, int rank, AddItemGroup addItemGroup)>.Get(out var list);
        var previousRank = 1;
        
        foreach (var rankItemAddItemGroup in rankItem.AddItemGroups)
        {
            list.Add((previousRank, rankItemAddItemGroup.Rank, rankItemAddItemGroup));
            previousRank = rankItemAddItemGroup.Rank + 1;
        }
        
        table.Initialize<(int prevRank, int rank, AddItemGroup addItemGroup), Utility.TextCell>(list, (groups, idx, cell) =>
        {
            var (prevRank, rank, addItemGroup) = groups[idx];

            if (rank - prevRank < 1)
            {
                cell.txtString.text = "Popup_RankingReward_Rank_F".L(rank, addItemGroup.GetString());
            }
            else
            {
                cell.txtString.text = "Popup_RankingReward_RankRange_F".L(rank, addItemGroup.GetString(), prevRank);
            }
            
        });
    }
    
    private void RefreshRules()
    {
        using var _ = ListPool<string>.Get(out var list);

        foreach (var (textCell, index, text) in rules.GetElements($"Popup_RankingReward_Rule_{rankItem.Id}".GetLocalizationList()))
        {
            textCell.txtString.text = text;
        }
    }
    
}
