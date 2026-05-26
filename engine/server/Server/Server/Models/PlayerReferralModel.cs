using System.Data;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("player_referrals")]
public class PlayerReferralModel : Model<PlayerReferralModel>
{
    [IgnoreUpdate]
    public long referred_player_id { get; set; }
    [IgnoreUpdate]
    public long referrer_player_id { get; set; }
    
    public bool applied { get; set; }
    
    public static async Task<PlayerReferralModel?> GetByReferrerPlayerIdAsync(long referrerPlayerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerReferralModel>(
                "SELECT * FROM player_referrals WHERE referrer_player_id = @referrerPlayerId",
                new { referrerPlayerId })).ConfigureAwait(false);
    }
    
    public static async Task<PlayerReferralModel?> GetByReferrerPlayerIdAndReferredPlayerIdAsync(long referrerPlayerId, long referredPlayerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerReferralModel>(
                "SELECT * FROM player_referrals WHERE referrer_player_id = @referrerPlayerId AND referred_player_id = @referredPlayerId",
                new { referrerPlayerId, referredPlayerId })).ConfigureAwait(false);
    }
    
    public static async Task<int> GetCountByReferredPlayerIdAsync(long referredPlayerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<int>(
                "SELECT COUNT(*) FROM player_referrals WHERE referred_player_id = @referredPlayerId",
                new { referredPlayerId })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerReferralModel>> GetAllByReferredPlayerIdAsync(long referredPlayerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerReferralModel>(
                "SELECT * FROM player_referrals WHERE referred_player_id = @referredPlayerId",
                new { referredPlayerId })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerReferralModel>> GetAllUnappliedByReferredPlayerIdAsync(long referredPlayerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerReferralModel>(
                "SELECT * FROM player_referrals WHERE referred_player_id = @referredPlayerId AND applied = FALSE",
                new { referredPlayerId })).ConfigureAwait(false);
    }
    
    public static async Task ApplyByIdsAsync(IDbConnection db, IDbTransaction transaction, IEnumerable<long> ids)
    {
        await db.ExecuteAsync(
            "UPDATE player_referrals SET applied = TRUE WHERE id = ANY(@ids)",
            new { ids }, transaction).ConfigureAwait(false);
    }
}
