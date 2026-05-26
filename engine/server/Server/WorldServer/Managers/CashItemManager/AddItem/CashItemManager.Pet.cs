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
    private void AddItemPostProcessPet(PlayerItemModel item, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        using var optionScope = item.GetOptionScope();
        optionScope.Option.RerollOptions.ResizeAndFillNew(item.Data.OptionCounts.Max(x => x));;
    }
}