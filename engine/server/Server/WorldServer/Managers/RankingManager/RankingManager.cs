using System.Data;
using Commons;
using Commons.Resources;
using log4net;
using Server.Models;

namespace WorldServer.Managers.RankingManager;

public partial class RankingManager(WorldPlayer.WorldPlayer constructorPlayer)
{
    private class QueuedRankingScore(ResourceItem resRankingItem, int date, long score)
    {
        public readonly ResourceItem ResRankingItem = resRankingItem;
        public readonly int Date = date;
        public readonly long Score = score;
    }
    
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType!);

    public readonly WorldPlayer.WorldPlayer Player = constructorPlayer;
    
    private readonly Queue<QueuedRankingScore> _queuedRankingScores = new();
    
    public void QueueRankingScore(ResourceItem resRankingItem, int date, long score)
    {
        _queuedRankingScores.Enqueue(new QueuedRankingScore(resRankingItem, date, score));
    }
    
    internal async Task Save(IDbConnection db, IDbTransaction transaction)
    {
        if (_queuedRankingScores.Count == 0)
            return;
        if (Config.IsDebug)
            Logger.Info($"{Player} RankingManager saving");

        while (_queuedRankingScores.TryDequeue(out var entity))
        {
            if (entity.ResRankingItem.RankingAccumulateScore)
                await PlayerRankingModel.UpdateAddScoreAsync(db, transaction,
                    entity.ResRankingItem.RankingId, entity.Date, Player.Id, entity.Score).ConfigureAwait(false);
            else
                await PlayerRankingModel.UpdateSetScoreAsync(db, transaction,
                    entity.ResRankingItem.RankingId, entity.Date, Player.Id, entity.Score).ConfigureAwait(false);
            
            if (Config.IsDebug)
                Logger.Info($"{Player} Ranking Update {entity.ResRankingItem.RankingId} {entity.Date} {entity.Score}");
        }
    }
}
