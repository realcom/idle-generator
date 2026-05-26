using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using Commons.Game.Events;
using Commons.Game.Interfaces;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Utility;
using static Commons.Resources.ResourceSkill.Types;
using static Commons.Resources.ResourceSkill.Types.Timeline.Types;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameSkill
    {
        private bool _inited;
        
        public GameBoard Board { private set; get; }
        private ResourceTrigger? _triggerOnUpdate;
        private ResourceTrigger? _triggerOnAttack;
        private ResourceTrigger? _triggerOnHeal;
        private ResourceTrigger? _triggerOnDestroy;
        private ResourceTrigger? _triggerOnKill;
        private ResourceTrigger? _triggerOnOwnerKill;

        public FixedFloat Scale { private set; get; } = FixedFloat.One;

        public ResourceSkill ResSkill { private set; get; }
        public ResourceItem? ResItem { private set; get; }

        private int _timelineIdx = -1;
        private uint _timelineTick;
        private uint _timelineUnitDisableMoveTick;
        private readonly List<Hit> _hits = new();
        public IEnumerable<Hit> Hits => _hits;

        public GameUnit? Sender => Board.GetUnitById(senderUnitId_);
        public GameUnit? Target => Board.GetUnitById(targetUnitId_);

        public bool Destroyed { private set; get; }
        
        public bool IsEnemyWith(GameUnit unit)
        {
            return Board.IsEnemyWith(team_, unit.Team);
        }

        partial void OnConstruction()
        {
            variables_ = new ResourceTrigger.Types.Variables();
        }
        
        internal GameSkill Init(GameBoard board)
        {
            if (_inited)
                return this;
            _inited = true;
            Board = board;
            
            ResSkill = ResourceSkill.Get(dataId_)!;
            if (Config.IsDebug && ResSkill == null)
            {
                Config.LogError($"GameSkill.Init failed: ResourceSkill [{dataId_}] doesn't exist");
                throw new InvalidOperationException();
            }
            ResItem = ResourceItem.Get(ItemDataId);
            
            _triggerOnUpdate = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnUpdate);
            _triggerOnAttack = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnAttack);
            _triggerOnHeal = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnHeal);
            _triggerOnDestroy = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnDestroy);
            _triggerOnKill = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnKill);
            _triggerOnOwnerKill = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnOwnerKill);
            
            Scale = ResSkill.Scale;
            //Scale *= Sender?.Scale ?? FixedFloat.One;
            Scale *= Sender?.SkillScale ?? FixedFloat.One;
            
            var addScalePercent = FixedFloat.Zero;
            addScalePercent += Sender?.SkillGroupStats.GetValueOrDefault(ResSkill.Group)?.SkillScalePercent?? FixedFloat.Zero;
            Scale *= FixedFloat.One + addScalePercent / FixedFloat.Hundred;

            if (ResSkill.ContainsTag(Tag.ScaleRemappingPossible))
            {
                var remappedScalePercent = Sender?.Stat.GameplayAttackPercent ?? FixedFloat.Zero;
                if (remappedScalePercent < FixedFloat.Zero)
                {
                    remappedScalePercent = FixedFloatMath.MapRangeClamped(
                        remappedScalePercent,
                        FixedFloatMath.Min(ResourceSkill.Global.Value.SizeClampMinAttackPercent, FixedFloat.Zero),
                        FixedFloat.Zero,
                        FixedFloatMath.Min(ResourceSkill.Global.Value.MinClampedSizePercent, FixedFloat.Zero),
                        FixedFloat.Zero
                    );
                }
                else if (remappedScalePercent > FixedFloat.Zero)
                {
                    remappedScalePercent = FixedFloatMath.MapRangeClamped(
                        remappedScalePercent,
                        FixedFloat.Zero,
                        FixedFloatMath.Max(ResourceSkill.Global.Value.SizeClampMaxAttackPercent, FixedFloat.Zero),
                        FixedFloat.Zero,
                        FixedFloatMath.Max(ResourceSkill.Global.Value.MaxClampedSizePercent, FixedFloat.Zero)
                    );
                }
                
                Scale *= FixedFloat.One + remappedScalePercent / FixedFloat.Hundred;   
            }

            if (tick_ == 0)
            {
                if (level_ == 0)
                    level_ = 1;

                if (timelineSpeed_ == 0f || !ResSkill.UseAttackSpeed)
                    timelineSpeed_ = 1f;
            }

            if (tick_ == 0)
            {
                _timelineIdx += 1;
                var timeline = ResSkill.Timelines[_timelineIdx];
                _timelineTick = GameBoard.TimeToTicks((FixedFloat)timeline.Time / timelineSpeed_);
            }
            else
            {
                while (++_timelineIdx < ResSkill.Timelines.Count)
                {
                    var timeline = ResSkill.Timelines[_timelineIdx];
                    _timelineTick = GameBoard.TimeToTicks((FixedFloat)timeline.Time / timelineSpeed_);
                    if (_timelineTick > tick_)
                        break;
                    switch (timeline.ActionCase)
                    {
                        case Timeline.ActionOneofCase.Hit:
                        {
                            if (_timelineTick == tick_)
                                _hits.Add(timeline.Hit);
                            break;
                        }
                        case Timeline.ActionOneofCase.UnitDisableMove:
                        {
                            var duration = GameBoard.TimeToTicks((FixedFloat)timeline.UnitDisableMove.Duration / timelineSpeed_);
                            if (_timelineTick + duration > tick_)
                                _timelineUnitDisableMoveTick = duration - (tick_ - _timelineTick) - 1;
                            break;
                        }
                    }
                }
            }

            return this;
        }
        
        private ResourceTrigger.Types.State CreateState()
        {
            var state = ResourceTrigger.Types.State.Rent(variables_);
            state.callerUnit = Sender;
            state.callerSkill = this;
            
            if (Sender != null)
            {
                if (Sender.VariablesByItemId.TryGetValue(ItemId, out var variables))
                {
                    var keys = variables.Variables_.Keys;
                    foreach (var key in keys)
                    {
                        state.CallerVariables.Set(key, variables.Get(key));
                    }
                }
            }
            
            return state;
        }

        internal void HandleOwnerKill(GameUnit owner, IAttackSource? attackSource = null)
        {
            using var state = CreateState();
            state.slotUnit = owner;

            var gameBuff = attackSource as GameBuff;
            var gameSkill = attackSource as GameSkill;

            state.slotBuff = gameBuff;
            state.slotSkill = gameSkill;

            _triggerOnOwnerKill?.Run(Board, state);
        }

        private void RunTriggerOnUpdate()
        {
            if (_triggerOnUpdate == null)
                return;
            if ((Tick - 1) % _triggerOnUpdate.Period != 0)
                return;
            
            using var state = CreateState();
            _triggerOnUpdate.Run(Board, state);
        }
        
        private void RunTimelines()
        {
            _hits.Clear();
            while (_timelineIdx < ResSkill.Timelines.Count)
            {
                if (_timelineTick > tick_)
                    break;
                var timeline = ResSkill.Timelines[_timelineIdx];
                
                if (++_timelineIdx < ResSkill.Timelines.Count)
                    _timelineTick = GameBoard.TimeToTicks((FixedFloat)ResSkill.Timelines[_timelineIdx].Time / timelineSpeed_);

                switch (timeline.ActionCase)
                {
                    case Timeline.ActionOneofCase.Hit:
                    {
                        _hits.Add(timeline.Hit);
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitDisableMove:
                    {
                        _timelineUnitDisableMoveTick = GameBoard.TimeToTicks((FixedFloat)timeline.UnitDisableMove.Duration / timelineSpeed_);
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitDisableAction:
                    {
                        var disableAction = timeline.UnitDisableAction;
                        Sender?.DisableAction(GameBoard.TimeToTicks((FixedFloat)disableAction.Duration / timelineSpeed_), disableAction.Priority);
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitLookAt:
                    {
                        var unit = Sender;
                        if (unit == null)
                            break;
                        if (timeline.UnitLookAt.LookMoveDirection)
                        {
                            if (unit.MoveDirection != null)
                                unit.SetDirection(unit.MoveDirection);
                        }
                        else
                            unit.SetDirection(((FixedVector2)unit.Direction).Rotate(timeline.UnitLookAt.Angle));
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitCharge:
                    {
                        var unit = Sender;
                        if (unit == null)
                            break;
                        var charge = timeline.UnitCharge;
                        unit.Charge(((FixedVector2)unit.Direction).Rotate(charge.Angle), GameBoard.TimeToTicks(charge.Duration), charge.Distance * (FixedFloat.One + unit.Stat.MoveSpeedPercent/ FixedFloat.Hundred), charge.AdjustDistanceToTarget);
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitKnockback:
                    {
                        var unit = Sender;
                        if (unit == null)
                            break;
                        var knockback = timeline.UnitKnockback;
                        unit.Knockback(((FixedVector2)unit.Direction).Rotate(knockback.Angle), GameBoard.TimeToTicks(knockback.Duration), knockback.Distance, this);
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitUseSkill:
                    {
                        var unit = Sender;
                        if (unit == null)
                            break;
                        var unitUseSkill = timeline.UnitUseSkill;
                        unit.UseSkill(unitUseSkill.UseSkill, targetUnitId: targetUnitId_, itemId: itemId_, itemDataId: itemDataId_, checkCooldownBySkillId: true);
                        break;
                    }
                    case Timeline.ActionOneofCase.AddSkill:
                    {
                        var unit = Sender;
                        if (unit == null)
                            break;
                        var addSkill = timeline.AddSkill;
                        unit.UseSkill(addSkill.UseSkill, position: position_, direction: direction_,
                            targetUnitId: targetUnitId_, timelineSpeed: timelineSpeed_, ignoreActable: true, itemId: itemId_, itemDataId: itemDataId_, checkCooldownBySkillId: true);
                        break;
                    }
                    case Timeline.ActionOneofCase.OwnerUseSkill:
                    {
                        var unit = Sender?.Owner;
                        if (unit == null)
                            break;
                        
                        var ownerUseSkill = timeline.OwnerUseSkill;
                        unit.UseSkill(ownerUseSkill.UseSkill, position:  Sender?.Position ?? unit.Position, direction:  Sender?.Direction ?? unit.Direction,
                            itemId: itemId_, itemDataId: itemDataId_, checkCooldownBySkillId: true);
                        break;
                    }
                    case Timeline.ActionOneofCase.SelfAddBuff:
                    {
                        var unit = Sender;
                        if (unit == null)
                            break;
                        var selfAddBuff = timeline.SelfAddBuff;
                        unit.QueueAddBuff(new GameUnit.QueuedAddBuff(unit, selfAddBuff.AddBuff, level_)
                        {
                            Duration = timelineSpeed_ * selfAddBuff.AddBuff.Duration,
                        });
                        break;
                    }
                    case Timeline.ActionOneofCase.UnitPlayAnimation:
                    {
                        Board.QueueEvent(new UnitPlayAnimationEvent
                        {
                            UnitId = senderUnitId_,
                            SkillDataId = ResSkill.Id,
                            Animation = timeline.UnitPlayAnimation.Animation,
                            Speed = timelineSpeed_,
                        });
                        break;
                    }
                    case Timeline.ActionOneofCase.PlayFx:
                    {
                        var playFx = timeline.PlayFx;
                        Board.QueueEvent(new PlayFxEvent
                        {
                            UnitId = senderUnitId_,
                            SkillId = id_,
                            Position = position_,
                            Prefab = playFx.Prefab,
                            Speed = timelineSpeed_,
                        });
                        break;
                    }
                    case Timeline.ActionOneofCase.ShowDialog:
                    {
                        var showDialog = timeline.ShowDialog;
                        var showDialogEvent = new ShowDialogEvent
                        {
                            Image = showDialog.Image,
                            Name = showDialog.Name,
                            Message = showDialog.Message,
                            PauseBoard = showDialog.PauseBoard,
                            PreFx = showDialog.PreFx,
                            PostFx = showDialog.PostFx,
                            Duration = showDialog.Duration,
                            interactionKey = showDialog.InteractionKey,
                        };
                        showDialogEvent.Portraits.AddRange(showDialog.Portraits);
                        showDialogEvent.interactionChoices.AddRange(showDialog.InteractionChoices);
                        Board.QueueEvent(showDialogEvent);
                        break;
                    }
                    case Timeline.ActionOneofCase.SetUpdateSpeed:
                    {
                        var setUpdateSpeed = timeline.SetUpdateSpeed;
                        Board.QueueEvent(new SetUpdateSpeedEvent
                        {
                            BoardSpeed = setUpdateSpeed.BoardSpeed,
                            EditorSpeed = setUpdateSpeed.EditorSpeed,
                            Duration = setUpdateSpeed.Duration,
                        });
                        break;
                    }
                    case Timeline.ActionOneofCase.RunTrigger:
                    {
                        foreach (var initVariable in timeline.RunTrigger.InitVariables)
                            variables_.Set(initVariable.CallerKey, initVariable.Value);
                        
                        using var state = CreateState();
                        timeline.RunTrigger.Trigger.Run(Board, state);
                        break;
                    }
                    case Timeline.ActionOneofCase.Destroy:
                    {
                        Destroy();
                        return;
                    }
                }
            }

            if (_timelineUnitDisableMoveTick > 0)
            {
                _timelineUnitDisableMoveTick -= 1;
                Sender?.DisableMove(2);
            }
        }
        
        internal void RunLogic()
        {
            try
            {
                RunLogicInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameSkill.RunLogic failed: {ex}");
            }
        }

        private void RunLogicInternal()
        {
            if (Destroyed)
                return;

            if (Tick == 0)
            {
                var position = (FixedVector2)position_;
                var direction = (FixedVector2)direction_;
                var velocity = (FixedVector2)velocity_;
                var acceleration = (FixedVector2)acceleration_;
                
                if (ResSkill.InitPosition != null)
                    position += ((FixedVector2)ResSkill.InitPosition).Rotate(direction);
                if (ResSkill.InitRotation != 0f)
                    direction = direction.Rotate(FixedFloatMath.Deg2Rad * ResSkill.InitRotation);
                
                var sender = Sender;
                if (sender?.ShotOffset != null && !ResSkill.IgnoreShotOffset)
                    position += sender.ShotOffset;
                
                switch (ResSkill.ProjectileType)
                {
                    case ProjectileType.Straight:
                    {
                        if (ResSkill.InitAcceleration != null)
                            acceleration += ((FixedVector2)ResSkill.InitAcceleration).Rotate(direction);
                        if (ResSkill.InitAbsoluteAcceleration != null)
                            acceleration += ResSkill.InitAbsoluteAcceleration;
                        
                        if (ResSkill.ContainsTag(Tag.AutoAim) && acceleration != FixedVector2.zero)
                        {
                            var target = Target ?? sender?.Target;
                            if (target != null)
                            {
                                var initSpeed = (FixedFloat)ResSkill.InitSpeed;
                                var targetPosition = target.Center;
                                var relativePosition = targetPosition - position;

                                var a = acceleration.sqrMagnitude / FixedFloat.Four;
                                var negativeB = FixedVector2.Dot(acceleration, relativePosition) + initSpeed * initSpeed;
                                var c = relativePosition.sqrMagnitude;

                                var discriminant = negativeB * negativeB - FixedFloat.Four * a * c;
                                if (discriminant >= FixedFloat.Zero)
                                {
                                    discriminant = FixedFloatMath.Sqrt(discriminant);
                                    FixedFloat squaredTimeToIntercept;
                                    if (negativeB > discriminant)
                                        squaredTimeToIntercept = (negativeB - discriminant) / (FixedFloat.Two * a);
                                    else
                                        squaredTimeToIntercept = (negativeB + discriminant) / (FixedFloat.Two * a);
                                    if (squaredTimeToIntercept > FixedFloat.Zero)
                                    {
                                        var targetPositionAtIntercept = targetPosition - FixedFloat.Half * acceleration * squaredTimeToIntercept;
                                        direction = (targetPositionAtIntercept - position).normalized;
                                    }
                                }
                            }
                            else
                            {
                                Destroy(skipPostDestroyProcess: true);
                                return;
                            }
                        }
                        
                        velocity += ResSkill.InitSpeed * direction;
                        break;
                    }
                    
                    case ProjectileType.Parabolic:
                    {
                        var target = Target ?? sender?.Target;
                        if (target != null)
                        {
                            FixedFloat parabolicHeight = ResSkill.TargetHeight;
                            FixedFloat arrivalTime = ResSkill.TargetArrivalTime;
                            if (arrivalTime == FixedFloat.Zero)
                            {
                                Config.LogError($"Arrival time would be set in parabolic projectile {ResSkill.Id}");
                                return;
                            }

                            var predictedTarget = target.Center;
                            if (target.MoveDestination != null)
                            {
                                predictedTarget = target.Center! + (FixedVector2)target.Direction * target.Stat.MoveSpeed * arrivalTime;    
                            }
                            
                            var dx = predictedTarget.x- position_.X;
                            var dy = predictedTarget.y - position_.Y;
                            var h = parabolicHeight + position_.Y; // 현재 위치에서 얼마나 위로 올라갈 것인가 (상대 높이)
                        
                            var g = FixedFloat.NegativeOne * FixedFloat.Eight * h / (arrivalTime * arrivalTime); // 음수
                            var vy = (dy - FixedFloat.Half * g * arrivalTime * arrivalTime) / arrivalTime;
                            var vx = dx / arrivalTime;

                            var forward = new FixedVector2(1, 0);
                            if (dx < 0) forward = new FixedVector2(-1, 0);
                            var upward = new FixedVector2(0, 1);

                            velocity = forward * vx + upward * vy;
                            acceleration = new FixedVector2(0, g);
                        }
                        else
                        {
                            Destroy(skipPostDestroyProcess: true);
                            return;
                        }

                        break;
                    }
                }

                position_.Set(position);
                direction_.Set(direction);
                velocity_.Set(velocity);
                acceleration_.Set(acceleration);
                
                foreach (var initVariable in ResSkill.InitVariables)
                    variables_.Set(initVariable.CallerKey, initVariable.Value);
                
                var triggerOnStart = ResSkill.GetTrigger(ResourceTrigger.Types.Type.OnStart);
                
                using var state = CreateState();
                triggerOnStart?.Run(Board, state);

                if (ResSkill.SelfAddDamage != null)
                    sender?.AddDamage(this, ResSkill.SelfAddDamage);
                if (ResSkill.SelfAddHeal != null)
                    sender?.AddHeal(this, ResSkill.SelfAddHeal);
                foreach (var addBuff in ResSkill.SelfAddBuffs)
                    sender?.QueueAddBuff(new GameUnit.QueuedAddBuff(sender, addBuff, level_));

                sender?.AddItems(ResSkill.SelfAddItemGroups, sender);
            }
            
            Tick += 1;
            RunTriggerOnUpdate();
            RunTimelines();
        }

        internal void Update()
        {
            try
            {
                UpdateInternal();
            }
            catch (Exception ex)
            {
                Config.LogError($"GameSkill.Update failed: {ex}");
            }
        }

        private void UpdateInternal()
        {
            if (Destroyed)
                return;
            
            UpdateMove();
            FlushPosition();
            UpdateHit();
        }
        
        public void Destroy(bool skipPostDestroyProcess = false)
        {
            if (Destroyed)
                return;
            Destroyed = true;
            Board.QueueDestroySkill(this);
            
            using var state = CreateState();
            if (!skipPostDestroyProcess)
            {
                _triggerOnDestroy?.Run(Board, state);
                
                if (ResSkill.ConsecutiveUseSkill != null)
                {
                    var sender = Sender;
                    sender?.UseSkill(ResSkill.ConsecutiveUseSkill, position_, direction_, itemId: itemId_,
                        itemDataId: itemDataId_, timelineSpeed: timelineSpeed_, ignoreActable: true);
                }
            }
        }
    }
}
