using Commons.Types.Players;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("player_telegrams")]
public class PlayerTelegramModel : Model<PlayerTelegramModel>
{
    public const int MaxNameLength = 32;
    
    [IgnoreUpdate]
    public long telegram_user_id { get; set; }
    
    public string first_name { get; set; }
    public string? last_name { get; set; }
    public string? username { get; set; }

    [IgnoreUpdate]
    public bool is_bot { get; set; }
    public bool is_premium { get; set; }
    
    public bool is_admin { get; set; }
    public bool is_analyst { get; set; }
    
    [IgnoreUpdate]
    public string ton_address { get; set; }

    public PlayerTelegramMessage ToMessage()
    {
        return new PlayerTelegramMessage
        {
            TelegramUserId = telegram_user_id,
            IsPremium = is_premium,
            TonAddress = ton_address ?? "",
        };
    }
    
    public static async Task<PlayerTelegramModel?> GetByTelegramUserIdAsync(long telegramUserId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerTelegramModel>(
                "SELECT * FROM player_telegrams WHERE telegram_user_id = @telegramUserId",
                new { telegramUserId })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerTelegramModel>> GetAllByTelegramUserIdsAsync(IEnumerable<long> telegramUserIds)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerTelegramModel>(
                "SELECT * FROM player_telegrams WHERE telegram_user_id = ANY(@telegramUserIds)",
                new { telegramUserIds = telegramUserIds.ToArray() })).ConfigureAwait(false);
    }
    
    public async Task UpdateTonAddressAsync(string tonAddress)
    {
        if (ton_address == tonAddress)
            return;
        ton_address = tonAddress;
        await DbManager.WithSessionAsync(db =>
            db.ExecuteAsync(
                "UPDATE player_telegrams SET ton_address = @tonAddress WHERE id = @id",
                new { tonAddress, id })).ConfigureAwait(false);
    }
}
