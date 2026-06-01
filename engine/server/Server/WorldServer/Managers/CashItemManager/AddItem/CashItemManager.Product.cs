using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void AddItemPostProcessProduct(PlayerItemModel item, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        using var optionScope = item.GetOptionScope();
        optionScope.Option.ProductOption ??= new();
        optionScope.Option.ProductOption.PityCounts.ResizeAndFillNew(item.Data.BonusCounts.Count);

        if (item.Data.GetGameSpeedMultiplier() > ResourceItem.MinGameSpeedMultiplier)
            RefreshBoosts();
    }
}
