using Commons.Utility;
using Server.Models;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private int GetAllExhaustedOffsetTime(PlayerItemModel item)
    {
        var offsetTime = DateTime.UtcNow.ToOffsetTime();
        var allExhaustedOffsetTime = offsetTime;
        
        using var optionScope = item.GetOptionScope();
        var option = optionScope.Option;
        
        foreach (var slotItem in option.Slots)
        {
            if (slotItem.Id == 0)
                continue;
            var unitItem = GetItemById(slotItem.Id);
            if (unitItem == null)
                continue;
            var stamina = unitItem.param1;
            var exhaustedOffsetTime = unitItem.param2 + stamina / item.Data.StaminaCostPerSecond;
            if (exhaustedOffsetTime > allExhaustedOffsetTime)
                allExhaustedOffsetTime = exhaustedOffsetTime;
        }

        return allExhaustedOffsetTime;
    }
}