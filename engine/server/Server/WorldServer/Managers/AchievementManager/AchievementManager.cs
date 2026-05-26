using System.Data;
using Commons;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Players;
using log4net;
using Server.Managers;
using Server.Models;
using static Commons.Resources.ResourceAchievement.ConditionQuery;
using static Commons.Resources.ResourceAchievement.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager(WorldPlayer.WorldPlayer constructorPlayer) : IAchievementManager
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType!);

    public readonly WorldPlayer.WorldPlayer Player = constructorPlayer;
    
    private readonly Dictionary<int, PlayerAchievementModel> _achievementByDataId = new();
    
    public IEnumerable<PlayerAchievementModel> Achievements => _achievementByDataId.Values;

    private bool _updated;
    private bool _dirty;

    public async Task Init()
    {
        foreach (var achievement in await PlayerAchievementModel.GetAllByPlayerIdAsync(Player.Id).ConfigureAwait(false))
        {
            achievement.AchievementManager = this;
            _achievementByDataId[achievement.achievement_data_id] = achievement;
        }
        
        IncreaseAchievement(Condition.Login);
        await RefreshReferralAchievements().ConfigureAwait(false);
        Player.PlayerLogManager.Queue(PlayerLogModel.Type.Login, new
        {
            Ip = Player.Ip,
        });
    }

    public PlayerAchievementModel? GetAchievementByDataId(int achievementDataId, bool forceOpen = false)
    {
        var resAchievement = ResourceAchievement.Get(achievementDataId);
        if (resAchievement == null) return null;
        var achievement = _achievementByDataId.GetValueOrDefault(achievementDataId);
        if (achievement != null)
            return achievement;

        if (resAchievement.ContainsTag(Tag.Deprecated))
            return null;
        
        if (resAchievement.InitialOpen || forceOpen)
        {
            if (!forceOpen)
            {
                if (!resAchievement.IsValidNow())
                    return null;
            }
            
            achievement = new PlayerAchievementModel(Player.Id, achievementDataId);
            achievement.AchievementManager = this;
            _achievementByDataId[achievementDataId] = achievement;
            achievement.Dirty = true;
            
            IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.EnableAchievement, Comparer.Equal, achievementDataId));

            if (achievement.state == PlayerAchievementMessage.Types.State.InProgress && resAchievement.InitialProgress > 0)
                IncreaseAchievement(achievement, resAchievement.InitialProgress);
            
            return achievement;
        }

        return null;
    }
    
    public bool IsAchievementCompleted(int achievementDataId)
    {
        var achievement = GetAchievementByDataId(achievementDataId);
        return achievement != null && (achievement.state == PlayerAchievementMessage.Types.State.Completed ||
                                       achievement.state == PlayerAchievementMessage.Types.State.Rewarded);
    }
    
    public bool IsAchievementRewarded(int achievementDataId)
    {
        var achievement = GetAchievementByDataId(achievementDataId);
        return achievement != null && achievement.state == PlayerAchievementMessage.Types.State.Rewarded;
    }

    internal PlayerAchievementUpdate? GetUpdate()
    {
        if (!_updated)
            return null;
        _updated = false;

        var update = new PlayerAchievementUpdate();
        foreach (var achievement in _achievementByDataId.Values)
        {
            if (achievement.Updated)
            {
                achievement.Updated = false;
                update.Achievements.Add(achievement.ToMessage());
            }
        }
        
        return update;
    }
    
    internal async Task Save(IDbConnection db, IDbTransaction transaction)
    {
        if (!_dirty)
            return;
        _dirty = false;

        foreach (var achievement in _achievementByDataId.Values)
        {
            if (achievement.Dirty)
            {
                await achievement.SaveAsync(db, transaction).ConfigureAwait(false);
                if (Config.IsDebug)
                    Logger.Info($"Achievement saved: {achievement.id} {achievement.achievement_data_id}");
            }
        }
    }

    public void SetUpdated()
    {
        _updated = true;
    }

    public void SetDirty()
    {
        _updated = true;
        _dirty = true;
    }
}
