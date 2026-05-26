using System.Data;
using Commons.Types.Players;
using Dapper;
using Google.Protobuf.WellKnownTypes;
using Newtonsoft.Json.Linq;
using Server.Managers;

namespace Server.Models;

[Table("player_mails")]
public class PlayerMailModel : Model<PlayerMailModel>
{
    [IgnoreUpdate]
    public long player_id { get; init; }

    [IgnoreUpdate]
    public long sender_player_id { get; init; }
    
    [IgnoreUpdate]
    public DateTime? until_at { get; init; }
    [IgnoreUpdate]
    public string title { get; init; }
    [IgnoreUpdate]
    public string? message { get; init; }
    
    [IgnoreUpdate]
    public int item_data_id { get; init; }
    [IgnoreUpdate]
    public long item_count { get; init; }
    [IgnoreUpdate]
    public int item_level { get; init; }
    [IgnoreUpdate]
    public int item_days { get; init; }
    [IgnoreUpdate]
    public int item_hours { get; init; }
    [IgnoreUpdate, Editable(true)]
    public JObject? item_option { get; init; }
    [IgnoreUpdate, Editable(true)]
    public JObject? option { get; init; }
    private PlayerMailOption? _deserializedOption;
    
    [NotMapped]
    public PlayerMailOption? DeserializedOption
    {
        get
        {
            if (_deserializedOption != null)
                return _deserializedOption;
            if (option == null)
                return null;
            _deserializedOption = option.ToObject<PlayerMailOption>();
            return _deserializedOption;
        }
    }
    
    public DateTime? read_at { get; set; }
    
    public bool deleted { get; set; }
    

    public PlayerMailMessage ToMessage(PlayerMessage? sender = null)
    {
        return new PlayerMailMessage
        {
            Id = id,
            Sender = sender,
            
            UntilAt = until_at?.ToTimestamp(),
            Title = title,
            Message = message ?? "",
            
            ItemDataId = item_data_id,
            ItemCount = item_count,
            ItemLevel = item_level,
            ItemDays = item_days,
            ItemHours = item_hours,
            ItemOption = item_option?.ToObject<PlayerItemOption>(),
            
            Option = DeserializedOption,
            
            CreatedAt = created_at.ToTimestamp(),
        };
    }
    
    public static async Task<bool> HasUnreadByPlayerId(long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.ExecuteScalarAsync<bool>(
                "SELECT EXISTS(SELECT 1 FROM player_mails WHERE player_id = @playerId AND read_at IS NULL AND deleted = false)",
                new { playerId })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerMailModel>> GetAllUnreadByPlayerId(long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerMailModel>(
                "SELECT * FROM player_mails WHERE player_id = @playerId AND read_at IS NULL AND deleted = false ORDER BY created_at DESC",
                new { playerId })).ConfigureAwait(false);
    }
    
    public static async Task MarkAsReadByIds(IDbConnection db, IDbTransaction transaction, IEnumerable<long> ids, DateTime readAt)
    {
        await db.ExecuteAsync(
            "UPDATE player_mails SET read_at = @readAt WHERE id = ANY(@ids)",
            new { readAt, ids },
            transaction).ConfigureAwait(false);
    }
    
    public static async Task MarkAsDeleteByIds(IDbConnection db, IDbTransaction transaction, IEnumerable<long> ids, bool deleted)
    {
        await db.ExecuteAsync(
            "UPDATE player_mails SET deleted = @deleted WHERE id = ANY(@ids)",
            new { deleted, ids },
            transaction).ConfigureAwait(false);
    }
    
}
