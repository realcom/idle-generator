using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, ClaimDailyRewardRequest request)
    {
        var status = StatusCode.Ok;
        var response = new ClaimDailyRewardRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();

        if (request.ItemId != 0)
            status = CashItemManager.ClaimDailyReward(CashItemManager.GetItemById(request.ItemId), addedItemStuffs);
        else if (request.ItemIds.Count > 0)
            status = CashItemManager
                .ClaimDailyReward(request.ItemIds.Select(id => CashItemManager.GetItemById(id)), addedItemStuffs);
        
        response.Status = status;
        response.Message = ResourceString.Get(response.Status, Language);
        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        
        SendPacket(packet);

        if (status.IsSuccess())
        {
            SendAcquiredItemsUpdate(
                addedItemStuffs.ToPlayerItemMessages(),
                PlayerAcquiredItemsUpdate.Types.Type.ItemDailyReward,
                silent: request.AcquiredItemUpdateSilently);
            
            QueueSave((db,transaction) => new PlayerLogModel()
            {
                player_id = Id,
                type = PlayerLogModel.Type.ClaimDailyReward,
                data = JObject.FromObject(new
                {
                    Request = request,
                    AddedItems = addedItemStuffs.ToPlayerItemMessages()
                })
            }.SaveAsync(db, transaction));
        }
        
        return Task.FromResult(true);
    }
}
