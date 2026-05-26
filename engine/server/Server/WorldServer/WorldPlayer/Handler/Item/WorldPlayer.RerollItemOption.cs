using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, RerollItemOptionRequest request)
    {
        var status = StatusCode.Ok;

        var item = CashItemManager.GetItemById(request.ItemId);
        var prevItem = item?.ToMessage();
        var consumedItems = new List<PlayerItemMessage>();
        
        if (item == null)
            status = StatusCode.ItemNotFound;
        else
        {
            status = CashItemManager.RerollItemOption(item, request.Slot, consumedItems);
        }

        var packet = Packet.Pop(GetNextPacketKey(), new RerollItemOptionRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language)
        }, requestId);
        
        SendPacket(packet);

        if (status.IsSuccess())
        {
            PlayerLogManager.Queue(PlayerLogModel.Type.RerollItemOption, new
            {
                Request = request,
                OptionBeforeReroll = prevItem?.Option,
                OptionAfterReroll = item?.ToMessage().Option,
                ConsumedItems = consumedItems,
            });
        }
        
        return Task.FromResult(true);
    }
}
