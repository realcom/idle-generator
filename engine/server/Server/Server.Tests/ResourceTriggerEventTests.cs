using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Server.Tests.TestSupport;
using static Server.Tests.TestSupport.ResourceTriggerTestFactory;
using Xunit;

namespace Server.Tests;

using BoardMethodType = ResourceTrigger.Types.Call.Types.BoardMethod.Types.Type;
using ParameterType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using TriggerType = ResourceTrigger.Types.Type;
using TriggerCall = ResourceTrigger.Types.Call;
using PredefinedType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

public sealed class ResourceTriggerEventTests
{
    private const int MapId = 900001;
    private const int UnitId = 900101;
    private const int SkillId = 900201;
    private const int BuffId = 900301;

    [Fact]
    public void Map_update_fires_on_first_board_update_and_start_fires_on_second_board_update()
    {
        var start = SetBoardVariableTrigger("MapStart", TriggerType.OnStart, 1001, 1);
        var update = SetBoardVariableTrigger("MapUpdate", TriggerType.OnUpdate, 1002, 2, period: 1);

        using var resources = new TestResourceScope(
            maps: [Map(start.Name, update.Name)],
            triggers: [start, update]);
        var board = Board();

        board.Update();

        Assert.Equal(0, board.Variables.GetInt(1001));
        Assert.Equal(2, board.Variables.GetInt(1002));

        board.Update();

        Assert.Equal(1, board.Variables.GetInt(1001));
    }

