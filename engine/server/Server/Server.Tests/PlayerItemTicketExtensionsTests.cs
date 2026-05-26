using Commons.Resources;
using Commons.Utility;
using Server.Models;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class PlayerItemTicketExtensionsTests
{
    private const int TicketItemDataId = 1000;

    [Fact]
    public void TicketState_helpers_round_trip_and_compute_effective_values()
    {
        using var resources = new TestResourceScope(items: [CreateTicketItem()]);

        var model = new PlayerItemModel(1, TicketItemDataId, count: 2)
        {
            param1 = 1,
            param2 = 12,
            param3 = 4,
            param4 = 30,
        };

        var state = model.GetTicketState();

        Assert.Equal(3, state.TotalCount);
        Assert.Equal(3, state.GetEffectiveMaxCount(model.Data));
        Assert.Equal(60, state.GetEffectiveRegenPeriod(model.Data));

        model.SetTicketState(state with
        {
            Count = 3,
            RegenReserveCount = 2,
            RefreshOffsetTime = 33,
        });

        Assert.Equal(3, model.count);
        Assert.Equal(2, model.param1);
        Assert.Equal(33, model.param2);
        Assert.Equal(0, model.param3);
        Assert.Equal(0, model.param4);
        Assert.Equal(5, model.GetTicketTotalCount());
        Assert.Equal(3, model.GetTicketEffectiveMaxCount());
        Assert.Equal(60, model.GetTicketEffectiveRegenPeriod());
    }

    [Fact]
    public void RefreshTicketCount_accepts_scanned_bonus_values()
    {
        using var resources = new TestResourceScope(items: [CreateTicketItem()]);

        var previousOffsetTime = DateTime.UtcNow.ToOffsetTime() - 180;
        var model = new PlayerItemModel(1, TicketItemDataId, count: 1)
        {
            param2 = previousOffsetTime,
        };

        var nextRefreshAt = model.RefreshTicketCount(DateTime.UtcNow, maxCountBonus: 2, regenPeriodBonus: 30);

        Assert.Equal(3, model.GetTicketTotalCount());
        Assert.Equal(2, model.param1);
        Assert.True(model.param2 >= previousOffsetTime + 180);
        Assert.Equal(0, model.param3);
        Assert.Equal(0, model.param4);
        Assert.True(nextRefreshAt > DateTime.UtcNow);
    }

    [Fact]
    public void AddItem_ticket_bonus_utilities_are_scanned_and_not_persisted_on_ticket()
    {
        const int maxCountBoostItemId = 1001;
        const int regenPeriodBoostItemId = 1002;

        using var resources = new TestResourceScope(
            items:
            [
                CreateTicketItem(),
                new ResourceItem
                {
                    Id = maxCountBoostItemId,
                    Category = ResourceItem.Types.Category.Utility,
                    Type = ResourceItem.Types.Type.AddMaxCount,
                    BonusItemDataId = TicketItemDataId,
                    BonusCount = 2,
                },
                new ResourceItem
                {
                    Id = regenPeriodBoostItemId,
                    Category = ResourceItem.Types.Category.Utility,
                    Type = ResourceItem.Types.Type.AddRegenPeriod,
                    BonusItemDataId = TicketItemDataId,
                    RegenPeriod = 30,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(TicketItemDataId, 1);

        var ticket = Assert.Single(harness.Manager.GetItemsByDataId(TicketItemDataId));
        ticket.count = 3;
        Assert.Equal(0, ticket.param2);

        Assert.Equal(Commons.Packets.Requests.StatusCode.Ok, harness.Manager.AddItem(maxCountBoostItemId, 2));
        Assert.Equal(Commons.Packets.Requests.StatusCode.Ok, harness.Manager.AddItem(regenPeriodBoostItemId, 3));

        Assert.True(ticket.param2 > 0);
        Assert.Equal(0, ticket.param3);
        Assert.Equal(0, ticket.param4);

        var maxCountBoost = Assert.Single(harness.Manager.GetItemsByDataId(maxCountBoostItemId));
        var regenPeriodBoost = Assert.Single(harness.Manager.GetItemsByDataId(regenPeriodBoostItemId));

        Assert.Equal(Commons.Packets.Requests.StatusCode.Ok, harness.Manager.RemoveItem(maxCountBoost, 2));
        Assert.Equal(Commons.Packets.Requests.StatusCode.Ok, harness.Manager.RemoveItem(regenPeriodBoost, 3));

        Assert.Equal(0, ticket.param2);
    }

    private static ResourceItem CreateTicketItem()
    {
        return new ResourceItem
        {
            Id = TicketItemDataId,
            Category = ResourceItem.Types.Category.Ticket,
            MaxCount = 3,
            RegenPeriod = 60,
            Tags = { Tag.AddParam1ToCount },
        };
    }
}
