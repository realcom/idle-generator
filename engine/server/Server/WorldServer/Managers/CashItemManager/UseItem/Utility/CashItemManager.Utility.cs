using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;
using Server.Stuffs;
using static Commons.Resources.ResourceItem.Types.Type;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private StatusCode UseItemUtility(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var status = CanRemoveItem(item, count);
        if (!status.IsSuccess())
            return status;
        
        var resItem = item.Data;
        var shouldRemoveItem = true;
        switch (resItem.Type)
        {
            case AddStamina:
                status = UseItemUtilityAddStamina(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            
            case Scout:
                status = UseItemUtilityGetScoutRewards(item, count, addedItemStuffs);
                shouldRemoveItem = false;
                break;
            default:
                status = StatusCode.BadRequest;
                break;
        }

        if (status.IsSuccess() && shouldRemoveItem)
            RemoveItem(item, count, false);
        
        return status;
    }
}
