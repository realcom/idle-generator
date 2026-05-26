using System;
using Commons.Game;
using Commons.Types.Geometry;
using Commons.Types.Units;
using static Commons.Resources.ResourceTrigger.Types.Call.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

using static Commons.Resources.ResourceTrigger.Types.Call.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static void RunBuffMethod(Types.Call call, BuffMethod method, GameBoard board, GameBuff buff, Types.State state)
        {
            switch (method.Type)
            {
                case BuffMethod.Types.Type.IncreaseStack:
                {
                    var queuedAddBuff = new GameUnit.QueuedAddBuff(buff.Unit, buff.DataId, buff.Level);
                    buff.Unit.QueueAddBuff(queuedAddBuff);
                    break;
                }
                case BuffMethod.Types.Type.AddBuffToOwner:
                {
                    var buffDataId = state.GetIntParameter(board, BuffDataId);
                    var level = Math.Max(1, state.GetIntParameter(board, Parameter.Types.Type.Level));
                    var duration = state.GetParameter(board, Duration);
                    var sender = OffsetToBuffSender(state.GetIntParameter(board, Offset), buff);
                    var addBuff = new AddBuff
                    {   
                        BuffDataId = buffDataId,
                        Level = level,
                        Duration = (float)duration,
                    };
                    buff.Unit.QueueAddBuff(new GameUnit.QueuedAddBuff(sender, addBuff, level));
                    break;
                }
                case BuffMethod.Types.Type.AddBuffToSender:
                {
                    var buffDataId = state.GetIntParameter(board, BuffDataId);
                    var level = Math.Max(1, state.GetIntParameter(board, Parameter.Types.Type.Level));
                    var duration = state.GetParameter(board, Duration);
                    var sender = OffsetToBuffSender(state.GetIntParameter(board, Offset), buff);
                    var addBuff = new AddBuff
                    {   
                        BuffDataId = buffDataId,
                        Level = level,
                        Duration = (float)duration,
                    };
                    buff.Attacker?.QueueAddBuff(new GameUnit.QueuedAddBuff(sender, addBuff, level));
                    break;
                }
                default:
                    throw new NotImplementedException(method.Type.ToString());
            }
        }

        private static GameUnit? OffsetToBuffSender(int offset, GameBuff existingBuff)
        {
            return offset switch
            {
                1 => existingBuff.Attacker,
                _ => existingBuff.Unit
            };
        }

        private static GameUnit? OffsetToBuffSender(int offset, Types.State state)
        {
            return offset switch
            {
                4 => state.slotBuff?.Attacker,
                3 => state.slotBuff?.Unit,
                2 => state.callerBuff?.Unit,
                1 => state.slotUnit,
                _ => state.callerUnit
            };
        }
    }
}
