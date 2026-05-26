using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, DecomposeItemRequest request)
    {
        var status = StatusCode.Ok;

        var response = new DecomposeItemRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();

        if (request.ItemIds.Count > 0)
        {
            status = CashItemManager.DecomposeItem(request.ItemIds.Select(x => CashItemManager.GetItemById(x)), addedItemStuffs);
        }
        else
        {
            var item = CashItemManager.GetItemById(request.ItemId);
            status = item == null ? StatusCode.ItemNotFound : CashItemManager.DecomposeItem(item, addedItemStuffs);
        }
        
        response.Status = status;
        response.Message = ResourceString.Get(status, Language);
        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        
        SendPacket(packet);

        if (status.IsSuccess())
        {
            QueueSave((db, transaction) =>
                new PlayerLogModel()
                {
                    player_id = Id,
                    type = PlayerLogModel.Type.DecomposeItem,
                    data = JObject.FromObject(new
                    {
                        Request = request,
                        AddedItems = addedItemStuffs.ToPlayerItemMessages()
                    })
                }.SaveAsync(db, transaction));
        }
        
        return Task.FromResult(true);
    }
}
