using Commons;
using Commons.Resources;

namespace Server;

public abstract partial class Server<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    public DateTime ReloadAt { get; private set; }
    public DateTime LastReloadedAt { get; private set; } = DateTime.UtcNow;
    private DateTime _lastDeferredReloadAt;

    public void ReloadReload()
    {
        var prevReloadAt = ReloadAt;
        ReloadAt = Config.GetDateTime(nameof(ReloadAt));

        if (ReloadAt != prevReloadAt)
            Logger.Info($"Reload time updated: {ReloadAt}");
    }

    public void TryReloadServer()
    {
        if (DateTime.UtcNow < ReloadAt || LastReloadedAt >= ReloadAt)
            return;

        if (PlayerCount > 0)
        {
            if (_lastDeferredReloadAt < ReloadAt)
            {
                Logger.Warn($"Deferred resource reload scheduled at {ReloadAt:o} because {PlayerCount} player(s) are connected.");
                _lastDeferredReloadAt = ReloadAt;
            }
            return;
        }

        ReloadServer();
    }

    public void ReloadServer()
    {
        Logger.Info("Reloading server...");
        ResourceManager.ReloadJson(Config.Path.Resources);
        LastReloadedAt = ReloadAt;
    }
}
