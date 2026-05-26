using Commons.Packets.Requests;
using Commons.Types;
using Dapper;
using Google.Protobuf.WellKnownTypes;
using Server.Managers;

namespace Server.Models;

[Table("notices")]
public class NoticeModel : Model<NoticeModel>
{
    public enum NoticeType
    {
        General = 0,
    }
    
    [IgnoreUpdate]
    public long order { get; init; }
    
    [IgnoreUpdate]
    public NoticeType type { get; init; }
    
    public DateTime? start_at { get; set; }
    public DateTime? until_at { get; set; }
    
    [IgnoreUpdate]
    public string language { get; set; }
    [IgnoreUpdate]
    public string title { get; set; }
    [IgnoreUpdate]
    public string message { get; set; }
    [IgnoreUpdate]
    public string image_url { get; set; }
    [IgnoreUpdate]
    public string image_path { get; set; }
    
    public NoticeMessage ToMessage()
    {
        return new NoticeMessage
        {
            Id = id,
            Order = order,
            Type = (int)type,
            
            StartAt = start_at?.ToTimestamp(),
            UntilAt = until_at?.ToTimestamp(),
            
            Language = language,
            Title = title,
            Message = message,
            ImageUrl = image_url,
            ImagePath = image_path,
            
            CreatedAt = created_at.ToTimestamp(),
        };
    }
    
    public static async Task<IEnumerable<NoticeModel>> GetAll(int limit = 100)
    {
        var test = new GetNoticesRequest.Types.Response();
        return await DbManager.WithSessionAsync(db =>
                db.QueryAsync<NoticeModel>("SELECT * FROM notices WHERE (start_at IS NULL OR start_at < NOW()) AND (until_at IS NULL OR until_at > NOW()) ORDER BY \"order\" LIMIT @limit", new { limit }))
            .ConfigureAwait(false);
    }
}
