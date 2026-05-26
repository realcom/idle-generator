using System.Linq;
using Commons.Packets.Updates;
using Commons.Types.Players;
using static Commons.Types.Players.PlayerAchievementMessage.Types.State;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public PlayerAchievementMessage GetAchievementByDataId(int dataId)
        {
            return achievements_.TryGetValue(dataId, out var achievement)
                ? achievement
                : new PlayerAchievementMessage
                {
                    AchievementDataId = dataId,
                    State = Disabled,
                };
        }
        
        private partial void HandleUpdateInternal(BoardAchievementUpdate update)
        {
            achievements_.Clear();
            foreach (var achievement in update.Achievements)
                achievements_[achievement.AchievementDataId] = achievement;
        }
    }
}
