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
using Commons.Types.Units.SlotStat;
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
        private static void RunUnitMethod(Types.Call call, UnitMethod method, GameBoard board, GameUnit unit, Types.State state)
        {
            switch (method.Type)
            {
                case UnitMethod.Types.Type.UseSkill:
                {
                    var skillDataId = state.GetIntParameter(board, SkillDataId);
                    var positionX = state.GetParameter(board, PositionX, unit.Position.X);
                    var positionY = state.GetParameter(board, PositionY, unit.Position.Y);
                    
                    var directionX = state.GetParameter(board, DirectionX, unit.Direction.X);
                    var directionY = state.GetParameter(board, DirectionY, unit.Direction.Y);

                    unit.UseSkill(skillDataId, new FixedVector2(positionX, positionY), new FixedVector2(directionX, directionY));
                    break;
                }
                case UnitMethod.Types.Type.SetDirection:
                {
                    var angle = state.GetParameter(board, Angle, FixedFloat.MaxValue);
                    var direction = angle == FixedFloat.MaxValue ? default(FixedVector2?) : GeometricMath.AngleToUnitVector2(angle);
                    unit.SetDirection(direction ?? GeometricMath.AngleToUnitVector2(2f * FixedFloatMath.Pi * board.RandomFloat()));
                    break;
                }
                case UnitMethod.Types.Type.LookAt:
                {
                    var positionX = state.GetParameter(board, PositionX);
                    var positionY = state.GetParameter(board, PositionY);
                    unit.LookAt(new FixedVector2(positionX, positionY));
                    break;
                }
                case UnitMethod.Types.Type.SetMoveDirection:
                {
                    var angle = state.GetParameter(board, Angle, FixedFloat.MaxValue);
                    var direction = angle == FixedFloat.MaxValue ? default(FixedVector2?) : GeometricMath.AngleToUnitVector2(angle);
                    unit.SetMoveDirection(direction ?? GeometricMath.AngleToUnitVector2(FixedFloatMath.TwoPi * board.RandomFloat()));
                    break;
                }
                case UnitMethod.Types.Type.SetMoveDestination:
                {
                    var positionX = state.GetParameter(board, PositionX);
                    var positionY = state.GetParameter(board, PositionY);
                    unit.SetMoveDestination(new FixedVector2(positionX, positionY));
                    break;
                }
                case UnitMethod.Types.Type.SetMoveRandomDestination:
                {
                    var positionX = state.GetParameter(board, PositionX, unit.Position.X);
                    var positionY = state.GetParameter(board, PositionY, unit.Position.Y);
                    var positionXRange = state.GetParameter(board, PositionXrange);
                    var positionYRange = state.GetParameter(board, PositionYrange);
                    var randomPositionX = positionX + board.RandomFloat() * positionXRange * 2 - positionXRange;
                    var randomPositionY = positionY + board.RandomFloat() * positionYRange * 2 - positionYRange;
                    unit.SetMoveDestination(new FixedVector2(randomPositionX, randomPositionY));
                    break;
                }
                case UnitMethod.Types.Type.RunawayFromTarget:
                {
                    var targetUnit = unit.Target;
                    if (targetUnit == null)
                        break;
                    var position = (FixedVector2)unit.Position;
                    var targetPosition = (FixedVector2)targetUnit.Position;
                    var direction = position - targetPosition;
                    direction.Normalize();
                    var distance = state.GetParameter(board, Distance);
                    unit.SetMoveDestination(position + direction * distance);
                    break;
                }
                case UnitMethod.Types.Type.Suicide:
                {
                    unit.HandleDead();
                    break;
                }
                case UnitMethod.Types.Type.Stop:
                {
                    unit.Stop();
                    break;
                }
                case UnitMethod.Types.Type.GetWeaponType:
                {
                    if (unit.PlayerAvatar == null ||
                        unit.PlayerAvatarWeaponSlot < 0 ||
                        unit.PlayerAvatarWeaponSlot >= unit.PlayerAvatar.Weapons.Count)
                    {
                        state.SetPredefinedVariable(board, Return, FixedFloat.Zero);
                        break;
                    }

                    var weapon = ResourceItem.Get(unit.PlayerAvatar!.Weapons[unit.PlayerAvatarWeaponSlot].ItemDataId);
                    
                    if (weapon == null)
                    {
                        state.SetPredefinedVariable(board, Return, FixedFloat.Zero);
                        break;
                    }

                    state.SetPredefinedVariable(board, Return, (float)(weapon!.Type));
                    break;
                }
                case UnitMethod.Types.Type.IsUsingSkill:
                {
                    state.SetPredefinedVariable(board, Return, board.HasSkillBySenderId(unit.Id) ? FixedFloat.One : FixedFloat.Zero);
                    break;
                }
                case UnitMethod.Types.Type.IsUsingSkillBySkillDataId:
                {
                    var skillDataId = state.GetIntParameter(board, SkillDataId);
                    state.SetPredefinedVariable(board, Return, board.HasSkillBySenderIdAndSkillDataId(unit.Id, skillDataId) ? FixedFloat.One : FixedFloat.Zero);
                    break;
                }
                case UnitMethod.Types.Type.GetSkillCooldown:
                {
                    var skillDataId = state.GetIntParameter(board, SkillDataId);
                    state.SetPredefinedVariable(board, Return, unit.GetSkillCooldown(skillDataId));
                    break;
                }
                case UnitMethod.Types.Type.LookAtTarget:
                {
                    var targetUnit = unit.Target;
                    if (targetUnit != null)
                        unit.LookAt(targetUnit);
                    break;
                }
                case UnitMethod.Types.Type.UseSkillToTarget:
                {
                    var skillDataId = state.GetIntParameter(board, SkillDataId);
                    var targetUnit = unit.Target;
                    if (targetUnit == null)
                    {
                        var resSkill = ResourceSkill.Get(skillDataId);
                        if (resSkill == null)
                            break;

                        // Let target-refreshing skills acquire their own target on the skill path.
                        switch (resSkill.TargetRefreshType)
                        {
                            case ResourceSkill.Types.TargetRefreshType.Random:
                            case ResourceSkill.Types.TargetRefreshType.LowestHp:
                            case ResourceSkill.Types.TargetRefreshType.HighestHp:
                            case ResourceSkill.Types.TargetRefreshType.Nearest:
                            case ResourceSkill.Types.TargetRefreshType.Furthest:
                                unit.UseSkill(skillDataId);
                                break;
                        }
                        break;
                    }

                    unit.LookAt(targetUnit);
                    unit.UseSkill(skillDataId);
                    break;
                }
                case UnitMethod.Types.Type.GetBuffByDataId:
                {
                    var buffDataId = state.GetIntParameter(board, BuffDataId);
                    state.slotBuff = unit.GetBuffByDataId(buffDataId);
                    break;
                }
                case UnitMethod.Types.Type.IsBuffApplied:
                {
                    var buffDataId = state.GetIntParameter(board, BuffDataId);
                    var buff = unit.GetBuffByDataId(buffDataId);
                    state.SetPredefinedVariable(board, Return, buff == null ? FixedFloat.Zero : FixedFloat.One);
                    break;
                }
                case UnitMethod.Types.Type.AddBuff:
                {
                    var buffDataId = state.GetIntParameter(board, BuffDataId);
                    var level = Math.Max(1, state.GetIntParameter(board, Types.Expression.Types.Operand.Types.Variable.Types.Parameter.Types.Type.Level));
                    var duration = state.GetParameter(board, Duration);
                    var sender = OffsetToBuffSender(state.GetIntParameter(board, Offset), state);
                    var addBuff = new AddBuff
                    {   
                        BuffDataId = buffDataId,
                        Level = level,
                        Duration = (float)duration,
                    };
                    unit.QueueAddBuff(new GameUnit.QueuedAddBuff(sender, addBuff, level));
                    break;
                }
                case UnitMethod.Types.Type.RemoveBuff:
                {
                    var buffDataId = state.GetIntParameter(board, BuffDataId);
                    unit.GetBuffByDataId(buffDataId)?.Destroy();
                    break;
                }
                case UnitMethod.Types.Type.GetInventoryEmptySlotCount:
                {
                    var emptySlotCount = board.PlayerActiveInventoryData.GetValueOrDefault(unit.PlayerId)?.EmptySlotCount ?? 0;
                    state.SetPredefinedVariable(board, Return, emptySlotCount);
                    break;
                }
                case UnitMethod.Types.Type.HasDuplicateInventoryItem:
                {
                    var hasDuplicateInventoryItem = false;
                    var activeInventoryData = board.PlayerActiveInventoryData.GetValueOrDefault(unit.PlayerId);
                    if (activeInventoryData != null)
                    {
                        hasDuplicateInventoryItem = activeInventoryData.SlotsByItemId.Count != activeInventoryData.ItemCountByItemDataId.Keys.Count;
                    }
                    state.SetPredefinedVariable(board, Return, hasDuplicateInventoryItem ? FixedFloat.One : FixedFloat.Zero);
                    break;
                }
                case UnitMethod.Types.Type.GetInventoryItemCountByTag:
                {
                    var tag = (Tag)state.GetIntParameter(board, Etag);
                    var count = FixedFloat.Zero;
                    var activeInventoryData = board.PlayerActiveInventoryData.GetValueOrDefault(unit.PlayerId);
                    if (activeInventoryData != null)
                    {
                        foreach (var pair in activeInventoryData.ItemCountByItemDataId)
                        {
                            var resourceItem = ResourceItem.Get(pair.Key);
                            if (resourceItem?.ContainsTag(tag) == true)
                            {
                                count += pair.Value;
                            }
                        }
                    }

                    state.SetPredefinedVariable(board, Return, count);
                    break;
                }
                
                case UnitMethod.Types.Type.GetGoldCount:
                {
                    if (unit.Player != null)
                        state.SetPredefinedVariable(board, Return, unit.Player.Gold);
                    
                    break;
                }

                case UnitMethod.Types.Type.GetLevel:
                {
                    state.SetPredefinedVariable(board, Return, unit.Level);
                    
                    break;
                }
                case UnitMethod.Types.Type.GetCurrentHpPercent:
                {
                    state.SetPredefinedVariable(
                        board,
                        Return,
                        unit.MaxHp <= 0L ? FixedFloat.Zero : unit.Hp * FixedFloat.Hundred / unit.MaxHp);
                    break;
                }
                
                case UnitMethod.Types.Type.IncreaseGold:
                {
                    var count = state.GetIntParameter(board, Count);
                    if (unit.Player == null)
                    {
                        Config.LogError($"{board.ToDebugString()}: IncreaseGold - player is null. unitId: {unit.DataId}");
                        return;
                    }
                    unit.Player!.Gold += count;
                    unit.Player.HandleGoldChange(count);
                    break;
                }
                
                case UnitMethod.Types.Type.IncreaseExp:
                {
                    var count = state.GetIntParameter(board, Count);
                    unit.AddExp(count);
                    break;
                }
                
                case UnitMethod.Types.Type.IncreaseLevel:
                {
                    var count = state.GetIntParameter(board, Count);
                    unit.IncreaseLevel(count);
                    break;
                }
                case UnitMethod.Types.Type.IncreaseRerollLevelUpSelectTrait:
                {
                    var count = state.GetIntParameter(board, Count);
                    
                    var player = unit.Player;
                    if (player == null)
                        return;

                    player.RerollLevelUpSelectTrait = Math.Max(0, player.RerollLevelUpSelectTrait);
                    player.RerollLevelUpSelectTrait += count;
                    
                    break;
                }
                // outgame 아이템 얻을 때 활용.. exp랑 골드도 다 통합해버릴까 
                case UnitMethod.Types.Type.AcquireItem:
                {
                    var itemDataId = state.GetIntParameter(board, ItemDataId);
                    var count = state.GetIntParameter(board, Count);
                    if (itemDataId > 0 && count > 0)
                    {
                        var addItem = new AddItem
                        {
                            ItemDataId = itemDataId,
                            Count = count,
                        };
                        unit.AddItem(addItem, unit);
                    }
                    else
                    {
                        Config.LogError($"{board.ToDebugString()}: AcquireItem - invalid param: {itemDataId} {Count}");
                    }
                    
                    break;
                }
                
                case UnitMethod.Types.Type.AddInventoryItemByItemDataId:
                {
                    var count = state.GetIntParameter(board, Count);
                    var itemDataId = state.GetIntParameter(board, ItemDataId); 
                    
                    foreach (var i in Enumerable.Range(0, count))
                    {
                        board.AddInventoryItem(unit.Player!, unit.Player!.Inventories[0], itemDataId: itemDataId);    
                    }

                    break;
                }
                
                case UnitMethod.Types.Type.AddInventoryItem2:
                {
                    // (ResourceItem.Types.WeaponCategory)
                    var weaponCategory = state.GetIntParameter(board, Category);
                    var count = state.GetIntParameter(board, Count);
                    var grade = state.GetIntParameter(board, Grade);
                    var rarity = state.GetIntParameter(board, Rarity);
                    var size =  state.GetIntParameter(board, Size);
                    if (size == 0) size = -1;
                    foreach (var i in Enumerable.Range(0, count))
                    {
                        board.AddInventoryItemFromAvatarWeapons(unit.Player!, unit.Player!.Inventories[0],
                            weaponCategory, grade, rarity, size, true);
                    }

                    break;
                }
                
                case UnitMethod.Types.Type.RemoveRandomInventoryItem:
                {
                    var player = unit.Player;
                    if (player == null)
                        return;
                    var (item, row, slot) = board.GetRandomInventoryItem(player);
                    if (item == null)
                        return;
                    
                    board.RemoveInventoryItem(player!, row, slot, false);
                    break;
                }
                
                
                case UnitMethod.Types.Type.ChangeRandomInventoryItem:
                {
                    var player = unit.Player;
                    if (player == null)
                        return;
                    
                    var gradeUp = state.GetIntParameter(board, Grade);
                    var rarityUp =  state.GetIntParameter(board, Rarity);
                    var weaponCategory = state.GetIntParameter(board, Category);
                    Func<PlayerItemMessage, bool>? predicate = null;
                    if (weaponCategory > 0)
                        predicate = x => weaponCategory != (int) x.GetData()!.WeaponCategory;
                    
                    var (item, row, slot) = board.GetRandomInventoryItem(player, fallbackRarityLimit: board.MaxRarity - 1, predicate: predicate);
                    if (item == null)
                        return;
                    
                    var removeOriginItem = state.GetIntParameter(board, Value) > 0 ? true : false;
                    
                    board.RemoveInventoryItem(player!, row, slot, false);
                    board.AddInventoryItemFromAvatarWeapons(player, player.Inventories[0],
                        weaponCategory, item.GetData().Grade + gradeUp, item.GetData().Rarity + rarityUp, -1, true);
                    
                    if (removeOriginItem)
                        board.RemoveInventoryItem(player!, row, slot, false);
                    
                    break;
                }
                                
                case UnitMethod.Types.Type.GetKillCount:
                {
                    var kill = 0;
                    if (unit.Player != null)
                        kill = unit.Player.Kills;
                    state.SetPredefinedVariable(board, Return, kill);
                    break;
                }

                case UnitMethod.Types.Type.PlayFxEvent:
                {
                    var positionX = state.GetParameter(board, PositionX, unit.Position.X);
                    var positionY = state.GetParameter(board, PositionY, unit.Position.Y);
                    var count = state.GetIntParameter(board, Count);
                    var prefab = call.ArgumentString;

                    board.QueueEvent(new PlayFxEvent()
                    {
                        UnitId = unit.Id,
                        Position = new FixedVector2(positionX, positionY),
                        Count = count,
                        Prefab = prefab,
                    });
                    
                    break;
                }

                case UnitMethod.Types.Type.TeleportToPosition:
                {
                    var positionX = state.GetParameter(board, PositionX);
                    var positionY = state.GetParameter(board, PositionY); ;
                    unit.TeleportToPosition(new FixedVector2(positionX, positionY));
                    break;
                }
                

                case UnitMethod.Types.Type.SetRespawnDelay:
                {
                    var duration = state.GetParameter(board, Duration);
                    if (duration > 0)
                        unit.RespawnWithDelay(GameBoard.TimeToTicks(duration));
                    
                    break;
                }
                
                
                default:
                    throw new NotImplementedException(method.Type.ToString());
            }
        }
    }
}
