using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Google.Protobuf.WellKnownTypes;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetPlayerDefenseRankResultsRequest request)
    {
        var response = new GetPlayerDefenseRankResultsRequest.Types.Response();

        var from = request.From.ToDateTime();
        if (from < DateTime.UtcNow.AddDays(-14))
            throw new InvalidOperationException("from is too old");
        var logs = (await PlayerLogModel
            .GetAllByPlayerIdTypeAsync(Id, PlayerLogModel.Type.DefenseRankResult, from, DateTime.UtcNow)
            .ConfigureAwait(false)).ToArray();
        var playerIds = logs.Select(l => l.data.Value<long>("PlayerId"))
            .Concat(logs.Select(l => l.data.Value<long>("OpponentPlayerId"))).Distinct();
        var players =
            (await WorldServer.GetPlayerMessagesByIds(playerIds).ConfigureAwait(false)).ToDictionary(p => p.Id);

        foreach (var log in logs)
        {
            response.Results.Add(new GetPlayerDefenseRankResultsRequest.Types.PlayerDefenseRankResult
            {
                Player = players.GetValueOrDefault(log.data.Value<long>("PlayerId")),
                PrevPlayerRankPoint = log.data.Value<long>("PrevRankPoint"),
                PlayerRankPoint = log.data.Value<long>("RankPoint"),
                
                OpponentPlayer = players.GetValueOrDefault(log.data.Value<long>("OpponentPlayerId")),
                PrevOpponentPlayerRankPoint = log.data.Value<long>("PrevOpponentRankPoint"),
                OpponentPlayerRankPoint = log.data.Value<long>("OpponentRankPoint"),
                
                WinningTeam = log.data.Value<int>("WinningTeam"),
                RankPointBonus = log.data.Value<int>("RankPointBonus"),
                RankPointTake = log.data.Value<int>("RankPointTake"),
                OpponentRankPointBonus = log.data.Value<int>("OpponentRankPointBonus"),
                
                CreatedAt = log.created_at.ToTimestamp(),
            });
        }

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}
