using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private StatusCode UseItemSelectableBox(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var status = CanRemoveItem(item, count);
        if (!status.IsSuccess())
            return status;
        
        var resItem = item.Data;
        switch (resItem.Type)
        {
            case ResourceItem.Types.Type.SeasonalSelectableBox:
            {
                AddItemGroup? aig = null;
                
                foreach (var resSeasonalSelectableBox in ResourceItem.GetAllByType(ResourceItem.Types.Type.SeasonalSelectableBox))
                {
                    if (resSeasonalSelectableBox.Category == ResourceItem.Types.Category.SelectableBox)
                        continue;

                    if (!resSeasonalSelectableBox.IsValid)
                        continue;

                    aig = resSeasonalSelectableBox.AddItemGroups.GetSafe(slot);
                    break;
                }

                if (aig == null)
                {
                    status = StatusCode.BadRequest;
                    break;
                }
                
                status = AddItem(aig, count, addedItemStuffs: addedItemStuffs);
                break;
            }
            default:
            {
                var aig = resItem.AddItemGroups.GetSafe(slot);
                if (aig == null)
                {
                    status = StatusCode.BadRequest;
                    break;
                }

                status = AddItem(aig, count, addedItemStuffs: addedItemStuffs);
                break;
            }
        }
        
        if (status.IsSuccess())
            RemoveItem(item, count, false);

        return status;
    }
} 