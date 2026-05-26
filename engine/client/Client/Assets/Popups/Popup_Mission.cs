using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Mission : UIPopup
{
    [Serializable]
    public class MissionCell : UIElement
    {
        public GameObject goDim;
        
        public Image imgIcon;
        public CustomButton btnIcon;
        public TextMeshProUGUI txtCount;
        public TextMeshProUGUI txtName;
        public TextMeshProUGUI txtDesc;
        public TextMeshProUGUI txtProgress;
        public Slider sliderProgress;

        public void Refresh(PlayerAchievementMessage achievement)
        {
            if (achievement == null)
            {
                elementRoot.SetActive(false);
                return;
            }
            
            var resAch = ResourceAchievement.Get(achievement.AchievementDataId)!;
            var rewardAddItem = resAch.RewardAddItemGroups.GetAddItem();
            var resRewardItem = ResourceItem.Get(rewardAddItem.ItemDataId)!;
            imgIcon.sprite = resRewardItem.ClientSpriteIcon;
            txtCount.text = rewardAddItem.Count.ToUnitString();
            txtName.text = resAch.ClientName;
            txtDesc.text = resAch.ClientDesc;

            txtProgress.text = resAch.GetProgressText(achievement);
            var denominator = Math.Max(1, resAch.TargetProgress);
            sliderProgress.value = achievement.Progress / (float)denominator;

            goDim.SetActive(achievement.IsAchievementCompletedOrRewarded());

            btnIcon.SetOnClick(() =>
            {
                resRewardItem.ShowInfoPopup();
            });
        }
    }

    [Serializable]
    public class MissionTableElement : UITableElement<MissionCell>
    {
        
    }

    [SerializeField] private MissionTableElement m_Element = new();

    public override void Refresh()
    {
        base.Refresh();

        using var missions = PooledList<PlayerAchievementMessage>.Get();
        missions.AddRange(MyPlayer.BoardPlayer?.Missions?.Values ?? Enumerable.Empty<PlayerAchievementMessage>());
        missions.Sort(PlayerAchievementMessage.comparer);
        
        m_Element.table.Initialize<PlayerAchievementMessage, MissionCell>(missions, (list, i, cell) =>
        {
            cell.Refresh(list.GetSafe(i));
        });
    }
    
    protected override void Start()
    {
        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.PauseBoard(nameof(Popup_Mission));
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.HasFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.BoardMissionUpdated:
            {
                AddRefreshFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED);
                break;
            }
        }
    }
    
    public override void OnCancel()
    {
        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.ResumeBoard(nameof(Popup_Mission));
        base.OnCancel();
    }
}
