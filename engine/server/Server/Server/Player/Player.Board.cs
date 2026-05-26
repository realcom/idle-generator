using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    public BoardPlayerMessage? OpponentBoardPlayer { get; set; }
    public PlayerAvatar? OpponentBoardPlayerAvatar { get; set; }

    public void ClearBoard()
    {
        Board = null;
        LeaveBoardCallback = null;
    }
    
    public abstract void InitBoard(GameBoard board);

    public void SendGetBoard(long requestId = 0L)
    {
        Logger.Info($"sending board info... requestId: {requestId} {Board.Id}");
        if (Board == null)
        {
            var packet = Packet.Pop(GetNextPacketKey(), new GetBoardRequest.Types.Response
            {
                Status = StatusCode.BoardNotFound,
            }, requestId);
            SendPacket(packet);
        }
        else
        {
            var packet = Packet.Pop(GetNextPacketKey(), new GetBoardRequest.Types.Response
            {
                CompressedBoard = Board.Compress(),
            }, requestId);
            SendPacket(packet);    
        }
    }

    public abstract IEnumerable<PlayerItemModel> GetItemsByCategory(ResourceItem.Types.Category category);
    public abstract IEnumerable<PlayerItemModel> GetItemsByType(ResourceItem.Types.Type type);
}
