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
    private StatusCode UseItemUtilityGetScoutRewards(PlayerItemModel item, long count = 1, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var statusCode = StatusCode.Ok;
        var resMap = ResourceMap.Get(item.param1);
        var resItem = item.Data;
        if (resMap == null) 
            return StatusCode.BadRequest;
        
        var rng = new Rng((uint) item.param4);
        var itemGroups = resMap.ScoutAddItemGroups;
        var minutes = 0;
        if (resItem.ContainsTag(Tag.ScoutNormal))
        {
            var offsetTime = DateTime.UtcNow.ToOffsetTime(); 
            minutes = (offsetTime - item.param2) / 60;
        }
        else if (resItem.ContainsTag(Tag.ScoutQuick))
        {
            minutes = 1;
        }
        else
            return StatusCode.BadRequest;
        var boostState = BuildBoostState();
        var rewardBoostMultiplier = boostState.GetScoutRewardMultiplier(resMap.Group);
        var maxMinutesBoostCount = boostState.GetScoutMaxMinutesBonus(resMap.Group);
        
        foreach (var scoutAddItemGroup in itemGroups)
        {
            var calculatedCount = Math.Min(scoutAddItemGroup.MaxMinutes + maxMinutesBoostCount, minutes * count) / scoutAddItemGroup.Minutes;
            if (calculatedCount <= 0)
                continue;
            
            statusCode = AddItem(scoutAddItemGroup, (long) (calculatedCount * rewardBoostMultiplier), addedItemStuffs: addedItemStuffs, rng: rng);
        }

        if (statusCode == StatusCode.Ok)
        {
            item.param2 = DateTime.UtcNow.ToOffsetTime();;
            item.param4 = StaticRandom.CryptoNext(int.MaxValue);
        }

        return statusCode;
    }

    public void SpendScoutTime(PlayerItemModel item, int minutes)
    {
        if (!IsValidScoutItem(item))
            return;

        item.param2 -= minutes * 60; // Convert minutes to seconds
    }

    public void RerollScoutRewards(PlayerItemModel item, int seed = -1)
    {
        if (!IsValidScoutItem(item))
            return;

        item.param4 = seed != -1 ? seed : StaticRandom.CryptoNext(int.MaxValue);
    }
    
    private bool IsValidScoutItem(PlayerItemModel? item)
    {
        if (item == null)
            return false;

        if (ResourceMap.Get(item.param1) == null)
            return false;

        return true;
    }
    
}
