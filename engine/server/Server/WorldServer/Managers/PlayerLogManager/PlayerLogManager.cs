using System.Data;
using Commons;
using log4net;
using Newtonsoft.Json.Linq;
using Server.Managers;
using Server.Models;

namespace WorldServer.Managers.PlayerLogManager;

public partial class PlayerLogManager(WorldPlayer.WorldPlayer constructorPlayer) : IPlayerLogManager
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType!);

    public readonly WorldPlayer.WorldPlayer Player = constructorPlayer;
    
    private readonly Queue<PlayerLogModel> _queuedLogModels = new();
    
    public void Queue(PlayerLogModel.Type type)
    {
        _queuedLogModels.Enqueue(new PlayerLogModel
        {
            player_id = Player.Id,
            type = type,
        });
    }
    
    public void Queue(PlayerLogModel.Type type, object data)
    {
        _queuedLogModels.Enqueue(new PlayerLogModel
        {
            player_id = Player.Id,
            type = type,
            data = JObject.FromObject(data),
        });
    }
    
    public void Queue(PlayerLogModel.Type type, JObject data)
    {
        _queuedLogModels.Enqueue(new PlayerLogModel
        {
            player_id = Player.Id,
            type = type,
            data = data,
        });
    }
    
    internal async Task Save(IDbConnection db, IDbTransaction transaction)
    {
        if (_queuedLogModels.Count == 0)
            return;
        if (Config.IsDebug)
            Logger.Info($"{Player} LogManager saving");

        while (_queuedLogModels.TryDequeue(out var logModel))
            await logModel.SaveAsync(db, transaction).ConfigureAwait(false);
    }
}
