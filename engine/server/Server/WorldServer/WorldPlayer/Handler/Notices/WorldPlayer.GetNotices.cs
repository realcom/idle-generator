using Commons.Packets;
using Commons.Packets.Requests;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetNoticesRequest request)
    {
        var response = new GetNoticesRequest.Types.Response();
        
        // TODO: implement unread
        
        var notices = (await NoticeModel.GetAll().ConfigureAwait(false)).ToArray();
        
        response.Notices.AddRange(notices.Select(n => n.ToMessage()));
        response.HasUnread = true;

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}