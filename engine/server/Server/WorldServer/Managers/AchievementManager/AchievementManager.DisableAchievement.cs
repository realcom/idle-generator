using Commons.Resources;
using Commons.Types.Players;
using Server.Models;
using static Commons.Types.Players.PlayerAchievementMessage.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    public void DisableAchievement(int achievementDataId)
    {
        var achievement = GetAchievementByDataId(achievementDataId, true);
        if (achievement == null)
            return;
        
        if (achievement.state == State.Disabled)
            return;
        
        achievement.state = State.Disabled;
    }
}
