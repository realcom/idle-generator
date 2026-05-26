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
    public void UseItemMineInternal(PlayerItemModel mineItem, PlayerItemModel unitItem, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var offsetTime = DateTime.UtcNow.ToOffsetTime();
        var stamina = Math.Min(unitItem.param1, mineItem.Data.StaminaCostPerSecond * (offsetTime - unitItem.param2));
        var efficiency = MineBoostEfficiency;
        efficiency *= mineItem.Data.EfficiencyPercents.GetClamped(mineItem.level - 1) / 100f;
        efficiency *= unitItem.Data.EfficiencyPercent / 100f;
        var score = (int)(efficiency * stamina);
        if (score == 0)
            return;

        var prevParam2 = unitItem.param2;
        unitItem.param1 -= stamina;
        unitItem.param2 = offsetTime;

        AddItem(mineItem.Data.AddItemGroups, score, addedItemStuffs: addedItemStuffs);

        if (unitItem.param1 == 0)
        {
            using var optionScope = mineItem.GetOptionScope();
            var option = optionScope.Option;
            var slots = option.Slots;
            for (var slot = 0; slot < slots.Count; slot++)
            {
                if (slots[slot].Id == unitItem.id)
                {
                    slots[slot] = new PlayerItemMessage();
                    break;
                }
            }
            unitItem.ClearMineItemId();
            var exhaustedAt = prevParam2 + stamina / mineItem.Data.StaminaCostPerSecond;
            unitItem.param1 = PlayerItemModelExtensions.CalculateRegenValue(unitItem.param1,
                unitItem.GetBoostedMaxStamina(MaxStaminaBoostRatio),
                unitItem.GetBoostedStaminaRegenPerSecond(StaminaRegenBoostRatio), exhaustedAt, out _);
        }
    }
    
    private StatusCode UseItemMine(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        using var optionScope = item.GetOptionScope();
        var option = optionScope.Option;
        var slotItem = option.Slots.GetSafe(slot);
        if (slotItem == null || slotItem.Id == 0)
            return StatusCode.BadRequest;

        UseItemMineInternal(item, GetItemById(slotItem.Id)!, addedItemStuffs);
        return StatusCode.Ok;
    }

    private StatusCode UseItemAllMines(IList<AddedItemStuff>? addedItemStuffs = null)
    {
        foreach (var resItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Mine))
        {
            var item = GetItemByDataId(resItem.Id);
            if (item == null)
                continue;
            
            using var optionScope = item.GetOptionScope();
            var option = optionScope.Option;
            
            for (var slot = 0; slot < option.Slots.Count; ++slot)
            {
                var slotItem = option.Slots[slot];
                if (slotItem.Id == 0)
                    continue;
                var unitItem = GetItemById(slotItem.Id);
                if (unitItem == null)
                    continue;
                UseItemMineInternal(item!, unitItem, addedItemStuffs);
            }
        }
        return StatusCode.Ok;
    }
}
