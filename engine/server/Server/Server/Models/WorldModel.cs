using System.Data;
using Commons.Game.Events;
using Dapper;
using Server.Managers;
using Commons.Types;
using Commons.Types.Players;
using log4net.Core;

namespace Server.Models;

[Table("worlds")]
public class WorldModel : Model<WorldModel>
{
    public WorldMessage.Types.Region region { get; set; }
    public int region_index { get; set; }
    public WorldMessage.Types.State state { get; set; }
    
    public int utc_offset_hours { get; set; }

    public WorldMessage ToMessage()
    {
        return new WorldMessage
        { 
            Id = id,
            Region = region,
            RegionIndex = region_index,
            State = state,
            UtcOffsetHours = utc_offset_hours,
        };
    }
    public static async Task<WorldModel> GetDefaultGlobalWorld()
    {
        return await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<WorldModel>("SELECT * FROM worlds WHERE region = @region and region_index = 1", new { WorldMessage.Types.Region.Ww }))
            .ConfigureAwait(false)!;
    }
}