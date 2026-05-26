using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using Commons.Game;
using Commons.Game.Events;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using static Commons.Resources.ResourceTrigger.Types.Call.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using Commons.Game;
using Commons.Game.Events;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using static Commons.Resources.ResourceTrigger.Types.Call.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static void RunSkillMethod(Types.Call call, SkillMethod method, GameBoard board, GameSkill skill, Types.State state)
        {
            switch (method.Type)
            {
                case SkillMethod.Types.Type.GetSkillCooldown:
                {
                    var attacker = skill.Attacker;
                    if (attacker == null) break;
                    state.SetPredefinedVariable(board, Return, attacker.GetSkillCooldown(skill.DataId, skill.ItemId));
                    break;
                }
                
                case SkillMethod.Types.Type.ReduceSkillCooldownByPercent:
                {
                    var attacker = skill.Attacker;
                    if (attacker == null) break;
                    var count = state.GetIntParameter(board, Count);
                    
                    attacker.ReduceSkillCooldownByPercent(skill.DataId, skill.ItemId, count);
                    break;
                }
                
                // case SkillMethod.Types.Type.ReduceSkillCooldownBySeconds:
                // {
                //     var attacker = skill.Attacker;
                //     attacker.ResetSkillCooldown(skill.DataId, skill.ItemId);
                //     break;
                // }
                default:
                    throw new NotImplementedException(method.Type.ToString());
            }
        }
    }
}