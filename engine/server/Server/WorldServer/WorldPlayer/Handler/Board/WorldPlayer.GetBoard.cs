using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Utility;
using Server.Player;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, GetBoardRequest request)
    {
        var status = StatusCode.Ok;
        if (Board == null)
            status = StatusCode.BoardNotJoined;
        else if (request.GetHash)
        {
            Board.QueueServerPostAction(() =>
            {
                var packet = Packet.Pop(GetNextPacketKey(), new GetBoardRequest.Types.Response
                {
                    Status = status,
                    Message = ResourceString.Get(status, Language),
                    Tick = Board!.Tick,
                    BoardHash = Board.GetHashCode(),
                }, requestId);
                SendPacket(packet);
            });
            return Task.FromResult(true);
        }
        else
        {
            Board.QueueServerPostAction(() =>
            {
                Board.ClearUpdates();
                Board.ClearActions();
                SendGetBoard(requestId);
            });
            return Task.FromResult(true);
        }

        var packet = Packet.Pop(GetNextPacketKey(), new GetBoardRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language),
        }, requestId);
        SendPacket(packet);
        
        return Task.FromResult(true);
    }
}
