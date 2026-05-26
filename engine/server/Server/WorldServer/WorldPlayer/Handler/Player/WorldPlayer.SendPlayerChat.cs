using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using WorldServer.Managers;
using Server.Models;
using Server.Player;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, SendPlayerChatRequest request)
    {
        var status = await ChatManager.SendChat(this, request.Chat.ChannelKey, request.Chat.Language, request.Chat.Message);
        var packet = Packet.Pop(GetNextPacketKey(), new SendPlayerChatRequest.Types.Response
        {
            Status = status,
        }, requestId);
        SendPacket(packet);
        
        return true;
    }
}
