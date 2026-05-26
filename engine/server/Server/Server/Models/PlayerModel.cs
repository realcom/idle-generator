using System.Data;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Dapper;
using Npgsql;
using Server.Managers;

namespace Server.Models;

[Table("players")]
public class PlayerModel : Model<PlayerModel>
{
    [IgnoreUpdate]
    public long world_id { get; init; }
    
    [IgnoreUpdate]
    public long account_id { get; init; }
    
    public const int MaxNameLength = 16;
    
    public string name { get; set; }
    public string language { get; set; } = "English";
    
    //TODO: delete
    [IgnoreInsert]
    [IgnoreUpdate]
    public bool is_admin { get; set; }

    [NotMapped]
    public bool Dirty { get; private set; } = false;

    private int _level;

    public int level
    {
        get => _level;
        set
        {
            if (value == _level)
                return;

            Dirty = true;
            _level = value;
        }
    }
    
    private DateTime _day_reset_at;
    public DateTime day_reset_at 
    {
        get => _day_reset_at;
        set
        {
            if (day_reset_at == value)
                return;
            
            Dirty = true;
            _day_reset_at = value;
        }
    }
    
    private long _power;
    public long power
    {
        get => _power;
        set
        {
            if (value == _power)
                return;

            Dirty = true;
            _power = value;
        }
    }

    private int _avatarCharacterItemDataId;
    public int avatar_character_item_data_id
    {
        get => _avatarCharacterItemDataId;
        set
        {
            if (value == _avatarCharacterItemDataId)
                return;

            Dirty = true;
            _avatarCharacterItemDataId = value;
        }
    }

    public PlayerMessage ToMessage()
    {
        return new PlayerMessage()
        {
            Id = id,
            Name = name,
            Level = level,
            IsAdmin = is_admin,
            Power = power,
            AvatarCharacterItemDataId = avatar_character_item_data_id,
        };
    }

    public override PlayerModel OnConstructionByDb()
    {
        Dirty = false;
        return this;
    }

    public override PlayerModel OnSave()
    {
        Dirty = false;
        return this;
    }

    public static async Task<PlayerModel?> GetByName(string name)
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<PlayerModel>("SELECT * FROM players WHERE name = @name", new { name }))
            .ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerModel>> GetAllByAccountIdAsync(long accountId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerModel>("SELECT * FROM players WHERE account_id = @accountId",
                new { accountId })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerModel>> GetAllByAccountIdsAsync(IList<long> accountIds)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerModel>("SELECT * FROM players WHERE account_id = any(@accountIds)",
                new { accountIds })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerModel>> GetAllByDayResetAtGreaterThan(DateTime dayResetAt)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerModel>("SELECT * FROM players WHERE day_reset_at > @dayResetAt",
                new { dayResetAt })).ConfigureAwait(false);
    }
    
    public async Task SetName(string name)
    {
        if (this.name == name)
            return;
        this.name = name;
        await DbManager.WithSessionAsync(db => db.ExecuteAsync("UPDATE players SET name = @name WHERE id = @id", this)).ConfigureAwait(false);
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
    
    public async Task<AccountModel> GetAccountModel()
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<AccountModel>("SELECT * FROM accounts WHERE id = @account_id", new { account_id }))
            .ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerModel>> GetAllBySnsIdsAsync(IList<string> snsKeys)
    {
        var accounts = await AccountModel.GetAllBySnsIdsAsync(snsKeys).ConfigureAwait(false);
        var accountIds = accounts.Select(e => e.id).ToList();
        return await GetAllByAccountIdsAsync(accountIds);
    }
    
    public async Task<StatusCode> UpdateNameAsync(string newName)
    {
        try
        {
            await DbManager.WithSessionAsync(db =>
                db.ExecuteAsync(
                    "UPDATE players SET name = @name WHERE id = @id",
                    new { name = newName, id })).ConfigureAwait(false);
            name = newName;
            return StatusCode.Ok;
        }
        catch (PostgresException  e)
        {
            // duplicate error
            return e.SqlState == "23505" ? StatusCode.PlayerDuplicateName : StatusCode.BadRequest;
        }
        catch (Exception)
        {
            return StatusCode.BadRequest;
        }
    }
}
