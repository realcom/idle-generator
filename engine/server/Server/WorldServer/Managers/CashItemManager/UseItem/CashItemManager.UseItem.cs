using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Events;
using Server.Models;
using Server.Stuffs;
using static Commons.Resources.ResourceItem.Types;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode UseItem(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (item.item_data_id == ResourceItem.Global.DataId.AllMines)
            return UseItemAllMines(addedItemStuffs);

        StatusCode status;
        var resItem = item.Data;
        switch (resItem.Category)
        {
            case Category.System:
                status = UseItemSystem(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Character:
                status = UseItemCharacter(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Weapon:
                status = UseItemWeapon(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Equipment:
                status = UseItemEquipment(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Unit:
                status = UseItemUnit(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Mine:
                status = UseItemMine(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Utility:
                status = UseItemUtility(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Skill:
                status = UseItemSkill(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.Pet:
                status = UseItemPet(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            case Category.SelectableBox:
                status = UseItemSelectableBox(item, count, targetItemId, slot, param1, param2, addedItemStuffs);
                break;
            default:
                return StatusCode.BadRequest;
        }
        
        if (status.IsSuccess())
            Player.PublishEvent(new ItemUseEvent
            {
                Item = item,
                Count = count,
                TargetItemId = targetItemId,
                Slot = slot,
                Param1 = param1,
                Param2 = param2,
            });
        
        return status;
    }
}
