using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Managers;
using Server.Models;
using Server.Player;
using Server.Utility;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, CreateBoardRequest request)
    {
        var status = StatusCode.Ok;
        var resMap = ResourceMap.Get(request.MapDataId)!;

        status = CashItemManager.TryConsumeMaterials(out var selectedMaterialItemModels, resMap.EntryMaterialItemGroups);
        
        if (status.IsSuccess())
        {
            switch (resMap.Type)
            {
                case ResourceMap.Types.Type.DefenseRank:
                {
                    var rankPointItem = CashItemManager.GetItemByDataId(ResourceItem.Global.DataId.RankPoint);
                    if (rankPointItem == null)
                    {
                        status = StatusCode.BadRequest;
                        break;
                    }
                    var rankPoint = rankPointItem.count;

                    var i = 0;
                    for (; i < 2; ++i)
                    {
                        var rankPointRange = i == 0 ? resMap.DefenseMatchRankPointRange1 : resMap.DefenseMatchRankPointRange2;
                        var opponentRankPointItems = (await PlayerItemModel
                            .GetAllByDataIdCountRangeAsync(ResourceItem.Global.DataId.RankPoint,
                                Math.Max(1, rankPoint - rankPointRange),
                                rankPoint + rankPointRange).ConfigureAwait(false))
                            .Where(i => i.player_id != Id).ToArray();
                        if (opponentRankPointItems.Length == 0)
                            continue;
                        var opponentRankPointItem = opponentRankPointItems.CryptoPickWeighted(item =>
                            1f / (float)Math.Pow(Math.Abs(rankPoint - item.count), resMap.DefenseMatchRankPointRangeConstant))!;

                        var playerId = opponentRankPointItem.player_id;
                        OpponentBoardPlayer = await WorldServer.GetBoardPlayerMessage(playerId).ConfigureAwait(false);
                        OpponentBoardPlayerAvatar = (await PlayerAvatarModel.GetByPlayerIdAsync(playerId).ConfigureAwait(false)).GetAvatar();
                        break;
                    }
                    if (i == 2)
                    {
                        status = StatusCode.BoardMatchFailed;
                        break;
                    }
                    break;
                }
            }

            if (status.IsSuccess())
            {
                (status, var board) = BoardManager.CreateBoard(this, request.MapDataId);
                if (status.IsSuccess())
                {
                    // createBoard시에만 재료가 소모된다고 가정.
                    board!.UsedMaterialItems = selectedMaterialItemModels;
                    foreach (var (materialItemModel, materialItemCount) in selectedMaterialItemModels)
                    {
                        CashItemManager.RemoveItem(materialItemModel, materialItemCount, checkCanRemove: false);
                    }
                }

                AchievementManager.IncreaseAchievement(ResourceAchievement.Types.Condition.JoinGameAny);
                AchievementManager.IncreaseAchievement(new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.JoinGame, ResourceAchievement.ConditionQuery.Comparer.Equal, resMap.AchievementMapDataId));
                AchievementManager.IncreaseAchievement(new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.JoinGameGroup, ResourceAchievement.ConditionQuery.Comparer.Equal, resMap.Group));
            }

            if (status.IsSuccess())
            {
                CashItemManager.RefreshAvatar(true);
            }
        }
        
        var packet = Packet.Pop(GetNextPacketKey(), new CreateBoardRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language),
        }, requestId);
        SendPacket(packet);
        
        return true;
    }
}
