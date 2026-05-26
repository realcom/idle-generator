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
    private StatusCode UseItemPet(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resItem = item.Data;
        
        switch (param2)
        {
            case UseCashItemRequest.PetParams.Param2.LockOption:
            {
                var optionItem = GetItemByDataId(resItem.TargetItemDataIds.First(), checkCount: true, checkUntilAt: true, checkDeprecated: true);
                if (optionItem == null)
                    return StatusCode.BadRequest;
                
                var optionCount = resItem.OptionCounts.GetClamped(optionItem.level - 1);
                if (slot < 0 || slot >= optionCount)
                    return StatusCode.BadRequest;

                if (item.param3.CountBits() == optionCount - 1)
                    return StatusCode.BadRequest; // Cannot lock more than one option.

                if (item.param3.IsBitSet(slot))
                    return StatusCode.BadRequest; // Option is already locked.

                using var optionScope = item.GetOptionScope();
                if (optionScope.Option.RerollOptions.GetSafe(slot) is not { Id: not 0 })
                    return StatusCode.BadRequest; // Option is not available.

                item.param3 = item.param3.MarkBit(slot); // Lock the option.
                
                break;
            }
            case UseCashItemRequest.PetParams.Param2.UnLockOption:
            {
                var optionItem = GetItemByDataId(resItem.TargetItemDataIds.First(), checkCount: true, checkUntilAt: true, checkDeprecated: true);
                if (optionItem == null)
                    return StatusCode.BadRequest;
                
                var optionCount = resItem.OptionCounts.GetClamped(optionItem.level - 1);
                if (slot < 0 || slot >= optionCount)
                    return StatusCode.BadRequest;
                
                if (!item.param3.IsBitSet(slot))
                    return StatusCode.BadRequest; // Option is not locked.
                
                using var optionScope = item.GetOptionScope();
                if (optionScope.Option.RerollOptions.GetSafe(slot) is not { Id: not 0 })
                    return StatusCode.BadRequest; // Option is not available.
                
                item.param3 = item.param3.ClearBit(slot); // Unlock the option.
                
                break;
            }
            default:
            {
                Avatar.Pets.SetSafe(slot, param1 == 0 ? item.ToMessage() : new PlayerItemMessage());
                Avatar.Dirty = true;
                break;
            }
        }
        return StatusCode.Ok;
    }
} 