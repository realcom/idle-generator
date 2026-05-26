
using System.Collections.Generic;
using Commons.Resources;

namespace Commons.Types.Players
{
    public partial class PlayerAchievementMessage
    {
        public static readonly Comparer comparer = new();
        public class Comparer : IComparer<PlayerAchievementMessage>
        {
            public int Compare(PlayerAchievementMessage a, PlayerAchievementMessage b)
            {
                if (a == null)
                    return 0;
                if (b == null)
                    return 0;

                var stateA = a.State;
                var stateB = b.State;
                
                var orderA = ResourceAchievement.Get(a.AchievementDataId)!.Order;
                var orderB = ResourceAchievement.Get(b.AchievementDataId)!.Order;
                
                if (stateA == stateB)
                {
                    return orderA == orderB ? a.AchievementDataId.CompareTo(b.AchievementDataId) : orderA.CompareTo(orderB);
                }
                
                var stateIntA = stateA switch
                {
                    Types.State.Rewarded => -100,
                    _ => (int)stateA,
                };
                
                var stateIntB = stateB switch
                {
                    Types.State.Rewarded => -100,
                    _ => (int)stateB,
                };

                return stateIntB.CompareTo(stateIntA);
            }
        }

    }
}