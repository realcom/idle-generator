using Commons.Game;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Types.Units.ArmorTypeStat;
using Commons.Types.Units.DamageTypeStat;
using Commons.Utility;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class StatRecalculationTests
{
    private const int MapId = 903001;
    private const int UnitId = 903101;
    private const int BuffId = 903201;

    [Fact]
    public void Max_resource_increase_preserves_missing_hp_and_mp()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(
                Stat(UnitStatType.Hp, 50f),
                Stat(UnitStatType.Mp, 20f))]);
        var board = Board().Init();
        var unit = UnitInstance();
        board.AddUnit(unit);
        unit.SetHp(60L);
        unit.SetMp(50L);

        ApplyBuff(board, unit);

        Assert.Equal(150L, unit.MaxHp);
        Assert.Equal(110L, unit.Hp);
        Assert.Equal(100L, unit.MaxMp);
        Assert.Equal(70L, unit.Mp);
    }

    [Fact]
    public void Max_resource_decrease_clamps_current_hp_and_mp()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(
                Stat(UnitStatType.Hp, 50f),
                Stat(UnitStatType.Mp, 20f))]);
        var board = Board().Init();
        var unit = UnitInstance();
        board.AddUnit(unit);

        var buff = ApplyBuff(board, unit);
        unit.SetHp(140L);
        unit.SetMp(95L);
        unit.QueueDestroyBuff(buff);
        board.PostUpdate();
        board.Update();

        Assert.Equal(100L, unit.MaxHp);
        Assert.Equal(100L, unit.Hp);
        Assert.Equal(80L, unit.MaxMp);
        Assert.Equal(80L, unit.Mp);
    }

    [Fact]
    public void Combat_stat_cache_updates_after_stat_buff()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(
                Stat(UnitStatType.Attack, 20f),
                Stat(UnitStatType.Defense, 7f),
                Stat(UnitStatType.MagicResist, 11f))]);
        var board = Board().Init();
        var unit = UnitInstance();
        board.AddUnit(unit);

        ApplyBuff(board, unit);

        Assert.Equal((FixedFloat)30, unit.Attack);
        Assert.Equal((FixedFloat)12, unit.Defense);
        Assert.Equal((FixedFloat)14, unit.MagicResist);
    }

    [Fact]
    public void Shield_percent_uses_recalculated_max_hp_and_shield_efficiency()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(
                Stat(UnitStatType.Hp, 100f),
                Stat(UnitStatType.ShieldPercent, 50f),
                Stat(UnitStatType.ShieldEfficiencyPercent, 100f))]);
        var board = Board().Init();
        var unit = UnitInstance();
        board.AddUnit(unit);

        ApplyBuff(board, unit);

        Assert.Equal(200L, unit.MaxHp);
        Assert.Equal(200L, unit.Shield);
    }

    [Fact]
    public void Damage_type_taken_ratio_cache_clears_when_buff_stat_is_removed()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(damageTypeStats:
            [
                new AddDamageTypeStat
                {
                    DamageType = DamageType.NormalDamage,
                    Type = DamageTypeStatType.GotDamagePercent,
                    Value = { 50f },
                },
            ])]);
        var board = Board().Init();
        var unit = UnitInstance();
        board.AddUnit(unit);

        var buff = ApplyBuff(board, unit);

        Assert.Equal((FixedFloat)1.5, unit.DamageTypeGotDamageRatio[DamageType.NormalDamage]);

        unit.QueueDestroyBuff(buff);
        board.PostUpdate();
        board.Update();

        Assert.False(unit.DamageTypeGotDamageRatio.ContainsKey(DamageType.NormalDamage));
    }

    [Fact]
    public void Armor_and_damage_type_ratio_caches_use_saturated_percent_ratios()
    {
        var resUnit = Unit();
        resUnit.AddArmorTypeStats.Add(new AddArmorTypeStat
        {
            ArmorType = ArmorType.NormalArmor,
            Type = ArmorTypeStatType.DamagePercent,
            Value = { FixedFloat.MaxValueFloat },
        });
        resUnit.AddDamageTypeStats.Add(new AddDamageTypeStat
        {
            DamageType = DamageType.NormalDamage,
            Type = DamageTypeStatType.DamagePercent,
            Value = { FixedFloat.MaxValueFloat },
        });
        resUnit.AddDamageTypeStats.Add(new AddDamageTypeStat
        {
            DamageType = DamageType.Pierce,
            Type = DamageTypeStatType.GotDamagePercent,
            Value = { FixedFloat.MaxValueFloat },
        });
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [resUnit]);
        var board = Board().Init();
        var unit = UnitInstance();

        board.AddUnit(unit);

        Assert.Equal(FixedFloatMath.RatioFromPercentSaturated(FixedFloat.MaxValue), unit.ArmorTypeDamageRatio[ArmorType.NormalArmor]);
        Assert.Equal(FixedFloatMath.RatioFromPercentSaturated(FixedFloat.MaxValue), unit.DamageTypeDamageRatio[DamageType.NormalDamage]);
        Assert.Equal(FixedFloatMath.RatioFromPercentSaturated(FixedFloat.MaxValue), unit.DamageTypeGotDamageRatio[DamageType.Pierce]);
    }

    private static GameBuff ApplyBuff(GameBoard board, GameUnit unit)
    {
        unit.QueueAddBuff(new GameUnit.QueuedAddBuff(null, BuffId, 1));
        board.PostUpdate();
        var buff = unit.GetBuffByDataId(BuffId);
        Assert.NotNull(buff);
        board.Update();
        return buff;
    }

    private static ResourceMap Map()
    {
        return new ResourceMap
        {
            Id = MapId,
            Type = ResourceMap.Types.Type.Dungeon,
        };
    }

    private static ResourceUnit Unit()
    {
        return new ResourceUnit
        {
            Id = UnitId,
            Type = ResourceUnit.Types.Type.Normal,
            AddStats =
            {
                Stat(UnitStatType.Hp, 100f),
                Stat(UnitStatType.Mp, 80f),
                Stat(UnitStatType.Attack, 10f),
                Stat(UnitStatType.Defense, 5f),
                Stat(UnitStatType.MagicResist, 3f),
            },
        };
    }

    private static ResourceBuff Buff(
        params AddUnitStat[] addStats)
    {
        return Buff(addStats, []);
    }

    private static ResourceBuff Buff(
        AddUnitStat[]? addStats = null,
        AddDamageTypeStat[]? damageTypeStats = null)
    {
        var buff = new ResourceBuff
        {
            Id = BuffId,
            Type = ResourceBuff.Types.Type.UnitBuff,
            Duration = 10f,
            Stack = 1,
            MaxStack = 1,
        };
        buff.AddStats.Add(addStats ?? []);
        buff.AddDamageTypeStats.Add(damageTypeStats ?? []);
        return buff;
    }

    private static AddUnitStat Stat(UnitStatType type, float value)
    {
        return new AddUnitStat
        {
            Type = type,
            Value = { value },
        };
    }

    private static GameBoard Board()
    {
        return new GameBoard { DataId = MapId };
    }

    private static GameUnit UnitInstance()
    {
        return new GameUnit
        {
            DataId = UnitId,
            Position = new Vector2Message(),
            Direction = new Vector2Message { X = 1 },
            Velocity = new Vector2Message(),
            Team = GameBoard.Team.Player,
        };
    }
}
