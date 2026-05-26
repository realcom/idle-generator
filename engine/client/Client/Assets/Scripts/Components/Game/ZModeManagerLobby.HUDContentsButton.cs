using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Types.Players;
using TMPro;
using UnityEngine;

public partial class ZModeManagerLobby
{
    [SerializeField] private LobbyHUDContentsButton _specialLimitedContentsButton;
    [SerializeField] private LobbyHUDContentsButton _chapterRewardContentsButton;
    [SerializeField] private LobbyHUDContentsButton _scoutContentsButton;
    [SerializeField] private LobbyHUDContentsButton _conquerContentsButton;
    [SerializeField] private GameObject _rightGridContentsButton;
    [SerializeField] private GameObject _leftGridContentsButton;
    
    public TextMeshProUGUI txtChapterRewardName;
    
    private void RefreshHUDContentsButtons()
    {
        var hudDef = LobbyHUDLayoutDefine.Get()!;
        
        _specialLimitedContentsButton.Initialize(hudDef.specialLimitedButtonDefs.FirstOrDefault(x => x.IsValid()));
        
        foreach (var (go, _, def) in _rightGridContentsButton.GetRecycleChildren(hudDef.rightGridButtons, x => x.IsValid()))
        {
            if (!go.TryGetComponent<LobbyHUDContentsButton>(out var button))
            {
                go.SetActive(false);
                continue;
            }
            
            button.Initialize(def);
        }

        foreach (var (go, _, def) in _leftGridContentsButton.GetRecycleChildren(hudDef.leftGridButtons, x => x.IsValid()))
        {
            if (!go.TryGetComponent<LobbyHUDContentsButton>(out var button))
            {
                go.SetActive(false);
                continue;
            }

            button.Initialize(def);
        }

        RefreshCenterContentsButtons();
    }

    private void InitCenterContentsButtons()
    {
        var hudDef = LobbyHUDLayoutDefine.Get()!;
        
        _chapterRewardContentsButton.Initialize(hudDef.chapterRewardButtonDef);
        _scoutContentsButton.Initialize(hudDef.scoutButtonDef);
        _conquerContentsButton.Initialize(hudDef.conquerButtonDef);
        
        RefreshCenterContentsButtons();
    }

    private void RefreshCenterContentsButtons()
    {
        _chapterRewardContentsButton.Refresh();
        _scoutContentsButton.Refresh();
        _conquerContentsButton.Refresh();
        
        var currentChapterRewardAch = Popup_ChapterReward.GetChapterRewardAchievements().FirstOrDefault(x => MyPlayer.GetAchievementByDataID(x.Id)?.State < PlayerAchievementMessage.Types.State.Rewarded);
        txtChapterRewardName.text = currentChapterRewardAch?.ClientDesc ?? "";
    }
    
}
