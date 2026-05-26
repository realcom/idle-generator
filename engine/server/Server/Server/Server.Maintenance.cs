using Commons;

namespace Server;

public abstract partial class Server<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    public bool OnMaintenance => MaintenanceStartAt != default && MaintenanceStartAt - DateTime.UtcNow < TimeSpan.FromMinutes(10)
                                 && (MaintenanceUntilAt == default || DateTime.UtcNow < MaintenanceUntilAt);
    public DateTime MaintenanceStartAt { get; private set; }
    public DateTime MaintenanceUntilAt { get; private set; }

    public void ReloadMaintenance()
    {
        var prevMaintenanceStartAt = MaintenanceStartAt;
        var prevMaintenanceUntilAt = MaintenanceUntilAt;
        MaintenanceStartAt = Config.GetDateTime(nameof(MaintenanceStartAt));
        MaintenanceUntilAt = Config.GetDateTime(nameof(MaintenanceUntilAt));
        
        if (prevMaintenanceStartAt != MaintenanceStartAt || prevMaintenanceUntilAt != MaintenanceUntilAt)
            Logger.Info($"Maintenance time updated: {MaintenanceStartAt} - {MaintenanceUntilAt}");
    }
}
