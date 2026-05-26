using System;
using Commons.Game;
using Commons.Types;
using Commons.Utility;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BuffVariable.Types.Type;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static FixedFloat GetBuffVariable(BuffVariable.Types.Type type, GameBoard board, GameBuff buff, Types.State state)
        {
            switch (type)
            {
                case Caller:
                    throw new ArgumentException("Caller is not allowed in this context");
                case DataId:
                    return buff.ResBuff.Id;
                case Stack:
                    return buff.Stack;
                case Level:
                    return buff.Level;
                case Enabled:
                    return buff.Enabled ? FixedFloat.One : FixedFloat.Zero;
                case MaxLevel:
                    return buff.ResBuff.MaxLevel;
                case MaxStack:
                    return buff.ResBuff.MaxStack;
                default:
                    throw new NotImplementedException(type.ToString());
            }
        }
        
        private static void SetBuffVariable(BuffVariable.Types.Type type, GameBoard board, GameBuff buff, Types.State state, FixedFloat value)
        {
            switch (type)
            {
                case Level:
                    buff.SetLevel((int)value);
                    break;
                case Enabled:
                    var isEnabled = value > FixedFloat.Zero;
                    buff.SetEnabled(isEnabled);
                    break;
                default:
                    throw new ArgumentException($"{type} is not allowed in this context");
            }
        }
    }
}
