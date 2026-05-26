using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Server.Managers;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, JoinBoardRequest request)
    {
        var callback = (StatusCode status, GameBoard? board) =>
        {
            var packet = Packet.Pop(GetNextPacketKey(), new JoinBoardRequest.Types.Response
            {
                Status = status,
                Message = ResourceString.Get(status, Language),
            }, requestId);
            SendPacket(packet);
        };
        
        if (request.MapDataId != 0)
            BoardManager.JoinBoardByMapDataId(this, request.MapDataId, callback);
        else
            BoardManager.JoinBoardById(this, request.BoardId, callback);
        
        return Task.FromResult(true);
    }
}
