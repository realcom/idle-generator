using System;
using Commons.Game;
using Commons.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BoardVariable.Types.Type;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static FixedFloat GetBoardVariable(BoardVariable.Types.Type type, GameBoard board, Types.State state)
        {
            switch (type)
            {
                case DataId:
                    return board.ResMap.Id;
                case Tick:
                    return board.Tick;
                case BoardVariable.Types.Type.Timer:
                    return board.TimerRemaining;
                case MapType:
                    return (int)board.ResMap.Type;
                default:
                    throw new NotImplementedException(type.ToString());
            }
        }
        
        private static void SetBoardVariable(BoardVariable.Types.Type type, GameBoard board, Types.State state, FixedFloat value)
        {
            switch (type)
            {
                default:
                    throw new ArgumentException($"{type} is not allowed in this context");
            }
        }
    }
}
