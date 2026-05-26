using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Server.Models;

namespace Server.Utility;

public static class MaterialItemExtensions
{
    public static bool IsValid(this MaterialItem materialItem, PlayerItemModel? item, int? requiredCount = null)
    {
        if (item == null)
            return false;
        if (item.HasFlag(PlayerItemMessage.State.NotConsumable))
            return false;
        
        var itemCount = item.count;
        if (item.Data.ContainsTag(Tag.AddParam1ToCount))
            itemCount += item.param1;

        requiredCount ??= materialItem.Count;
        if (itemCount < requiredCount)
            return false;
        if (item.level < materialItem.MinLevel)
            return false;
        if (materialItem.MaxLevel > 0 && item.level > materialItem.MaxLevel)
            return false;
        return true;
    }
}