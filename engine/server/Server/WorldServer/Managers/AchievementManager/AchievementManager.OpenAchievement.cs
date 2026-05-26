using Commons.Resources;
using Commons.Types.Players;
using Server.Models;
using Server.Stuffs;
using static Commons.Types.Players.PlayerAchievementMessage.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    public void OpenAchievement(int achievementDataId, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resAch = ResourceAchievement.Get(achievementDataId);
        if (resAch == null)
        {
            Logger.Warn($"{this} {achievementDataId} is not found.");
            return;
        }

        if (!resAch.IsValid)
            return;
        
        var achievement = GetAchievementByDataId(achievementDataId, true)!;
        if (achievement.state != State.Completed)
        {
            achievement.state = State.InProgress;
            achievement.progress = 0;

            if (resAch.InitialProgress > 0)
                IncreaseAchievement(achievement, resAch.InitialProgress, addedItemStuffs);
        }

        switch (resAch.Condition)
        {
            case ResourceAchievement.Types.Condition.HasItem:
            {
                var count = resAch.ConditionValue2;
                if (count == 0)
                    count = 1;
                
                if (Player.CashItemManager.GetItemByDataId(resAch.ConditionValue1, false, true)?.count >= count)
                    IncreaseAchievement(achievement, -1, addedItemStuffs);
                break;
            }
            case ResourceAchievement.Types.Condition.HasItemLevel:
            {
                foreach (var item in Player.CashItemManager.GetItemsByDataId(resAch.ConditionValue1, true, true))
                {
                    if (item.level >= resAch.ConditionValue2)
                    {
                        IncreaseAchievement(achievement, -1, addedItemStuffs);
                        break;
                    }
                }
                break;
            }
        }
    }
}
