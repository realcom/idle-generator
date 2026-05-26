using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Utility;
using Server.Managers;
using Server.Player;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, AutoPlayToTickBoardRequest request)
    {
        var toTick = request.ToTick;
        if (Board == null || Board.Destroyed)
        {
            var packet = Packet.Pop(GetNextPacketKey(), new AutoPlayToTickBoardRequest.Types.Response
            {
                Status = StatusCode.BoardNotFound
            }, requestId);
            SendPacket(packet);
            return Task.FromResult(false);
        }
        BoardManager.AutoPlayToTickBoard(this, toTick, callback: status =>
        {
            var packet = Packet.Pop(GetNextPacketKey(), new AutoPlayToTickBoardRequest.Types.Response
            {
                Status = status,
                CompressedBoard = Board!.Compress(),
                Message = ResourceString.Get(status, Language),
            }, requestId);
            SendPacket(packet);
        });
        
        return Task.FromResult(true);
    }
}

