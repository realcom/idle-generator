using Commons.Game.Actions;
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
    private StatusCode UseItemSystem(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var status = StatusCode.Ok;
        var resItem = item.Data;
        switch (resItem.Type)
        {
            case ResourceItem.Types.Type.Setting:
            {
                item.count = count;
                item.param1 = param1;
                item.param2 = param2;
                break;
            }
            default:
            {
                status = StatusCode.BadRequest;
                break;
            }
        }
        
        return status;
    }
}
