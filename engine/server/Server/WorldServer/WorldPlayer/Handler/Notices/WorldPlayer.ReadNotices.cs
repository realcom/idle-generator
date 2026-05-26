using Commons.Packets;
using Commons.Packets.Requests;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, ReadNoticeRequest request)
    {
        var response = new GetNoticesRequest.Types.Response();
        
        // TODO: implement unread and read notice

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return Task.FromResult(true);
    }
}
