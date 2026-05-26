using Commons.Types.Players;
using Commons.Utility;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void RemoveItemPostProcessTicket(PlayerItemModel item, int count = 1)
    {
        if (item.Data.RegenPeriod == 0)
            return;
        
        var now = DateTime.UtcNow;
        var refreshAt = item.EnsureTicketRefreshScheduled(now, GetTicketMaxCountBonus(item.item_data_id),
            GetTicketRegenPeriodBonus(item.item_data_id));
        if (RefreshTicketsAt > refreshAt)
            RefreshTicketsAt = refreshAt;
    }
}
