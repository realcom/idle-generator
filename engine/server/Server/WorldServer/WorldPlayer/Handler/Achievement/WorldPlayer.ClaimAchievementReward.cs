using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Newtonsoft.Json.Linq;
using Server.Managers;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, ClaimAchievementRewardRequest request)
    {
        var count = request.Count == 0 ? 1 : request.Count;
        var response = new ClaimAchievementRewardRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();
        
        var status = StatusCode.Ok;
        if (request.AchievementDataId != 0)
        {
            status = AchievementManager.ClaimReward(request.AchievementDataId, count, addedItemStuffs);
        }
        else
        {
            var achievementDataIds = request.AchievementDataIds.Where(achievementDataId => AchievementManager.CanClaimReward(achievementDataId, count) == StatusCode.Ok).ToList();
            if (achievementDataIds.Count == 0)
                status = StatusCode.BadRequest;

            foreach (var achievementDataId in achievementDataIds)
            {
                status = AchievementManager.ClaimReward(achievementDataId, count, addedItemStuffs);
            }
        }
            
        response.Status = status;
        response.Message = ResourceString.Get(status, Language);
        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);

        if (status.IsSuccess())
        {
            SendAcquiredItemsUpdate(addedItemStuffs.ToPlayerItemMessages(),
                PlayerAcquiredItemsUpdate.Types.Type.ClaimReward,
                achievementDataId: request.AchievementDataId,
                silent: request.AcquiredItemUpdateSilently); 

            QueueSave((db, transaction) => new PlayerLogModel()
            {
                player_id = Id,
                type = PlayerLogModel.Type.ClaimAchievementReward,
                data = JObject.FromObject(new
                {
                    Request = request,
                    AddedItems = addedItemStuffs.ToPlayerItemMessages(),
                })
            }.SaveAsync(db, transaction));
        }
        
        return Task.FromResult(true);
    }
}
