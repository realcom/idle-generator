using Commons.Game;
using Commons.Resources;
using Commons.Types;
using Server.Tests.TestSupport;
using static Server.Tests.TestSupport.ResourceTriggerTestFactory;
using Xunit;

namespace Server.Tests;

using TriggerCall = ResourceTrigger.Types.Call;
using OperatorType = ResourceTrigger.Types.Expression.Types.Operator.Types.Type;
using ParameterType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using PredefinedType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;
using BoardMethodType = ResourceTrigger.Types.Call.Types.BoardMethod.Types.Type;
using UnitMethodType = ResourceTrigger.Types.Call.Types.UnitMethod.Types.Type;

public sealed class ResourceTriggerTests
{
    [Fact]
    public void Expression_evaluate_handles_postfix_arithmetic_and_comparison()
    {
        var expression = Expression(
            Constant(2),
            Constant(3),
            Operator(OperatorType.Add),
            Constant(4),
            Operator(OperatorType.Multiply),
            Constant(20),
            Operator(OperatorType.Equal));

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        Assert.Equal(FixedFloat.One, expression.Evaluate(new GameBoard(), state));
    }

    [Fact]
    public void Expression_evaluate_handles_fractional_equality_tolerance()
    {
        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        var board = new GameBoard();

        Assert.Equal(FixedFloat.One, Expression(
            Constant(1.25),
            Constant(1.2505),
            Operator(OperatorType.Equal)).Evaluate(board, state));
        Assert.Equal(FixedFloat.One, Expression(
            Constant(1.25),
            Constant(1.26),
            Operator(OperatorType.NotEqual)).Evaluate(board, state));
        Assert.Equal(FixedFloat.Zero, Expression(
            Constant(1),
            Constant(2),
            Operator(OperatorType.Equal)).Evaluate(board, state));
    }

    [Fact]
    public void Expression_evaluate_handles_extreme_value_comparison_without_raw_overflow()
    {
        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        var board = new GameBoard();

        Assert.Equal(FixedFloat.Zero, Expression(
            Constant(double.MaxValue),
            Constant(double.MinValue),
            Operator(OperatorType.Equal)).Evaluate(board, state));
        Assert.Equal(FixedFloat.One, Expression(
            Constant(double.MaxValue),
            Constant(double.MinValue),
            Operator(OperatorType.GreaterThan)).Evaluate(board, state));
    }

    [Fact]
    public void Expression_evaluate_treats_values_inside_epsilon_as_equal_for_ordering()
    {
        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        var board = new GameBoard();

        Assert.Equal(FixedFloat.Zero, Expression(
            Constant(1.2505),
            Constant(1.25),
            Operator(OperatorType.GreaterThan)).Evaluate(board, state));
        Assert.Equal(FixedFloat.One, Expression(
            Constant(1.2505),
            Constant(1.25),
            Operator(OperatorType.GreaterThanOrEqual)).Evaluate(board, state));
        Assert.Equal(FixedFloat.One, Expression(
            Constant(1.2505),
            Constant(1.25),
            Operator(OperatorType.LessThanOrEqual)).Evaluate(board, state));
    }

    [Fact]
    public void Expression_evaluate_handles_unary_and_boolean_operators()
    {
        var expression = Expression(
            Constant(0),
            Operator(OperatorType.Not),
            Constant(-3),
            Operator(OperatorType.UnaryMinus),
            Constant(3),
            Operator(OperatorType.Equal),
            Operator(OperatorType.And),
            Constant(5),
            Operator(OperatorType.Or));

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        Assert.Equal(FixedFloat.One, expression.Evaluate(new GameBoard(), state));
    }

    [Fact]
    public void Expression_evaluate_uses_epsilon_consistent_truthiness_for_logical_operators()
    {
        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        var board = new GameBoard();

        Assert.Equal(FixedFloat.One, Expression(
            Constant(0.0005),
            Operator(OperatorType.Not)).Evaluate(board, state));
        Assert.Equal(FixedFloat.Zero, Expression(
            Constant(0.0005),
            Constant(0),
            Operator(OperatorType.Or)).Evaluate(board, state));
        Assert.Equal(FixedFloat.One, Expression(
            Constant(0.002),
            Constant(0.0005),
            Operator(OperatorType.Or)).Evaluate(board, state));
    }

    [Fact]
    public void Expression_evaluate_rejects_binary_operator_without_two_operands()
    {
        var expression = Expression(
            Constant(1),
            Operator(OperatorType.Add));

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        Assert.Throws<InvalidOperationException>(() => expression.Evaluate(new GameBoard(), state));
    }

    [Fact]
    public void Expression_parameters_are_consumed_after_the_first_read()
    {
        var board = new GameBoard();
        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        state.SetParameter(board, ParameterType.Count, 7);

        var expression = Expression(
            Variable(Parameter(ParameterType.Count)),
            Variable(Parameter(ParameterType.Count)),
            Operator(OperatorType.Add));

        Assert.Equal(7, ResourceTrigger.FloatToInt(expression.Evaluate(board, state)));
    }

