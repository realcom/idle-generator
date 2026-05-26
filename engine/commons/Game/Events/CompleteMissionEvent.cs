using System.Collections.Generic;
using Commons.Types;

namespace Commons.Game.Events
{
    public partial class CompleteMissionEvent : BoardEvent
    {
        public override Type EventType => Type.CompleteMission;
        
        public long PlayerId;
        public int AchievementDataId;
        public List<AddItem> AddItems;
    }
}