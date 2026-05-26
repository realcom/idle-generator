using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void RefreshItemStat()
    {
        Player.ItemStat.Clear();
        PlayerItemModelExtensions.ApplyItemStats(id => GetItemByDataId(id), Player.ItemStat);
    }
}
