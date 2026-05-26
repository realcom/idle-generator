using Commons.Resources;
using Server.Models;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private async Task ProcessTimeExpirationInternal(PlayerItemModel? item)
    {
        if (item is not { count: > 0 })
            return;
        
        var now = DateTime.UtcNow;
        item.time_expiration_process_at = now;
        
        var resItem = item.Data;

        switch (resItem.Type)
        {
            case ResourceItem.Types.Type.GamePassMain:
            {
                foreach (var itemDataId in resItem.TargetItemDataIds)
                {
                    await ProcessTimeExpirationInternal(GetItemByDataId(itemDataId)).ConfigureAwait(false);
                }
                
                break;
            }
        }

        if (resItem.ContainsTag(Tag.RetroactiveAchievementReward))
        {
            foreach (var achievementDataId in resItem.TargetAchievementDataIds)
            {
                Player.AchievementManager.ClaimReward(achievementDataId, sendRewardToMail: true);
            }
        }
        
    }
}