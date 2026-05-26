using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, DisposeItemRequest request)
    {
        var status = StatusCode.Ok;

        var item = CashItemManager.GetItemById(request.ItemId);
        if (item == null)
            status = StatusCode.ItemNotFound;
        else if (!item.Data.Disposable)
            status = StatusCode.ItemNotDisposable;
        else
            status = CashItemManager.RemoveItem(item, request.Count == 0 ? 1 : request.Count);

        var packet = Packet.Pop(GetNextPacketKey(), new DisposeItemRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language),
        }, requestId);
        SendPacket(packet);
        
        if (status.IsSuccess())
            PlayerLogManager.Queue(PlayerLogModel.Type.DisposeItem, new
            {
                Request = request,
            });
        
        return Task.FromResult(true);
    }
}
