using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.UI;

public class Popup_Ranking : UIPopup
{
    public UITabBarEx tabBar;
    public CustomDropdown dropDownSeason;
    public GameObject goTimer;
    public TextTimer txtTimerUntilAt;

    [Serializable]
    public class RankCell : UIElement
    {
        public Image imgCell;
        public TextMeshProUGUI txtRank;
        public TextMeshProUGUI txtPlayerLevel;
        public TextMeshProUGUI txtPlayerName;
        public Image imgRankPointIcon;
        public TextMeshProUGUI txtRankPointAmount;

        public void RefreshCell(ResourceItem rankItem, PlayerRankingMessage rankingMessage)
        {
            if (imgCell)
                imgCell.sprite = CRC.Get().GetRankCellSprite(rankingMessage.Rank);
            txtRank.text = rankingMessage.Rank < 1 ? "--" : rankingMessage.Rank.ToString();
            txtPlayerLevel.text = "Lv." + rankingMessage.Player.Level;
            txtPlayerName.text = rankingMessage.Player.Name;
            imgRankPointIcon.sprite = rankItem.ClientSpriteIcon;
            txtRankPointAmount.text = rankingMessage.Score.ToMoneyNum();
            //rankingMessage.
        }
    }

    [Serializable]
    public class RankTableElement : UITableElement<RankCell>
    {
        
    }
    
    public RankCell myRankCell = new();
    public RankTableElement rankTableElement = new();
    public UITableViewEx rankTable;

    private List<ResourceItem> rankItems = new();
    
    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        using var _ = ListPool<int>.Get(out var rankItemIds);
        
        foreach (var token in tokens)
        {
            if (int.TryParse(token, out var rankItemId))
                rankItemIds.Add(rankItemId);
        }
        
        foreach (var rankItemId in rankItemIds)
        {
            rankItems.Add(ResourceItem.Get(rankItemId));
        }
    }

    protected override void Start()
    {
        if (rankItems.Count == 0) //To Default Ranking Popup
        {
            foreach (var rankItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Ranking))
            {
                if (rankItem.RankingId == 0)
                    continue;
                
                if (!rankItem.CompareTargetPopupName(nameof(Popup_Ranking)))
                    continue;
                
                rankItems.Add(rankItem);
            }
        }

        if (rankItems.Count == 0)
        {
            Hide();
            return;
        }

        rankItems.Sort((x, y) => x.Order.CompareTo(y.Order));
        
        foreach (var (element, index) in tabBar.GetRecycleTabs(rankItems.Count, true))
        {
            var rankItem = rankItems[index];
            element.txtTabName.text = rankItem.ClientName;
        }
        tabBar.onTabSelected.RemoveAllListeners();
        tabBar.onTabSelected.AddListener(OnTabSelected);

        tabBar.RefreshTab();
        
        base.Start();
    }

    private void OnTabSelected(int index)
    {
        var rankItem = rankItems.GetSafe(index);
        if (rankItem == null)
        {
            Hide();
            return;
        }
        
        dropDownSeason.ClearOptions();
        var currentDate = rankItem.GetRankingDate();
        using var _ = ListPool<string>.Get(out var seasonList);
        for (var i = 1; i <= currentDate; i++)
        {
            seasonList.Add("Popup_Ranking_Season".L(i));
        }

        dropDownSeason.AddOptions(seasonList);
        dropDownSeason.SetValueWithoutNotify(currentDate - 1);
        dropDownSeason.onValueChanged.RemoveAllListeners();
        dropDownSeason.onValueChanged.AddListener((_) => RefreshRankings());
        
        RefreshRankings();
    }

    private void RefreshRankings()
    {
        RequestGetRanking().Forget();
    }

    private async UniTask RequestGetRanking()
    {
        var rankItem = rankItems.GetSafe(tabBar.selectedTabIndex);
        if (rankItem == null)
        {
            Hide();
            return;
        }
        
        var rankUntilAt = rankItem.GetRankSeasonUntilAt();
        if (double.IsPositiveInfinity(rankUntilAt))
        {
            goTimer.SetActive(false);
        }
        else
        {
            goTimer.SetActive(true);
            txtTimerUntilAt.targetTimeAt = rankUntilAt;
        }
        
        var response = await SendPacket<GetPlayerRankingRequest.Types.Response>(Packet.Pop(0, new GetPlayerRankingRequest()
        {
            RankingItemDataId = rankItem.Id,
            Date = dropDownSeason.value + 1
        }), this.GetCancellationTokenOnDestroy());


        if (!response.Status.IsSuccess())
            return;
        
        rankTable.Initialize<PlayerRankingMessage, RankCell>(response.PlayerRankings, (ranks, idx, element) =>
        {
            element.RefreshCell(rankItem, ranks[idx]);
        });

        myRankCell.RefreshCell(rankItem, response.MyPlayerRanking);

    }

    protected override void RefreshByFlag()
    {
        
    }

    public void OnClickRewardInfo()
    {
        GameManager.Get().ShowPopup<Popup_RankingRewards>().Initialize(rankItems[tabBar.selectedTabIndex]);
    }
    
}
