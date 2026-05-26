using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetPlayerMailsRequest request)
    {
        var response = new GetPlayerMailsRequest.Types.Response();

        if (request.HasUnreadOnly)
            response.HasUnread = await PlayerMailModel.HasUnreadByPlayerId(Id).ConfigureAwait(false);
        else
        {
            var mails = (await PlayerMailModel.GetAllUnreadByPlayerId(Id).ConfigureAwait(false)).ToArray();

            var players =
                (await WorldServer.GetPlayerMessagesByIds(mails.Select(m => m.sender_player_id).Distinct())
                    .ConfigureAwait(false)).ToDictionary(p => p.Id);

            response.Mails.AddRange(mails.Select(m => m.ToMessage(players.GetValueOrDefault(m.sender_player_id))));
            response.HasUnread = response.Mails.Count > 0;
        }

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}
