using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using WorldServer.Managers;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetPlayerChatsRequest request)
    {
        var response = new GetPlayerChatsRequest.Types.Response();
        
        var (statusCode, chats) = await ChatManager.GetChats(request.ChannelKey, request.LastChatId);
        response.Chats.AddRange(chats);
        response.Status = statusCode;

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}