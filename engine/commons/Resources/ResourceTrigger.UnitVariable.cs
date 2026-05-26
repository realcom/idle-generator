using System;
using System.Security.Cryptography.X509Certificates;
using Commons.Game;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Resources
{
    public partial class ResourceTrigger
    {
        private static FixedFloat GetUnitVariable(UnitVariable.Types.Type type, GameBoard board, GameUnit unit, Types.State state)
        {
            switch (type)
            {
                case Caller:
                    throw new ArgumentException("Caller is not allowed in this context");
                case DataId:
                    return unit.ResUnit.Id;
                
                case PositionX:
                    return unit.Position.X;
                case PositionY:
                    return unit.Position.Y;
                case DirectionX:
                    return unit.Direction.X;
                case DirectionY:
                    return unit.Direction.Y;
                case VelocityX:
                    return unit.Velocity.X;
                case VelocityY:
                    return unit.Velocity.Y;
                
                case HasMoveDirection:
                    return unit.MoveDirection == null ? FixedFloat.Zero : FixedFloat.One;
                case MoveDirectionX:
                    return unit.MoveDirection?.X ?? unit.Position.X;
                case MoveDirectionY:
                    return unit.MoveDirection?.Y ?? unit.Position.Y;
                case HasMoveDestination:
                    return unit.MoveDestination == null ? FixedFloat.Zero : FixedFloat.One;
                case MoveDestinationX:
                    return unit.MoveDestination?.X ?? unit.Position.X;
                case MoveDestinationY:
                    return unit.MoveDestination?.Y ?? unit.Position.Y;
                
                case Level:
                    return unit.Level;
                case State:
                    return unit.State;
                case IsCollidingWall:
                    return unit.IsCollidedWall ? FixedFloat.One : FixedFloat.Zero;
                case IsCollidingUnit:
                    return unit.IsCollidedUnit ? FixedFloat.One : FixedFloat.Zero;
                
                case Hp:
                    return unit.Hp;
                case MaxHp:
                    return unit.MaxHp;
                case HpRatio:
                    return unit.MaxHp == 0 ? FixedFloat.Zero : (FixedFloat)unit.Hp / unit.MaxHp;
                case Mp:
                    return unit.Mp;
                case MaxMp:
                    return unit.MaxMp;
                case MpRatio:
                    return unit.MaxMp == 0 ? FixedFloat.Zero : (FixedFloat)unit.Mp / unit.MaxMp;
                case Shield:
                    return unit.Shield;
                case Guard:
                    return unit.Guard;
                case Luck:
                    return unit.Stat.Luck;
                
                case Target:
                    throw new ArgumentException("Target is not allowed in this context");
                case HasTarget:
                    return unit.Target == null ? 0f : 1f;
                case TargetPositionX:
                    return unit.Target?.Position.X ?? unit.Position.X;
                case TargetPositionY:
                    return unit.Target?.Position.Y ?? unit.Position.Y;
                case TargetDistance:
                {
                    var target = unit.Target;
                    return target == null ? FixedFloat.MaxValue : ((FixedVector2)target.Position - unit.Position).magnitude;
                }
                case TargetAngle:
                {
                    var target = unit.Target;
                    return target == null ? FixedFloat.Zero : ((FixedVector2)target.Position - unit.Position).GetAngle();
                }
                
                case IsBoss:
                {
                    return unit.ResUnit.TypeGroup == ResourceUnit.Types.TypeGroup.BossGroup;
                }
                case FreeRollCount:
                {
                    return unit.Variables.Get((int)FreeRollCount);
                }
                case TotalSpawnItemCount:
                {
                    return unit.Variables.Get((int)TotalSpawnItemCount);
                    break;
                }
                case CumulativeSpawnCountWithoutReset:
                    return unit.Variables.GetInt((int)CumulativeSpawnCountWithoutReset);
                case CumulativeSpawnCount:
                    return unit.Variables.GetInt((int)CumulativeSpawnCount);
                case CumulativeFreeRollCount:
                    return unit.Variables.GetInt((int)CumulativeFreeRollCount);
                case CumulativeTotalCountBeforeBagExpand:
                    return unit.Variables.GetInt((int)CumulativeTotalCountBeforeBagExpand);
                case CumulativeLuckAppliedCount:
                    return unit.Variables.GetInt((int)CumulativeLuckAppliedCount);
                
                default:
                    throw new NotImplementedException(type.ToString());
            }
        }
        
        private static void SetUnitVariable(UnitVariable.Types.Type type, GameBoard board, GameUnit unit, Types.State state, FixedFloat value)
        {
            switch (type)
            {
                case Caller:
                    throw new ArgumentException("Caller is not allowed in this context");
                case DataId:
                    throw new ArgumentException("DataId cannot be set");

                case PositionX:
                {
                    unit.SetPosition(new FixedVector2(value, unit.Position.Y));
                    break;
                }
                case PositionY:
                {
                    unit.SetPosition(new FixedVector2(unit.Position.X, value));
                    break;
                }
                case DirectionX:
                {
                    unit.SetDirection(new FixedVector2(value, unit.Direction.Y));
                    break;
                }
                case DirectionY:
                {
                    unit.SetDirection(new FixedVector2(unit.Direction.X, value));
                    break;
                }
                case VelocityX:
                    throw new ArgumentException("VelocityX cannot be set");
                case VelocityY:
                    throw new ArgumentException("VelocityY cannot be set");
                
                case HasMoveDirection:
                    throw new ArgumentException("HasMoveDirection cannot be set");
                case MoveDirectionX:
                    throw new ArgumentException("Call SetMoveDirection instead");
                case MoveDirectionY:
                    throw new ArgumentException("Call SetMoveDirection instead");
                case HasMoveDestination:
                    throw new ArgumentException("HasMoveDestination cannot be set");
                case MoveDestinationX:
                    throw new ArgumentException("Call SetMoveDestination instead");
                case MoveDestinationY:
                    throw new ArgumentException("Call SetMoveDestination instead");
                
                case Level:
                {
                    unit.SetLevel(FloatToInt(value));
                    break;
                }
                case State:
                    throw new ArgumentException("State cannot be set");
                    
                case Hp:
                {
                    unit.SetHp(FloatToLong(value));
                    break;
                }
                case MaxHp:
                    throw new ArgumentException("MaxHp cannot be set");
                case HpRatio:
                    throw new ArgumentException("HpRatio cannot be set");
                case Mp:
                {
                    unit.SetMp(FloatToLong(value));
                    break;
                }
                case MaxMp:
                    throw new ArgumentException("MaxMp cannot be set");
                case MpRatio:
                    throw new ArgumentException("MpRatio cannot be set");
                case Shield:
                {
                    unit.SetShield(FloatToLong(value));
                    break;
                }
                case Guard:
                {
                    unit.SetGuard(FloatToLong(value));
                    break;
                }
                case Luck:
                {
                    throw new ArgumentException("Luck cannot be set");
                }
                case Target:
                    throw new ArgumentException("Target is not allowed in this context");
                case HasTarget:
                    throw new ArgumentException("HasTarget is not allowed in this context");
                case TargetPositionX:
                {
                    var target = unit.Target;
                    target?.SetPosition(new FixedVector2(value, target.Position.Y));
                    break;
                }
                case TargetPositionY:
                {
                    var target = unit.Target;
                    target?.SetPosition(new FixedVector2(target.Position.X, value));
                    break;
                }
                case TargetDistance:
                    throw new ArgumentException("TargetDistance cannot be set");
                case TargetAngle:
                    throw new ArgumentException("TargetAngle cannot be set");
                case IsBoss:
                    throw new ArgumentException("IsBoss cannot be set");
                case FreeRollCount:
                {
                    unit.Variables.Set((int)FreeRollCount, value);
                    break;
                }
                case AddFreeRollCountPercentBySell:
                {
                    unit.Variables.Set((int)AddFreeRollCountPercentBySell, value + unit.Variables.Get((int)AddFreeRollCountPercentBySell));
                    break;
                }
                case PaybackBasicConsumablePercentBySell:
                {
                    unit.Variables.Set((int)PaybackBasicConsumablePercentBySell, value);
                    break;
                }
                case RespawnHpPercent:
                {
                    unit.Variables.Set((int)RespawnHpPercent, value);
                    break;
                }
                
                case RespawnMpPercent:
                {
                    unit.Variables.Set((int)RespawnMpPercent, value);
                    break;
                }
                
                case PaybackGoldOnSellConsumable:
                {
                    unit.Variables.Set((int)PaybackGoldOnSellConsumable, value);
                    break;
                }
                
                case FixedSpawnPrice:
                {
                    unit.Variables.Set((int)FixedSpawnPrice, value);
                    break;
                }
                
                case OnMergeAddSameGradeRandomWeapon:
                {
                    unit.Variables.Set((int)OnMergeAddSameGradeRandomWeapon, value);
                    break;
                }
                
                default:
                    throw new ArgumentException($"{type} is not allowed in this context");
            }
        }
    }
}
