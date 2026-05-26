using Commons.Resources;
using Commons.Types.Players;
using Server.Managers;
using Server.Player;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    private DateTime _nextUpdatePerMinuteAt = DateTime.UtcNow;
    public Task UpdatePerMinute()
    {
        var now = DateTime.UtcNow;
        if (now < _nextUpdatePerMinuteAt)
            return Task.CompletedTask;
        
        //floor less than a minute
        now = now.AddMinutes(1);
        now = new DateTime(now.Year, now.Month, now.Day, now.Hour, now.Minute, 0);
        _nextUpdatePerMinuteAt = now;
        
        try
        {
            UpdatePerMinuteInternal();
        }
        catch (Exception ex)
        {
            Logger.Error($"{Player}.CashItemManager.UpdatePerMinute failed", ex);
        }

        return Task.CompletedTask;
    }

    private void UpdatePerMinuteInternal()
    
    {
        // OnlineAtHour 업적 처리
        var hour = DateTime.UtcNow.Hour;
        var world = WorldManager.GetWorldById(Player.Model.world_id)!;
        IncreaseAchievement(
            new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.OnlineAtHour,
                ResourceAchievement.ConditionQuery.Comparer.Equal, hour + world.utc_offset_hours), 1);
    }
}
