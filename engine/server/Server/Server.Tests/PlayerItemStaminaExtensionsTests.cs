using Commons.Resources;
using Commons.Utility;
using Server.Models;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class PlayerItemStaminaExtensionsTests
{
    private const int UnitItemDataId = 1000;

    [Fact]
    public void MineBinding_helpers_round_trip_item_id()
    {
        var model = new PlayerItemModel(1, UnitItemDataId);
        var mineItemId = (long)int.MaxValue * 2 + 1234;

        model.SetMineItemId(mineItemId);

        Assert.True(model.HasMineBinding());
        Assert.Equal(mineItemId, model.GetMineItemId());

        model.ClearMineItemId();

        Assert.False(model.HasMineBinding());
        Assert.Equal(0L, model.GetMineItemId());
    }

    [Fact]
    public void GetCurrentUnitStamina_projects_regen_for_unbound_units()
    {
        using var resources = new TestResourceScope(items: [CreateUnitItem()]);

        var previousOffsetTime = DateTime.UtcNow.ToOffsetTime() - 10;
        var model = new PlayerItemModel(1, UnitItemDataId)
        {
            param1 = 3,
            param2 = previousOffsetTime,
        };

        var stamina = model.GetCurrentUnitStamina(1.5f, 2f, out var offsetTime);

        Assert.Equal(15, stamina);
        Assert.True(offsetTime >= previousOffsetTime);

        model.RefreshUnitStamina(1.5f, 2f);

        Assert.Equal(15, model.param1);
        Assert.True(model.param2 >= previousOffsetTime);
    }

    [Fact]
    public void GetCurrentUnitStamina_keeps_frozen_value_for_mine_bound_units()
    {
        using var resources = new TestResourceScope(items: [CreateUnitItem()]);

        var previousOffsetTime = DateTime.UtcNow.ToOffsetTime() - 10;
        var model = new PlayerItemModel(1, UnitItemDataId)
        {
            param1 = 4,
            param2 = previousOffsetTime,
        };
        model.SetMineItemId(4321L);

        var stamina = model.GetCurrentUnitStamina(10f, 10f, out var offsetTime);

        Assert.Equal(4, stamina);
        Assert.Equal(previousOffsetTime, offsetTime);

        model.RefreshUnitStamina(10f, 10f);

        Assert.Equal(4, model.param1);
        Assert.Equal(previousOffsetTime, model.param2);
    }

    private static ResourceItem CreateUnitItem()
    {
        return new ResourceItem
        {
            Id = UnitItemDataId,
            Category = ResourceItem.Types.Category.Unit,
            MaxStamina = 10,
            StaminaRegenPerSecond = 2,
        };
    }
}
