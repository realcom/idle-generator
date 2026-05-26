using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, UseCashItemRequest request)
    {
        var status = StatusCode.Ok;

        PlayerItemModel? item = null;
        if (request.ItemId > 0L)
            item = CashItemManager.GetItemById(request.ItemId);
        else if (request.ItemDataId > 0)
            item = CashItemManager.GetItemByDataId(request.ItemDataId);

        var response = new UseCashItemRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();
        
        var itemBeforeUse = item?.ToMessage();
        
        if (item == null)
            status = StatusCode.ItemNotFound;
        else
        {
            var count = request.Count;
            if (count == 0)
                count = 1;
            status = CashItemManager.UseItem(item, count, request.TargetItemId,
                request.Slot, request.Param1, request.Param2, addedItemStuffs);
        }

        response.Status = status;
        response.Message = ResourceString.Get(status, Language);
        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        if (status.IsSuccess())
        {
            QueueSave((db, transaction) => new PlayerLogModel()
            {
                player_id = Id,
                type = PlayerLogModel.Type.UseCashItem,
                data = JObject.FromObject(new
                {
                    Request = request,
                    ItemBeforeUse = itemBeforeUse,
                    ItemAfterUse = item!.ToMessage(),
                    AddedItems = addedItemStuffs.ToPlayerItemMessages(),   
                })
            }.SaveAsync(db, transaction));
        }
        
        return Task.FromResult(true);
    }
}
