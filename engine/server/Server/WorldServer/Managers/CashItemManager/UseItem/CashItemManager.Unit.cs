using System.Collections;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private StatusCode UseItemUnit(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (targetItemId > 0L)
        {
            var targetItem = GetItemById(targetItemId);
            if (targetItem == null)
                return StatusCode.ItemNotFound;
            if (targetItem.Data.Category != ResourceItem.Types.Category.Mine)
                return StatusCode.BadRequest;
            var slotCount = targetItem.Data.UnitSlotCounts.GetClamped(targetItem.level - 1);
            if (slot < 0 || slot >= slotCount)
                return StatusCode.BadRequest;
                    
            using var optionScope = targetItem.GetOptionScope();
            var option = optionScope.Option;
            if (option.Slots.Count != slotCount)
                option.Slots.ResizeAndFillNew(slotCount);

            if (param1 == 1)
            {
                if (targetItemId != item.GetMineItemId())
                    return StatusCode.BadRequest;
                UseItemMineInternal(targetItem, item);
                option.Slots[slot] = new PlayerItemMessage();
                item.ClearMineItemId();
            }
            else
            {
                if (option.Slots[slot].Id != 0)
                    return StatusCode.BadRequest;
                if (item.HasMineBinding())
                    return StatusCode.BadRequest;

                item.RefreshUnitStamina(MaxStaminaBoostRatio, StaminaRegenBoostRatio);
                option.Slots[slot] = item.ToMessage();
                item.SetMineItemId(targetItemId);
            }
        }
        else
        {
            IList<PlayerItemMessage> units;
            switch (param2)
            {
                case 0:
                    units = Avatar.Units;
                    break;
                case 1:
                    units = Avatar.DefenseUnits;
                    break;
                case 2:
                    units = Avatar.OffenseUnits;
                    break;
                default:
                    return StatusCode.BadRequest;
            }
            if (param1 == 0)
            {
                for (var i = 0; i < units.Count; i++)
                {
                    if (units[i].Id == item.id)
                    {
                        units[i] = new PlayerItemMessage();
                        break;
                    }
                }
            }
            units.SetSafe(slot, param1 == 0 ? item.ToMessage() : new PlayerItemMessage());
            Avatar.Dirty = true;
        }
        return StatusCode.Ok;
    }
}
