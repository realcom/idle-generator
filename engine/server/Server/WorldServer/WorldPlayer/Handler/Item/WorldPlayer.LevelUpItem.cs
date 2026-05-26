using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, LevelUpItemRequest request)
    {
        var status = StatusCode.Ok;

        var item = CashItemManager.GetItemById(request.ItemId);
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

        var consumedItems = new List<PlayerItemMessage>();
        if (item == null)
            status = StatusCode.ItemNotFound;
        else if (status.IsSuccess())
            status = CashItemManager.LevelUpItem(item, consumedItems, request.Count, selectedMaterialItems);

        var response = new LevelUpItemRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language),
        };

        if (item != null)
            response.Items.Add(item.ToMessage());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        if (status.IsSuccess())
            PlayerLogManager.Queue(PlayerLogModel.Type.LevelUpItem, new
            {
                Request = request,
                ConsumedItems = consumedItems,
            });
        
        return Task.FromResult(true);
    }
}
