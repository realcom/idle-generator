using Commons.Resources;
using Commons.Utility;

namespace WorldServer.Managers.CashItemManager;




public partial class CashItemManager
{
    private DateTime RefreshTicketsAt { get; set; } = DateTime.MaxValue;

    private int GetTicketMaxCountBonus(int itemDataId)
    {
        long totalBonus = 0;
        foreach (var item in GetItemsByType(ResourceItem.Types.Type.AddMaxCount, checkCount: true, checkUntilAt: true))
        {
            if (item.Data.BonusItemDataId != itemDataId)
                continue;

            totalBonus += item.Data.BonusCount * item.count;
        }

        return checked((int)totalBonus);
    }

    private int GetTicketRegenPeriodBonus(int itemDataId)
    {
        long totalBonus = 0;
        foreach (var item in GetItemsByType(ResourceItem.Types.Type.AddRegenPeriod, checkCount: true, checkUntilAt: true))
        {
            if (item.Data.BonusItemDataId != itemDataId)
                continue;

            totalBonus += item.Data.RegenPeriod * item.count;
        }

        return checked((int)totalBonus);
    }

    private DateTime GetNextTicketBonusExpirationAt()
    {
        DateTime? refreshAt = null;

        foreach (var item in GetItemsByType(ResourceItem.Types.Type.AddMaxCount, checkCount: true, checkUntilAt: true)
                     .Concat(GetItemsByType(ResourceItem.Types.Type.AddRegenPeriod, checkCount: true, checkUntilAt: true)))
        {
            if (item.until_at == null)
                continue;

            if (refreshAt == null || item.until_at < refreshAt)
                refreshAt = item.until_at;
        }

        return refreshAt ?? DateTime.MaxValue;
    }

    private void RefreshTickets()
    {
        var now = DateTime.UtcNow;
        var refreshAt = DateTime.MaxValue;
        foreach (var resItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Ticket))
        {
            if (resItem.RegenPeriod == 0)
                continue;
            
            var item = GetItemByDataId(resItem.Id, checkUntilAt: true);
            if (item == null)
                continue;

            var newRefreshAt = item.RefreshTicketCount(now, GetTicketMaxCountBonus(item.item_data_id),
                GetTicketRegenPeriodBonus(item.item_data_id));
            if (refreshAt > newRefreshAt)
                refreshAt = newRefreshAt;
        }

        var ticketBonusExpirationAt = GetNextTicketBonusExpirationAt();
        if (refreshAt > ticketBonusExpirationAt)
            refreshAt = ticketBonusExpirationAt;

        RefreshTicketsAt = refreshAt;
    }
    
}
