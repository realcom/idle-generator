using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void RemoveItemPostProcessUnit(PlayerItemModel item, int count = 1)
    {
        for (var i = 0; i < Player.Avatar.Units.Count; ++i)
        {
            if (Player.Avatar.Units[i].Id != item.id)
                continue;
            Player.Avatar.Units[i] = new PlayerItemMessage();
            Player.Avatar.Dirty = true;
            break;
        }
        
        for (var i = 0; i < Player.Avatar.DefenseUnits.Count; ++i)
        {
            if (Player.Avatar.DefenseUnits[i].Id != item.id)
                continue;
            Player.Avatar.DefenseUnits[i] = new PlayerItemMessage();
            Player.Avatar.Dirty = true;
            break;
        }
        
        for (var i = 0; i < Player.Avatar.OffenseUnits.Count; ++i)
        {
            if (Player.Avatar.OffenseUnits[i].Id != item.id)
                continue;
            Player.Avatar.OffenseUnits[i] = new PlayerItemMessage();
            Player.Avatar.Dirty = true;
            break;
        }

        var mineItemId = item.GetMineItemId();
        if (mineItemId > 0L)
        {
            var mineItem = GetItemById(mineItemId)!;
            using var optionScope = mineItem.GetOptionScope();
            var option = optionScope.Option;
            for (var i = 0; i < option.Slots.Count; ++i)
            {
                if (option.Slots[i].Id != item.id)
                    continue;
                option.Slots[i] = new PlayerItemMessage();
                break;
            }
        }
    }
}
