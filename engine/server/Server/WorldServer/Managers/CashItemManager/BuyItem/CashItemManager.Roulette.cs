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
// not USED
public partial class CashItemManager
{
    private void ProcessBuyRoulette(ResourceItem resProductItem, int count, out int multiplier, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var productItemDataId = resProductItem.ProductItemDataId != 0 ? resProductItem.ProductItemDataId : resProductItem.Id;
        var productItem = GetOrCreateItem(productItemDataId, out var _, 0);
        if (productItem.param1 >= resProductItem.BonusCount)
        {
            productItem.param1 = 0;
            multiplier = resProductItem.Multipliers.Max();
        }
        else
        {
            productItem.param1 += 1;
            multiplier = resProductItem.Multipliers.CryptoPickWeighted(resProductItem.MultiplierWeights);
        }
        
        AddItem(resProductItem.AddItemGroups, multiplier * count, addedItemStuffs: addedItemStuffs);
    }
}