    [Fact]
    public void Unit_start_and_update_fire_during_first_unit_logic_tick()
    {
        var start = SetCallerVariableTrigger("UnitStart", TriggerType.OnStart, 1101, 1);
        var update = SetCallerVariableTrigger("UnitUpdate", TriggerType.OnUpdate, 1102, 2, period: 1);

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(start.Name, update.Name)],
            triggers: [start, update]);
        var board = Board().Init();
        var unit = UnitInstance();

        board.AddUnit(unit);
        board.Update();

        Assert.Equal(1, unit.Variables.GetInt(1101));
        Assert.Equal(2, unit.Variables.GetInt(1102));
    }

    [Fact]
    public void Unit_start_exposes_unit_as_caller_without_default_slot_unit()
    {
        var start = new ResourceTrigger
        {
            Name = "UnitStartSlots",
            Type = TriggerType.OnStart,
            Statements =
            {
                Assign(BoardKey(1111), Expression(Variable(UnitKey(1110, caller: true)))),
                Assign(BoardKey(1112), Expression(Variable(UnitKey(1110)))),
            },
        };

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(start.Name)],
            triggers: [start]);
        var board = Board().Init();
        var unit = UnitInstance();
        unit.Variables.SetInt(1110, 7);

        board.AddUnit(unit);
        board.Update();

        Assert.Equal(7, board.Variables.GetInt(1111));
        Assert.Equal(0, board.Variables.GetInt(1112));
    }

    [Fact]
    public void Skill_start_and_update_fire_during_first_skill_logic_tick()
    {
        var start = SetCallerVariableTrigger("SkillStart", TriggerType.OnStart, 1201, 1);
        var update = SetCallerVariableTrigger("SkillUpdate", TriggerType.OnUpdate, 1202, 2, period: 1);

        using var resources = new TestResourceScope(
            maps: [Map()],
            skills: [Skill(start.Name, update.Name)],
            triggers: [start, update]);
        var board = Board().Init();
        var skill = SkillInstance();

        board.QueueAddSkill(skill);
        board.PostUpdate();
        board.Update();

        Assert.Equal(1, skill.Variables.GetInt(1201));
        Assert.Equal(2, skill.Variables.GetInt(1202));
    }

    [Fact]
    public void Skill_start_exposes_sender_as_caller_unit_and_skill_as_caller_skill()
    {
        var start = new ResourceTrigger
        {
            Name = "SkillStartSlots",
            Type = TriggerType.OnStart,
            Statements =
            {
                Assign(BoardKey(1211), Expression(Variable(UnitKey(1210, caller: true)))),
                Assign(BoardKey(1212), Expression(Variable(SkillKey(1210, caller: true)))),
                Assign(BoardKey(1213), Expression(Variable(SkillKey(1210)))),
            },
        };

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(start.Name)],
            triggers: [start]);
        var board = Board().Init();
        var sender = UnitInstance();
        sender.Variables.SetInt(1210, 11);
        board.AddUnit(sender);
        var skill = SkillInstance();
        skill.SenderUnitId = sender.Id;
        skill.Variables.SetInt(1210, 22);

        board.QueueAddSkill(skill);
        board.PostUpdate();
        board.Update();

        Assert.Equal(11, board.Variables.GetInt(1211));
        Assert.Equal(22, board.Variables.GetInt(1212));
        Assert.Equal(0, board.Variables.GetInt(1213));
    }

    [Fact]
    public void Skill_timeline_continues_after_missing_sender_dependent_action()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            skills:
            [
                SkillWithTimelines(
                    new ResourceSkill.Types.Timeline
                    {
                        Time = 0f,
                        UnitUseSkill = new ResourceSkill.Types.Timeline.Types.UnitUseSkill
                        {
                            UseSkill = new UseSkill { SkillDataId = SkillId },
                        },
                    },
                    new ResourceSkill.Types.Timeline
                    {
                        Time = 0f,
                        PlayFx = new ResourceSkill.Types.Timeline.Types.PlayFx
                        {
                            Prefab = "senderless-fx",
                        },
                    })
            ]);
        var board = Board().Init();
        var skill = SkillInstance();

        board.QueueAddSkill(skill);
        board.PostUpdate();
        board.Update();

        var fx = Assert.Single(board.Events.OfType<PlayFxEvent>(), e => e.Prefab == "senderless-fx");
        Assert.Equal(skill.Id, fx.SkillId);
    }

    [Fact]
    public void Board_add_unit_without_location_id_uses_position_parameters()
    {
        var addUnit = BoardAddUnitTrigger(
            "BoardAddUnitByPosition",
            CallAssign(Parameter(ParameterType.UnitDataId), Expression(Constant(UnitId))),
            CallAssign(Parameter(ParameterType.Count), Expression(Constant(1))),
            CallAssign(Parameter(ParameterType.PositionX), Expression(Constant(3))),
            CallAssign(Parameter(ParameterType.PositionY), Expression(Constant(4))));

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            triggers: [addUnit]);
        var board = Board().Init();

        using var state = ResourceTrigger.Types.State.Rent(board.Variables);
        addUnit.Run(board, state);
        board.PostUpdate();

        var unit = Assert.Single(board.Units.Values);
        Assert.Equal(UnitId, unit.DataId);
        Assert.Equal(3f, unit.Position.X);
        Assert.Equal(4f, unit.Position.Y);
    }

    [Fact]
    public void Board_add_unit_with_missing_location_id_is_noop()
    {
        var addUnit = BoardAddUnitTrigger(
            "BoardAddUnitMissingLocation",
            CallAssign(Parameter(ParameterType.LocationId), Expression(Constant(999))),
            CallAssign(Parameter(ParameterType.UnitDataId), Expression(Constant(UnitId))),
            CallAssign(Parameter(ParameterType.Count), Expression(Constant(1))));

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            triggers: [addUnit]);
        var board = Board().Init();

        using var state = ResourceTrigger.Types.State.Rent(board.Variables);
        addUnit.Run(board, state);
        board.PostUpdate();

        Assert.Empty(board.Units);
    }

    [Fact]
    public void Buff_start_and_update_fire_during_first_buff_logic_tick()
    {
        var start = SetCallerVariableTrigger("BuffStart", TriggerType.OnStart, 1301, 1);
        var update = SetCallerVariableTrigger("BuffUpdate", TriggerType.OnUpdate, 1302, 2, period: 1);

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(start.Name, update.Name)],
            triggers: [start, update]);
        var board = Board().Init();
        var unit = UnitInstance();

        board.AddUnit(unit);
        unit.QueueAddBuff(new GameUnit.QueuedAddBuff(null, BuffId, 1));
        board.PostUpdate();
        var buff = unit.GetBuffByDataId(BuffId);

        Assert.NotNull(buff);

        board.Update();

        Assert.Equal(1, buff.Variables.GetInt(1301));
        Assert.Equal(2, buff.Variables.GetInt(1302));
    }

    [Fact]
    public void Buff_start_exposes_owner_as_caller_unit_buff_as_caller_buff_and_attacker_as_slot_unit()
    {
        var start = new ResourceTrigger
        {
            Name = "BuffStartSlots",
            Type = TriggerType.OnStart,
            Statements =
            {
                Assign(BoardKey(1311), Expression(Variable(UnitKey(1310, caller: true)))),
                Assign(BoardKey(1312), Expression(Variable(UnitKey(1310)))),
                Assign(BoardKey(1313), Expression(Variable(BuffKey(1310, caller: true)))),
                Assign(BoardKey(1314), Expression(Variable(BuffKey(1310)))),
            },
        };

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            buffs: [Buff(start.Name)],
            triggers: [start]);
        var board = Board().Init();
        var owner = UnitInstance();
        var attacker = UnitInstance();
        owner.Variables.SetInt(1310, 31);
        attacker.Variables.SetInt(1310, 32);
        board.AddUnit(owner);
        board.AddUnit(attacker);
        owner.QueueAddBuff(new GameUnit.QueuedAddBuff(attacker, BuffId, 1));
        board.PostUpdate();
        var buff = owner.GetBuffByDataId(BuffId);
        Assert.NotNull(buff);
        buff.Variables.SetInt(1310, 33);

        board.Update();

        Assert.Equal(31, board.Variables.GetInt(1311));
        Assert.Equal(32, board.Variables.GetInt(1312));
        Assert.Equal(33, board.Variables.GetInt(1313));
        Assert.Equal(0, board.Variables.GetInt(1314));
    }

    [Fact]
    public void Unit_kill_exposes_killed_unit_as_slot_unit_and_attack_source_as_slot_skill()
    {
        var kill = new ResourceTrigger
        {
            Name = "UnitKillSlots",
            Type = TriggerType.OnKill,
            Statements =
            {
                Assign(BoardKey(1411), Expression(Variable(UnitKey(1410)))),
                Assign(BoardKey(1412), Expression(Variable(SkillKey(1410)))),
            },
        };

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(kill.Name)],
            skills: [Skill()],
            triggers: [kill]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        target.Variables.SetInt(1410, 41);
        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Variables.SetInt(1410, 42);
        skill.Init(board);

        target.AddDamage(skill, new AddDamage { Damages = { 100L } });

        Assert.Equal(41, board.Variables.GetInt(1411));
        Assert.Equal(42, board.Variables.GetInt(1412));
    }

    [Fact]
    public void Skill_kill_exposes_skill_as_caller_skill_and_killed_unit_as_slot_unit()
    {
        var kill = new ResourceTrigger
        {
            Name = "SkillKillSlots",
            Type = TriggerType.OnKill,
            Statements =
            {
                Assign(BoardKey(1421), Expression(Variable(SkillKey(1420, caller: true)))),
                Assign(BoardKey(1422), Expression(Variable(UnitKey(1420)))),
            },
        };

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(kill.Name)],
            triggers: [kill]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        target.Variables.SetInt(1420, 51);
        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Variables.SetInt(1420, 52);
        skill.Init(board);

        target.AddDamage(skill, new AddDamage { Damages = { 100L } });

        Assert.Equal(52, board.Variables.GetInt(1421));
        Assert.Equal(51, board.Variables.GetInt(1422));
    }

    [Fact]
    public void Unit_attacked_post_exposes_valid_damage_to_trigger()
    {
        var attackedPost = new ResourceTrigger
        {
            Name = "UnitAttackedPost",
            Type = TriggerType.OnAttackedPost,
            Statements =
            {
                Assign(CallerKey(1401), Expression(Variable(Predefined(PredefinedType.ValidDamage)))),
            },
        };

        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(attackedPost.Name)],
            skills: [Skill()],
            triggers: [attackedPost]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();

        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { 10 } });

        Assert.Equal(10, result.ValidDamage);
        Assert.Equal(10, target.Variables.GetInt(1401));
    }

    [Fact]
    public void Unit_add_damage_preserves_large_base_damage_without_fixed_float_wrap()
    {
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill()]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();

        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { long.MaxValue } });

        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Damage);
        Assert.Equal(long.MaxValue, result.ValidDamage);
        Assert.Equal(0, target.Hp);
    }

    [Fact]
    public void Skill_attack_trigger_without_return_preserves_large_damage()
    {
        var attack = SetCallerVariableTrigger("SkillAttackNoReturn", TriggerType.OnAttack, 1501, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(attack.Name)],
            triggers: [attack]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { long.MaxValue } });

        Assert.Equal(1, skill.Variables.GetInt(1501));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Damage);
        Assert.Equal(long.MaxValue, result.ValidDamage);
    }

    [Fact]
    public void Unit_attack_trigger_without_return_preserves_large_damage()
    {
        var attack = SetCallerVariableTrigger("UnitAttackNoReturn", TriggerType.OnAttack, 1502, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(attack.Name)],
            skills: [Skill()],
            triggers: [attack]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { long.MaxValue } });

        Assert.Equal(1, attacker.Variables.GetInt(1502));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Damage);
        Assert.Equal(long.MaxValue, result.ValidDamage);
    }

    [Fact]
    public void Unit_attacked_trigger_without_return_preserves_large_damage()
    {
        var attacked = SetCallerVariableTrigger("UnitAttackedNoReturn", TriggerType.OnAttacked, 1503, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit(attacked.Name)],
            skills: [Skill()],
            triggers: [attacked]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { long.MaxValue } });

        Assert.Equal(1, target.Variables.GetInt(1503));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Damage);
        Assert.Equal(long.MaxValue, result.ValidDamage);
    }

    [Fact]
    public void Buff_attacked_trigger_without_return_preserves_large_damage()
    {
        var attacked = SetCallerVariableTrigger("BuffAttackedNoReturn", TriggerType.OnAttacked, 1504, 1);
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill()],
            buffs: [Buff(attacked.Name)],
            triggers: [attacked]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        board.AddUnit(attacker);
        board.AddUnit(target);
        target.QueueAddBuff(new GameUnit.QueuedAddBuff(null, BuffId, 1));
        board.PostUpdate();
        var buff = target.GetBuffByDataId(BuffId);
        Assert.NotNull(buff);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { long.MaxValue } });

        Assert.Equal(1, buff.Variables.GetInt(1504));
        Assert.True(result.IsValid);
        Assert.Equal(long.MaxValue, result.Damage);
        Assert.Equal(long.MaxValue, result.ValidDamage);
    }

    [Fact]
    public void Attack_trigger_return_still_overrides_damage()
    {
        var attack = new ResourceTrigger
        {
            Name = "SkillAttackReturn",
            Type = TriggerType.OnAttack,
            Statements =
            {
                Assign(Predefined(PredefinedType.Return), Expression(Constant(5))),
            },
        };
        using var resources = new TestResourceScope(
            maps: [Map()],
            units: [Unit()],
            skills: [Skill(attack.Name)],
            triggers: [attack]);
        var board = Board().Init();
        var attacker = UnitInstance();
        attacker.Team = GameBoard.Team.Player;
        var target = UnitInstance();
        board.AddUnit(attacker);
        board.AddUnit(target);
        var skill = SkillInstance();
        skill.SenderUnitId = attacker.Id;
        skill.Init(board);

        var result = target.AddDamage(skill, new AddDamage { Damages = { long.MaxValue } });

        Assert.True(result.IsValid);
        Assert.Equal(5L, result.Damage);
        Assert.Equal(5L, result.ValidDamage);
        Assert.Equal(95L, target.Hp);
    }

    private static ResourceTrigger BoardAddUnitTrigger(
        string name,
        params ResourceTrigger.Types.Assignment[] assignments)
    {
        return new ResourceTrigger
        {
            Name = name,
            Type = TriggerType.OnStart,
            Statements =
            {
                Call(
                    new TriggerCall.Types.Method
                    {
                        BoardMethod = new TriggerCall.Types.BoardMethod { Type = BoardMethodType.AddUnit },
                    },
                    assignments: assignments),
            },
        };
    }

    private static ResourceTrigger SetBoardVariableTrigger(
        string name,
        TriggerType type,
        int boardKey,
        int value,
        uint period = 0)
    {
        return new ResourceTrigger
        {
            Name = name,
            Type = type,
            Period = period,
            Statements =
            {
                Assign(BoardKey(boardKey), Expression(Constant(value))),
            },
        };
    }

    private static ResourceTrigger SetCallerVariableTrigger(
        string name,
        TriggerType type,
        int callerKey,
        int value,
        uint period = 0)
    {
        return new ResourceTrigger
        {
            Name = name,
            Type = type,
            Period = period,
            Statements =
            {
                Assign(CallerKey(callerKey), Expression(Constant(value))),
            },
        };
    }

    private static ResourceMap Map(params string[] triggers)
    {
        var map = new ResourceMap
        {
            Id = MapId,
            Type = ResourceMap.Types.Type.Dungeon,
        };
        map.Triggers.Add(triggers);
        return map;
    }

    private static ResourceUnit Unit(params string[] triggers)
    {
        var unit = new ResourceUnit
        {
            Id = UnitId,
            Type = ResourceUnit.Types.Type.Normal,
        };
        unit.AddStats.Add(new AddUnitStat
        {
            Type = UnitStatType.Hp,
            Value = { 100f },
        });
        unit.Triggers.Add(triggers);
        return unit;
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

    private static ResourceSkill SkillWithTimelines(params ResourceSkill.Types.Timeline[] timelines)
    {
        var skill = new ResourceSkill
        {
            Id = SkillId,
        };
        skill.Timelines.Add(timelines);
        return skill;
    }

    private static ResourceBuff Buff(params string[] triggers)
    {
        var buff = new ResourceBuff
        {
            Id = BuffId,
            Type = ResourceBuff.Types.Type.UnitBuff,
            Duration = 10f,
            Stack = 1,
            MaxStack = 1,
        };
        buff.Triggers.Add(triggers);
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
            Team = GameBoard.Team.Enemy,
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
