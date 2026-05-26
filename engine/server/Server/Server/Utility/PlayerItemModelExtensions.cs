using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Server.Models;

namespace Server.Utility;

public static class PlayerItemModelExtensions
{
    public static async Task<UnitStat> GetPlayerStat(long playerId, PlayerAvatar? playerAvatar = null, UnitStat? stat = null)
    {
        stat ??= await GetPlayerItemStat(playerId).ConfigureAwait(false);
        playerAvatar ??= (await PlayerAvatarModel.GetAsync(playerId).ConfigureAwait(false))!.GetAvatar();
        playerAvatar.ApplyAvatarStats(stat);
        playerAvatar.ApplyAvatarEquipBuffStats(stat);
        
        return stat;
    }
    
    public static async Task<UnitStat> GetPlayerItemStat(long playerId)
    {
        var itemDataIds = ResourceItem.HasAddStatsItems.Select(i => i.Id).ToList();
        var items = await PlayerItemModel.GetAllByPlayerIdDataIdsAsync(playerId, itemDataIds).ConfigureAwait(false);
        var statItemModels = items.ToDictionary(i => i.item_data_id);
        
        var itemStat = new UnitStat();
        itemStat.Clear();
        Commons.Utility.PlayerItemModelExtensions.ApplyItemStats(id => statItemModels.GetValueOrDefault(id), itemStat);
    
        return itemStat;
    }
}