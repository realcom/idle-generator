using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Server.Managers;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, LeaveBoardRequest request)
    {
        BoardManager.LeaveBoard(this, callback: status =>
        {
            var packet = Packet.Pop(GetNextPacketKey(), new LeaveBoardRequest.Types.Response
            {
                Status = status,
                Message = ResourceString.Get(status, Language),
            }, requestId);
            SendPacket(packet);
        });
        
        return Task.FromResult(true);
    }
}
