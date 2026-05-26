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
    private void AddItemPostProcessUnit(PlayerItemModel item, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        item.param1 = item.GetBoostedMaxStamina(MaxStaminaBoostRatio);
        item.param2 = DateTime.UtcNow.ToOffsetTime();
    }
}
