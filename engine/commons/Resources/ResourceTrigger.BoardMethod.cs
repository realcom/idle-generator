using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets.Updates;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Packets.Updates;
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
        private static void RunMapMethod(Types.Call call, BoardMethod method, GameBoard board, Types.State state)
        {
            switch (method.Type)
            {
                case BoardMethod.Types.Type.AddUnit:
                {
                    var cnt = state.GetIntParameter(board, Count, 1);
                    var team = state.GetIntParameter(board, Team, GameBoard.Team.Enemy);
                    var angle = state.GetParameter(board, Angle, FixedFloat.MaxValue);
                    var direction = angle == FixedFloat.MaxValue ? default(FixedVector2?) : GeometricMath.AngleToUnitVector2(angle);
                    var locationId = state.GetIntParameter(board, LocationId);
                    var positionX = state.GetParameter(board, PositionX);
                    var positionY = state.GetParameter(board, PositionY);
                    var unitDataId = state.GetIntParameter(board, UnitDataId);
                    var offset = state.GetIntParameter(board, Offset);
                    
                    IEnumerable<FixedVector2> positions;
                    if (locationId == 0)
                        positions = Enumerable.Repeat(new FixedVector2(positionX, positionY), cnt);
                    else
                        positions = board.ResMap.GetBalancedLocationsById(locationId, cnt, board)
                            .Select(l => l.IGeometries.PickOne(board)!.GetRandomPoint(board));
                    foreach (var position in positions)
                    {
                        board.QueueAddUnit(new GameUnit
                        {
                            DataId = unitDataId,
                            Offset = offset,
                            Position = (Vector2Message)position,
                            Direction = (Vector2Message)(direction ?? GeometricMath.AngleToUnitVector2(FixedFloatMath.TwoPi * board.RandomFloat())),
                            Velocity = new Vector2Message(),
                            Team = team,
                        });
                    }
                    break;
                }
                case BoardMethod.Types.Type.GetUnitCount:
                {
                    var unitDataId = state.GetIntParameter(board, UnitDataId);
                    var count = board.GetUnitCountByDataId(unitDataId);
                    state.SetPredefinedVariable(board, Return, count);
                    break;
                }
                case BoardMethod.Types.Type.GetUnitCountByOffset:
                {
                    var offset = state.GetIntParameter(board, Offset);
                    var count = board.GetUnitCountByOffset(offset);
                    state.SetPredefinedVariable(board, Return, count);
                    break;
                }
                case BoardMethod.Types.Type.GetUnitCountByTeam:
                {
                    var team = state.GetIntParameter(board, Team);
                    var count = board.GetUnitCountByTeam(team);
                    state.SetPredefinedVariable(board, Return, count);
                    break;
                }
                case BoardMethod.Types.Type.RandomBetween:
                {
                    var min = state.GetParameter(board, Min);
                    var max = state.GetParameter(board, Max);
                    var value = board.RandomFloat() * (max - min) + min;
                    state.SetPredefinedVariable(board, Return, value);
                    break;
                }
                case BoardMethod.Types.Type.RandomIntBetween:
                {
                    var min = state.GetIntParameter(board, Min);
                    var max = state.GetIntParameter(board, Max);
                    var value = min + board.Random(max - min + 1);
                    state.SetPredefinedVariable(board, Return, value);
                    break;
                }
                case BoardMethod.Types.Type.StartTimer:
                {
                    var duration = state.GetParameter(board, Duration);
                    board.StartTimer(duration);
                    break;
                }
                case BoardMethod.Types.Type.AddTimer:
                {
                    var duration = state.GetParameter(board, Duration);
                    board.AddTimer(duration);
                    break;
                }
                case BoardMethod.Types.Type.StopTimer:
                {
                    board.StopTimer();
                    break;
                }
                case BoardMethod.Types.Type.PauseTimer:
                {
                    board.PauseTimer();
                    break;
                }
                case BoardMethod.Types.Type.ResumeTimer:
                {
                    board.ResumeTimer();
                    break;
                }
                case BoardMethod.Types.Type.KillAllUnits:
                {
                    var team = state.GetIntParameter(board, Team);
                    board.QueuePostAction(() =>
                    {
                        foreach (var unit in board.Units.Values)
                        {
                            if (unit.Team == team)
                                unit.HandleDead();
                        }
                    });
                    break;
                }
                
                case BoardMethod.Types.Type.KillUnitsByDataId:
                {
                    var unitDataId = state.GetIntParameter(board, UnitDataId);
                    
                    board.QueuePostAction(() =>
                    {
                        foreach (var unit in board.Units.Values)
                        {
                            if (unit.DataId == unitDataId)
                                unit.HandleDead();
                        }
                    });
                    break;
                }

                case BoardMethod.Types.Type.KillAllNormalUnits:
                {
                    var team = state.GetIntParameter(board, Team);
                    board.QueuePostAction(() =>
                    {
                        foreach (var unit in board.Units.Values)
                        {
                            if (unit.Team == team && unit.ResUnit.Type == ResourceUnit.Types.Type.Normal)
                                unit.HandleDead();
                        }
                    });
                    
                    break;
                }
                case BoardMethod.Types.Type.ToastMessage:
                {
                    var argumentString = call.ArgumentString;
                    var argumentExpressions = new FixedFloat[call.ArgumentExpressions.Count];
                    for (var i = 0; i < call.ArgumentExpressions.Count; i++)
                    {
                        argumentExpressions[i] = call.ArgumentExpressions[i].Evaluate(board, state);
                    }
                    BoardEvent newEvent = new ToastMessageEvent
                    {
                        ArgumentString = argumentString,
                        ArgumentExpressions = argumentExpressions
                    };
                    board.QueueEvent(newEvent);
                    break;
                }
                case BoardMethod.Types.Type.EndGame:
                {
                    var winningTeam = state.GetIntParameter(board, Team);
                    board.QueuePostAction(() =>
                    {
                        board.EndGame(winningTeam);
                    });
                    break;
                }
                case BoardMethod.Types.Type.SetNavigability:
                {
                    var triangleNumber = state.GetIntParameter(board, TriangleNumber);
                    var isNavigable = state.GetIntParameter(board, IsNavigable);
                    if (isNavigable == 0)
                    {
                        if (!board.DisabledTerrainTriangles.ContainsKey(triangleNumber))
                            board.DisabledTerrainTriangles.Add(triangleNumber, true);
                    }
                    else
                    {
                        if (board.DisabledTerrainTriangles.ContainsKey(triangleNumber))
                            board.DisabledTerrainTriangles.Remove(triangleNumber);
                    }
                    break;
                }
                case BoardMethod.Types.Type.GetAchievementProgress:
                {
                    var achievementDataId = state.GetIntParameter(board, AchievementDataId);
                    state.SetPredefinedVariable(board, Return, board.GetAchievementByDataId(achievementDataId).Progress);
                    break;
                }
                case BoardMethod.Types.Type.GetAchievementState:
                {
                    var achievementDataId = state.GetIntParameter(board, AchievementDataId);
                    state.SetPredefinedVariable(board, Return, (int)board.GetAchievementByDataId(achievementDataId).State);
                    break;
                }
                case BoardMethod.Types.Type.IncreaseAchievementProgress:
                {
                    var achievementDataId = state.GetIntParameter(board, AchievementDataId);
                    var progress = state.GetIntParameter(board, Progress, 1);
                    var playerId = state.GetIntParameter(board, PlayerId, 0);
                    var achievement = board.GetAchievementByDataId(achievementDataId);
                    if (achievement.State == PlayerAchievementMessage.Types.State.InProgress)
                    {
                        var resAch = ResourceAchievement.Get(achievementDataId)!;
                        achievement.Progress = Math.Min(resAch.TargetProgress, achievement.Progress + progress);
                        if (achievement.Progress >= resAch.TargetProgress)
                        {
                            if (resAch.AutoReward)
                                achievement.State = PlayerAchievementMessage.Types.State.Rewarded;
                            else
                                achievement.State = PlayerAchievementMessage.Types.State.Completed;
                        }
                    }
                    var increaseAchievementEvent = new IncreaseAchievementEvent
                    {
                        PlayerId = playerId,
                        AchievementDataId = achievementDataId,
                        Progress = progress
                    };
                    board.QueueEvent(increaseAchievementEvent);
                    break;
                }
                case BoardMethod.Types.Type.UseSkill:
                {
                    var skillDataId = state.GetIntParameter(board, SkillDataId);
                    var positionX = state.GetParameter(board, PositionX, 0);
                    var positionY = state.GetParameter(board, PositionY, 0);
                    board.UseSkill(skillDataId, new FixedVector2(positionX, positionY));
                    break;
                }
                
                
                case BoardMethod.Types.Type.IsAchievementCompleted:
                {
                    var achievementDataId = state.GetIntParameter(board, AchievementDataId);
                    var achievement = board.GetAchievementByDataId(achievementDataId);
                    state.SetPredefinedVariable(board, Return, (achievement.State == PlayerAchievementMessage.Types.State.Completed ||
                                                                       achievement.State == PlayerAchievementMessage.Types.State.Rewarded) ? 1 : 0);
                    break;
                }
                case BoardMethod.Types.Type.IsAchievementRewarded:
                {
                    var achievementDataId = state.GetIntParameter(board, AchievementDataId);
                    var achievement = board.GetAchievementByDataId(achievementDataId);
                    state.SetPredefinedVariable(board, Return, achievement.State == PlayerAchievementMessage.Types.State.Rewarded ? 1 : 0);
                    break;
                }
                case BoardMethod.Types.Type.MoveBoard:
                {
                    var mapDataId = state.GetIntParameter(board, MapDataId);
                    var playerId = state.GetIntParameter(board, PlayerId, 0);

                    var moveBoardEvent = new PlayerMoveBoardEvent
                    {
                        PlayerId = playerId,
                        MapDataId = mapDataId
                    };
                    board.QueueEvent(moveBoardEvent);
                    break;
                }
                case BoardMethod.Types.Type.GetUnitByDataId:
                {
                    var unitDataId = state.GetIntParameter(board, UnitDataId);
                    state.slotUnit = board.GetUnitByDataId(unitDataId);
                    break;
                }
                
                case BoardMethod.Types.Type.GetMainPlayerUnit:
                {
                    var unit = board.GetMainPlayerUnit();
                    state.slotUnit = unit;
                    break;
                }
                
                case BoardMethod.Types.Type.StartWaveEndSelectTrait:
                {
                    var level = state.GetIntParameter(board, Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type.Level);
                    var player = board.GetMainPlayer();
                    if (player == null)
                        break;
                    var resMap = board.ResMap;
                    var addItemGroup = resMap.WaveEndTraitItemGroups.Where(e => e.Level == level).ToArray()
                        .PickWeighted(board, e => e.ProbPercent)!;
                    player.SelectTraitEvents.Add(new SelectTraitEventMessage
                    {
                        State = SelectTraitEventMessage.Types.State.Pending,
                        TraitItemGroup = addItemGroup
                    });
                    
                    state.SetPredefinedVariable(board, Return, addItemGroup.UnitDataId);
                    
                    break;
                }
                
                case BoardMethod.Types.Type.StartLevelUpSelectTrait:
                {
                    var player = board.GetMainPlayer();
                    var unit = board.GetMainPlayerUnit(); 
                    if (player == null || unit == null)
                        break;
                    
                    board.SetSelectLevelUpTrait(player, unit);
                    if (player.SelectTraitEvents.Count == 1)
                    {
                        var traitDataIds = board.PickTraitCandidatesFromSelectTraitEvents(player, setToVariables: true);
                        board.QueueEvent(new SelectTraitEvent { });
                    }

                    break;
                }

                case BoardMethod.Types.Type.ShowSelectTrait:
                {
                    var player = board.GetMainPlayer();
                    if (player?.SelectTraitEvents.Count >= 1)
                    {
                        board.PickTraitCandidatesFromSelectTraitEvents(player, true);
                        board.QueueEvent(new SelectTraitEvent
                        {
                        });  
                    }
                    
                    break;
                }
                    
                case BoardMethod.Types.Type.SendWaveQueuedEvent:
                {
                    long playerId = state.GetIntParameter(board, PlayerId, 0);
                    if (playerId == 0)
                        playerId = board.GetMainPlayer()?.Id ?? playerId;
                    
                    board.QueueEvent(new WaveQueuedEvent()
                    {
                        PlayerId = playerId,
                    });
                    break;
                }
                case BoardMethod.Types.Type.SendWaveStartedEvent:
                {
                    long playerId = state.GetIntParameter(board, PlayerId, 0);
                    if (playerId == 0)
                        playerId = board.GetMainPlayer()?.Id ?? playerId;
                    
                    board.QueueEvent(new WaveStartedEvent()
                    {
                        PlayerId = playerId,
                    });
                    
                    break;
                }
                case BoardMethod.Types.Type.SendResetMapScrollEvent:
                {
                    long playerId = state.GetIntParameter(board, PlayerId, 0);
                    if (playerId == 0)
                        playerId = board.GetMainPlayer()?.Id ?? playerId;

                    board.QueueEvent(new ResetMapScrollEvent()
                    {
                        PlayerId = playerId,
                    });
                    break;
                }
                case BoardMethod.Types.Type.ShowPopup:
                {
                    var argumentString = call.ArgumentString;   
                    long playerId = state.GetIntParameter(board, PlayerId, 0);
                    if (playerId == 0)
                        playerId = board.GetMainPlayer()?.Id ?? playerId;
                    
                    var argumentExpressions = new FixedFloat[call.ArgumentExpressions.Count];
                    for (var i = 0; i < call.ArgumentExpressions.Count; i++)
                    {
                        argumentExpressions[i] = call.ArgumentExpressions[i].Evaluate(board, state);
                    }
                    
                    board.QueueEvent(new ShowPopupEvent()
                    {
                        PlayerId = playerId,
                        ArgumentString = argumentString,
                        ArgumentExpressions = argumentExpressions
                    });
                    
                    break;
                }

                case BoardMethod.Types.Type.GetMainPlayerUnitVariable:
                {
                    var unit = board.GetMainPlayerUnit();
                    var value = state.GetIntParameter(board , Value, 0);
                    state.SetPredefinedVariable(board, Return, unit?.Variables.GetInt(value) ?? 0);

                    break;
                }
                case BoardMethod.Types.Type.GetBoardState:
                {
                    var boardState = board.State;
                    state.SetPredefinedVariable(board, Return, (int)boardState);
                    break;
                }
                case BoardMethod.Types.Type.SetBoardState:
                {
                    var boardState = (GameBoard.Types.State)state.GetIntParameter(board, BoardState);
                    if (boardState == GameBoard.Types.State.Ended)
                    {
                        throw new ArgumentOutOfRangeException(nameof(boardState), "Can't set board state to ended");
                    }
                    
                    board.State = boardState;
                    board.QueueEvent(new BoardStateChangedEvent());
                    break;
                }

                case BoardMethod.Types.Type.BlockSkillAction:
                {
                    board.BlockAction(GameBoard.Types.BlockActionFlag.Skill);
                    break;
                }
                
                case BoardMethod.Types.Type.UnBlockSkillAction:
                {
                    board.UnblockAction(GameBoard.Types.BlockActionFlag.Skill);
                    break;
                }
                
                case BoardMethod.Types.Type.BlockMoveAction:
                {
                    board.BlockAction(GameBoard.Types.BlockActionFlag.Move);
                    break;
                }
                
                case BoardMethod.Types.Type.UnBlockMoveAction:
                {
                    board.UnblockAction(GameBoard.Types.BlockActionFlag.Move);
                    break;
                }
                
                
                default:
                    throw new NotImplementedException(method.Type.ToString());
            }
        }
    }
}