    [Fact]
    public void Trigger_run_writes_board_caller_and_state_variables_in_separate_scopes()
    {
        var board = new GameBoard();
        var callerVariables = new ResourceTrigger.Types.Variables();
        var trigger = new ResourceTrigger
        {
            Name = "ScopeProbe",
            Statements =
            {
                Assign(BoardKey(100), Expression(Constant(4))),
                Assign(CallerKey(200), Expression(Variable(BoardKey(100)), Constant(6), Operator(OperatorType.Add))),
                Assign(StateKey(300), Expression(Variable(CallerKey(200)), Constant(1), Operator(OperatorType.Add))),
                Assign(CallerKey(201), Expression(Variable(StateKey(300)), Constant(1), Operator(OperatorType.Add))),
            },
        };

        using var state = ResourceTrigger.Types.State.Rent(callerVariables);
        trigger.Run(board, state);

        Assert.Equal(4, board.Variables.GetInt(100));
        Assert.Equal(10, callerVariables.GetInt(200));
        Assert.Equal(11, state.StateVariables.GetInt(300));
        Assert.Equal(12, callerVariables.GetInt(201));
    }

    [Fact]
    public void Unit_method_get_weapon_type_returns_zero_without_player_avatar()
    {
        var board = new GameBoard();
        var trigger = new ResourceTrigger
        {
            Name = "WeaponTypeNoAvatar",
            Statements =
            {
                Call(
                    new TriggerCall.Types.Method
                    {
                        UnitMethod = new TriggerCall.Types.UnitMethod { Type = UnitMethodType.GetWeaponType },
                    },
                    caller: true),
                Assign(BoardKey(800), Expression(Variable(Predefined(PredefinedType.Return)))),
            },
        };

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        state.callerUnit = new GameUnit();

        trigger.Run(board, state);

        Assert.Equal(0, board.Variables.GetInt(800));
    }

    [Fact]
    public void Unit_method_get_current_hp_percent_returns_zero_when_max_hp_is_zero()
    {
        var board = new GameBoard();
        var trigger = new ResourceTrigger
        {
            Name = "HpPercentZeroMaxHp",
            Statements =
            {
                Call(
                    new TriggerCall.Types.Method
                    {
                        UnitMethod = new TriggerCall.Types.UnitMethod { Type = UnitMethodType.GetCurrentHpPercent },
                    },
                    caller: true),
                Assign(BoardKey(802), Expression(Variable(Predefined(PredefinedType.Return)))),
            },
        };

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());
        state.callerUnit = new GameUnit();

        trigger.Run(board, state);

        Assert.Equal(0, board.Variables.GetInt(802));
    }

    [Fact]
    public void Board_method_get_main_player_unit_variable_returns_zero_without_main_unit()
    {
        var board = new GameBoard();
        var trigger = new ResourceTrigger
        {
            Name = "MainPlayerUnitVariableNoUnit",
            Statements =
            {
                Call(
                    new TriggerCall.Types.Method
                    {
                        BoardMethod = new TriggerCall.Types.BoardMethod
                        {
                            Type = BoardMethodType.GetMainPlayerUnitVariable,
                        },
                    },
                    assignments:
                    [
                        CallAssign(Parameter(ParameterType.Value), Expression(Constant(123))),
                    ]),
                Assign(BoardKey(801), Expression(Variable(Predefined(PredefinedType.Return)))),
            },
        };

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        trigger.Run(board, state);

        Assert.Equal(0, board.Variables.GetInt(801));
    }

    [Fact]
    public void Board_method_show_select_trait_is_noop_without_main_player()
    {
        var board = new GameBoard();
        var trigger = new ResourceTrigger
        {
            Name = "ShowSelectTraitNoPlayer",
            Statements =
            {
                Call(new TriggerCall.Types.Method
                {
                    BoardMethod = new TriggerCall.Types.BoardMethod { Type = BoardMethodType.ShowSelectTrait },
                }),
            },
        };

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        trigger.Run(board, state);

        Assert.Empty(board.Events);
    }

    [Fact]
    public void Reload_initializes_default_period_and_run_trigger_resolves_by_name()
    {
        const string childName = "Child";
        const string parentName = "Parent";
        var child = new ResourceTrigger
        {
            Name = childName,
            Statements =
            {
                Assign(BoardKey(700), Expression(Constant(42))),
            },
        };
        var parent = new ResourceTrigger
        {
            Name = parentName,
            Statements =
            {
                Call(new TriggerCall.Types.Method
                {
                    RunTrigger = new TriggerCall.Types.RunTrigger { Name = childName },
                }),
            },
        };

        using var resources = new TestResourceScope(triggers: [child, parent]);
        var loadedParent = ResourceTrigger.Get(parentName);
        var board = new GameBoard();
        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        Assert.NotNull(loadedParent);
        Assert.Equal(ResourceTrigger.DefaultPeriod, loadedParent.Period);

        loadedParent.Run(board, state);

        Assert.Equal(42, board.Variables.GetInt(700));
    }

    [Fact]
    public void Trigger_run_stops_when_runtime_cost_is_exhausted()
    {
        var trigger = new ResourceTrigger { Name = "CostProbe" };
        for (var i = 0; i <= ResourceTrigger.MaxRuntimeCost; i++)
            trigger.Statements.Add(Assign(CallerKey(1), Expression(Constant(i))));

        using var state = ResourceTrigger.Types.State.Rent(new ResourceTrigger.Types.Variables());

        Assert.Throws<ResourceTrigger.TriggerRuntimeCostExhaustedException>(() => trigger.Run(new GameBoard(), state));
    }
}
