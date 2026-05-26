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
    private partial Task<bool> HandlePacket(long requestId, BuyItemRequest request)
    {
        var status = StatusCode.Ok;
        
        var selectedMaterialItems = new List<PlayerItemModel>();
        foreach (var selectedMaterialItemId in request.SelectedMaterialItemIds)
        {
            var selectedMaterialItem = CashItemManager.GetItemById(selectedMaterialItemId);
            if (selectedMaterialItem == null)
            {
                status = StatusCode.ItemNotFound;
                break;
            }
            selectedMaterialItems.Add(selectedMaterialItem);
        }
        
        var response = new BuyItemRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();
        var resProductItem = ResourceItem.Get(request.ProductItemDataId);
        if (resProductItem == null)
        {
            Logger.Error($"{this} sent invalid ProductItemDataId: {request.ProductItemDataId}");
            status = StatusCode.BadRequest;
        }

        var consumedItems = new List<PlayerItemMessage>();
        if (status.IsSuccess())
        {
            status = CashItemManager.BuyItem(request.ProductItemDataId, request.Count, out var multiplier, consumedItems, selectedMaterialItems, addedItemStuffs);
            response.Multiplier = multiplier;
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
                type = PlayerLogModel.Type.BuyItem,
                data = JObject.FromObject(new
                {
                    Request = request,
                    AddedItems = addedItemStuffs.ToPlayerItemMessages(),
                    ConsumedItems = consumedItems,
                    Multiplier = response.Multiplier,   
                })
            }.SaveAsync(db, transaction));
        }
        
        return Task.FromResult(true);
    }
}
