using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Events;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void AddItemPostProcessUtility(PlayerItemModel item, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        switch (item.Data.Type)
        {
            case ResourceItem.Types.Type.AddMaxCount:
            {
                RefreshTickets();
                break;
            }
            
            case ResourceItem.Types.Type.AddRegenPeriod:
            {
                RefreshTickets();
                break;
            }

            case ResourceItem.Types.Type.Scout:
            {
                var resMap = ResourceMap.Get(item.param1);
                if (item.param1 > 0 && resMap != null)
                {
                    UseItemUtilityGetScoutRewards(item, count, addedItemStuffs);
                }
                else
                {
                    // 초기화
                    var map = ResourceMap.GetAllByGroup(item.Data.MapGroup).Where(m => m.IsValid).LastOrDefault(map =>
                    {
                        var achievement = Player.AchievementManager.GetAchievementByDataId(map.ReferenceAchievementDataIds.FirstOrDefault());
                        return achievement?.progress >= 1;
                    });
                    
                    if (map != null)
                    {
                        item.param1 = map.Id;
                        item.param2 = DateTime.UtcNow.ToOffsetTime();;    
                    }
                    item.param4 = StaticRandom.CryptoNext(int.MaxValue);    
                }
                break;
            }
            
            case ResourceItem.Types.Type.Respawn:
            {
                break;
            }
        }
    }
}
