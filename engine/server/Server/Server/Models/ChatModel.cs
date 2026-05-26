using System.Collections.Generic;
using Commons.Packets.Requests;
using Commons.Types;
using Dapper;
using Google.Protobuf.WellKnownTypes;
using Server.Managers;

namespace Server.Models;

[Table("chats")]
public class ChatModel : Model<ChatModel>
{
    public enum ChatType
    {
        General = 0,
    }
    
    [IgnoreUpdate]
    public ChatType type { get; init; }
    
    // [IgnoreUpdate]
    // public long chat_id { get; init; }
    
    [IgnoreUpdate]
    public string channel_key { get; init; }
    
    
    [IgnoreUpdate]
    public long sender_player_id { get; init; }
    
    [IgnoreUpdate]
    public string language { get; set; }
    [IgnoreUpdate]
    public string title { get; set; }
    [IgnoreUpdate]
    public string message { get; set; }

    public ChatMessage ToMessage()
    {
        return new ChatMessage
        {
            Id = id,
            Type = (int)type,
            // ChatId = (int)chat_id,
            ChannelKey = channel_key,
            Language = language,
            Title = title,
            Message = message,
            
            CreatedAt = created_at.ToTimestamp(),
        };
    }
    
    public static async Task<IEnumerable<ChatModel>> GetChatsAsync(string channelKey, long lastChatId = 0, int limit = 100)
    {
        var whereClauses = new List<string>();
        whereClauses.Add("c.channel_key = @channelKey");
        
        if (lastChatId > 0)
        {
            whereClauses.Add("c.id < @lastChatId");
        }

        var whereClause = whereClauses.Count > 0 ? "WHERE " + string.Join(" AND ", whereClauses) : "";
        var query = $"SELECT c.*, p.name as PlayerName FROM chats c JOIN players p ON c.sender_player_id = p.id {whereClause} ORDER BY c.id DESC LIMIT @limit";

        return await DbManager.WithSessionAsync(db =>
                db.QueryAsync<ChatModel>(query, new { channelKey, lastChatId, limit }))
            .ConfigureAwait(false);
    }
}