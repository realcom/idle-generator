using System;
using System.Collections.Generic;
using System.Numerics;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using RBush;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#else
using Commons.Utility;
#endif

namespace Commons.Game
{
    public partial class GameUnit
    {
        public static readonly FixedFloat CollideSearchRange = 5f; 
        public static readonly FixedFloat MaxMovePerTick = 0.25f;
        public static readonly FixedFloat SqrMoveDistanceEpsilon = 0.0025f;

        private bool _positionDirty;
        
        public bool IsCollideWith(GameUnit other)
        {
            if (other.IsGhost)
                return false;
            if (other.CollideSize == FixedFloat.Zero)
                return false;
            return Board.IsCollideWith(team_, other.team_);
        }

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

            var position = (FixedVector2)position_;
            
            var collideSize = CollideSize;
            if (collideSize > 0f && !IsGhost)
            {
                position += CollideOffset;
                
                var unitCollided = false;
                var searchRange = CollideSearchRange + collideSize;
                var direction = (FixedVector2)direction_;
                var remainedOffset = FixedFloat.Zero;
                using var envelopes = Board.GetUnitsInBound(new Envelope((float)(position.x - searchRange),
                    (float)(position.y - searchRange), (float)(position.x + searchRange), (float)(position.y + searchRange)));
                foreach (var envelope in envelopes)
                {
                    var unit = envelope.Unit;
                    if (ReferenceEquals(unit, this))
                        continue;
                    if (!IsCollideWith(unit))
                        continue;
                    var d = unit.position_ - position;
                    d += unit.CollideOffset;
                    var dot = FixedVector2.Dot(d, direction);
                    if (dot <= FixedFloat.Zero)
                        continue;
                    var dSqrMag = d.sqrMagnitude;
                    if (dSqrMag < SqrMoveDistanceEpsilon)
                        continue;
                    var r = collideSize + unit.CollideSize;
                    var rSqr = r * r;
                    if (dSqrMag < rSqr)
                    {
                        unitCollided = true;
                        if (remainedOffset == FixedFloat.Zero)
                            remainedOffset = GameBoard.FixedFloatTickDuration * ((FixedVector2)velocity_).magnitude;
                        var dMag = FixedFloatMath.Sqrt(dSqrMag);
                        var push = r - dMag;
                        var cos = dot / dMag;
                        var offset = cos * push;
                        if (offset < remainedOffset)
                        {
                            var move = (push / dMag) * d;
                            if (ResourceMap.Global.BoardConstants.FixX)
                                move.x = FixedFloat.Zero;
                            if (ResourceMap.Global.BoardConstants.FixY)
                                move.y = FixedFloat.Zero;
                            position -= move;
                            remainedOffset -= offset;
                        }
                        else
                        {
                            var move = (remainedOffset / cos / dMag) * d;
                            if (ResourceMap.Global.BoardConstants.FixX)
                                move.x = FixedFloat.Zero;
                            if (ResourceMap.Global.BoardConstants.FixY)
                                move.y = FixedFloat.Zero;
                            position -= move;
                            break;
                        }
                    }
                }

                if (unitCollided)
                    state_ |= StateFlag.CollidedUnit;
                else
                    state_ &= ~StateFlag.CollidedUnit;
                
                position -= CollideOffset;
            }
            
            position = Board.ResMap.UnitTerrain.GetNearbyPositionOnTerrain(position, Board.DisabledTerrainTriangles, out var collided);
            position_.Set(position);
            
            if (collided)
                state_ |= StateFlag.CollidedWall;
            else
                state_ &= ~StateFlag.CollidedWall;
            
            RefreshHitGeometry();

            return true;
        }
        
        private void RefreshHitGeometry()
        {
            var center = (FixedVector2)position_;
            center += HitOffset;
                
            HitGeometry = new Circle(center, HitSize);
            HitBoundingBoxEnvelope.Set(HitGeometry.GetBoundingBox());
        }

        public void SetDirection(FixedVector2 direction)
        {
            if (!IsAlive)
                return;
            if (ResourceMap.Global.BoardConstants.FixX)
                direction.x = FixedFloat.Zero;
            if (ResourceMap.Global.BoardConstants.FixY)
                direction.y = FixedFloat.Zero;
            direction.Normalize();
            if (direction == FixedVector2.zero)
                direction_.Set(FixedVector2.right);
            else
                direction_.Set(direction);
        }

        public void TeleportToPosition(FixedVector2 position)
        {
            if (!IsAlive)
                return;
            position = Board.ResMap.UnitTerrain.GetNearbyPositionOnTerrain(position, Board.DisabledTerrainTriangles, out _);
            if (ResourceMap.Global.BoardConstants.FixX)
                position.x = position_.X;
            if (ResourceMap.Global.BoardConstants.FixY)
                position.y = position_.Y;
            SetPosition(position);
        }

