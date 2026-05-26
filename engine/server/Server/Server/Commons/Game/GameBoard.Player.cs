using Commons.Game.Events;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;
using Google.Protobuf;
using Server.Player;
using BoardEvent = Server.Events.BoardEvent;

// ReSharper disable once CheckNamespace
namespace Commons.Game;

public partial class GameBoard
{
    public bool DestroyIfNoPlayer = true;
    
    public void SendPacket(Func<byte, Packet> packetGenerator)
    {
        foreach (var playerMessage in players_.Values)
        {
            var player = Server.GetIPlayerById(playerMessage.Id);
            player?.SendPacket(packetGenerator(player.GetNextPacketKey()));
        }
    }
    
    public void JoinPlayer(uint tick, IPlayer player)
    {
        if (AutoProgress)
            tick = 0;
        
        player.ClearBoard();
        player.Board = this;
        Subscribe(player);
        player.SendUpdate();
        
        QueueUpdate(new BoardPlayerUpdate
        {
            Player = player.ToBoardMessage(includePlayerTraits: ResMap.ContainsTag(Tag.ContainPlayerTrait)),
            Avatar = player.Avatar,
            Tick = tick,
        });
        
        
        QueueServerPostAction(() =>
        {
            player.SendGetBoard();
        });
    }

    public void RefreshPlayer(uint tick, IPlayer player)
    {
        if (AutoProgress)
            tick = 0;
        
        QueueUpdate(new BoardPlayerUpdate
        {
            Player = player.ToBoardMessage(),
            Avatar = player.Avatar,
            Tick = tick,
        });
    }
    
    public void LeavePlayer(uint tick, IPlayer player)
    {
        var boardPlayer = GetPlayerById(player.Id);
        if (boardPlayer == null)
            return;
        
        if (AutoProgress)
            tick = 0;
        
        QueueUpdate(new BoardPlayerUpdate
        {
            Player = player.ToBoardMessage(),
            Avatar = player.Avatar,
            Tick = tick,
            Left = true,
        });
    }
}
