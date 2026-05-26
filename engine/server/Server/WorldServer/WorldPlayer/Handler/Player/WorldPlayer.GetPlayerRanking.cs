using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetPlayerRankingRequest request)
    {
        var response = new GetPlayerRankingRequest.Types.Response();
        var resRankingItem = ResourceItem.Get(request.RankingItemDataId)!;
        var date = request.Date;
        if (date == 0)
            date = resRankingItem.GetRankingDate();
        if (request.MyRankOnly)
        {
            var myScore = await PlayerRankingModel.GetScoreAsync(resRankingItem.RankingId, date, Id).ConfigureAwait(false);
            var myRank = myScore == 0L ? -1 : await PlayerRankingModel.GetRankAsync(resRankingItem.RankingId, date, Id).ConfigureAwait(false);
            response.MyPlayerRanking = new PlayerRankingMessage
            {
                Player = ToMessage(),
                Rank = myRank,
                Score = myScore,
            };
        }
        else if (request.TargetPlayerId > 0L)
        {
            var targetScore = await PlayerRankingModel.GetScoreAsync(resRankingItem.RankingId, date, request.TargetPlayerId).ConfigureAwait(false);
            var targetRank = targetScore == 0L ? -1 : await PlayerRankingModel.GetRankAsync(resRankingItem.RankingId, date, request.TargetPlayerId).ConfigureAwait(false);
            response.TargetPlayerRanking = new PlayerRankingMessage
            {
                Player = await WorldServer.GetPlayerMessageById(request.TargetPlayerId).ConfigureAwait(false),
                Rank = targetRank,
                Score = targetScore,
            };
        }
        else
        {
            var rankings = (await PlayerRankingModel.GetAllAsync(resRankingItem.RankingId, date).ConfigureAwait(false)).ToList();
            var myRank = rankings.FindIndex(r => r.player_id == Id);
            long score;
            if (myRank >= 0)
            {
                score = rankings[myRank].score;
                myRank += 1;
            }
            else
            {
                score = await PlayerRankingModel.GetScoreAsync(resRankingItem.RankingId, date, Id).ConfigureAwait(false);
                myRank = score == 0L ? -1 : await PlayerRankingModel.GetRankAsync(resRankingItem.RankingId, date, Id).ConfigureAwait(false);
            }
            response.MyPlayerRanking = new PlayerRankingMessage
            {
                Player = ToMessage(),
                Rank = myRank,
                Score = score,
            };

            var players =
                (await WorldServer.GetPlayerMessagesByIds(rankings.Select(r => r.player_id)).ConfigureAwait(false))
                .ToDictionary(p => p.Id);
            for (var i = 0; i < rankings.Count; ++i)
            {
                var ranking = rankings[i];
                response.PlayerRankings.Add(new PlayerRankingMessage
                {
                    Player = players.GetValueOrDefault(ranking.player_id),
                    Rank = i + 1,
                    Score = ranking.score,
                });
            }
        }

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}
