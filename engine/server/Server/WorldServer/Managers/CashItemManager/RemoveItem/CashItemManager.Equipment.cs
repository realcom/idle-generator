using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void RemoveItemPostProcessEquipment(PlayerItemModel item, int count = 1)
    {
        for (var i = 0; i < Player.Avatar.Equipments.Count; ++i)
        {
            if (Player.Avatar.Equipments[i].Id != item.id)
                continue;
            Player.Avatar.Equipments[i] = new PlayerItemMessage();
            Player.Avatar.Dirty = true;

            Logger.Warn($"{Player} Equipped item removed: {item.id} {item.item_data_id}");
            break;
        }
    }
}