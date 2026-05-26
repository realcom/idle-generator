
using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Events;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private partial void HandleUpdateInternal(SelectTraitUpdate update)
        {
            // var player = GetUnitByPlayerId(update.PlayerId);
            // var playerMessage = GetPlayerById(update.PlayerId);
            // IncreaseMission(
            //     playerMessage!,
            //     new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionUnitLevelUp,
            //         ResourceAchievement.ConditionQuery.Comparer.GreaterOrEqual, player.Level), 1);
        }

        private partial void HandleUpdateInternal(CompleteSelectTraitUpdate update)
        {
            var playerUnit = GetUnitByPlayerId(update.PlayerId);
            if (playerUnit == null)
                return;

            var shouldAddAll = Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
                .PredefinedVariable.Types.Type.SelectTraitShouldAddAll) == 1;
            
            using var itemDataIds = ConcurrentObjectPool<PooledList<int>>.StaticPool.Pop();
            if (shouldAddAll)
            {
                for (var i = 1; i < 9; i++)
                {
                    var itemDataId = Variables.GetInt((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.SelectTraitUnitDataId + i, 0);
                    if (itemDataId <= 0)
                        break;
                    itemDataIds.Add(itemDataId);
                }
            }
            else
            {
                var itemDataId = update.TraitDataId;    
                if (itemDataId > 0)
                    itemDataIds.Add(itemDataId);
            }

            foreach (var itemDataId in itemDataIds)
            {
                AcquireTrait(playerUnit, itemDataId);
            }
                          
            QueueEvent(new CompleteSelectTraitEvent()
            {
                PlayerId = playerUnit.PlayerId,
                TraitDataId = itemDataIds.FirstOrDefault(),
            });
            ResetSelectTraitVariables();
            var player = GetPlayerById(update.PlayerId);
            if (player == null)
                return;
            player.SelectTraitEvents.RemoveAt(0);
            var selectTraitEvent = player.SelectTraitEvents.FirstOrDefault();
            if (selectTraitEvent is { State: SelectTraitEventMessage.Types.State.Immediate })
            {
                PickTraitCandidatesFromSelectTraitEvents(player, true);
                
                QueueEvent(new SelectTraitEvent
                {
                });  
            }
        }

        private partial void HandleUpdateInternal(RerollSelectTraitUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            var unit = GetUnitByPlayerId(update.PlayerId);
            if (player == null || unit == null)
                return;

            switch (update.Type)
            {
                case SelectTraitUpdate.Types.Type.LevelUp:
                {
                    if (player.RerollLevelUpSelectTrait <= 0)
                    {
                        Config.LogError("Can't reroll levelUp Trait.");
                        return;
                    }

                    PickTraitCandidatesFromSelectTraitEvents(player, true, true);
                    --player.RerollLevelUpSelectTrait;
                    break;
                }

                default:
                {
                    Config.LogError($"Not specified select trait update Type {update.Type}.");
                    return;
                }
            }
            
            QueueEvent(new SelectTraitEvent
            {
                Reroll = true
            });    
        }
        
        internal void SetSelectLevelUpTrait(BoardPlayerMessage player, GameUnit unit)
        {
            var level = unit.Level;
            var targetLevel = 1;
            foreach (var itemGroup in ResMap.LevelUpAddItemGroups)
            {
                if (itemGroup.Level > level)
                    break;
                if (level >= itemGroup.Level)
                    targetLevel = itemGroup.Level;
            }
            var traitItemGroup = ResMap.LevelUpAddItemGroups.Where(e => e.Level == targetLevel).ToArray()
                .PickWeighted(this, e => e.ProbPercent)!;

            player.SelectTraitEvents.Add(new SelectTraitEventMessage
            {
                State = SelectTraitEventMessage.Types.State.Immediate,
                TraitItemGroup = traitItemGroup
            });
            // for (var i = 0; i < traitDataIds.Length; i++)
            // {
            //     var traitId = traitDataIds[i];
            //     Variables.Set((int) ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
            //         .PredefinedVariable.Types.Type.SelectTraitUnitDataId + 1 + i, traitId);
            // }
        }
        
        internal int[] PickTraitCandidatesFromSelectTraitEvents(BoardPlayerMessage player, bool setToVariables, bool isReroll = false)
        {
            var selectTraitEvent = player.SelectTraitEvents.FirstOrDefault();
            if (selectTraitEvent == null)
            {
                Config.LogInfo("SelectTraitEvents is empty");
                return new int[0];
            }

            if (!isReroll && Variables.Get((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
                    .PredefinedVariable.Types.Type.SelectTraitType) > 0)
            {
                Config.LogInfo("SelectTrait is on processing.");
                return new int[0];
            }
            
            var traitItemGroup = selectTraitEvent.TraitItemGroup;
            var size = traitItemGroup.Size;
            var unit = GetUnitByPlayerId(player.Id)!;
            var appliedTraits = player.AppliedTraits;
            using var groupDict = ConcurrentObjectPool<PooledDictionary<int, List<AddItem>>>.StaticPool.Pop();
            foreach (var item in traitItemGroup.AddItems)
            {
                if (!groupDict.ContainsKey(item.Group))
                    groupDict[item.Group] = ConcurrentObjectPool<PooledList<AddItem>>.StaticPool.Pop();
    
                groupDict[item.Group].Add(item);
            }
            
            var selectIds = new int[size * groupDict.Count];
            for (var i = 0; i < groupDict.Count; i++)
            {
                var group = groupDict[i + 1]; // group starts from 1
                for (var j = 0; j < size; j++)
                {
                    var choice = group.PickWeighted(this, addItem =>
                    {
                        var resItem = addItem!.GetData();
                        foreach (var selectId in selectIds)
                        {
                            if (selectId == addItem.ItemDataId)
                                return 0;
                        }
                        
                        if (resItem.Type == ResourceItem.Types.Type.Learnable &&
                            player.LearnableTraits.All(learnableTrait =>
                                learnableTrait.ItemDataId != addItem.ItemDataId))
                            return 0;
                        
                        var appliedTrait =appliedTraits.FirstOrDefault(appliedTrait => appliedTrait.ItemDataId == addItem.ItemDataId);
                        if (appliedTrait != null && appliedTrait.Count >= resItem.MaxCount)
                            return 0;

                        return addItem.Weight;
                    })!;
 
                    selectIds[i * size + j] = choice.ItemDataId;
                }
            }
           
            if (setToVariables)
            {
                Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
                    .PredefinedVariable.Types.Type.SelectTraitType, (int) traitItemGroup.Type);
                Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
                    .PredefinedVariable.Types.Type.SelectTraitUnitDataId, traitItemGroup.UnitDataId);
                Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
                    .PredefinedVariable.Types.Type.SelectTraitShouldAddAll, traitItemGroup.ShouldAddAll);
                for (var i = 0; i < selectIds.Length; i++)
                {
                    var traitId = selectIds[i];
                    Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types
                        .PredefinedVariable.Types.Type.SelectTraitUnitDataId + 1 + i, traitId);
                }
            }

            return selectIds;
        }

        private void AcquireTrait(GameUnit playerUnit, int itemDataId)
        {
            var resItem = ResourceItem.Get(itemDataId);
            if (resItem == null)
            {
                Config.LogError($"{ToDebugString()} not found item ${itemDataId}");
                return;
            }

            if (resItem.SkillDataId != 0)
            {
                playerUnit.UseSkill(resItem.SkillDataId);    
            } 
            foreach (var resItemEquipAddBuff in resItem.EquipAddBuffs)
            {
                playerUnit.QueueAddBuff(new GameUnit.QueuedAddBuff(null, resItemEquipAddBuff.BuffDataId, resItemEquipAddBuff.Level)); 
            }
            
            var appliedTrait = playerUnit.Player?.AppliedTraits.FirstOrDefault(e => e.ItemDataId == resItem.Id);
            if (appliedTrait != null)
            {
                appliedTrait.Count = Math.Min(resItem.MaxCount, appliedTrait.Count + 1);
            }
            else
            {
                playerUnit.Player?.AppliedTraits.Add(new PlayerItemMessage{ ItemDataId = resItem.Id, Count = 1});
            }
            
            playerUnit?.Player?.IncreaseMission(
                new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionAcquireTraitAnyRarity,
                    ResourceAchievement.ConditionQuery.Comparer.Equal, resItem.Rarity),
                1);
        }
        
        private void ResetSelectTraitVariables()
        {
            // TODO: 이름 뺴기 ..step 초기화
            Variables.Set(520, 0);
            for (var i = 0; i < 9; i++)
            {
                Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.SelectTraitUnitDataId + i, 0);
            }
            Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.SelectTraitShouldAddAll, 0);
            Variables.Set((int)ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type.SelectTraitType, (int) SelectTraitUpdate.Types.Type.None);
        }
        
    }
}