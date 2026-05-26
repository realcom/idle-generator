using Commons.Resources;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void RemoveItemPostProcessUtility(PlayerItemModel item, int count = 1)
    {
        switch (item.Data.Type)
        {
            case ResourceItem.Types.Type.AddMaxCount:
            case ResourceItem.Types.Type.AddRegenPeriod:
                RefreshTickets();
                break;
        }
    }
}
