using Dapper;
using Newtonsoft.Json.Linq;
using Server.Managers;

namespace Server.Models;

[Table("player_logs")]
public class PlayerLogModel : Model<PlayerLogModel>
{
    public enum Type
    {
        Unknown = 0,
        
        // 1000-1999: Debug
        SendCommand = 1000,
        
        // 2000-2999: Player
        Login = 2000,
        LevelUp = 2001,
        AddPlayerReferral = 2002,
        DayReset = 2003,
        Chat = 2004,
        ReadMail = 2005,
        ChangeName = 2006,
        
        // 3000-3999: Item
        UseCashItem = 3000,
        LevelUpItem = 3001,
        CreateItem = 3002,
        BuyItem = 3003,
        DisposeItem = 3004,
        CreateReceipt = 3005,
        LevelDownItem = 3006,
        RerollItemOption = 3007,
        DecomposeItem = 3008,
        ClaimDailyReward = 3009,
        TimeExpiredItem = 3010,
        
        // 4000-4999: Board
        CreateBoard = 4000,
        JoinBoard = 4001,
        LeaveBoard = 4002,
        DefenseRankResult = 4003,
        BoardNoReplayValidationMismatch = 4004,
        
        // 5000-5999: Achievement
        ClaimAchievementReward = 5000,
        IncreaseAchievementProgress = 5001,
    }
    
    [IgnoreUpdate]
    public long player_id { get; set; }

    public Type type { get; set; }
    [Editable(true)]
    public JObject data { get; set; } = new();

    public static async Task<IEnumerable<PlayerLogModel>> GetLimitByPlayerIdTypeAsync(long playerId, Type type, int offset = 0, int limit = 100)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerLogModel>(
                "SELECT * FROM player_logs WHERE player_id = @playerId AND type = @type ORDER BY created_at DESC OFFSET @offset LIMIT @limit",
                new { playerId, type, offset, limit })).ConfigureAwait(false);
    }

    public static async Task<IEnumerable<PlayerLogModel>> GetAllByPlayerIdTypeAsync(long playerId, Type type, DateTime from, DateTime to)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerLogModel>(
                "SELECT * FROM player_logs WHERE player_id = @playerId AND type = @type AND created_at >= @from AND created_at <= @to ORDER BY created_at DESC",
                new { playerId, type, from, to })).ConfigureAwait(false);
    }
}