        public void LookAt(FixedVector2 position)
        {
            SetDirection(position - Center);
        }
        
        public void LookAt(GameUnit unit)
        {
            LookAt(unit.Center);
        }

        internal void Stop()
        {
            moveDirection_ = null;
            moveDestination_ = null;
            Path.Clear();
            state_ &= ~StateFlag.Running;
        }

        internal void SetMoveDirection(FixedVector2 direction)
        {
            if (!IsAlive)
                return;
            if (ResourceMap.Global.BoardConstants.FixX)
                direction.x = FixedFloat.Zero;
            if (ResourceMap.Global.BoardConstants.FixY)
                direction.y = FixedFloat.Zero;
            direction.Normalize();
            if (direction == FixedVector2.zero)
            {
                Stop();
                return;
            }
            
            moveDirection_ = (Vector2Message)direction;
            moveDestination_ = null;
            Path.Clear();
            
            if (!IsMovable)
                return;
            
            state_ |= StateFlag.Running;
        }
        
        internal void SetMoveDestination(FixedVector2 position)
        {
            if (!IsAlive)
                return;

            position = Board.ResMap.UnitTerrain.GetNearbyPositionOnTerrain(position, Board.DisabledTerrainTriangles, out _, range: 8f);
            if (ResourceMap.Global.BoardConstants.FixX)
                position.x = position_.X;
            if (ResourceMap.Global.BoardConstants.FixY)
                position.y = position_.Y;
            
            moveDirection_ = null;
            moveDestination_ = (Vector2Message)position;
            Path.Clear();
            
            if (!IsMovable)
                return;

            Board.ResMap.UnitTerrain.FindPath(position_, position, Board.DisabledTerrainTriangles, Path);
            if (Path.Count > 0)
                state_ |= StateFlag.Running;
            else
                Stop();
        }
        
        internal void Knockback(FixedVector2 direction, uint duration, FixedFloat distance, IAttackSource attackSource)
        {
            if (duration == 0)
                return;
            var attacker = attackSource.Attacker;
            
            if (attacker != null)
            {
                // skill 이고 태그 KnockbackByStat 가 붙어있을 때만 확률 / 효율 스탯 반영
                var knockDistanceMultiplier = FixedFloat.One;
                if (attackSource is GameSkill skill && skill.ResSkill.ContainsTag(Tag.KnockbackByStat))
                {
                    var totalKnockbackPercent = attacker.Stat.KnockbackPercent;
                    if (skill.ItemDataId != 0)
                    {
                        var resItem = ResourceItem.Get(skill.ItemDataId)!;
                        totalKnockbackPercent += attacker?.ItemGroupStats.GetValueOrDefault(resItem.Group)?.KnockbackPercent ?? FixedFloat.Zero;

                        if (Board.PlayerActiveInventoryData.TryGetValue(this.PlayerId, out var activeInventoryData) &&
                            activeInventoryData.SlotsByItemId.TryGetValue(skill.ItemId, out var slots))
                        {
                            foreach (var slot in slots)
                            {
                                totalKnockbackPercent += attacker?.SlotStats.GetValueOrDefault(slot)?.KnockbackPercent ?? FixedFloat.Zero;
                            }
                        }
                    }
                    
                    var knockbackProb = FixedFloatMath.Max(FixedFloat.Zero, totalKnockbackPercent / FixedFloat.Hundred);
                    var canKnockback = knockbackProb > FixedFloat.Zero && Board.RandomFloat() < knockbackProb;

                    if (!canKnockback)
                        return;

                    var totalKnockbackEfficiency = attacker.Stat.KnockbackEfficiencyPercent;
                    knockDistanceMultiplier += FixedFloatMath.Max(FixedFloat.Zero, totalKnockbackEfficiency / FixedFloat.Hundred);
                }

                distance *= attacker.Weight / Weight;
                distance *= knockDistanceMultiplier;
            }
            

            if (knockbackTick_ > 0 && (state_ & StateFlag.Charging) == 0)
            {
                var prevDistance = knockbackTick_ * knockbackSpeed_;
                if (prevDistance > distance)
                    return;
            }
            
            if (ResourceMap.Global.BoardConstants.FixX)
                direction.x = FixedFloat.Zero;
            if (ResourceMap.Global.BoardConstants.FixY)
                direction.y = FixedFloat.Zero;
            direction.Normalize();
            if (direction == FixedVector2.zero)
                return;

            Stop();
            knockbackDirection_ = (Vector2Message)direction;
            knockbackTick_ = duration;
            knockbackSpeed_ = (float)(distance / duration * GameBoard.FixedFloatTicksPerSecond);
            state_ |= StateFlag.Knockback;
            state_ &= ~StateFlag.Charging;
        }
        
