using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Newtonsoft.Json.Linq;
using Server.Models;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    internal PlayerMailModel? CreateRewardMail(ResourceAchievement resourceAchievement, int count)
    {
        if (count == 0)
            count = 1;
        
        var achievement = GetAchievementByDataId(resourceAchievement.Id);
        if (achievement?.state != PlayerAchievementMessage.Types.State.Completed)
            return null;

        var title = Player.GetString(ResourceString.Types.Category.Achievement, resourceAchievement.Id, "RewardMailTitle");
        var untilAt = resourceAchievement.RewardMailDays > 0 ? DateTime.UtcNow.AddDays(resourceAchievement.RewardMailDays) : (DateTime?)null;

        PlayerMailOption? option = null;
        var addItemGroups = resourceAchievement.RewardAddItemGroups.FilterByLevel(Player.CashItemManager.GetItemLevelWithBonusLevel, resourceAchievement.RewardLevelReferenceItemDataId).ToList();
        if (addItemGroups.Count > 0)
        {
            option = new PlayerMailOption();

            for (var i = 0; i < count; i++)
            {
                foreach (var addItemGroup in addItemGroups)
                {
                    if (addItemGroup.ShouldAddAll)
                    {
                        if (!addItemGroup.CanSampleGroup())
                            continue;

                        foreach (var addItem in addItemGroup.AddItems)
                            option.AddItems.Add(addItem);
                    }
                    else
                    {
                        var addItem = addItemGroup.Sample();
                        if (addItem != null)
                            option.AddItems.Add(addItem);
                    }
                }   
            }
        }

        return new PlayerMailModel()
        {
            player_id = Player.Id,
            title = title,
            until_at = untilAt,
            option = option == null ? null : JObject.FromObject(option)
        };
    }
    
    private void SendRewardMail(ResourceAchievement resourceAchievement, int count = 1)
    {
        SendRewardMail(() => [resourceAchievement], count);
    }
    
    private void SendRewardMail(Func<IEnumerable<ResourceAchievement>> achievementSelector, int count = 1)
    {
        var resourceAchievements = achievementSelector();
        foreach (var resourceAchievement in resourceAchievements)
        {
            var model = CreateRewardMail(resourceAchievement, count);
            if (model == null)
                continue;

            Player.QueueSave(model.SaveAsync);
        }
    }
    
}
