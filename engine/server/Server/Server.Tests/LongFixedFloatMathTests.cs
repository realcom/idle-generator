using Commons.Types;
using Commons.Utility;
using Xunit;

namespace Server.Tests;

public sealed class LongFixedFloatMathTests
{
    [Fact]
    public void ScaleSaturated_matches_fixed_float_math_for_normal_positive_values()
    {
        Assert.Equal(150L, LongFixedFloatMath.ScaleSaturated(100L, (FixedFloat)1.5));
        Assert.Equal(25L, LongFixedFloatMath.ScaleSaturated(100L, (FixedFloat)0.25));
        Assert.Equal(0L, LongFixedFloatMath.ScaleSaturated(1L, (FixedFloat)0.5));
    }

    [Fact]
    public void ScaleSaturated_preserves_sign_without_throwing()
    {
        Assert.Equal(-150L, LongFixedFloatMath.ScaleSaturated(100L, (FixedFloat)(-1.5)));
        Assert.Equal(-150L, LongFixedFloatMath.ScaleSaturated(-100L, (FixedFloat)1.5));
        Assert.Equal(150L, LongFixedFloatMath.ScaleSaturated(-100L, (FixedFloat)(-1.5)));
    }

    [Fact]
    public void ScaleSaturated_clamps_large_positive_results_instead_of_wrapping()
    {
        Assert.Equal(long.MaxValue, LongFixedFloatMath.ScaleSaturated(long.MaxValue / 2L + 1L, (FixedFloat)2));
        Assert.Equal(long.MaxValue / 2L, LongFixedFloatMath.ScaleSaturated(long.MaxValue, (FixedFloat)0.5));
    }

    [Fact]
    public void ScaleSaturated_clamps_large_negative_results_instead_of_wrapping()
    {
        Assert.Equal(long.MinValue, LongFixedFloatMath.ScaleSaturated(long.MinValue / 2L - 1L, (FixedFloat)2));
        Assert.Equal(long.MinValue, LongFixedFloatMath.ScaleSaturated(long.MinValue, FixedFloat.One));
        Assert.Equal(long.MaxValue, LongFixedFloatMath.ScaleSaturated(long.MinValue, -FixedFloat.One));
    }

    [Fact]
    public void AddSaturated_clamps_overflow_instead_of_wrapping()
    {
        Assert.Equal(30L, LongFixedFloatMath.AddSaturated(10L, 20L));
        Assert.Equal(long.MaxValue, LongFixedFloatMath.AddSaturated(long.MaxValue - 1L, 2L));
        Assert.Equal(long.MinValue, LongFixedFloatMath.AddSaturated(long.MinValue + 1L, -2L));
    }

    [Fact]
    public void SubtractSaturated_clamps_overflow_instead_of_wrapping()
    {
        Assert.Equal(5L, LongFixedFloatMath.SubtractSaturated(10L, 5L));
        Assert.Equal(long.MaxValue, LongFixedFloatMath.SubtractSaturated(long.MaxValue - 1L, -2L));
        Assert.Equal(long.MinValue, LongFixedFloatMath.SubtractSaturated(long.MinValue + 1L, 2L));
    }

    [Fact]
    public void ToFixedFloatSaturated_clamps_values_outside_fixed_float_range()
    {
        Assert.Equal((FixedFloat)100L, LongFixedFloatMath.ToFixedFloatSaturated(100L));
        Assert.Equal(FixedFloat.MaxValue, LongFixedFloatMath.ToFixedFloatSaturated(long.MaxValue));
        Assert.Equal(FixedFloat.MinValue, LongFixedFloatMath.ToFixedFloatSaturated(long.MinValue));
    }
}
