using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode DecomposeItem(IEnumerable<PlayerItemModel?> items, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        foreach (var item in items)
        {
            if (item == null)
                return StatusCode.ItemNotFound;
            
            var status = DecomposeItem(item, addedItemStuffs);
            if (!status.IsSuccess())
                return status;
        }

        return StatusCode.Ok;
    }
    
    public StatusCode DecomposeItem(PlayerItemModel item, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resItem = item.Data;
        if (resItem.DecomposeAddItemGroups.Count == 0)
            return StatusCode.BadRequest;

        var status = CanRemoveItem(item);
        if (!status.IsSuccess())
            return status;

        RemoveItem(item, checkCanRemove: false);

        AddItem(resItem.DecomposeAddItemGroups, addedItemStuffs: addedItemStuffs);
        
        return StatusCode.Ok;
    }
}
