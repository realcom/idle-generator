using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Players;
using Newtonsoft.Json.Linq;
using Npgsql;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, UpdatePlayerNameRequest request)
    {
        var prevName = new string(Name);
        
        var response = new UpdatePlayerNameRequest.Types.Response();

        if (string.Equals(Name, request.Name, StringComparison.InvariantCultureIgnoreCase))
        {
            response.Status = StatusCode.BadRequest;
        }

        if (request.Name.Length < Resources.Global.MinNameLength || request.Name.Length > Resources.Global.MaxNameLength)
        {
            response.Status = StatusCode.BadRequest;
        }
        
        var resProductItem = ResourceItem.Get(request.ProductItemDataId);
        if (resProductItem == null)
        {
            Logger.Error($"{this} sent invalid ProductItemDataId: {request.ProductItemDataId}");
            response.Status = StatusCode.BadRequest;
        }
        
        if (response.Status.IsSuccess())
        {
            response.Status = CashItemManager.GetBuyItemPredictionResult(resProductItem!, 1).status;
        }

        if (response.Status.IsSuccess())
        {
            response.Status = await Model.UpdateNameAsync(request.Name).ConfigureAwait(false);
        }

        var addedItemStuffs = new List<AddedItemStuff>();
        var consumedItems = new List<PlayerItemMessage>();
        if (response.Status.IsSuccess())
        {
            response.Status = CashItemManager.BuyItem(resProductItem!, 1, out _, consumedItemMessages: consumedItems, addedItemStuffs: addedItemStuffs);
        }
        
        response.Message = GetString(response.Status);
        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);

        if (response.Status.IsSuccess())
        {
            SendUpdate();
            
            QueueSave((db, ts) => new PlayerLogModel()
            {
                player_id = Id,
                type = PlayerLogModel.Type.ChangeName,
                data = JObject.FromObject(new
                {
                    Request = request,
                    AddedItems = addedItemStuffs.ToPlayerItemMessages(),
                    ConsumedItems = consumedItems,
                    PrevName = prevName,
                    NewName = request.Name
                })
            }.SaveAsync(db, ts));
        }
        
        return true;
    }
}
