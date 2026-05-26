using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Server.Managers;
using Server.Models;
using Server.Utility;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetPlayerInfoRequest request)
    {
        var response = new GetPlayerInfoRequest.Types.Response
        {
            PlayerInfo = new()
        };

        if (request.PlayerId == 0L)
        {
            //self info
            response.PlayerInfo.Player = ToMessage();
            response.PlayerInfo.Avatar = Avatar;
            response.PlayerInfo.World = WorldManager.GetWorldById(Model.world_id)!.ToMessage();

            var stat = new UnitStat();
            ItemStat.CopyTo(stat);
            stat = await PlayerItemModelExtensions.GetPlayerStat(Id, Avatar, stat).ConfigureAwait(false);
            stat.CopyTo(response.PlayerInfo.Stat);
            
            var resScoutItem = ResourceItem.GetAllByType(ResourceItem.Types.Type.Scout)
                .First(i => i.IsValid && ResourceMap.Get(i.MapGroup)?.ContainsTag(Tag.Main) == true);
            var scoutItem = CashItemManager.GetItemByDataId(resScoutItem.Id)!;
            response.PlayerInfo.HighestChapter = scoutItem.param1;
        }
        else
        {
            var player = await PlayerModel.GetAsync(request.PlayerId).ConfigureAwait(false);
            if (player == null)
            {
                response.Status = StatusCode.PlayerNotFound;
            }
            else
            {
                response.PlayerInfo.Player = player.ToMessage();
                
                var avatar = await PlayerAvatarModel.GetByPlayerIdAsync(player.id).ConfigureAwait(false);
                response.PlayerInfo.Avatar = avatar!.GetAvatar();
                
                var world = WorldManager.GetWorldById(player.world_id)!;
                response.PlayerInfo.World = world.ToMessage();
                
                var stat = await PlayerItemModelExtensions.GetPlayerStat(player.id, response.PlayerInfo.Avatar).ConfigureAwait(false);
                stat.CopyTo(response.PlayerInfo.Stat);

                var resScoutItem = ResourceItem.GetAllByType(ResourceItem.Types.Type.Scout)
                    .First(i => i.IsValid && ResourceMap.Get(i.MapGroup)?.ContainsTag(Tag.Main) == true);
                var scoutItem = await PlayerItemModel.GetAsync(player.id, resScoutItem.Id).ConfigureAwait(false)!;
                response.PlayerInfo.HighestChapter = scoutItem?.param1 ?? 0;
            }
        }
        
        response.Status = StatusCode.Ok;

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}