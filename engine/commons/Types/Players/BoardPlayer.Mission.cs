using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types.Players;

namespace Commons.Types.Players 
{
    public partial class BoardPlayerMessage
    {
        public void InitMissions(ResourceMap resourceMap)
        {
            Missions.Clear();
            var achievementDataIds = resourceMap.MissionDataIds;
            foreach (var achievementDataId in achievementDataIds)
            {
                Missions[achievementDataId] = new PlayerAchievementMessage
                {
                    AchievementDataId = achievementDataId,
                    State = PlayerAchievementMessage.Types.State.InProgress
                };
            }
        }
        public PlayerAchievementMessage? GetMissionByDataId(int dataId)
        {
            if (Missions == null)
                return null;

            return Missions.TryGetValue(dataId, out var achievement)
                ? achievement
                : new PlayerAchievementMessage
                {
                    AchievementDataId = dataId,
                    State = PlayerAchievementMessage.Types.State.Disabled,
                };
        }
        
        public void IncreaseMission(ResourceAchievement.Types.Condition condition, int progress = 1)
        {
            if (progress == 0)
                return;
            
            var validAchievements = ResourceAchievement.GetAllByCondition(condition)
                .Select(resAch => GetMissionByDataId(resAch.Id)).Where(ach => ach != null);
            foreach (var achievement in validAchievements)
                IncreaseMission(achievement!, progress);
        }
        
        public void IncreaseMission(ResourceAchievement.ConditionQuery query, int progress = 1)
        {
            if (progress == 0)
                return;
            
            var validAchievements = ResourceAchievement.GetAllByConditionQuery(query)
                .Select(resAch => GetMissionByDataId(resAch.Id)).Where(ach => ach != null);
            foreach (var achievement in validAchievements)
                IncreaseMission(achievement!, progress);
        }
    
        
        public void IncreaseMission(PlayerAchievementMessage achievement, int progress = 1)
        {
            if (progress == 0)
                return;
            
            var resAch = ResourceAchievement.Get(achievement.AchievementDataId);
            if (resAch == null)
                return;
            
            if (achievement.State != PlayerAchievementMessage.Types.State.InProgress
                && !(resAch.Repeatable && achievement.State is PlayerAchievementMessage.Types.State.Completed or PlayerAchievementMessage.Types.State.Rewarded))
                return;
   
            if (progress < 0)
                achievement.Progress = resAch.TargetProgress;
            else
            {
                achievement.Progress = Math.Min(resAch.TargetProgress, achievement.Progress + progress);
                if (achievement.Progress < 0)
                    achievement.Progress = resAch.TargetProgress;
            }

            if (achievement.Progress == resAch.TargetProgress)
            {
                if (resAch.AutoReward)
                {
                    achievement.State = PlayerAchievementMessage.Types.State.Rewarded;
                    var addItems = ClaimReward(achievement);
                    Board.QueueEvent(new CompleteMissionEvent
                    {
                        PlayerId = Id,
                        AchievementDataId =  achievement.AchievementDataId,
                        AddItems = addItems,
                    });
                }
                else
                {
                    achievement.State = PlayerAchievementMessage.Types.State.Completed;
                }
            }
            else
                Board?.QueueEvent(new IncreaseMissionEvent
                {
                    PlayerId = Id,
                    AchievementDataId =  achievement.AchievementDataId,
                    Progress = achievement.Progress,
                    State = achievement.State,
                });
        }

        private List<AddItem> ClaimReward(PlayerAchievementMessage achievement)
        {
            var resAch = ResourceAchievement.Get(achievement.AchievementDataId);
            var rewardsAddItemGroups = resAch.RewardAddItemGroups;
            var addItems = new List<AddItem>();
            var totalGoldIncreased = 0L;
            for (var i = 0; i < rewardsAddItemGroups.Count; ++i)
            {
                var addItemGroup = rewardsAddItemGroups[i];
                foreach (var addItem in addItemGroup.AddItems)
                {
                    // TODO: other case?
                    if (addItem.ItemDataId == ResourceItem.Global.DataId.Gold)
                    {
                        Gold += addItem.Count;
                        totalGoldIncreased += addItem.Count;
                    }
                    addItems.Add(addItem);
                }
            }
            HandleGoldChange(totalGoldIncreased);
            return addItems;
        }
    }
}