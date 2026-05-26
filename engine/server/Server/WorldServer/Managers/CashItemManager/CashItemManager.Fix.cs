using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void FixMines()
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
                {
                    option.Slots[slot] = new PlayerItemMessage();
                    continue;
                }
                var unitMineItemId = unitItem.GetMineItemId();
                if (unitMineItemId != item!.id)
                {
                    option.Slots[slot] = new PlayerItemMessage();
                }
            }
        }

        foreach (var resItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Unit))
        {
            foreach (var item in GetItemsByDataId(resItem.Id))
            {
                if (!item.HasMineBinding())
                    continue;
                var mineItemId = item.GetMineItemId();
                var mineItem = GetItemById(mineItemId);
                if (mineItem == null)
                {
                    item.ClearMineItemId();
                    continue;
                }
                
                using var optionScope = mineItem.GetOptionScope();
                var option = optionScope.Option;
                if (option.Slots.All(s => s.Id != item.id))
                    item.ClearMineItemId();
            }
        }
    }
}
