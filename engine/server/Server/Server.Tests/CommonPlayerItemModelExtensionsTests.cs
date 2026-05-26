using CommonPlayerItemModelExtensions = Commons.Utility.PlayerItemModelExtensions;
using Xunit;

namespace Server.Tests;

public sealed class CommonPlayerItemModelExtensionsTests
{
    [Fact]
    public void CalculateRegenValue_returns_previous_value_when_refresh_has_not_elapsed()
    {
        var result = CommonPlayerItemModelExtensions.CalculateRegenValue(
            prevValue: 7,
            maxValue: 20,
            regenPerSecond: 3,
            refreshOffsetTime: int.MaxValue,
            out var offsetTime);

        Assert.Equal(7, result);
        Assert.True(offsetTime <= int.MaxValue);
    }

    [Fact]
    public void CalculateRegenValue_applies_regen_and_clamps_to_max()
    {
        var refreshOffsetTime = 0;
        var result = CommonPlayerItemModelExtensions.CalculateRegenValue(
            prevValue: 4,
            maxValue: 9,
            regenPerSecond: 2,
            refreshOffsetTime: refreshOffsetTime,
            out var offsetTime);

        var expected = Math.Min(9, 4 + (offsetTime - refreshOffsetTime) * 2);
        Assert.Equal(expected, result);
        Assert.Equal(9, result);
    }

    [Fact]
    public void CalculateRegenValueFromPeriod_keeps_existing_regen_when_already_full()
    {
        var result = CommonPlayerItemModelExtensions.CalculateRegenValueFromPeriod(
            count: 9,
            prevRegenCount: 1,
            maxValue: 10,
            regenPeriod: 5,
            refreshOffsetTime: 0,
            out _);

        Assert.Equal(1, result);
    }

    [Fact]
    public void CalculateRegenValueFromPeriod_adds_full_periods_and_advances_offset_time()
    {
        var refreshOffsetTime = 0;
        var result = CommonPlayerItemModelExtensions.CalculateRegenValueFromPeriod(
            count: 1,
            prevRegenCount: 2,
            maxValue: 10,
            regenPeriod: 5,
            refreshOffsetTime: refreshOffsetTime,
            out var offsetTime);

        var regenCount = (offsetTime - refreshOffsetTime) / 5;
        Assert.Equal(2 + regenCount, result);
        Assert.Equal(refreshOffsetTime + regenCount * 5, offsetTime);
    }
}
