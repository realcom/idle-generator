using System.Data;
using Commons.Types.Players;
using Dapper;
using Newtonsoft.Json.Linq;
using Server.Managers;

namespace Server.Models;

[Table("player_avatars")]
public class PlayerAvatarModel : Model<PlayerAvatarModel>
{
    [IgnoreUpdate]
    public long player_id { get; init; }

    [Editable(true)]
    public JObject data { get; set; } = new();
    
    public PlayerAvatar GetAvatar()
    {
        return data.ToObject<PlayerAvatar>()!;
    }
    
    public static async Task<PlayerAvatarModel> GetByPlayerIdAsync(long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
                   db.QueryFirstOrDefaultAsync<PlayerAvatarModel>(
                       "SELECT * FROM player_avatars WHERE player_id = @player_id",
                       new { player_id = playerId })).ConfigureAwait(false) ??
               new PlayerAvatarModel { player_id = playerId };
    }

    public static async Task SaveAsyncWithTransaction(IDbConnection db, IDbTransaction transaction, long playerId, PlayerAvatar avatar)
    {
        await db.ExecuteAsync(
            "INSERT INTO player_avatars (player_id, data) VALUES (@player_id, @data) ON CONFLICT (player_id) DO UPDATE SET data = @data",
            new { player_id = playerId, data = JObject.FromObject(avatar) }, transaction).ConfigureAwait(false);
    }
}
