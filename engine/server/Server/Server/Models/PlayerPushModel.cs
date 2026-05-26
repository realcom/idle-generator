using System.Data;
using Commons.Resources;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("player_pushes")]
public class PlayerPushModel : Model<PlayerPushModel>
{
    public enum PushType
    {
        General = 0,
        Volatile = 1,
        Scheduled = 2,
    }
    
    [IgnoreUpdate]
    public PushType type { get; init; }
    
    [IgnoreUpdate]
    public long player_id { get; init; }

    public DateTime? publish_at { get; set; }
    public bool published { get; set; }
    public bool failed { get; set; }
    public bool deleted { get; set; }
    public int retry_count { get; init; }
    [IgnoreUpdate]
    public string language { get; set; }
    [IgnoreUpdate]
    public string title { get; set; }
    [IgnoreUpdate]
    public string message { get; set; }
    [IgnoreUpdate]
    public string image_url { get; set; }
    
    [IgnoreUpdate]
    public string key { get; set; }
    
    public static async Task<IEnumerable<PlayerPushModel>> GetAllUnpublishedAsync(int limit = 50)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerPushModel>("SELECT * FROM player_pushes WHERE (publish_at IS NULL OR publish_at < NOW()) AND published = false AND deleted = false AND failed = false ORDER BY publish_at NULLS FIRST LIMIT @limit", new { limit }))
            .ConfigureAwait(false);
    }
    
    public static async Task SetPublishedByIdsAsync(IList<long> ids)
    {
        await DbManager.WithSessionAsync(db =>
            db.ExecuteAsync("UPDATE player_pushes SET published = true WHERE id = ANY(@ids)", new { ids }))
            .ConfigureAwait(false);
    }
    
    public static async Task<PlayerPushModel?> DeleteByPlayerIdAndKeyAndPublished(long playerId, string key, bool published)
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<PlayerPushModel>("UPDATE player_pushes SET deleted = true WHERE player_id = @playerId and key = @key and published = @published", new { playerId, key, published }))
            .ConfigureAwait(false);
    }
    
    public static async Task IncrementRetryByIdsAsync(IList<long> ids)
    {
        await DbManager.WithSessionAsync(db =>
                db.ExecuteAsync("UPDATE player_pushes SET retry_count = retry_count + 1 WHERE id = ANY(@ids)", new { ids }))
            .ConfigureAwait(false);
    }
    
    public static async Task SetFailedByIdsAsync(IList<long> ids, bool incrementRetry = true)
    {
        var sql = "UPDATE player_pushes SET failed = true WHERE id = ANY(@ids)";
        if (incrementRetry)
            sql = "UPDATE player_pushes SET failed = true, retry_count = retry_count + 1 WHERE id = ANY(@ids)";
        await DbManager.WithSessionAsync(db =>
                db.ExecuteAsync(sql, new { ids }))
            .ConfigureAwait(false);
    }
    
    public static async Task DeleteUnpublishedByPlayerIdAndTypeAsync(long playerId, PushType type)
    {
        await DbManager.WithSessionAsync(db =>
            db.ExecuteAsync("UPDATE player_pushes SET deleted = true WHERE player_id = @playerId AND type = @type AND published = false AND deleted = false", new { playerId, type }))
            .ConfigureAwait(false);
    }
}
