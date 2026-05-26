using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Types.Units.ItemGroupStat;
using Commons.Types.Units.SkillGroupStat;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class AddDamageTests
{
    private const int MapId = 902001;
    private const int UnitId = 902101;
    private const int SkillId = 902201;
    private const int ItemId = 902301;
    private const int ItemGroup = 902401;
    private const int SkillGroup = 902501;
    private const int BuffId = 902601;

    [Fact]
    public void GetDamageLong_treats_percent_damage_fields_as_raw_ratios()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()]);
        var board = Board().Init();
        var attacker = UnitInstance(GameBoard.Team.Player);
        var target = UnitInstance(GameBoard.Team.Enemy);
        board.AddUnit(attacker);
        board.AddUnit(target);
        target.SetHp(40L);

        var damage = new AddDamage
        {
            AttackPercentDamages = { 1f },
            HpPercentDamages = { 1f },
            MaxHpPercentDamages = { 1f },
        };

        Assert.Equal(141L, damage.GetDamageLong(attacker, target, 1, 1f));
    }

    [Fact]
    public void AddDamage_applies_partial_guard_and_shield_absorption_before_hp()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill()]);
        var board = Board().Init();
        var attacker = UnitInstance(GameBoard.Team.Player);
        var target = UnitInstance(GameBoard.Team.Enemy);
        board.AddUnit(attacker);
        board.AddUnit(target);
        target.AddGuard(20L);
        target.AddShield(10L);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { 50L } });

        Assert.True(result.IsValid);
        Assert.Equal(50L, result.Damage);
        Assert.Equal(20L, result.ValidDamage);
        Assert.Equal(0L, target.Guard);
        Assert.Equal(0L, target.Shield);
        Assert.Equal(80L, target.Hp);
    }

    [Fact]
    public void AddDamage_valid_without_damage_does_not_turn_negative_damage_into_guard_heal()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(Tag.ValidWithoutDamage)]);
        var board = Board().Init();
        var attacker = UnitInstance(GameBoard.Team.Player);
        var target = UnitInstance(GameBoard.Team.Enemy);
        board.AddUnit(attacker);
        board.AddUnit(target);
        target.AddGuard(10L);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { -5L } });

        Assert.True(result.IsValid);
        Assert.Equal(-5L, result.Damage);
        Assert.Equal(0L, result.ValidDamage);
        Assert.Equal(10L, target.Guard);
        Assert.Equal(100L, target.Hp);
    }

    [Fact]
    public void AddDamage_skill_damage_ratio_saturates_percent_sum_instead_of_wrapping()
    {
        using var resources = new TestResourceScope(
            items: [Item()],
            maps: [Map()],
            units: [Unit()],
            skills: [Skill()]);
        var board = Board().Init();
        var attacker = UnitInstance(GameBoard.Team.Player);
        var target = UnitInstance(GameBoard.Team.Enemy);
        board.AddUnit(attacker);
        board.AddUnit(target);
        attacker.ItemGroupStats[ItemGroup] = ItemGroupStats(ItemGroupStatType.DamagePercent, FixedFloat.MaxValue);
        attacker.SkillGroupStats[SkillGroup] = SkillGroupStats(SkillGroupStatType.DamagePercent, FixedFloat.MaxValue);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.ItemDataId = ItemId;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { AttackPercentDamages = { 1f } });

        Assert.True(result.IsValid);
        Assert.True(result.Damage > 1_000_000L);
        Assert.Equal(result.Damage, result.ValidDamage);
        Assert.Equal(0L, target.Hp);
    }

    [Fact]
    public void AddDamage_critical_ratio_saturates_percent_sum_instead_of_wrapping()
    {
        using var resources = new TestResourceScope(
            items: [Item()],
            maps: [Map()],
            units: [Unit()],
            skills: [Skill()]);
        var board = Board().Init();
        var attacker = UnitInstance(GameBoard.Team.Player);
        var target = UnitInstance(GameBoard.Team.Enemy);
        board.AddUnit(attacker);
        board.AddUnit(target);
        attacker.Stat[UnitStatType.CriticalPercent] = 100;
        attacker.Stat[UnitStatType.CriticalDamagePercent] = FixedFloat.MaxValue;
        attacker.ItemGroupStats[ItemGroup] = ItemGroupStats(ItemGroupStatType.CriticalDamagePercent, FixedFloat.MaxValue);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.ItemDataId = ItemId;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { 1L } });

        Assert.True(result.IsValid);
        Assert.True(result.IsCritical);
        Assert.True(result.Damage > 1_000_000L);
        Assert.Equal(result.Damage, result.ValidDamage);
        Assert.Equal(0L, target.Hp);
    }

    [Fact]
    public void AddDamage_buff_source_keeps_buff_event_and_fx_identity_without_critical()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff()]);
        var board = Board().Init();
        var attacker = UnitInstance(GameBoard.Team.Player);
        var target = UnitInstance(GameBoard.Team.Enemy);
        board.AddUnit(attacker);
        board.AddUnit(target);
        target.QueueAddBuff(new GameUnit.QueuedAddBuff(attacker, BuffId, 1));
        board.PostUpdate();
        board.ClearEvents();
        var buff = target.GetBuffByDataId(BuffId);
        Assert.NotNull(buff);

        var result = target.AddDamage(buff, new AddDamage
        {
            Damages = { 10L },
            FxOnHit = "buff-hit",
        });

        Assert.True(result.IsValid);
        Assert.False(result.IsCritical);
        Assert.Equal(10L, result.Damage);
        Assert.Equal(90L, target.Hp);
        var attacked = Assert.Single(board.Events.OfType<UnitAttackedEvent>());
        Assert.Equal(0, attacked.SkillDataId);
        Assert.Equal(BuffId, attacked.BuffDataId);
        Assert.False(attacked.IsCritical);
        var fx = Assert.Single(board.Events.OfType<PlayFxEvent>());
        Assert.Equal(0L, fx.SkillId);
        Assert.Equal(buff.Id, fx.BuffId);
        Assert.Equal("buff-hit", fx.Prefab);
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
                new AddUnitStat
                {
                    Type = UnitStatType.Hp,
                    Value = { 100f },
                },
                new AddUnitStat
                {
                    Type = UnitStatType.Attack,
                    Value = { 1f },
                },
            },
        };
    }

    private static ResourceSkill Skill(params Tag[] tags)
    {
        var skill = new ResourceSkill
        {
            Id = SkillId,
            Group = SkillGroup,
        };
        skill.Tags.Add(tags);
        skill.Timelines.Add(new ResourceSkill.Types.Timeline { Time = 0f });
        skill.Timelines.Add(new ResourceSkill.Types.Timeline
        {
            Time = 10f,
            Destroy = new ResourceSkill.Types.Timeline.Types.Destroy(),
        });
        return skill;
    }

    private static ResourceItem Item()
    {
        return new ResourceItem
        {
            Id = ItemId,
            Group = ItemGroup,
            ConstantDamageRatio = 1f,
        };
    }

    private static ResourceBuff Buff(params Tag[] tags)
    {
        var buff = new ResourceBuff
        {
            Id = BuffId,
            Type = ResourceBuff.Types.Type.UnitBuff,
            Duration = 10f,
            Stack = 1,
            MaxStack = 1,
            DamageType = DamageType.NormalDamage,
        };
        buff.Tags.Add(tags);
        return buff;
    }

    private static ItemGroupStat ItemGroupStats(ItemGroupStatType type, FixedFloat value)
    {
        var stat = new ItemGroupStat();
        stat[type] = value;
        return stat;
    }

    private static SkillGroupStat SkillGroupStats(SkillGroupStatType type, FixedFloat value)
    {
        var stat = new SkillGroupStat();
        stat[type] = value;
        return stat;
    }

    private static GameBoard Board()
    {
        return new GameBoard { DataId = MapId };
    }

    private static GameUnit UnitInstance(int team)
    {
        return new GameUnit
        {
            DataId = UnitId,
            Position = new Vector2Message(),
            Direction = new Vector2Message { X = 1 },
            Velocity = new Vector2Message(),
            Team = team,
        };
    }

    private static GameSkill SkillInstance()
    {
        return new GameSkill
        {
            DataId = SkillId,
            Position = new Vector2Message(),
            Direction = new Vector2Message { X = 1 },
            Velocity = new Vector2Message(),
            Acceleration = new Vector2Message(),
            Level = 1,
        };
    }
}
