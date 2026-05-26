using Commons.Types;
using Commons.Utility;
using Xunit;

namespace Server.Tests;

public sealed class FixedFloatMathTests
{
    [Fact]
    public void MultiplySaturated_matches_fixed_float_operator_for_normal_values()
    {
        Assert.Equal((FixedFloat)150, FixedFloatMath.MultiplySaturated((FixedFloat)100, (FixedFloat)1.5));
        Assert.Equal((FixedFloat)25, FixedFloatMath.MultiplySaturated((FixedFloat)100, (FixedFloat)0.25));

        var negative = (FixedFloat)(-0.1) * (FixedFloat)0.1;
        Assert.Equal(negative, FixedFloatMath.MultiplySaturated((FixedFloat)(-0.1), (FixedFloat)0.1));
    }

    [Fact]
    public void MultiplySaturated_clamps_instead_of_wrapping()
    {
        Assert.Equal(FixedFloat.MaxValue, FixedFloatMath.MultiplySaturated(FixedFloat.MaxValue, FixedFloat.Two));
        Assert.Equal(FixedFloat.MinValue, FixedFloatMath.MultiplySaturated(FixedFloat.MaxValue, -FixedFloat.Two));
    }

    [Fact]
    public void AddSaturated_clamps_instead_of_wrapping()
    {
        Assert.Equal(FixedFloat.MaxValue, FixedFloatMath.AddSaturated(FixedFloat.MaxValue, FixedFloat.One));
        Assert.Equal(FixedFloat.MinValue, FixedFloatMath.AddSaturated(FixedFloat.MinValue, -FixedFloat.One));
    }

    [Fact]
    public void RatioFromPercentSaturated_clamps_additive_ratio()
    {
        Assert.Equal((FixedFloat)1.5, FixedFloatMath.RatioFromPercentSaturated(50));
        Assert.Equal(
            FixedFloatMath.AddSaturated(FixedFloat.One, FixedFloat.MaxValue / 100),
            FixedFloatMath.RatioFromPercentSaturated(FixedFloat.MaxValue));
    }
}
