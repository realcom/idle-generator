using System.Data;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("player_rankings")]
public class PlayerRankingModel : Model<PlayerRankingModel>
{
    [IgnoreUpdate]
    public long player_id { get; set; }
    [IgnoreUpdate]
    public int ranking_id { get; set; }
    [IgnoreUpdate]
    public int date { get; set; }
    
    public long score { get; set; }
    public bool valid { get; set; } = true;

    public static async Task<PlayerRankingModel?> GetAsync(int rankingId, int date, long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerRankingModel>(
                "SELECT * FROM player_rankings WHERE valid = TRUE AND ranking_id = @rankingId AND date = @date AND player_id = @playerId",
                new { rankingId, date, playerId })).ConfigureAwait(false);
    }

    public static async Task<IEnumerable<PlayerRankingModel>> GetAllAsync(int rankingId, int date, int limit = 200)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerRankingModel>(
                "SELECT * FROM player_rankings WHERE valid = TRUE AND ranking_id = @rankingId AND date = @date ORDER BY score DESC LIMIT @limit",
                new { rankingId, date, limit })).ConfigureAwait(false);
    }

    public static async Task<int> GetRankAsync(int rankingId, int date, long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<int>(
                "SELECT COUNT(*) + 1 FROM player_rankings WHERE valid = TRUE AND ranking_id = @rankingId AND date = @date AND score > (SELECT score FROM player_rankings WHERE valid = TRUE AND ranking_id = @rankingId AND date = @date AND player_id = @playerId)",
                new { rankingId, date, playerId })).ConfigureAwait(false);
    }
    
    public static async Task<long> GetScoreAsync(int rankingId, int date, long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<long>(
                "SELECT score FROM player_rankings WHERE valid = TRUE AND ranking_id = @rankingId AND date = @date AND player_id = @playerId",
                new { rankingId, date, playerId })).ConfigureAwait(false);
    }
    
    public static async Task UpdateSetScoreAsync(int rankingId, int date, long playerId, long score, bool valid = true)
    {
        await DbManager.WithSessionAsync(db =>
            db.ExecuteAsync(
                "INSERT INTO player_rankings (player_id, ranking_id, date, score, valid) VALUES (@playerId, @rankingId, @date, @score, @valid) ON CONFLICT (player_id, ranking_id, date) DO UPDATE SET score = EXCLUDED.score, valid = EXCLUDED.valid",
                new { playerId, rankingId, date, score, valid })).ConfigureAwait(false);
    }
    
    public static async Task UpdateSetScoreAsync(IDbConnection db, IDbTransaction transaction, int rankingId, int date, long playerId, long score, bool valid = true)
    {
        await db.ExecuteAsync(
            "INSERT INTO player_rankings (player_id, ranking_id, date, score, valid) VALUES (@playerId, @rankingId, @date, @score, @valid) ON CONFLICT (player_id, ranking_id, date) DO UPDATE SET score = EXCLUDED.score, valid = EXCLUDED.valid",
            new { playerId, rankingId, date, score, valid }, transaction).ConfigureAwait(false);
    }

    public static async Task UpdateAddScoreAsync(int rankingId, int date, long playerId, long score, bool valid = true)
    {
        await DbManager.WithSessionAsync(db =>
            db.ExecuteAsync(
                "INSERT INTO player_rankings (player_id, ranking_id, date, score, valid) VALUES (@playerId, @rankingId, @date, @score, @valid) ON CONFLICT (player_id, ranking_id, date) DO UPDATE SET score = player_rankings.score + EXCLUDED.score, valid = EXCLUDED.valid",
                new { playerId, rankingId, date, score, valid })).ConfigureAwait(false);
    }
    
    public static async Task UpdateAddScoreAsync(IDbConnection db, IDbTransaction transaction, int rankingId, int date, long playerId, long score, bool valid = true)
    {
        await db.ExecuteAsync(
            "INSERT INTO player_rankings (player_id, ranking_id, date, score, valid) VALUES (@playerId, @rankingId, @date, @score, @valid) ON CONFLICT (player_id, ranking_id, date) DO UPDATE SET score = player_rankings.score + EXCLUDED.score, valid = EXCLUDED.valid",
            new { playerId, rankingId, date, score, valid }, transaction).ConfigureAwait(false);
    }
}
