using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Newtonsoft.Json.Linq;
using Server.Managers;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, IncreaseAchievementRequest request)
    {
        var status = StatusCode.Ok;
        var response = new IncreaseAchievementRequest.Types.Response();
        var addedItemStuffs = new List<AddedItemStuff>();

        if (request.Progress == 0)
            request.Progress = 1;
        
        var resAch = ResourceAchievement.Get(request.AchievementDataId);
        if (resAch == null)
            status = StatusCode.AchievementNotFound;
        else
        {
            if (!resAch.ClientAchievement)
                status = StatusCode.BadRequest;
            else
                AchievementManager.IncreaseAchievement(request.AchievementDataId, request.Progress, addedItemStuffs);
        }
        
        response.Status = status;
        response.Message = ResourceString.Get(status, Language);
        response.Items.AddRange(addedItemStuffs.ToPlayerItemMessages());
        
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);

        if (status.IsSuccess())
        {
            QueueSave((db, transaction) => new PlayerLogModel()
            {
                player_id = Id,
                type = PlayerLogModel.Type.IncreaseAchievementProgress,
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
