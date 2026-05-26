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
    private StatusCode UseItemEquipment(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resItem = item.Data;
        if (PlayerAvatar.ToEquipmentType(slot) != resItem.Type)
            return StatusCode.BadRequest;

        if (param1 == 0)
            item.AddFlag(PlayerItemMessage.State.InUse);
        else
            item.RemoveFlag(PlayerItemMessage.State.InUse);
        
        Avatar.Equipments.SetSafe(slot, param1 == 0 ? item.ToMessage() : new PlayerItemMessage());
        Avatar.Dirty = true;
        return StatusCode.Ok;
    }
}