        internal void StopKnockback()
        {
            if ((state_ & StateFlag.Knockback) == 0)
                return;
            
            knockbackDirection_ = null;
            knockbackSpeed_ = 0f;
            knockbackTick_ = 0;
            state_ &= ~StateFlag.Knockback;
        }
        
        internal void Charge(FixedVector2 direction, uint duration, FixedFloat distance, bool adjustDistanceToTarget = false)
        {
            if (!IsAlive)
                return;
            if (duration == 0)
                return;
            
            if (ResourceMap.Global.BoardConstants.FixX)
                direction.x = FixedFloat.Zero;
            if (ResourceMap.Global.BoardConstants.FixY)
                direction.y = FixedFloat.Zero;
            direction.Normalize();
            if (direction == FixedVector2.zero)
                return;
            
            Stop();
            knockbackDirection_ = (Vector2Message)direction;
            knockbackTick_ = duration;
            if (adjustDistanceToTarget && Target != null)
            {
                var targetDistance = FixedVector2.Distance(position_, Target.position_) - Target.CollideSize - CollideSize;
                if (targetDistance < distance)
                    distance = targetDistance;
            }
            knockbackSpeed_ = (float)(distance / duration * GameBoard.FixedFloatTicksPerSecond);
            state_ |= StateFlag.Charging;
            state_ &= ~StateFlag.Knockback;
        }
        
        internal void StopCharge()
        {
            if ((state_ & StateFlag.Charging) == 0)
                return;
            
            knockbackDirection_ = null;
            knockbackSpeed_ = 0f;
            knockbackTick_ = 0;
            state_ &= ~StateFlag.Charging;
        }
        
        private void UpdateMove()
        {
            var position = (FixedVector2)position_;
            
            if (HasOwner && positionOffset_ != null)
            {
                var owner = Owner!;
                position = owner.position_ + (FixedVector2)positionOffset_;
                SetPosition(position);
                state_ = (state_ & ~StateFlag.Running) | (owner.state_ & StateFlag.Running);
                return;
            }

            if (knockbackTick_ > 0)
            {
                var direction = (FixedVector2)knockbackDirection_;
                velocity_.Set(knockbackSpeed_ * direction);
                
                var distance = GameBoard.FixedFloatTickDuration * knockbackSpeed_;
                while (distance > MaxMovePerTick)
                {
                    position += MaxMovePerTick * direction;
                    position = Board.ResMap.UnitTerrain.GetNearbyPositionOnTerrain(position, Board.DisabledTerrainTriangles, out var collided);
                    if (collided)
                    {
                        distance = FixedFloat.Zero;
                        break;
                    }
                    distance -= MaxMovePerTick;
                }
                if (distance == FixedFloat.Zero)
                    SetPosition(position);
                else
                    SetPosition(position + distance * direction);
                
                if (--knockbackTick_ == 0)
                {
                    knockbackDirection_ = null;
                    knockbackSpeed_ = 0f;
                    state_ &= ~StateFlag.Knockback;
                    state_ &= ~StateFlag.Charging;
                }
                
                return;
            }

            if (Board.HasBlockedAction(GameBoard.Types.BlockActionFlag.Move))
                return;

            if (!IsMovable)
            {
                velocity_.Set(FixedVector2.zero);
                return;
            }
            
            if (moveDirection_ != null)
            {
                if ((state_ & StateFlag.Running) == 0)
                    state_ |= StateFlag.Running;
                direction_.Set(moveDirection_);
                velocity_.Set(MoveSpeed * (FixedVector2)direction_);
            }
            else if (moveDestination_ != null)
            {
                if (Path.Count == 0)
                {
                    Board.ResMap.UnitTerrain.FindPath(position, moveDestination_, Board.DisabledTerrainTriangles, Path);
                    if (Path.Count == 0)
                    {
                        Stop();
                        return;
                    }
                    state_ |= StateFlag.Running;
                }
                
                var d = (FixedVector2)Path[0] - position;
                var mag = d.magnitude;
                if (mag > FixedFloat.Zero)
                    direction_.Set(d / mag);
                if (mag < MoveSpeedPerTick)
                {
                    position = Path[0];
                    SetPosition(position);
                    velocity_.Set(d / GameBoard.FixedFloatTickDuration);
                    Path.RemoveAt(0);
                    if (Path.Count == 0)
                    {
                        var destination = (FixedVector2)moveDestination_;
                        if ((destination - position).sqrMagnitude < SqrMoveDistanceEpsilon)
                            Stop();
                        else
                            SetMoveDestination(destination);
                    }
                    return;
                }
                velocity_.Set(MoveSpeed * ((FixedVector2)direction_).normalized);
            }
            else
            {
                velocity_.Set(FixedVector2.zero);
                return;
            }
            
            SetPosition(position + GameBoard.TickDuration * (FixedVector2)velocity_);
        }
    }
}
