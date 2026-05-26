using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Server.Events;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode CanRemoveItem(PlayerItemModel? item, int count = 1)
    {
        if (item == null)
            return StatusCode.ItemNotFound;
        if (item.HasFlag(PlayerItemMessage.State.NotConsumable))
            return StatusCode.BadRequest;
        
        var itemCount = item.count;
        var resItem = item.Data;
        if (resItem.ContainsTag(Tag.AddParam1ToCount)) // 여러 조건이 들어갈 수 있음.
            itemCount += item.param1;
        if (itemCount < count)
            return StatusCode.ItemNotEnough;
        return StatusCode.Ok;
    }

    private void RemoveItemPostProcess(PlayerItemModel item, int count = 1)
    {
        switch (item.Data.Category)
        {
            case ResourceItem.Types.Category.Unit:
            {
                RemoveItemPostProcessUnit(item, count);
                break;
            }
            case ResourceItem.Types.Category.Equipment:
            {
                RemoveItemPostProcessEquipment(item, count);
                break;
            }
            case ResourceItem.Types.Category.Ticket:
            {
                RemoveItemPostProcessTicket(item, count);
                break;
            }
            case ResourceItem.Types.Category.Utility:
            {
                RemoveItemPostProcessUtility(item, count);
                break;
            }
        }
    }
    
    public StatusCode RemoveItem(PlayerItemModel? item, int count = 1, bool checkCanRemove = true)
    {
        if (count <= 0)
            return StatusCode.BadRequest;
        
        if (checkCanRemove)
        {
            var canRemove = CanRemoveItem(item, count);
            if (!canRemove.IsSuccess())
                return canRemove;
        }

        if (item == null)
            return StatusCode.ItemNotFound;
        
        var resItem = item.Data;
        if (resItem.ContainsTag(Tag.AddParam1ToCount)) // 여러 조건이 들어갈 수 있음.
        {
            if (item.count >= count)
                item.count -= count;
            else
            {
                item.param1 -= (int)(count - item.count);
                item.count = 0;
            }
        }
        else
        {
            item.count -= count;
        }

        if (item.count == 0 && item.Data.Unstackable)
            item.deleted = true;
        
        RemoveItemPostProcess(item, count);
        
        Player.PublishEvent(new ItemConsumeEvent
        {
            Item = item,
            Count = count,
        });
        
        return StatusCode.Ok;
    }
}
