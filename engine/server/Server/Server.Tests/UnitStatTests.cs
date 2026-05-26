using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;
using Xunit;

namespace Server.Tests;

public sealed class UnitStatTests
{
    [Fact]
    public void Derived_combat_and_resource_stats_preserve_normal_formulas()
    {
        var stat = new UnitStat();
        stat[UnitStatType.Hp] = 100;
        stat[UnitStatType.HpPercent] = 50;
        stat[UnitStatType.GameplayHpPercent] = 20;
        stat[UnitStatType.Mp] = 80;
        stat[UnitStatType.MpPercent] = 25;
        stat[UnitStatType.Attack] = 100;
        stat[UnitStatType.AttackPercent] = 50;
        stat[UnitStatType.GameplayAttackPercent] = 20;
        stat[UnitStatType.Defense] = 100;
        stat[UnitStatType.DefensePercent] = 50;
        stat[UnitStatType.GamePlayDefensePercent] = 20;
        stat[UnitStatType.MagicResist] = 100;
        stat[UnitStatType.MagicResistPercent] = 50;

        AssertFixedNear(180, stat.MaxHp);
        Assert.Equal((FixedFloat)100, stat.MaxMp);
        AssertFixedNear(180, stat.Attack);
        AssertFixedNear(180, stat.Defense);
        Assert.Equal((FixedFloat)150, stat.MagicResist);
    }

    [Fact]
    public void Derived_stat_scaling_saturates_large_results_instead_of_wrapping()
    {
        var stat = new UnitStat();
        var largeBase = FixedFloat.MaxValue / 2;
        stat[UnitStatType.Hp] = largeBase;
        stat[UnitStatType.HpPercent] = 200;
        stat[UnitStatType.Attack] = largeBase;
        stat[UnitStatType.AttackPercent] = 200;
        stat[UnitStatType.Defense] = largeBase;
        stat[UnitStatType.DefensePercent] = 200;
        stat[UnitStatType.MagicResist] = largeBase;
        stat[UnitStatType.MagicResistPercent] = 200;

        Assert.Equal(FixedFloat.MaxValue, stat.MaxHp);
        Assert.Equal(FixedFloat.MaxValue, stat.Attack);
        Assert.Equal(FixedFloat.MaxValue, stat.Defense);
        Assert.Equal(FixedFloat.MaxValue, stat.MagicResist);
    }

    [Fact]
    public void Percent_sums_saturate_instead_of_wrapping()
    {
        var stat = new UnitStat();
        stat[UnitStatType.CriticalPercent] = FixedFloat.MaxValue;
        stat[UnitStatType.GameplayCriticalPercent] = FixedFloat.MaxValue;
        stat[UnitStatType.ShieldEfficiencyPercent] = FixedFloat.MaxValue;
        stat[UnitStatType.GamePlayShieldEfficiencyPercent] = FixedFloat.MaxValue;

        Assert.Equal(FixedFloat.MaxValue, stat.CriticalPercent);
        Assert.Equal(
            FixedFloatMath.AddSaturated(FixedFloat.One, FixedFloat.MaxValue / 100),
            stat.ShieldEfficiency);
    }

    private static void AssertFixedNear(double expected, FixedFloat actual)
    {
        Assert.InRange((double)actual, expected - 0.001, expected + 0.001);
    }
}
