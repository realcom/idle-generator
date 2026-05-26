using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, ReadPlayerMailsRequest request)
    {
        var response = new ReadPlayerMailsRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();

        var readAt = DateTime.UtcNow;
        var readMailIDs = new List<long>();
        foreach (var mail in await PlayerMailModel.GetAllByIdsAsync(request.MailIDs).ConfigureAwait(false))
        {
            if (mail.read_at != null || mail.deleted)
                continue;
            
            mail.read_at = readAt;
            readMailIDs.Add(mail.id);
            
            if (mail.until_at < readAt)
                continue;

            if (mail.item_data_id != 0)
            {
                CashItemManager.AddItem(new PlayerMailAddItem()
                {
                    ItemDataId = mail.item_data_id,
                    ItemCount = mail.item_count,
                    ItemLevel = mail.item_level,
                    ItemDays = mail.item_days,
                    ItemHours = mail.item_hours,
                    ItemOption = mail.item_option?.ToObject<PlayerItemOption>(),
                }, addedItemStuffs);
            }

            if (mail.DeserializedOption != null)
            {
                foreach (var addItem in mail.DeserializedOption.AddItems)
                {
                    if (addItem.ItemDataId == 0)
                        continue;

                    CashItemManager.AddItem(addItem, addedItemStuffs);
                }
            }
        }
        
        QueueSave((db, transaction) => PlayerMailModel.MarkAsReadByIds(db, transaction, readMailIDs, readAt));

        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        QueueSave((db, transaction) => new PlayerLogModel()
        {
            player_id = Id,
            type = PlayerLogModel.Type.ReadMail,
            data = JObject.FromObject(new
            {
                Request = request,
                AddedItems = addedItemStuffs.ToPlayerItemMessages()       
            })
        }.SaveAsync(db, transaction));
        
        return true;
    }
}
