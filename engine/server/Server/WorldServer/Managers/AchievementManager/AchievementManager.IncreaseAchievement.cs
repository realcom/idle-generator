using Commons.Resources;
using Commons.Types.Players;
using Server.Models;
using Server.Stuffs;
using static Commons.Resources.ResourceAchievement.Types;
using static Commons.Types.Players.PlayerAchievementMessage.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    public int IncreaseAchievement(PlayerAchievementModel achievement, int progress = 1, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (progress == 0)
            return 0;
        
        var resAch = achievement.Data;
        if (achievement.state != State.InProgress
            && !(resAch.Repeatable && achievement.state == State.Completed))
            return 0;
        
        if (!resAch.IsValidNow())
            return 0;

        var openAchievementCount = 0;
        if (resAch.Repeatable)
        {
            var prevProgress = achievement.progress;
            if (progress < 0)
                achievement.progress += resAch.TargetProgress;
            else
                achievement.progress += progress;

            if (achievement.progress >= resAch.TargetProgress)
            {
                if (achievement.state == State.InProgress)
                    achievement.state = State.Completed;
                var clearCount = achievement.progress / resAch.TargetProgress - prevProgress / resAch.TargetProgress;
                if (clearCount > 0)
                    IncreaseAchievement(
                        new ResourceAchievement.ConditionQuery(Condition.CompleteAchievement,
                            ResourceAchievement.ConditionQuery.Comparer.Equal, resAch.Id), clearCount, addedItemStuffs);

                if (resAch.AutoReward)
                    ClaimReward(achievement, -1, addedItemStuffs);
            }
        }
        else
        {
            if (progress < 0)
                achievement.progress = resAch.TargetProgress;
            else
            {
                achievement.progress = Math.Min(resAch.TargetProgress, achievement.progress + progress);
                if (achievement.progress < 0)
                    achievement.progress = resAch.TargetProgress;
            }

            if (achievement.progress == resAch.TargetProgress)
            {
                achievement.state = State.Completed;
                if (resAch.OpenChildrenOnComplete)
                {
                    foreach (var childAchievementDataId in resAch.ChildAchievementDataIds)
                    {
                        openAchievementCount += 1;
                        OpenAchievement(childAchievementDataId, addedItemStuffs);
                    }
                }

                if (resAch.ParentAchievementDataId != 0 && resAch.ProgressParentOnComplete)
                    IncreaseAchievement(resAch.ParentAchievementDataId, addedItemStuffs: addedItemStuffs);

                IncreaseAchievement(
                    new ResourceAchievement.ConditionQuery(
                        Condition.CompleteAchievement,
                        ResourceAchievement.ConditionQuery.Comparer.Equal,
                        resAch.Id),
                    addedItemStuffs: addedItemStuffs);

                if (resAch.AutoReward)
                    ClaimReward(achievement, -1, addedItemStuffs);
            }
        }

        return openAchievementCount;
    }
    
    public void IncreaseAchievement(int achievementDataId, int progress = 1, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (progress == 0)
            return;
        
        var achievement = GetAchievementByDataId(achievementDataId);
        if (achievement == null)
            return;
        IncreaseAchievement(achievement, progress, addedItemStuffs);
    }

    public void IncreaseAchievement(Condition condition, int progress = 1, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (progress == 0)
            return;

        while (true)
        {
            var openAchievementCount = 0;
            var validAchievements = ResourceAchievement.GetAllByCondition(condition)
                .Select(resAch => GetAchievementByDataId(resAch.Id)).Where(ach => ach != null).ToArray();
            foreach (var achievement in validAchievements)
                openAchievementCount += IncreaseAchievement(achievement!, progress, addedItemStuffs);

            if (progress > 0 || openAchievementCount == 0)
                break;
        }
    }

    public void IncreaseAchievement(ResourceAchievement.ConditionQuery query, int progress = 1, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (progress == 0)
            return;

        while (true)
        {
            var openAchievementCount = 0;
            var validAchievements = ResourceAchievement.GetAllByConditionQuery(query)
                .Select(resAch => GetAchievementByDataId(resAch.Id)).Where(ach => ach != null).ToArray();
            foreach (var achievement in validAchievements)
                openAchievementCount += IncreaseAchievement(achievement!, progress, addedItemStuffs);

            if (progress > 0 || openAchievementCount == 0)
                break;
        }
    }
}
