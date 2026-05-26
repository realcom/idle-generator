using Commons;
using Commons.Resources;

namespace Server;

public abstract partial class Server<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    public int MinimumClientVersion { get; private set; } = 0;

    public void ReloadDynamicConfig()
    {
        var prevMinimumClientVersion = MinimumClientVersion;
        MinimumClientVersion = Config.GetInt(nameof(MinimumClientVersion));

        if (MinimumClientVersion != prevMinimumClientVersion)
            Logger.Info($"Minimum client version updated: {MinimumClientVersion}");
    }
}