using System.Data;
using Commons.Packets.Requests;
using Commons.Resources;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("accounts")]
public class AccountModel : Model<AccountModel>
{
    public static int MaxNameLength = 16;
    public class State
    {
        public const int Deleted = -2;
        public const int Banned = -1;
        public const int Init = 0;
        public const int Normal = 1;
        public const int Ai = 2;
        public const int ChatBanned = 10;
    }
    
    public enum SnsType
    {
        Unknown,
        Admin,
        Guest,
        Telegram,
        Google,
        Apple,
    }
    
    [IgnoreUpdate]
    public string sns_id { get; set; }
    
    private SnsType _snsType;
    [NotMapped]
    public SnsType sns_type
    {
        get 
        {
            if (_snsType == SnsType.Unknown)
                Enum.TryParse(sns_id.Split("_", 2)[0], true, out _snsType);
            return _snsType;
        }
    }
    private string? _snsKey;
    [NotMapped]
    public string sns_key
    {
        get
        {
            if (_snsKey == null)
                _snsKey = sns_id.Split("_", 2).Last();
            return _snsKey;
        }
    }
    
    public string play_game_id { get; set; }
    public string game_center_id { get; set; }
    
    public string device_id { get; set; } 
    public string device_os { get; set; }
    public string device_model { get; set; }
    public string push_token { get; set; }
    public int state { get; set; } = State.Normal;
    public string name { get; set; }
    public string language { get; set; } = "English";
    public string country { get; set; }
    public long main_player_id { get; set; }
    
    
    [IgnoreInsert]
    [IgnoreUpdate]
    public bool is_admin { get; set; }
    
    public static async Task<AccountModel?> GetBySnsIdAsync(string snsId)
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<AccountModel>("SELECT * FROM accounts WHERE sns_id = @snsId", new { snsId }))
            .ConfigureAwait(false);
    }
    
    public static async Task<AccountModel?> GetByMainPlayerIdAsync(long mainPlayerId)
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<AccountModel>("SELECT * FROM accounts WHERE main_player_id = @mainPlayerId", new { mainPlayerId }))
            .ConfigureAwait(false);
    }
    
    public string GetString(StatusCode status)
    {
        Enum.TryParse(this.language, out ResourceString.Types.Language language);
        return ResourceString.Get(status, language);
    }
    
    public string GetString(StatusCode status, params object[] args)
    {
        Enum.TryParse(this.language, out ResourceString.Types.Language language);
        return ResourceString.Get(status, language, args);
    }
    
    public string GetString(string key)
    {
        Enum.TryParse(this.language, out ResourceString.Types.Language language);
        return ResourceString.Get(key, language);
    }
    
    public string GetString(string key, params object[] args)
    {
        Enum.TryParse(this.language, out ResourceString.Types.Language language);
        return ResourceString.Get(key, language, args);
    }

    public string GetString(ResourceString.Types.Category category, int id, string key)
    {
        Enum.TryParse(this.language, out ResourceString.Types.Language language);
        return ResourceString.Get(category, id, key, language);
    }
    
    public async Task<PlayerModel?> GetMainPlayer()
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<PlayerModel>("SELECT * FROM players WHERE id = @main_player_id", new { main_player_id }))
            .ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<AccountModel>> GetAllByMainPlayerIdsAsync(IList<long> ids)
    {
        return (await DbManager.WithSessionAsync(db =>
            db.GetListAsync<AccountModel>(
                "WHERE main_player_id = ANY(@ids)",
                new { ids })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public static async Task<IEnumerable<AccountModel>> GetAllBySnsIdsAsync(IList<string> ids)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.GetListAsync<AccountModel>(
                    "WHERE sns_id = ANY(@ids)",
                    new { ids })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public async Task UpdateSnsIdAsync()
    {
        await DbManager.WithSessionAsync(db =>
            db.ExecuteAsync("UPDATE accounts SET sns_id = @sns_id WHERE id = @id",
            new { sns_id,  id })).ConfigureAwait(false);
    }
}