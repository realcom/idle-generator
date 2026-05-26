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
    private partial Task<bool> HandlePacket(long requestId, LevelDownItemRequest request)
    {
        var item = CashItemManager.GetItemById(request.ItemId);
        var response = new LevelDownItemRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();

        if (request.Count == 0)
            request.Count = int.MaxValue;
        
        var status = item == null ? StatusCode.ItemNotFound : CashItemManager.LevelDownItem(item, request.Count, addedItemStuffs);
        
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
                type = PlayerLogModel.Type.LevelDownItem,
                data = JObject.FromObject(new
                {
                    Request = request,
                    AddedItems = addedItemStuffs.ToPlayerItemMessages(),   
                })
            }.SaveAsync(db, transaction));   
        }
        
        return Task.FromResult(true);
    }
}
