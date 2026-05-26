using Commons.Game;
using Commons.Resources;
using Commons.Types.Players;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    public override void InitBoard(GameBoard board)
    {
        try
        {
            InitBoardAchievements(board);
        }
        catch (Exception ex)
        {
            Logger.Error($"Failed to apply board achievements: {this} {board}", ex);
        }
    }

    private void InitBoardAchievements(GameBoard board)
    {
        board.Achievements.Clear();
        foreach (var achievementDataId in board.ResMap.ReferenceAchievementDataIds)
        {
            var achievement = AchievementManager.GetAchievementByDataId(achievementDataId);
            if (achievement != null)
                board.Achievements.Add(achievementDataId, achievement.ToMessage());
            else
                board.Achievements.Add(achievementDataId, new PlayerAchievementMessage
                {
                    AchievementDataId = achievementDataId,
                    State = PlayerAchievementMessage.Types.State.Disabled,
                });
        }
    }

    private bool ValidateBoardAchievements(GameBoard board, IReadOnlyList<PlayerAchievementMessage> achievements)
    {
        foreach (var boardAch in achievements)
        {
            var achievement = AchievementManager.GetAchievementByDataId(boardAch.AchievementDataId);
            if (achievement == null)
            {
                if (boardAch.State != PlayerAchievementMessage.Types.State.Disabled || boardAch.Progress != 0)
                    return false;
            }
            else
            {
                switch (boardAch.State)
                {
                    case PlayerAchievementMessage.Types.State.InProgress:
                    {
                        if (boardAch.Progress > achievement.progress)
                            return false;
                        break;
                    }
                    case PlayerAchievementMessage.Types.State.Completed:
                    case PlayerAchievementMessage.Types.State.Rewarded:
                    {
                        if (boardAch.Progress != achievement.Data.TargetProgress)
                            return false;
                        if (boardAch.State != achievement.state)
                            return false;
                        break;
                    }
                }
            }
        }

        return true;
    }

    private bool CanUseSkill(uint tick, int skillDataId)
    {
        // TODO: check skill is equipped
        var resSkill = ResourceSkill.Get(skillDataId)!;
        if (resSkill.ItemDataId != 0)
        {
            var resItem = ResourceItem.Get(resSkill.ItemDataId)!;
            if (resItem.Category == ResourceItem.Types.Category.Skill)
            {
                var skillCount = BoardPlayerSkillCount.GetValueOrDefault(resSkill.Id);
                if (skillCount <= 0)
                    return false;
                BoardPlayerSkillCount[resSkill.Id] = skillCount - 1;
            }
        }

        return true;
    }
}
