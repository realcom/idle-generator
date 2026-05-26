using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Stuffs;
using static Commons.Types.Players.PlayerAchievementMessage.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    public void DayReset(DateTime prevDate, DateTime date)
    {
        var startOfWeek = date.StartOfWeek();
        var weekPassed = startOfWeek != prevDate.StartOfWeek();

        foreach (var resAch in ResourceAchievement.GetAllByTag(Tag.ClaimRewardWhenReset))
        {
            var achievement = GetAchievementByDataId(resAch.Id);
            if (achievement == null)
                continue;
            
            var addedItemStuffs = new List<AddedItemStuff>();
            ClaimReward(achievement, sendRewardToMail: true, addedItemStuffs: addedItemStuffs);
            Player.SendAcquiredItemsUpdate(addedItemStuffs.ToPlayerItemMessages(),
                type: PlayerAcquiredItemsUpdate.Types.Type.ClaimReward, achievementDataId: resAch.Id);
        }

        foreach (var resAch in ResourceAchievement.GetAllByType(ResourceAchievement.Types.Type.Daily))
        {
            DisableAchievement(resAch.Id);
            if (IsOpenable(resAch))
                OpenAchievement(resAch.Id);
        }
        
        if (weekPassed)
        {
            foreach (var resAch in ResourceAchievement.GetAllByType(ResourceAchievement.Types.Type.Weekly))
            {
                DisableAchievement(resAch.Id);
                if (IsOpenable(resAch))
                    OpenAchievement(resAch.Id);
            }
        }
        
        foreach (var resAch in ResourceAchievement.GetAllByType(ResourceAchievement.Types.Type.Ranking))
        {
            var resRankingItem = ResourceItem.Get(resAch.RankingItemDataId)!;
            var prevRankingDate = resRankingItem.GetRankingDate(prevDate);
            var rankingDate = resRankingItem.GetRankingDate(date);
            if (prevRankingDate != rankingDate)
            {
                DisableAchievement(resAch.Id);
                if (IsOpenable(resAch))
                {
                    if (resAch.RankingDelayDays > 0)
                    {
                        var delayRankingDate = resRankingItem.GetRankingDate(date.AddDays(-resAch.RankingDelayDays));
                        if (rankingDate != delayRankingDate)
                            continue;
                    }
                    OpenAchievement(resAch.Id);
                }
            }
            else if (IsOpenable(resAch) && resAch.RankingDelayDays > 0)
            {
                var delayPrevRankingDate = resRankingItem.GetRankingDate(prevDate.AddDays(-resAch.RankingDelayDays));
                var delayRankingDate = resRankingItem.GetRankingDate(date.AddDays(-resAch.RankingDelayDays));
                if (delayPrevRankingDate != delayRankingDate)
                    OpenAchievement(resAch.Id);
            }
        }
        
        IncreaseAchievement(ResourceAchievement.Types.Condition.DayReset);
        IncreaseAchievement(ResourceAchievement.Types.Condition.Login);
        if (weekPassed)
            IncreaseAchievement(ResourceAchievement.Types.Condition.WeekReset);
        
        var passedDay = (date.Date - prevDate.Date).Days;
        IncreaseAchievement(ResourceAchievement.Types.Condition.AchievementProgressDay, passedDay);
        
        foreach (var resRankingItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Ranking))
        {
            if (resRankingItem.GetRankingDate(prevDate) != resRankingItem.GetRankingDate(date))
            {
                var achievementItemDataId = resRankingItem.AchievementItemDataId > 0
                    ? resRankingItem.AchievementItemDataId
                    : resRankingItem.Id;
                IncreaseAchievement(ResourceAchievement.Types.Condition.RankingReset, achievementItemDataId);
            }
        }
        
        return;

        bool IsOpenable(ResourceAchievement resAch)
        {
            return resAch.InitialOpen || (resAch.DayResetOpenRequiredAchievementDataId > 0 && IsAchievementCompleted(resAch.DayResetOpenRequiredAchievementDataId));
        }
        
    }
    
}
