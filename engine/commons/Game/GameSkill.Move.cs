using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameSkill
    {
        private bool _positionDirty;

        public void SetPosition(FixedVector2 position)
        {
            position_.Set(position);
            _positionDirty = true;
        }

        internal bool FlushPosition()
        {
            if (!_positionDirty)
                return false;
            _positionDirty = false;
            
            var position = Board.ResMap.SkillTerrain.GetNearbyPositionOnTerrain(position_,
                Board.DisabledTerrainTriangles, out var collided);
            position_.Set(position);

            if (collided)
                Destroy();

            return true;
        }

        public void SetDirection(FixedVector2 direction)
        {
            direction.Normalize();
            if (direction == FixedVector2.zero)
                direction_.Set(FixedVector2.right);
            else
                direction_.Set(direction);
        }

        public void LookAt(FixedVector2 position)
        {
            SetDirection(position - position_);
        }

        public void LookAt(GameUnit unit)
        {
            LookAt(unit.Center);
        }
        
        public void SetAcceleration(FixedVector2 acceleration)
        {
            acceleration_.Set(acceleration);
        }
        
        private void UpdateMove()
        {
            FixedVector2 position;
            switch (ResSkill.ProjectileType)
            {
                case ResourceSkill.Types.ProjectileType.Straight:
                case ResourceSkill.Types.ProjectileType.Parabolic:
                {
                    FixedVector2 v = velocity_;
                    if (acceleration_.X != 0f || acceleration_.Y != 0f)
                    {
                        v += GameBoard.FixedFloatTickDuration * (FixedVector2)acceleration_;
                        velocity_.Set(v);
                    }

                    SetDirection(v);
                    position = position_ + GameBoard.FixedFloatTickDuration * v;
                    break;
                }
                case ResourceSkill.Types.ProjectileType.Target:
                {
                    var target = Board.GetUnitById(targetUnitId_);
                    if (target == null)
                    {
                        Destroy();
                        return;
                    }
                    
                    LookAt(target.Center);
                    velocity_.Set(ResSkill.InitSpeed * (FixedVector2)direction_);
                    position = position_ + GameBoard.FixedFloatTickDuration * (FixedVector2)velocity_;
                    break;
                }
                case ResourceSkill.Types.ProjectileType.Relative:
                {
                    var sender = Board.GetUnitById(senderUnitId_);
                    if (sender == null)
                    {
                        Destroy();
                        return;
                    }
                    position = sender.Center;
                    SetDirection(sender.Direction);
                    break;
                }
                default:
                    return;
            }
            
            SetPosition(position);
        }
    }
}
