using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Utility;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class CashItemManagerBoostTests
{
    [Fact]
    public void AddItem_applies_game_speed_multiplier_from_active_item_popup_arg()
    {
        const int speedPassItemId = 1001;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = speedPassItemId,
                    Category = ResourceItem.Types.Category.Product,
                    Type = ResourceItem.Types.Type.MaterialRealPrice,
                    Unstackable = true,
                    PopupArgs =
                    {
                        [ResourceItem.GameSpeedMultiplierPopupArg] = "2",
                    },
                },
            ]);

        var harness = new WorldPlayerTestHarness();

        harness.Manager.AddItem(speedPassItemId, duration: TimeSpan.FromDays(7));

        Assert.Equal(2f, harness.Manager.GameSpeedMultiplier, 3);
        Assert.Equal(2f, harness.Player.GameSpeedMultiplier, 3);
    }

    [Fact]
    public void DayReset_applies_regen_boosts_from_shared_boost_state()
    {
        const int regenItemId = 1001;
        const int maxCountBoostItemId = 1002;
        const int regenCountBoostItemId = 1003;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = regenItemId,
                    Category = ResourceItem.Types.Category.Ticket,
                    Tags = { Tag.RegenDaily },
                    MaxCount = 3,
                    RegenCount = 1,
                },
                new ResourceItem
                {
                    Id = maxCountBoostItemId,
                    Category = ResourceItem.Types.Category.Premium,
                    Tags = { Tag.BoostMaxCount },
                    BoostMaxCountItemDataId = regenItemId,
                    BoostMaxCount = 2,
                },
                new ResourceItem
                {
                    Id = regenCountBoostItemId,
                    Category = ResourceItem.Types.Category.Premium,
                    Tags = { Tag.BoostRegenCount },
                    BoostRegenCountItemDataId = regenItemId,
                    BoostRegenCount = 2,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(regenItemId, 2);
        harness.Manager.AddItem(maxCountBoostItemId, 1);
        harness.Manager.AddItem(regenCountBoostItemId, 1);

        var regenItem = Assert.Single(harness.Manager.GetItemsByDataId(regenItemId));

        harness.Manager.DayReset(DateTime.UtcNow.AddDays(-1), DateTime.UtcNow);

        Assert.Equal(5, regenItem.count);
    }

    [Fact]
    public void UseItem_scout_applies_grouped_boosts_from_shared_boost_state()
    {
        const int scoutItemId = 1001;
        const int rewardItemId = 1002;
        const int rewardBoostItemId = 1003;
        const int maxMinutesBoostItemId = 1004;
        const int mapDataId = 2001;
        const int mapGroup = 77;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = scoutItemId,
                    Category = ResourceItem.Types.Category.Utility,
                    Type = ResourceItem.Types.Type.Scout,
                    Tags = { Tag.ScoutNormal },
                },
                new ResourceItem
                {
                    Id = rewardItemId,
                    Category = ResourceItem.Types.Category.Material,
                },
                new ResourceItem
                {
                    Id = rewardBoostItemId,
                    Category = ResourceItem.Types.Category.Premium,
                    Tags = { Tag.BoostScoutReward },
                    MapGroup = mapGroup,
                    BoostScoutRewardPercent = 100,
                },
                new ResourceItem
                {
                    Id = maxMinutesBoostItemId,
                    Category = ResourceItem.Types.Category.Premium,
                    Tags = { Tag.BoostScoutMaxMinutes },
                    MapGroup = mapGroup,
                    BoostScoutMaxMinutes = 2,
                },
            ],
            maps:
            [
                new ResourceMap
                {
                    Id = mapDataId,
                    Group = mapGroup,
                    Type = ResourceMap.Types.Type.Lobby,
                    ScoutAddItemGroups =
                    {
                        new AddItemGroup
                        {
                            ShouldAddAll = true,
                            Minutes = 2,
                            MaxMinutes = 4,
                            AddItems =
                            {
                                new AddItem
                                {
                                    ItemDataId = rewardItemId,
                                    Count = 1,
                                },
                            },
                        },
                    },
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(scoutItemId, 1);
        harness.Manager.AddItem(rewardBoostItemId, 1);
        harness.Manager.AddItem(maxMinutesBoostItemId, 1);

        var scoutItem = Assert.Single(harness.Manager.GetItemsByDataId(scoutItemId));
        var previousOffsetTime = DateTime.UtcNow.ToOffsetTime() - 6 * 60;
        scoutItem.param1 = mapDataId;
        scoutItem.param2 = previousOffsetTime;
        scoutItem.param4 = 12345;

        Assert.Equal(StatusCode.Ok, harness.Manager.UseItem(scoutItem));

        var rewardItem = Assert.Single(harness.Manager.GetItemsByDataId(rewardItemId));
        Assert.Equal(6, rewardItem.count);
        Assert.Equal(1, scoutItem.count);
        Assert.True(scoutItem.param2 >= previousOffsetTime);
    }
}
