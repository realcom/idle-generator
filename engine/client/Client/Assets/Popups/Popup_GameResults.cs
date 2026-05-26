using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.UI;

public class Popup_GameResultsVictory : Popup_GameResults
{
}
public class Popup_GameResultsFailure : Popup_GameResults
{
}

public class Popup_GameResults : UIPopup
{
    
    [Flags]
    public enum ResultInfoFlag : uint
    {
        NONE = 0,
        Ranking = 1 << 0,
        RankingScore = 1 << 1,
        UnitDeath = 1 << 2,
        TimeRemaining = 1 << 3,
        Reward = 1 << 4,
        ALL = ~NONE,
    }
    
    public const ResultInfoFlag BattleResultFlag = ResultInfoFlag.Ranking | ResultInfoFlag.UnitDeath | ResultInfoFlag.TimeRemaining | ResultInfoFlag.Reward;
    public const ResultInfoFlag ConquestResultFlag = ResultInfoFlag.Ranking | ResultInfoFlag.RankingScore | ResultInfoFlag.TimeRemaining;
    [Serializable]
    public class RewardTableElement : UITableElement<ItemCellBehaviourWrapperElement>
    {
        
    }

    public UIElementContainer<ItemCellBehaviourWrapperElement> rewardCells = new();
    public GameObject goEmptyReward;
    // public RewardTableElement rewardTableElement = new();
    // public UITableViewEx rewardTable;
    
    public TextMeshProUGUI txtContentsInfo;
    //public TextMeshProUGUI txtRemainTime;
    //public TextMeshProUGUI txtRanking;
    //public TextMeshProUGUI txtRankingScore;
    //public TextMeshProUGUI txtDeadUnitCount;

    //public RectTransform rtRankingPanel;
    //public RectTransform rtRankingScorePanel;
    public RectTransform rtRewardPanel;
    //public RectTransform rtDeathPanel;
    
    //public RectTransform rtTopIcon;
    public CanvasGroup cgBody;
    
    private PlayerRankingMessage _prevRanking;
    private PlayerRankingMessage _newRanking;
    
    private List<PlayerItemMessage> _inGameRewardItems = new();   // 게임 도중 보상
    private List<PlayerItemMessage> _resultRewardItems = new();    // 게임 결과 보상

    public void Initialize(
        PlayerRankingMessage prevRanking,
        PlayerRankingMessage newRanking,
        bool isWin,
        IEnumerable<PlayerItemMessage> midGameRewards,
        IEnumerable<PlayerItemMessage> resultRewards,
        ResultInfoFlag infoFlag = BattleResultFlag)
    {
        AudioManager.Get().PauseBGM();
        GameBoardManager.Get().PauseBoard(nameof(Popup_GameResults));

        var resMap = GameBoardManager.Get().gameBoard.ResMap;
        txtContentsInfo.text = resMap.ClientName;

        _prevRanking = prevRanking ?? newRanking;
        _newRanking = newRanking;

        var hasNewRanking = _newRanking != null && _newRanking.Rank != -1;

        RefreshInfoWithFlag(infoFlag);

        if (hasNewRanking)
        {
            if (_prevRanking.Rank == -1)
                _prevRanking.Rank = _newRanking.Rank * 2;
            //txtRanking.text = "Popup_GameResults_Ranking".L(_newRanking.Rank, _prevRanking.Rank - _newRanking.Rank);
            //txtRankingScore.text =
            //    "Popup_GameResults_Ranking_Score".L(_newRanking.Score, _newRanking.Score - _prevRanking.Score);
        }
        else
        {
            //rtRankingPanel.SetActive(false);
            //rtRankingScorePanel.SetActive(false);
        }

        _inGameRewardItems.Clear();
        _resultRewardItems.Clear();
        if (midGameRewards != null)
            _inGameRewardItems.AddRange(midGameRewards);
        if (resultRewards != null)
            _resultRewardItems.AddRange(resultRewards);

        RefreshRewardItems();
        
        PlatformManager.Get().LogEvent("gamePlayEnd",
            ("mapDataId", resMap.Id.ToString()), 
            ("level", MyPlayer.BoardPlayer.Level.ToString()),
            ("result", isWin.ToString())
        );
    }
    
    private void RefreshInfoWithFlag(ResultInfoFlag infoFlag)
    {
        //rtRankingPanel.SetActive(infoFlag.HasFlag(ResultInfoFlag.Ranking));
        //rtRankingScorePanel.SetActive(infoFlag.HasFlag(ResultInfoFlag.RankingScore));
        //rtDeathPanel.SetActive(infoFlag.HasFlag(ResultInfoFlag.UnitDeath));
        //txtRemainTime.gameObject.SetActive(infoFlag.HasFlag(ResultInfoFlag.TimeRemaining));
        rtRewardPanel.SetActive(infoFlag.HasFlag(ResultInfoFlag.Reward));
    }

    protected override void Start()
    {
        base.Start();
    }

    public override void OnCancel()
    {
        GameBoardManager.Get().ResumeBoard(nameof(Popup_GameResults));
        AudioManager.Get().ResumeBGM();
        GameBoardManager.Get().GoToLobby();
        base.OnCancel();
    }

    protected override void RefreshByFlag()
    {
    }

    public void AppendIngameRewards(List<PlayerItemMessage> items, bool refresh = true)
    {
        _inGameRewardItems.AddRange(items);
        if (refresh)
            RefreshRewardItems();
    }

    public void AppendResultRewards(List<PlayerItemMessage> items, bool refresh = true)
    {
        _resultRewardItems.AddRange(items);
        if (refresh)
            RefreshRewardItems();
    }

    public void RefreshRewardItems()
    {
        using var items = PooledList<PlayerItemMessage>.Get();
        items.AddRange(_inGameRewardItems.ToRewardEnumerable());
        items.AddRange(_resultRewardItems.ToRewardEnumerable());
        items.Shrink(false);
        goEmptyReward.SetActive(items.Count == 0);
        foreach (var (element, index, item) in rewardCells.GetElements(items))
        {
            var cell = element.Get<ItemCell>();
            cell.Refresh(item);
        }
    }
}
