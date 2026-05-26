using Commons.Packets;
using Commons.Resources;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    private int _prevMaintenanceRemainingSeconds;
    
    private bool UpdateMaintenance()
    {
        if (Model.is_admin)
            return false;
        if (!Server.OnMaintenance)
        {
            _prevMaintenanceRemainingSeconds = 0;
            return false;
        }
        
        var remainingSeconds = (int)((Server.MaintenanceStartAt - DateTime.UtcNow).TotalSeconds + 1);
        if (remainingSeconds <= 0)
            return true;
        if (_prevMaintenanceRemainingSeconds == remainingSeconds)
            return false;
        _prevMaintenanceRemainingSeconds = remainingSeconds;
        if (remainingSeconds >= 60 && remainingSeconds % 60 != 0)
            return false;
        if (remainingSeconds >= 10 && remainingSeconds % 10 != 0)
            return false;
        SendDisplayMessageUpdate(message: GetString("MaintenanceStartIn", remainingSeconds));
        return false;
    }
}
