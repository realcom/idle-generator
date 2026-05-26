using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, DeletePlayerMailsRequest request)
    {
        var response = new DeletePlayerMailsRequest.Types.Response();

        var deleteMailIds = new List<long>();
        foreach (var mail in await PlayerMailModel.GetAllByIdsAsync(request.MailIDs).ConfigureAwait(false))
        {
            if (mail.deleted)
                continue;
            
            mail.deleted = true;
            deleteMailIds.Add(mail.id);
        }

        QueueSave((db, transaction) => PlayerMailModel.MarkAsDeleteByIds(db, transaction, deleteMailIds, true));

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}