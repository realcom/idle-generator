using System.Collections.Generic;
using Commons.Types.Players;

namespace Commons.Game.Events
{
    public partial class IncreaseMissionEvent : BoardEvent
    {
        public override Type EventType => Type.IncreaseMission;
        
        public long PlayerId;
        public int AchievementDataId;
        public int Progress;
        public PlayerAchievementMessage.Types.State State;
        
    }
}