using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Commons.Utility;
using Server.Tests.TestSupport;
using static Server.Tests.TestSupport.ResourceTriggerTestFactory;
using Xunit;

namespace Server.Tests;

using TriggerType = ResourceTrigger.Types.Type;
using PredefinedType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

public sealed class AddHealTests
{
    private const int MapId = 901001;
    private const int UnitId = 901101;
    private const int SkillId = 901201;
    private const int BuffId = 901301;

    [Fact]
    public void GetHeal_treats_attack_percent_as_raw_ratio_and_max_hp_percent_as_percent()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);

        var heal = new AddHeal
        {
            AttackPercentHeals = { 1f },
            MaxHpPercentHeals = { 100f },
            MaxHpPercentShieldHeals = { 100f },
        };

        Assert.Equal(120L, heal.GetHeal(healer, target, 1));
        Assert.Equal(100L, heal.GetShieldHeal(healer, target, 1));
    }

    [Fact]
    public void GetHeal_large_max_hp_percent_uses_saturated_percent_ratio()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);

        var heal = new AddHeal
        {
            MaxHpPercentHeals = { FixedFloat.MaxValueFloat },
            MaxHpPercentShieldHeals = { FixedFloat.MaxValueFloat },
        };
        var expected = LongFixedFloatMath.ScaleSaturated(target.MaxHp, FixedFloat.MaxValue / 100);

        Assert.Equal(expected, heal.GetHeal(healer, target, 1));
        Assert.Equal(expected, heal.GetShieldHeal(healer, target, 1));
    }

    [Fact]
    public void GetHeal_preserves_normal_attack_and_max_hp_based_values()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);

        var heal = new AddHeal
        {
            AttackPercentHeals = { 2f },
            MaxHpPercentHeals = { 50f },
        };

        Assert.Equal(90L, heal.GetHeal(healer, target, 1));
    }

    [Fact]
    public void GetHeal_clamps_large_sum_instead_of_wrapping()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);

        var heal = new AddHeal
        {
            Heals = { long.MaxValue - 10L },
            AttackPercentHeals = { 2f },
            MaxHpPercentHeals = { 50f },
        };

        Assert.Equal(long.MaxValue, heal.GetHeal(healer, target, 1));
    }

    [Fact]
    public void AddHeal_skill_scales_large_heal_efficiency_without_fixed_float_wrap()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(Stat(UnitStatType.HealEfficiencyPercent, 100f))],
            skills: [Skill()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(1L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal { Heals = { long.MaxValue / 2L + 1L } });

        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Heal);
        Assert.Equal(99L, result.ValidHeal);
        Assert.Equal(100L, target.Hp);
    }

    [Fact]
    public void AddHeal_skill_applies_guard_ratio_with_saturated_long_math()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(Stat(UnitStatType.GuardPercent, 100f))],
            skills: [Skill()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(99L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal
        {
            Heals = { 1L },
            GuardHeals = { long.MaxValue / 2L + 1L },
        });

        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue / 2L + 1L, result.GuardHeal);
        Assert.Equal(long.MaxValue, target.Guard);
    }

    [Fact]
    public void AddHeal_skill_clamps_shield_accumulation_instead_of_wrapping()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(99L);
        target.AddShield(long.MaxValue - 10L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal
        {
            Heals = { 1L },
            MaxHpPercentShieldHeals = { 100f },
        });

        Assert.True(result.IsValid);
        Assert.Equal(100L, result.ShieldHeal);
        Assert.Equal(long.MaxValue, target.Shield);
    }

    [Fact]
    public void Skill_heal_trigger_without_return_preserves_large_heal()
    {
        var heal = SetCallerVariableTrigger("SkillHealNoReturn", TriggerType.OnHeal, 1601, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(heal.Name)],
            triggers: [heal]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(1L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal { Heals = { long.MaxValue } });

        Assert.Equal(1, skill.Variables.GetInt(1601));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Heal);
        Assert.Equal(99L, result.ValidHeal);
        Assert.Equal(100L, target.Hp);
    }

    [Fact]
    public void Unit_heal_trigger_without_return_preserves_large_heal()
    {
        var heal = SetCallerVariableTrigger("UnitHealNoReturn", TriggerType.OnHeal, 1602, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [UnitWithTriggers([heal.Name])],
            skills: [Skill()],
            triggers: [heal]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(1L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal { Heals = { long.MaxValue } });

        Assert.Equal(1, healer.Variables.GetInt(1602));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Heal);
        Assert.Equal(99L, result.ValidHeal);
    }

    [Fact]
    public void Unit_healed_trigger_without_return_preserves_large_heal()
    {
        var healed = SetCallerVariableTrigger("UnitHealedNoReturn", TriggerType.OnHealed, 1603, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [UnitWithTriggers([healed.Name])],
            skills: [Skill()],
            triggers: [healed]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(1L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal { Heals = { long.MaxValue } });

        Assert.Equal(1, target.Variables.GetInt(1603));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Heal);
        Assert.Equal(99L, result.ValidHeal);
    }

    [Fact]
    public void Heal_trigger_return_still_overrides_heal()
    {
        var heal = new ResourceTrigger
        {
            Name = "SkillHealReturn",
            Type = TriggerType.OnHeal,
            Statements =
            {
                Assign(Predefined(PredefinedType.Return), Expression(Constant(5))),
            },
        };
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(heal.Name)],
            triggers: [heal]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(1L);
        var skill = SkillInstance();
        skill.SenderUnitId = healer.Id;
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal { Heals = { long.MaxValue } });

        Assert.True(result.IsValid);
        Assert.Equal(5L, result.Heal);
        Assert.Equal(5L, result.ValidHeal);
        Assert.Equal(6L, target.Hp);
    }

    [Fact]
    public void AddHeal_skill_without_sender_is_ignored_even_with_ignore_alive()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [SkillWithTags(Tag.IgnoreAlive)]);
        var board = Board().Init();
        var target = UnitInstance();
        board.AddUnit(target);
        target.SetHp(1L);
        var skill = SkillInstance();
        skill.Init(board);

        var result = target.AddHeal(skill, new AddHeal { Heals = { 10L } });

        Assert.True(result.IsIgnored);
        Assert.Equal(1L, target.Hp);
        Assert.Empty(board.Events.OfType<UnitHealedEvent>());
    }

    [Fact]
    public void AddHeal_buff_source_keeps_buff_event_and_fx_identity()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff()]);
        var board = Board().Init();
        var healer = UnitInstance();
        var target = UnitInstance();
        board.AddUnit(healer);
        board.AddUnit(target);
        target.SetHp(1L);
        target.QueueAddBuff(new GameUnit.QueuedAddBuff(healer, BuffId, 1));
        board.PostUpdate();
        board.ClearEvents();
        var buff = target.GetBuffByDataId(BuffId);
        Assert.NotNull(buff);

        var result = target.AddHeal(buff, new AddHeal
        {
            Heals = { 10L },
            FxOnHit = "buff-heal",
        });

        Assert.True(result.IsValid);
        Assert.Equal(10L, result.Heal);
        Assert.Equal(10L, result.ValidHeal);
        Assert.Equal(11L, target.Hp);
        var healed = Assert.Single(board.Events.OfType<UnitHealedEvent>());
        Assert.Equal(0, healed.SkillDataId);
        Assert.Equal(BuffId, healed.BuffDataId);
        var fx = Assert.Single(board.Events.OfType<PlayFxEvent>());
        Assert.Equal(0L, fx.SkillId);
        Assert.Equal(buff.Id, fx.BuffId);
        Assert.Equal("buff-heal", fx.Prefab);
    }

    private static ResourceTrigger SetCallerVariableTrigger(
        string name,
        TriggerType type,
        int callerKey,
        int value)
    {
        return new ResourceTrigger
        {
            Name = name,
            Type = type,
            Statements =
            {
                Assign(CallerKey(callerKey), Expression(Constant(value))),
            },
        };
    }

    private static ResourceMap Map()
    {
        return new ResourceMap
        {
            Id = MapId,
            Type = ResourceMap.Types.Type.Dungeon,
        };
    }

    private static ResourceUnit Unit(params AddUnitStat[] addStats)
    {
        var unit = new ResourceUnit
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
                    Value = { 20f },
                },
            },
        };
        unit.AddStats.Add(addStats);
        return unit;
    }

    private static ResourceUnit UnitWithTriggers(string[] triggers, params AddUnitStat[] addStats)
    {
        var unit = Unit(addStats);
        unit.Triggers.Add(triggers);
        return unit;
    }

    private static AddUnitStat Stat(UnitStatType type, float value)
    {
        return new AddUnitStat
        {
            Type = type,
            Value = { value },
        };
    }

    private static ResourceSkill Skill(params string[] triggers)
    {
        var skill = new ResourceSkill
        {
            Id = SkillId,
        };
        skill.Triggers.Add(triggers);
        skill.Timelines.Add(new ResourceSkill.Types.Timeline { Time = 0f });
        skill.Timelines.Add(new ResourceSkill.Types.Timeline
        {
            Time = 10f,
            Destroy = new ResourceSkill.Types.Timeline.Types.Destroy(),
        });
        return skill;
    }

    private static ResourceSkill SkillWithTags(params Tag[] tags)
    {
        var skill = Skill();
        skill.Tags.Add(tags);
        return skill;
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
        };
        buff.Tags.Add(tags);
        return buff;
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
