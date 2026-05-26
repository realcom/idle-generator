using Commons.Resources;
using Commons.Types.Players;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("player_achievements")]
public class PlayerAchievementModel : Model<PlayerAchievementModel>
{
    [IgnoreUpdate]
    public long player_id { get; init; }

    [IgnoreUpdate]
    public int achievement_data_id { get; init; }
    public ResourceAchievement Data => ResourceAchievement.Get(achievement_data_id)!;

    private PlayerAchievementMessage.Types.State _state;
    public PlayerAchievementMessage.Types.State state
    {
        get => _state;
        set
        {
            Dirty = true;
            _state = value;
        }
    }

    private int _progress;
    public int progress
    {
        get => _progress;
        set
        {
            Dirty = true;
            _progress = value;
        }
    }

    private bool _dirty;
    [NotMapped]
    public bool Dirty
    {
        get => _dirty;
        set
        {
            _dirty = value;
            if (value)
            {
                Updated = true;
                AchievementManager?.SetDirty();
            }
        }
    }

    public bool Updated;

    public IAchievementManager? AchievementManager;

    private PlayerAchievementModel()
    {
    }
    
    public PlayerAchievementModel(long playerId, int achievementDataId)
    {
        player_id = playerId;
        achievement_data_id = achievementDataId;
        Dirty = false;
        Updated = true;
    }
    
    public override PlayerAchievementModel OnConstructionByDb()
    {
        Dirty = false;
        return this;
    }
    
    public override PlayerAchievementModel OnSave()
    {
        Dirty = false;
        return this;
    }

    public PlayerAchievementMessage ToMessage()
    {
        return new PlayerAchievementMessage
        {
            AchievementDataId = achievement_data_id,
            State = state,
            Progress = progress,
        };
    }
    
    public static async Task<PlayerAchievementModel?> GetAsync(long playerId, int achievementDataId)
    {
        return (await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerAchievementModel>(
                "SELECT * FROM player_achievements WHERE player_id = @playerId AND achievement_data_id = @achievementDataId",
                new { playerId, achievementDataId })).ConfigureAwait(false))
            ?.OnConstructionByDb();

        
    }
    
    public static async Task<IEnumerable<PlayerAchievementModel>> GetAllByPlayerIdAsync(long playerId)
    {
        return (await DbManager.WithSessionAsync(db =>
            db.GetListAsync<PlayerAchievementModel>(new { player_id = playerId })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());

    }
}
