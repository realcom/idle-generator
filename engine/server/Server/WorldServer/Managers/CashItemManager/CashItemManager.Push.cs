using Commons.Resources;
using Commons.Utility;
using Server.Models;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public async Task ScheduleItemPushes()
    {
        var offsetTime = DateTime.UtcNow.ToOffsetTime();
        foreach (var resItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Mine))
        {
            var item = GetItemByDataId(resItem.Id);
            if (item == null)
                continue;

            var allExhaustedOffsetTime = GetAllExhaustedOffsetTime(item);
            
            if (offsetTime != allExhaustedOffsetTime)
                await new PlayerPushModel
                {
                    type = PlayerPushModel.PushType.Volatile,
                    publish_at = DateTimeExtensions.FromOffsetTime(allExhaustedOffsetTime),
                    player_id = Player.Id,
                    message = Player.GetString($"Push/MineExhausted/{resItem.Id}"),
                }.SaveAsync().ConfigureAwait(false);
        }

       
    }
    
}
