using System;
using Commons.Game;
using Commons.Packets.Requests;
using Commons.Types;
using Commons.Types.Geometry;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.SkillVariable.Types.Type;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static FixedFloat GetSkillVariable(SkillVariable.Types.Type type, GameBoard board, GameSkill skill, Types.State state)
        {
            switch (type)
            {
                case Caller:
                    throw new ArgumentException("Caller is not allowed in this context");
                case DataId:
                    return skill.ResSkill.Id;
                
                case PositionX:
                    return skill.Position.X;
                case PositionY:
                    return skill.Position.Y;
                case DirectionX:
                    return skill.Direction.X;
                case DirectionY:
                    return skill.Direction.Y;
                case VelocityX:
                    return skill.Velocity.X;
                case VelocityY:
                    return skill.Velocity.Y;
                case AccelerationX:
                    return skill.Acceleration.X;
                case AccelerationY:
                    return skill.Acceleration.Y;
                case Level:
                    return skill.Level;
                case SenderUnit:
                    throw new ArgumentException("SenderUnit is not allowed in this context");
                case TargetUnit:
                    throw new ArgumentException("TargetUnit is not allowed in this context");
                
                default:
                    throw new NotImplementedException(type.ToString());
            }
        }
        
        private static void SetSkillVariable(SkillVariable.Types.Type type, GameBoard board, GameSkill skill, Types.State state, FixedFloat value)
        {
            switch (type)
            {

                case PositionX:
                {
                    skill.SetPosition(new FixedVector2(value, skill.Position.Y));
                    break;
                }
                case PositionY:
                {
                    skill.SetPosition(new FixedVector2(skill.Position.X, value));
                    break;
                }
                case DirectionX:
                {
                    skill.SetDirection(new FixedVector2(value, skill.Direction.Y));
                    break;
                }
                case DirectionY:
                {
                    skill.SetDirection(new FixedVector2(skill.Direction.X, value));
                    break;
                }
                case VelocityX:
                    throw new ArgumentException("VelocityX cannot be set");
                case VelocityY:
                    throw new ArgumentException("VelocityY cannot be set");
                case AccelerationX:
                {
                    skill.SetAcceleration(new FixedVector2(skill.Acceleration.X, value));
                    break;
                }
                case AccelerationY:
                {
                    skill.SetAcceleration(new FixedVector2(value, skill.Acceleration.Y));
                    break;
                }
                
                case SenderUnit:
                    throw new ArgumentException("SenderUnit is not allowed in this context");
                case TargetUnit:
                    throw new ArgumentException("TargetUnit is not allowed in this context");
                
                default:
                    throw new ArgumentException($"{type} is not allowed in this context");
            }
        }
    }
}
