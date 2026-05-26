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
    private StatusCode UseItemUtilityAddStamina(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (targetItemId == 0L)
            return StatusCode.BadRequest;
        var targetItem = GetItemById(targetItemId)!;
        if (targetItem.Data.Category != ResourceItem.Types.Category.Unit)
            return StatusCode.BadRequest;

        var maxStamina = targetItem.GetBoostedMaxStamina(MaxStaminaBoostRatio);
        targetItem.param1 = Math.Max(targetItem.param1, Math.Min(maxStamina, targetItem.param1 + item.Data.Stamina));
        
        return StatusCode.Ok;
    }
}
