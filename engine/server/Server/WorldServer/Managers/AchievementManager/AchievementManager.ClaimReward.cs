using System.Reflection;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Server.Models;
using Server.Stuffs;
using static Commons.Resources.ResourceAchievement.Types;
using static Commons.Types.Players.PlayerAchievementMessage.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    public StatusCode CanClaimReward(int achievementDataId, int count = 1)
    {
        var achievement = GetAchievementByDataId(achievementDataId);
        if (achievement == null)
            return StatusCode.AchievementNotFound;
        return CanClaimReward(achievement, count);
    }
    
    public StatusCode CanClaimReward(PlayerAchievementModel achievement, int count = 1)
    {
        if (achievement.state != State.Completed)
            return StatusCode.AchievementNotCompleted;
        
        var resAch = achievement.Data;
        if (resAch.RewardRequiredItemDataId != 0)
        {
            var requiredItem = Player.CashItemManager.GetItemByDataId(resAch.RewardRequiredItemDataId, true, true);
            if (requiredItem == null)
                return StatusCode.AchievementRequiredItemNotExist;
        }
        
        if (count < 0)
            count = Math.Max(1, achievement.progress / resAch.TargetProgress);
        if (count > 1 && (!resAch.Repeatable || achievement.progress < count * resAch.TargetProgress))
            return StatusCode.BadRequest;

        return StatusCode.Ok;
    }
    
    public StatusCode ClaimReward(int achievementDataId, int count = 1, IList<AddedItemStuff>? addedItemStuffs = null, bool sendRewardToMail = false)
    {
        var achievement = GetAchievementByDataId(achievementDataId);
        if (achievement == null)
            return StatusCode.AchievementNotFound;
        return ClaimReward(achievement, count, addedItemStuffs);
    }
    
    public StatusCode ClaimReward(PlayerAchievementModel achievement, int count = 1, IList<AddedItemStuff>? addedItemStuffs = null, bool sendRewardToMail = false)
    {
        var status = CanClaimReward(achievement, count);
        if (status != StatusCode.Ok)
            return status;
        
        var resAch = achievement.Data;
        
        if (count < 0)
            count = Math.Max(1, achievement.progress / resAch.TargetProgress);
        if (count > 1 && (!resAch.Repeatable || achievement.progress < count * resAch.TargetProgress))
            return StatusCode.BadRequest;

        if (sendRewardToMail ||resAch.ContainsTag(Tag.RewardToMail))
        {
            SendRewardMail(resAch, count);
        }
        else
        {
            var addItemGroups = resAch.RewardAddItemGroups.FilterByLevel(Player.CashItemManager.GetItemLevelWithBonusLevel, resAch.RewardLevelReferenceItemDataId).ToList();
            if (addedItemStuffs == null)
            {
                addedItemStuffs = new List<AddedItemStuff>();
                status = Player.CashItemManager.AddItem(addItemGroups, count, addedItemStuffs: addedItemStuffs);
                Player.SendAcquiredItemsUpdate(addedItemStuffs.ToPlayerItemMessages(),
                    type: PlayerAcquiredItemsUpdate.Types.Type.ClaimReward, achievementDataId: resAch.Id);
            }
            else
                Player.CashItemManager.AddItem(addItemGroups, count, addedItemStuffs: addedItemStuffs);            
        }
                
        if (status.IsSuccess())
        {
            if (resAch.Repeatable)
            {
                achievement.progress -= count * resAch.TargetProgress;
                if (achievement.progress < resAch.TargetProgress)
                    achievement.state = State.InProgress;
            }
            else
            {
                achievement.state = State.Rewarded;
                if (!resAch.OpenChildrenOnComplete)
                {
                    foreach (var childAchievementDataId in resAch.ChildAchievementDataIds)
                        OpenAchievement(childAchievementDataId, addedItemStuffs);
                }

                if (resAch.ParentAchievementDataId != 0 && !resAch.ProgressParentOnComplete)
                    IncreaseAchievement(resAch.ParentAchievementDataId, addedItemStuffs: addedItemStuffs);
            }

            IncreaseAchievement(
                new ResourceAchievement.ConditionQuery(
                    Condition.ClaimRewardAchievement,
                    ResourceAchievement.ConditionQuery.Comparer.Equal,
                    resAch.Id),
                addedItemStuffs: addedItemStuffs);
        }
        
        return status;
    }
}
