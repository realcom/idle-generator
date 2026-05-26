using Commons.Resources;
using Server.Events;

namespace WorldServer.Managers.RankingManager;

public partial class RankingManager : IServerEventSubscriber
{
    public void HandleEvent(ServerEvent @event)
    {
        switch (@event.EventType)
        {
            case ServerEvent.Type.ItemAddedEvent:
            {
                var ev = (ItemAddedEvent)@event;
                var resItem = ev.Item.Data;

                if (resItem.RankingItemDataId != 0)
                {
                    var resRankingItem = ResourceItem.Get(resItem.RankingItemDataId)!;
                    if (!resRankingItem.RankingExpScore)
                    {
                        var date = resRankingItem.GetRankingDate();
                        var score = resRankingItem.RankingAccumulateScore ? ev.Count : ev.Item.count;
                        Player.RankingManager.QueueRankingScore(resRankingItem, date, score);
                    }
                }
                
                break;
            }
            case ServerEvent.Type.ItemLevelUpEvent:
            {
                var ev = (ItemLevelUpEvent)@event;
                var resItem = ev.Item.Data;

                if (resItem.RankingItemDataId != 0)
                {
                    var resRankingItem = ResourceItem.Get(resItem.RankingItemDataId)!;
                    if (resRankingItem.RankingExpScore)
                    {
                        var date = resRankingItem.GetRankingDate();
                        var score = resRankingItem.RankingAccumulateScore ? ev.Count : ev.Item.level;
                        Player.RankingManager.QueueRankingScore(resRankingItem, date, score);
                    }
                }
                
                break;
            }
        }
    }
}
