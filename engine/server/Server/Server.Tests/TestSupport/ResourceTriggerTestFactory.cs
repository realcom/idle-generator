using Commons.Resources;

namespace Server.Tests.TestSupport;

using TriggerCall = ResourceTrigger.Types.Call;
using TriggerExpression = ResourceTrigger.Types.Expression;
using TriggerStatement = ResourceTrigger.Types.Statement;
using TriggerVariable = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable;
using OperatorType = ResourceTrigger.Types.Expression.Types.Operator.Types.Type;
using ParameterType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using PredefinedType = ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

internal static class ResourceTriggerTestFactory
{
    public static TriggerStatement Assign(TriggerVariable variable, TriggerExpression expression)
    {
        return new TriggerStatement
        {
            Assignment = new ResourceTrigger.Types.Assignment
            {
                Variable = variable,
                Expression = expression,
            },
        };
    }

    public static TriggerStatement Call(
        TriggerCall.Types.Method method,
        bool caller = false,
        params ResourceTrigger.Types.Assignment[] assignments)
    {
        var statement = new TriggerStatement
        {
            Call = new TriggerCall
            {
                Caller = caller,
                Method = method,
            },
        };
        statement.Call.Assignments.Add(assignments);
        return statement;
    }

    public static ResourceTrigger.Types.Assignment CallAssign(TriggerVariable variable, TriggerExpression expression)
    {
        return new ResourceTrigger.Types.Assignment
        {
            Variable = variable,
            Expression = expression,
        };
    }

    public static TriggerExpression Expression(params TriggerExpression.Types.Element[] elements)
    {
        var expression = new TriggerExpression();
        expression.Postfix.Add(elements);
        return expression;
    }

    public static TriggerExpression.Types.Element Constant(double value)
    {
        return new TriggerExpression.Types.Element
        {
            Operand = new TriggerExpression.Types.Operand
            {
                Constant = new TriggerExpression.Types.Operand.Types.Constant { Value = value },
            },
        };
    }

    public static TriggerExpression.Types.Element Variable(TriggerVariable variable)
    {
        return new TriggerExpression.Types.Element
        {
            Operand = new TriggerExpression.Types.Operand
            {
                Variable = variable,
            },
        };
    }

    public static TriggerExpression.Types.Element Operator(OperatorType type)
    {
        return new TriggerExpression.Types.Element
        {
            Operator = new TriggerExpression.Types.Operator { Type = type },
        };
    }

    public static TriggerVariable BoardKey(int key)
    {
        return new TriggerVariable { BoardKey = key };
    }

    public static TriggerVariable CallerKey(int key)
    {
        return new TriggerVariable { CallerKey = key };
    }

    public static TriggerVariable StateKey(int key)
    {
        return new TriggerVariable { StateKey = key };
    }

    public static TriggerVariable UnitKey(int key, bool caller = false)
    {
        return new TriggerVariable { Caller = caller, UnitKey = key };
    }

    public static TriggerVariable SkillKey(int key, bool caller = false)
    {
        return new TriggerVariable { Caller = caller, SkillKey = key };
    }

    public static TriggerVariable BuffKey(int key, bool caller = false)
    {
        return new TriggerVariable { Caller = caller, BuffKey = key };
    }

    public static TriggerVariable Parameter(ParameterType type)
    {
        return new TriggerVariable
        {
            Parameter = new TriggerVariable.Types.Parameter { Type = type },
        };
    }

    public static TriggerVariable Predefined(PredefinedType type)
    {
        return new TriggerVariable
        {
            PredefinedVariable = new TriggerVariable.Types.PredefinedVariable { Type = type },
        };
    }
}
