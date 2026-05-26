using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Types;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        public const int MaxRuntimeCost = 1024;
        public static readonly FixedFloat Epsilon = 1e-3f;
        
        public static int FloatToInt(FixedFloat value)
        {
            
            int sign = value < 0 ? -1 : 1;
            return (int)((FixedFloat.Abs(value) + Epsilon)) * sign;
        }

        public static long FloatToLong(FixedFloat value)
        {
            int sign = value < 0 ? -1 : 1;
            return (long)((FixedFloat.Abs(value) + Epsilon)) * sign;
        }
        
        public class TriggerRuntimeException : Exception
        {
            public TriggerRuntimeException(string message) : base(message)
            {
            }
            
            public TriggerRuntimeException(string message, Exception? innerException) : base(message, innerException)
            {
            }
        }
        
        public class TriggerRuntimeCostExhaustedException : Exception
        {
            public TriggerRuntimeCostExhaustedException(string message) : base(message)
            {
            }
        }
        
        public partial class Types
        {
            public partial class Expression
            {
                public partial class Types
                {
                    public partial class Operand
                    {
                        public partial class Types
                        {
                            public partial class Variable
                            {
                                public FixedFloat GetValue(GameBoard board, State state)
                                {
                                    switch (variableCase_)
                                    {
                                        case VariableOneofCase.BoardKey:
                                            return board.Variables.Get(BoardKey);
                                        case VariableOneofCase.CallerKey:
                                            return state.CallerVariables.Get(CallerKey);
                                        case VariableOneofCase.StateKey:
                                            return state.StateVariables.Get(StateKey);
                                        case VariableOneofCase.Parameter:
                                            return state.GetParameter(board, Parameter.Type);
                                        case VariableOneofCase.ObjectVariable:
                                        {
                                            throw new ArgumentException("ObjectVariable is not allowed in this context");
                                        }
                                        case VariableOneofCase.PredefinedVariable:
                                        {
                                            if ((int) PredefinedVariable.Type >= 1000000) // Unit death (board scoped)
                                            {
                                                return board.Variables.GetPredefinedVariable(board, PredefinedVariable.Type);
                                            }
                                            // other predefined variables are state scoped
                                            return state.GetPredefinedVariable(board, PredefinedVariable.Type);
                                        }
                                        case VariableOneofCase.BoardVariable:
                                        {
                                            return GetBoardVariable(BoardVariable.Type, board, state);
                                        }
                                        case VariableOneofCase.UnitKey:
                                        {
                                            var unit = Caller ? state.callerUnit : state.slotUnit;
                                            return unit?.Variables.Get(UnitKey) ?? FixedFloat.Zero;
                                        }
                                        case VariableOneofCase.UnitVariable:
                                        {
                                            var unit = Caller ? state.callerUnit : state.slotUnit;
                                            if (unit == null)
                                                return FixedFloat.Zero;
                                            return GetUnitVariable(UnitVariable.Type, board, unit, state);
                                        }
                                        case VariableOneofCase.SkillKey:
                                        {
                                            var skill = Caller ? state.callerSkill : state.slotSkill;
                                            return skill?.Variables.Get(SkillKey) ?? FixedFloat.Zero;
                                        }
                                        case VariableOneofCase.SkillVariable:
                                        {
                                            var skill = Caller ? state.callerSkill : state.slotSkill;
                                            if (skill == null)
                                                return FixedFloat.Zero;
                                            return GetSkillVariable(SkillVariable.Type, board, skill, state);
                                        }
                                        case VariableOneofCase.BuffKey:
                                        {
                                            var buff = Caller ? state.callerBuff : state.slotBuff;
                                            return buff?.Variables.Get(BuffKey) ?? FixedFloat.Zero;
                                        }
                                        case VariableOneofCase.BuffVariable:
                                        {
                                            var buff = Caller ? state.callerBuff : state.slotBuff;
                                            if (buff == null)
                                                return FixedFloat.Zero;
                                            return GetBuffVariable(BuffVariable.Type, board, buff, state);
                                        }
                                        default:
                                            throw new ArgumentException($"Unknown variable type: {VariableCase}");
                                    }
                                }
                            }
                        }
                    }
                }

                private const int FixedFloatFractionMask = (1 << FixedFloat.Shift) - 1;

                private static bool IsIntegral(FixedFloat value)
                {
                    return (value.Raw & FixedFloatFractionMask) == 0;
                }

                private static bool ApproximatelyEqual(FixedFloat a, FixedFloat b)
                {
                    if (IsIntegral(a) && IsIntegral(b))
                        return a.Raw == b.Raw;

                    return RawDistanceWithin(a.Raw, b.Raw, Epsilon.Raw);
                }

                private static bool RawDistanceWithin(long a, long b, long tolerance)
                {
                    if (a == b)
                        return true;

                    if (a > b)
                    {
                        var minAccepted = a < long.MinValue + tolerance ? long.MinValue : a - tolerance;
                        return b >= minAccepted;
                    }

                    var lowerBound = b < long.MinValue + tolerance ? long.MinValue : b - tolerance;
                    return a >= lowerBound;
                }

                private static int CompareWithTolerance(FixedFloat a, FixedFloat b)
                {
                    if (ApproximatelyEqual(a, b))
                        return 0;
                    return a.Raw > b.Raw ? 1 : -1;
                }

                internal static bool IsTruthy(FixedFloat value)
                {
                    return !ApproximatelyEqual(value, FixedFloat.Zero);
                }

                private static FixedFloat ToTriggerBool(bool value)
                {
                    return value ? FixedFloat.One : FixedFloat.Zero;
                }

                private static FixedFloat EvaluateOperand(Types.Operand operand, GameBoard board, State state)
                {
                    return operand.OperandCase switch
                    {
                        Types.Operand.OperandOneofCase.Constant => operand.Constant.Value,
                        Types.Operand.OperandOneofCase.Variable => operand.Variable.GetValue(board, state),
                        _ => throw new NotImplementedException(operand.OperandCase.ToString()),
                    };
                }

                private static bool IsUnaryOperator(Types.Operator.Types.Type op)
                {
                    return op is Types.Operator.Types.Type.Not or Types.Operator.Types.Type.UnaryMinus;
                }

                private static FixedFloat EvaluateUnaryOperator(Types.Operator.Types.Type op, FixedFloat value)
                {
                    return op switch
                    {
                        Types.Operator.Types.Type.Not => ToTriggerBool(!IsTruthy(value)),
                        Types.Operator.Types.Type.UnaryMinus => -value,
                        _ => throw new NotImplementedException(op.ToString()),
                    };
                }

                private static FixedFloat EvaluateBinaryOperator(Types.Operator.Types.Type op, FixedFloat a, FixedFloat b)
                {
                    switch (op)
                    {
                        case Types.Operator.Types.Type.Or:
                            return ToTriggerBool(IsTruthy(a) || IsTruthy(b));

                        case Types.Operator.Types.Type.And:
                            return ToTriggerBool(IsTruthy(a) && IsTruthy(b));

                        case Types.Operator.Types.Type.Equal:
                            return ToTriggerBool(CompareWithTolerance(a, b) == 0);

                        case Types.Operator.Types.Type.NotEqual:
                            return ToTriggerBool(CompareWithTolerance(a, b) != 0);

                        case Types.Operator.Types.Type.GreaterThan:
                            return ToTriggerBool(CompareWithTolerance(a, b) > 0);

                        case Types.Operator.Types.Type.LessThan:
                            return ToTriggerBool(CompareWithTolerance(a, b) < 0);

                        case Types.Operator.Types.Type.GreaterThanOrEqual:
                            return ToTriggerBool(CompareWithTolerance(a, b) >= 0);

                        case Types.Operator.Types.Type.LessThanOrEqual:
                            return ToTriggerBool(CompareWithTolerance(a, b) <= 0);

                        case Types.Operator.Types.Type.Add:
                            return a + b;

                        case Types.Operator.Types.Type.Subtract:
                            return a - b;

                        case Types.Operator.Types.Type.Multiply:
                            return a * b;

                        case Types.Operator.Types.Type.Divide:
                            if (b.Raw == 0)
                                throw new DivideByZeroException();
                            return a / b;

                        case Types.Operator.Types.Type.Modulo:
                            if (b.Raw == 0)
                                throw new DivideByZeroException();
                            return a % b;

                        case Types.Operator.Types.Type.Exponent:
                            return FixedFloatMath.Pow(a, b);

                        default:
                            throw new NotImplementedException(op.ToString());
                    }
                }

                private static void ApplyOperator(
                    PooledStack<FixedFloat> stack,
                    Types.Operator.Types.Type op)
                {
                    if (IsUnaryOperator(op))
                    {
                        var value = stack.Pop();
                        stack.Push(EvaluateUnaryOperator(op, value));
                        return;
                    }

                    if (stack.Count < 2)
                        throw new InvalidOperationException($"Operator {op} requires two operands.");

                    var b = stack.Pop();
                    var a = stack.Pop();
                    stack.Push(EvaluateBinaryOperator(op, a, b));
                }

                public FixedFloat Evaluate(GameBoard board, State state)
                {
                    using var stack = ConcurrentObjectPool<PooledStack<FixedFloat>>.StaticPool.Pop();
                    
                    foreach (var element in Postfix)
                    {
                        if (element.Operand != null)
                        {
                            stack.Push(EvaluateOperand(element.Operand, board, state));
                        }
                        else if (element.Operator != null)
                        {
                            ApplyOperator(stack, element.Operator.Type);
                        }
                    }

                    if (stack.Count== 0) return 0;
                    return stack.Pop();
                }
            }

            public partial class Assignment
            {
                internal void Run(GameBoard board, State state)
                {
                    switch (variable_.VariableCase)
                    {
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.ObjectVariable:
                        {
                            if (variable_.ObjectVariable.Caller)
                                throw new ArgumentException("ObjectVariable assignment must have Variable with Caller set to false");
                            if (expression_.Postfix.Count != 1)
                                throw new ArgumentException("ObjectVariable assignment must have only one operand");
                            
                            var operand = expression_.Postfix[0].Operand;
                            if (operand.OperandCase != Expression.Types.Operand.OperandOneofCase.Variable)
                                throw new ArgumentException("ObjectVariable assignment must have only one operand of Variable type");
                            
                            switch (variable_.ObjectVariable.Type)
                            {
                                case Expression.Types.Operand.Types.Variable.Types.ObjectVariable.Types.Type.Unit:
                                {
                                    switch (operand.Variable.VariableCase)
                                    {
                                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.ObjectVariable:
                                        {
                                            switch (operand.Variable.ObjectVariable.Type)
                                            {
                                                case Expression.Types.Operand.Types.Variable.Types.ObjectVariable.Types.Type.Unit:
                                                {
                                                    state.slotUnit = operand.Variable.ObjectVariable.Caller ? state.callerUnit : state.slotUnit;
                                                    break;
                                                }
                                                default:
                                                    throw new ArgumentException("Invalid ObjectVariable Assignment");
                                            }
                                            break;
                                        }
                                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.SkillVariable:
                                        {
                                            var skill = operand.Variable.SkillVariable.Caller ? state.callerSkill : state.slotSkill;
                                            if (skill == null)
                                                break;
                                            switch (operand.Variable.SkillVariable.Type)
                                            {
                                                case Expression.Types.Operand.Types.Variable.Types.SkillVariable.Types.Type.SenderUnit:
                                                {
                                                    state.slotUnit = board.GetUnitById(skill.SenderUnitId);
                                                    break;
                                                }
                                                case Expression.Types.Operand.Types.Variable.Types.SkillVariable.Types.Type.TargetUnit:
                                                {
                                                    state.slotUnit = board.GetUnitById(skill.TargetUnitId);
                                                    break;
                                                }
                                                default:
                                                    throw new ArgumentException($"Invalid ObjectVariable Assignment: {operand.Variable.SkillVariable.Type}");
                                            }
                                            break;
                                        }
                                        default:
                                            throw new ArgumentException("Invalid ObjectVariable Assignment");
                                    }
                                    break;
                                }
                                case Expression.Types.Operand.Types.Variable.Types.ObjectVariable.Types.Type.Skill:
                                {
                                    switch (operand.Variable.VariableCase)
                                    {
                                        case Expression.Types.Operand.Types.Variable.VariableOneofCase
                                            .ObjectVariable:
                                        {
                                            switch (operand.Variable.ObjectVariable.Type)
                                            {
                                                case Expression.Types.Operand.Types.Variable.Types
                                                    .ObjectVariable.Types.Type.Skill:
                                                {
                                                    state.slotSkill = operand.Variable.ObjectVariable.Caller ? state.callerSkill : state.slotSkill;
                                                    break;
                                                }
                                                default:
                                                    throw new ArgumentException(
                                                        "Invalid ObjectVariable Assignment");
                                            }
                                            break;
                                        }
                                    }
                                    break;
                                }
                                case Expression.Types.Operand.Types.Variable.Types.ObjectVariable.Types.Type.Buff:
                                {
                                    switch (operand.Variable.VariableCase)
                                    {
                                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.ObjectVariable:
                                        {
                                            switch (operand.Variable.ObjectVariable.Type)
                                            {
                                                case Expression.Types.Operand.Types.Variable.Types
                                                    .ObjectVariable.Types.Type.Buff:
                                                {
                                                    state.slotBuff = operand.Variable.ObjectVariable.Caller ? state.callerBuff : state.slotBuff;
                                                    break;
                                                }
                                                default:
                                                    throw new ArgumentException("Invalid ObjectVariable Assignment");
                                            }
                                            break;
                                        }
                                    }
                                    break;
                                }
                            }
                            
                            return;
                        }
                    }
                    
                    var result = expression_.Evaluate(board, state);
                    switch (variable_.VariableCase)
                    {
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.BoardKey:
                        {
                            board.Variables.Set(variable_.BoardKey, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.CallerKey:
                        {
                            state.CallerVariables.Set(variable_.CallerKey, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.StateKey:
                        {
                            state.StateVariables.Set(variable_.StateKey, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.Parameter:
                        {
                            state.SetParameter(board, variable_.Parameter.Type, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.ObjectVariable:
                            throw new ArgumentException("ObjectVariable assignment must have Variable of ObjectVariable type");
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.PredefinedVariable:
                        {
                            state.SetPredefinedVariable(board, variable_.PredefinedVariable.Type, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.EditorDefinedVariable:
                        {
                            state.SetEditorDefinedVariable(board, variable_.EditorDefinedVariable, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.BoardVariable:
                        {
                            SetBoardVariable(variable_.BoardVariable.Type, board, state, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.UnitKey:
                        {
                            var unit = variable_.Caller ? state.callerUnit : state.slotUnit;
                            unit?.Variables.Set(variable_.UnitKey, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.UnitVariable:
                        {
                            var unit = variable_.Caller ? state.callerUnit : state.slotUnit;
                            if (unit == null)
                                break;
                            SetUnitVariable(variable_.UnitVariable.Type, board, unit, state, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.SkillKey:
                        {
                            var skill = variable_.Caller ? state.callerSkill : state.slotSkill;
                            skill?.Variables.Set(variable_.SkillKey, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.SkillVariable:
                        {
                            var skill = variable_.Caller ? state.callerSkill : state.slotSkill;
                            if (skill == null)
                                break;
                            SetSkillVariable(variable_.SkillVariable.Type, board, skill, state, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.BuffKey:
                        {
                            var buff = variable_.Caller ? state.callerBuff : state.slotBuff;
                            buff?.Variables.Set(variable_.BuffKey, result);
                            break;
                        }
                        case Expression.Types.Operand.Types.Variable.VariableOneofCase.BuffVariable:
                        {
                            var buff = variable_.Caller ? state.callerBuff : state.slotBuff;
                            if (buff == null)
                                break;
                            SetBuffVariable(variable_.BuffVariable.Type, board, buff, state, result);
                            break;
                        }
                        default:
                            throw new NotImplementedException(variable_.VariableCase.ToString());
                    }
                }
            }

            public partial class Call
            {
                internal void Run(GameBoard board, State state)
                {
                    foreach (var assignment in Assignments)
                        assignment.Run(board, state);

                    switch (Method.MethodCase)
                    {
                        case Types.Method.MethodOneofCase.BoardMethod:
                        {
                            RunMapMethod(this, Method.BoardMethod, board, state);
                            break;
                        }
                        case Types.Method.MethodOneofCase.UnitMethod:
                        {
                            var unit = Caller ? state.callerUnit : state.slotUnit;
                            if (unit == null)
                                break;
                            RunUnitMethod(this, Method.UnitMethod, board, unit, state);
                            break;
                        }
                        case Types.Method.MethodOneofCase.SkillMethod:
                        {
                            var skill = Caller ? state.callerSkill : state.slotSkill;
                            if (skill == null)
                                break;
                            RunSkillMethod(this, Method.SkillMethod, board, skill, state);
                            break;
                        }
                        case Types.Method.MethodOneofCase.BuffMethod:
                        {
                            var buff = Caller ? state.callerBuff : state.slotBuff;
                            if (buff == null)
                                break;
                            RunBuffMethod(this, Method.BuffMethod, board, buff, state);
                            break;
                        }
                        case Types.Method.MethodOneofCase.DebugMethod:
                        {
                            if (!Config.IsDebug)
                                break;

                            var debug = Method.DebugMethod;
                            var message = debug.Message;
                            if (debug.Expression != null)
                                message += $": {debug.Expression.Evaluate(board, state)}";
                            switch (debug.Type)
                            {
                                case Types.DebugMethod.Types.Type.Log:
                                {
                                    Config.LogInfo(message);
                                    break;
                                }
                                case Types.DebugMethod.Types.Type.Error:
                                {
                                    Config.LogError(message);
                                    break;
                                }
                                case Types.DebugMethod.Types.Type.Exception:
                                    throw new TriggerRuntimeException(message);
                                default:
                                    throw new NotImplementedException(debug.Type.ToString());
                            }

                            break;
                        }
                        case Types.Method.MethodOneofCase.RunTrigger:
                        {
                            var trigger = Method.RunTrigger.Trigger;
                            trigger.Run(board, state);
                            break;
                        }
                        default:
                            throw new NotImplementedException();
                    }
                }
            }
            
            public partial class Statement
            {
                internal StatementOneofCase Run(GameBoard board, State state, string name)
                {
                    switch (statementCase_)
                    {
                        case StatementOneofCase.Assignment:
                        {
                            Assignment.Run(board, state);
                            break;
                        }
                        case StatementOneofCase.Call:
                        {
                            Call.Run(board, state);
                            break;
                        }
                        case StatementOneofCase.Condition:
                        {
                            var condition = Condition.Expression.Evaluate(board, state);
                            if (Expression.IsTruthy(condition))
                            {
                                var result = ResourceTrigger.Run(board, state, name, Condition.Statements);
                                if (result != StatementOneofCase.None)
                                    return result;
                            }
                            else if (Condition.ElseStatements.Count > 0)
                            {
                                var result = ResourceTrigger.Run(board, state, name, Condition.ElseStatements);
                                if (result != StatementOneofCase.None)
                                    return result;
                            }
                            break;
                        }
                        case StatementOneofCase.Loop:
                        {
                            while (true)
                            {
                                var condition = Loop.Expression.Evaluate(board, state);
                                if (Expression.IsTruthy(condition))
                                {
                                    var result = ResourceTrigger.Run(board, state, name, Loop.Statements);
                                    if (result == StatementOneofCase.Break)
                                        break;
                                    if (result == StatementOneofCase.Return)
                                        return StatementOneofCase.Return;
                                }
                                else
                                    break;
                            }
                            break;
                        }
                        default:
                            throw new ArgumentException($"{statementCase_} is not allowed in this context");
                    }

                    return StatementOneofCase.None;
                }
            }

            public partial class Variables
            {
                public FixedFloat Get(int key, FixedFloat @default = default)
                {
                    if (variables_.TryGetValue(key, out var value))
                        return FixedFloat.FromRaw(value);
                    return @default;
                }

                public bool TryGet(int key, out FixedFloat value)
                {
                    if (variables_.TryGetValue(key, out var raw))
                    {
                        value = FixedFloat.FromRaw(raw);
                        return true;
                    }

                    value = default;
                    return false;
                }
                
                public FixedFloat GetAndClear(int key, FixedFloat @default = default)
                {
                    if (variables_.Remove(key, out var value))
                        return FixedFloat.FromRaw(value);
                    return @default;
                }

                public int GetInt(int key, int @default = default)
                {
                    return FloatToInt(Get(key, @default));
                }
                
                public int GetIntAndClear(int key, int @default = default)
                {
                    return FloatToInt(GetAndClear(key, @default));
                }
            
                internal void Set(int key, FixedFloat value)
                {
                    variables_[key] = value.Raw;
                }
                
                internal void SetInt(int key, int value)
                {
                    Set(key, value);
                }

                public FixedFloat GetParameter(GameBoard board, Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type parameter, FixedFloat @default = default)
                {
                    return GetAndClear(-(int)parameter, @default);
                }
                
                public int GetIntParameter(GameBoard board, Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type parameter, int @default = default)
                {
                    return GetIntAndClear(-(int)parameter, @default);
                }

                public void SetParameter(GameBoard board, Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type parameter, FixedFloat value)
                {
                    Set(-(int)parameter, value);
                }
                
                public FixedFloat GetPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, FixedFloat @default = default)
                {
                    switch (predefined)
                    {
                        case Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Random:
                            return board.RandomFloat();
                        default:
                            return Get(-(int)predefined, @default);
                    }
                }

                public bool TryGetPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, out FixedFloat value)
                {
                    switch (predefined)
                    {
                        case Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.Random:
                            value = board.RandomFloat();
                            return true;
                        default:
                            return TryGet(-(int)predefined, out value);
                    }
                }
                
                public int GetIntPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, int @default = default)
                {
                    return GetInt(-(int)predefined, @default);
                }
                
                public void SetPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, FixedFloat value)
                {
                    Set(-(int)predefined, value);
                }
                
                public FixedFloat GetEditorDefinedVariable(GameBoard board, int editorDefined, FixedFloat @default = default)
                {
                    return Get(-editorDefined, @default);
                }
                
                public int GetIntEditorDefinedVariable(GameBoard board, int editorDefined, int @default = default)
                {
                    return GetInt(-editorDefined, @default);
                }
                
                public void SetEditorDefinedVariable(GameBoard board, int editorDefined, FixedFloat value)
                {
                    Set(-editorDefined, value);
                }

                public void Clear()
                {
                    variables_.Clear();
                }
                
            }
            
            public class State : IPooledObject<State>
            {
                private Utility.ObjectPool.IObjectPool<State> _objectPool = null; 
                public void SetPool(Utility.ObjectPool.IObjectPool<State> pool)
                {
                    _objectPool = pool;
                }

                public void Dispose()
                {
                    Clear();
                    _objectPool.Push(this);
                }
                
                public static State Rent(Variables callerVariables)
                {
                    var state = ConcurrentObjectPool<State>.StaticPool.Pop();
                    state.CallerVariables = callerVariables;
                    return state;
                }
                
                public Variables CallerVariables = null!;
                public readonly Variables StateVariables = new();

                public GameUnit? slotUnit;
                public GameUnit? callerUnit;
                
                public GameSkill? slotSkill;
                public GameSkill? callerSkill;
                
                public GameBuff? slotBuff;
                public GameBuff? callerBuff;

                public int cost = MaxRuntimeCost;

                public FixedFloat GetParameter(GameBoard board, Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type parameter, FixedFloat @default = default)
                {
                    return StateVariables.GetParameter(board, parameter, @default);
                }
                
                public int GetIntParameter(GameBoard board, Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type parameter, int @default = default)
                {
                    return StateVariables.GetIntParameter(board, parameter, @default);
                }

                public void SetParameter(GameBoard board, Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type parameter, FixedFloat value)
                {
                    StateVariables.SetParameter(board, parameter, value);
                }
                
                public FixedFloat GetPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, FixedFloat @default = default)
                {
                    return StateVariables.GetPredefinedVariable(board, predefined, @default);
                }

                public long GetLongPredefinedVariableSaturated(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, long @default = default)
                {
                    return StateVariables.TryGetPredefinedVariable(board, predefined, out var value)
                        ? LongFixedFloatMath.ToLongSaturated(value)
                        : @default;
                }
                
                public int GetIntPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, int @default = default)
                {
                    return StateVariables.GetIntPredefinedVariable(board, predefined, @default);
                }
                
                public void SetPredefinedVariable(GameBoard board, Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type predefined, FixedFloat value)
                {
                    StateVariables.SetPredefinedVariable(board, predefined, value);
                }
                
                public FixedFloat GetEditorDefinedVariable(GameBoard board, int editorDefined, FixedFloat @default = default)
                {
                    return StateVariables.GetEditorDefinedVariable(board, editorDefined, @default);
                }
                
                public int GetIntEditorDefinedVariable(GameBoard board, int editorDefined, int @default = default)
                {
                    return StateVariables.GetIntEditorDefinedVariable(board, editorDefined, @default);
                }
                
                public void SetEditorDefinedVariable(GameBoard board, int editorDefined, FixedFloat value)
                {
                    StateVariables.SetEditorDefinedVariable(board, editorDefined, value);
                }

                public void Clear()
                {
                    CallerVariables = null;
                    StateVariables.Clear();
                    slotUnit = null;
                    callerUnit = null;
                    slotSkill = null;
                    callerSkill = null;
                    slotBuff = null;
                    callerBuff = null;
                    cost = MaxRuntimeCost;
                }
                
            }
        }

        private static Types.Statement.StatementOneofCase Run(GameBoard board, Types.State state, string name, IEnumerable<Types.Statement> statements)
        {
            foreach (var statement in statements)
            {
                if (--state.cost < 0)
                    throw new TriggerRuntimeCostExhaustedException($"Trigger ({name}) / {statement} ({statement.Comment})");
                
                switch (statement.StatementCase)
                {
                    case Types.Statement.StatementOneofCase.Return:
                        return Types.Statement.StatementOneofCase.Return;
                    case Types.Statement.StatementOneofCase.Break:
                        return Types.Statement.StatementOneofCase.Break;
                }
                
                try
                {
                    var result = statement.Run(board, state, name);
                    if (result != Types.Statement.StatementOneofCase.None)
                        return result;
                }
                catch (TriggerRuntimeCostExhaustedException)
                {
                    throw;
                }
                catch (Exception ex)
                {
                    throw new TriggerRuntimeException($"Trigger ({name}) / {statement} ({statement.Comment})", ex);
                }
            }

            return Types.Statement.StatementOneofCase.None;
        }
        
        internal void Run(GameBoard board, Types.State state)
        {
            var result = Run(board, state, name_, statements_);
            if (result != Types.Statement.StatementOneofCase.None && result != Types.Statement.StatementOneofCase.Return)
                throw new TriggerRuntimeException($"Trigger ({name_}) is ended with inappropriate return: {result}");
        }
    }
}
