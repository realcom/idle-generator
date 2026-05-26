using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Transactions;
using Commons.Game.Events;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units.SlotStat;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using Google.Protobuf.Collections;


using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.BoardVariable.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type;

using static Commons.Resources.ResourceMap.Types.Global.Types.BoardConstants;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public class ActiveInventorySkillCommand
        {
            public long PlayerId;
            public int Row;
            public int Index;
            public int ItemDataId;
            public int CommandIndex;
            public int BuffDataId;
        }

        private bool _playerActiveInventoryDirty;
        public readonly Dictionary<long, List<ActiveInventorySkillCommand>> PlayerActiveInventorySkillCommands = new();
        private FixedFloat[,]? _spawnWeights = null;
        private AddItemGroup _spawnAddItemGroup = null;
        private List<int> _spawnWeaponCandidateDataIds = new();
        private int _spawnWeightsMaxRow = 0;
        public int MaxGrade
        {
            get
            {
                if (_spawnWeightsMaxRow == 0)
                    InitSpawnWeights();
                return _spawnWeightsMaxRow;
            }
        }
        
        private int _spawnWeightsMaxColumn = 0;
        public int MaxRarity
        {
            get
            {
                if (_spawnWeightsMaxColumn == 0)
                    InitSpawnWeights();
                return _spawnWeightsMaxColumn;
            }
        }
        
        public class ActiveInventoryData
        {
            public readonly Dictionary<long, List<Slot>> SlotsByItemId = new();
            public readonly Dictionary<int, int> ItemCountByItemDataId = new();
            public FixedFloat InventorySlotCount;
            public FixedFloat InventoryMaxSlotCount;
            
            public FixedFloat EmptySlotCount => InventoryMaxSlotCount - InventorySlotCount;

            public void Clear()
            {
                SlotsByItemId.Clear();
                ItemCountByItemDataId.Clear();
                InventorySlotCount = FixedFloat.Zero;
                InventoryMaxSlotCount = FixedFloat.Zero;
            }
        }
        
        public readonly Dictionary<long, ActiveInventoryData> PlayerActiveInventoryData = new();
        
        private partial void HandleUpdateInternal(BoardPlayerInventorySpawnUpdate update)
        {
            HandleBoardInventoryUpdate(update);
        }
        
        private void HandleBoardInventoryUpdate(BoardPlayerInventorySpawnUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            if (player == null || player.Inventories.Count == 0)
                return;
            
            var playerUnit = GetUnitByPlayerId(update.PlayerId);
            if (playerUnit == null)
                return;
            
            var unitVariables = playerUnit.Variables;

            var inventory = player.Inventories[0]!;
            var resetHoldItemsOnSpawn = ResMap.ContainsTag(Tag.ResetHoldItemsOnSpawn);

            // limit the number of items
            var holdItemCount = player.HoldItems.Count(i => i.ItemDataId != 0);
            if (!resetHoldItemsOnSpawn && holdItemCount + ResMap.SpawnCount > ResMap.MaxHoldCount)
                return;

            var totalSellPrice = 0;
            if (resetHoldItemsOnSpawn)
            {
                foreach (var item in player.HoldItems)
                {
                    if (item.ItemDataId != 0)
                        totalSellPrice += ResourceItem.Get(item.ItemDataId)!.SellPrice;
                }
                
                InventoryResetHold(GetPlayerById(update.PlayerId));
            }

            var cumulativeSpawnCountWithoutReset = (int)unitVariables.Get((int)CumulativeSpawnCountWithoutReset);
            var cumulativeFreeRollCount = (int)unitVariables.Get((int)CumulativeFreeRollCount);
            var fixedSpawnPrice = unitVariables.Get((int)FixedSpawnPrice, -1);
            var spawnPrice = fixedSpawnPrice>=0 ? fixedSpawnPrice : ResMap.SpawnPrices.GetClamped(cumulativeSpawnCountWithoutReset - cumulativeFreeRollCount);
            
            var bagExpandItem = ResourceItem.GetAllByTag(Tag.InventoryExpand).FirstOrDefault(x => x.Type == ResourceItem.Types.Type.InventorySkill)!;
            
            var freeRollCount = (int)(playerUnit?.Variables.Get((int)FreeRollCount) ?? FixedFloat.Zero);
            if (freeRollCount > 0)
            { 
                spawnPrice = 0;
                unitVariables.Set((int)FreeRollCount, freeRollCount - 1);
                unitVariables.Set((int)CumulativeFreeRollCount, cumulativeFreeRollCount + 1);
            }
            
            if (player.Gold + totalSellPrice < spawnPrice)
                return;
            player.Gold -= (long) spawnPrice;

            var cumulativeSpawnCount = (int)unitVariables.Get((int)CumulativeSpawnCount);

            cumulativeSpawnCountWithoutReset += 1;
            cumulativeSpawnCount += 1;
            
            var spawnCount = ResMap.SpawnCount;
            // check for inventory expansion count
            // force spawn an inventory expansion item if max interval is reached
            // if (cumulativeSpawnCount >= ResMap.BagExpansionMaxInterval)
            // {
            //     spawnCount -= 1;
            //     cumulativeSpawnCount = 0;
            //     isBagExpanded = true;
            //     AddInventoryItem(player, inventory, bagExpandItem.Id);
            // }
            
            unitVariables.Set((int)CumulativeSpawnCount, cumulativeSpawnCount);
            unitVariables.Set((int)CumulativeSpawnCountWithoutReset, cumulativeSpawnCountWithoutReset);
            

            var spawnAddItemGroup =
                ResMap.SpawnAddItemGroups.GetClamped(cumulativeSpawnCountWithoutReset - 1);
            var shouldAddAll = spawnAddItemGroup.ShouldAddAll;
            var weaponDataIds = _spawnWeaponCandidateDataIds;
            if (!spawnAddItemGroup.Equals(_spawnAddItemGroup))
            {
                _spawnAddItemGroup = spawnAddItemGroup; ;
                weaponDataIds.Clear();
                foreach (var addItem in spawnAddItemGroup.AddItems)
                {
                    if (ResMap.ContainsTag(Tag.IgnoreHeldWeaponCheck))
                    {
                        weaponDataIds.Add(addItem.ItemDataId);
                        continue;
                    }

                    foreach (var weapon in player.InventorySkills)
                    {
                        if (weapon.ItemDataId == addItem.ItemDataId)
                        {
                            weaponDataIds.Add(addItem.ItemDataId);
                            break;
                        }
                    }
                }
            }
            
            // using var weaponDataIds = ConcurrentObjectPool<PooledList<int>>.StaticPool.Pop();
            var cumulativeTotalCountBeforeBagExpand = (int)unitVariables.Get((int)CumulativeTotalCountBeforeBagExpand);
            var itemNotSelectedCount = 0;
            for (var i = 0; i < spawnCount; i++)
            {
                var isBagExpandable = true;
                ResourceItem? resItem = null;
                if (shouldAddAll)
                    resItem = ResourceItem.Get(weaponDataIds.ElementAtOrDefault(i));

                FixedFloat scaledLuck = playerUnit.Stat.Luck * GameConstants.LuckScaleFactor;
                var luckApplied = scaledLuck > RandomFloat();
                
                
                if (!luckApplied)
                {
                    if (cumulativeTotalCountBeforeBagExpand >= ResMap.BagExpansionMaxInterval)
                    {
                        resItem = bagExpandItem;
                    }
                    else if (cumulativeTotalCountBeforeBagExpand <= ResMap.BagExpansionMinInterval)
                    {
                        isBagExpandable = false;
                    }
                }
                else
                {
                    Config.LogInfo($"Luck applied with scaled Luck {scaledLuck}.");
                }

                if (resItem == null)
                {
                    if (_spawnWeights == null)
                        InitSpawnWeights();
                    
                    var totalWeight = FixedFloat.Zero;
                    for (var r = 0; r < _spawnWeightsMaxRow; r++)
                    {
                        for (var c = 0; c < _spawnWeightsMaxColumn; c++)
                        {
                            if (!isBagExpandable && r == 0)
                            {
                                _spawnWeights[r, c] = 0;
                            }
                            else if (luckApplied)
                            {
                                _spawnWeights[r, c] = ResMap.LuckSpawnBaseWeights.Rows[r].Cells[c];
                                _spawnWeights[r, c] += ResMap.LuckSpawnAdditionalWeights.Rows[r].Cells[c] * scaledLuck;
                            }
                            else
                            {
                                _spawnWeights[r, c] = ResMap.SpawnWeights.Rows[r].Cells[c];
                            }

                            totalWeight += _spawnWeights[r, c];
                        }
                    }
                    
                    var value = RandomFloat() * totalWeight;
                    var rarity = 0;
                    var grade = 0;
                    var selected = false;
                    for (var x = 0; x < _spawnWeightsMaxRow; x++)
                    {
                        for (var y = 0; y < _spawnWeightsMaxColumn; y++)
                        {
                            if (value < _spawnWeights[x, y])
                            {
                                rarity = x;
                                grade = y;
                                selected = true;
                                break;
                            }

                            value -= _spawnWeights[x, y];
                        }

                        if (selected)
                            break;
                    }

                    using var targetWeapons = ConcurrentObjectPool<PooledList<int>>.StaticPool.Pop();
                    foreach (var dataId in weaponDataIds)
                    {
                        if (ResourceItem.Get(dataId)?.Rarity == rarity && ResourceItem.Get(dataId)?.Grade == grade)
                            targetWeapons.Add(dataId);
                    }

                    var weaponDataId = targetWeapons.PickOne(this);
                    // selectedWeapon = new PlayerItemMessage{ItemDataId = 1121001};
                    resItem = ResourceItem.Get(weaponDataId);
                }

                if (resItem == null)
                {
                    itemNotSelectedCount++;
                    if (itemNotSelectedCount >= 10)
                    {
                        Config.LogError($"{ToDebugString()} itemNotSelectedCount exceeds 10;");
                        itemNotSelectedCount = 0;
                    }
                    else
                        i--;

                    continue;
                }
                
                AddInventoryItem(player, inventory, resItem.Id, placeInInventory: ResMap.ContainsTag(Tag.AutoplaceInInventoryOnSpawn), luckApplied: luckApplied);
                cumulativeTotalCountBeforeBagExpand = resItem.Rarity == bagExpandItem.Rarity
                    ? 0
                    : (cumulativeTotalCountBeforeBagExpand + 1);
            }
            _playerActiveInventoryDirty = true;
            unitVariables.Set((int)CumulativeTotalCountBeforeBagExpand, cumulativeTotalCountBeforeBagExpand);
        }

        private void InitSpawnWeights()
        {
            foreach (var resInventoryItem in ResourceItem.GetAllByType(ResourceItem.Types.Type.InventorySkill))
            {
                _spawnWeightsMaxRow = Math.Max(_spawnWeightsMaxRow, resInventoryItem.Rarity);
                _spawnWeightsMaxColumn = Math.Max(_spawnWeightsMaxColumn, resInventoryItem.Grade);
            }
            // index starts from 0
            ++_spawnWeightsMaxRow;
            ++_spawnWeightsMaxColumn;
            _spawnWeights = new FixedFloat[_spawnWeightsMaxRow, _spawnWeightsMaxColumn];
        }

        public void CopyRandomInventoryItem(long playerId, int grade = -1)
        {
            var player = GetPlayerById(playerId);
            var activeInventoryData = PlayerActiveInventoryData.GetValueOrDefault(playerId);
            if (player == null || player.Inventories.Count == 0)
                return;

            if (activeInventoryData != null)
            {
                var itemDataId = activeInventoryData.ItemCountByItemDataId.Keys.PickOne(this);
                if (itemDataId == default)
                    return;
                
                if (grade > 0)
                {
                    var resItem = ResourceItem.Get(itemDataId);
                    var targetItem = ResourceItem.GetAllByType(ResourceItem.Types.Type.InventorySkill).FirstOrDefault(x => x.Group == resItem.Group && x.Grade == grade);
                    itemDataId = targetItem!.Id;
                }
                AddInventoryItem(player, player.Inventories[0], itemDataId);
            }
        }

        public PlayerItemMessage AddInventoryItem(BoardPlayerMessage player, PlayerInventory inventory, int itemDataId,
            bool resetHold = false, bool placeInInventory = false, bool luckApplied = false)
        {
            var itemId = GetNextId(player, inventory);
            var itemMessage = new PlayerItemMessage
            {
                Id = itemId,
                ItemDataId = itemDataId,
            };
            AddInventoryItem(player, itemMessage, isCreated: true, resetHold: resetHold, placeInInventory: placeInInventory, luckApplied: luckApplied);
            return itemMessage;
        }
        
        public PlayerItemMessage? AddInventoryItemFromAvatarWeapons(
            BoardPlayerMessage player,
            PlayerInventory inventory,
            int weaponCategory = -1,
            int grade = -1,
            int rarity = -1,
            int size = -1,
            bool allowLowerRarity = false,
            bool resetHold = false)
        {
            
            if (grade > 0)
                grade = Math.Min(MaxGrade, grade);
            
            if (rarity > 0)
                rarity = Math.Min(MaxRarity, rarity);
            
            var unit = GetUnitByPlayerId(player.Id);
            if (unit == null || unit.PlayerAvatar == null)
            {
                Config.LogError($"{ToDebugString()} AddInventoryItemByFilter: unit or avatar is null for player {player.Id}");
                return null;
            }
            var avatar = unit.PlayerAvatar;
            using var items = ConcurrentObjectPool<PooledList<PlayerItemMessage>>.StaticPool.Pop();
            int searchRarity = rarity;

            do
            {
                items.Clear();
                foreach (var item in player.InventorySkills)
                {
                    if ((weaponCategory < 0 || item.GetData()!.WeaponCategory == (ResourceItem.Types.WeaponCategory)weaponCategory) &&
                        (grade < 0 || item.GetData()!.Grade == grade) &&
                        (size < 0 || item.GetData()!.InventoryCells.Count + 1 == size) && 
                        (searchRarity < 0 || item.GetData()!.Rarity == searchRarity))
                    {
                        items.Add(item);
                    }
                }

                if (items.Count > 0 || !allowLowerRarity)
                    break;

                searchRarity--;
            } while (searchRarity >= 0);

            if (items.Count == 0)
                return null;

            var selectedItem = items.PickOne(this);
            if (selectedItem == null)
                return null;;

            return AddInventoryItem(player, inventory, selectedItem.ItemDataId, resetHold);
        }

        public PlayerInventory MakeInventory(BoardPlayerMessage player, ResourceItem resInventory)
        {
            using var queue = ConcurrentObjectPool<PooledQueue<int>>.StaticPool.Pop();
            foreach (var addItem in resInventory.AddItemGroups.Sample(this))
            {
                var count = addItem.GetCount(this);
                for (var i = 0; i < count; i++)
                {
                    queue.Enqueue(addItem.ItemDataId);   
                }
            }
            
            var inventory = new PlayerInventory();
            inventory.Rows.ResizeAndFillNew(ResourceMap.Global.BoardConstants.BoardMaxY);
            for (var r = 0; r < inventory.Rows.Count; r++)
            {
                var row = inventory.Rows[r];
                row.Items.ResizeAndFillNew(ResourceMap.Global.BoardConstants.BoardMaxX);
                for (var c = 0; c < row.Items.Count; c++)
                {
                    if (!queue.TryDequeue(out var itemDataId))
                        return inventory;
                    
                    var cell = row.Items[c];
                    cell.Id = GetNextId(player, inventory);
                    cell.ItemDataId = itemDataId;
                }
            }

            return inventory;
        }

        private partial void HandleUpdateInternal(BoardPlayerInventoryRootingUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            if (player == null)
                return;

            if (player.RootedInventories.Count > 0)
            {
                MoveRootedInventoryToHold(player);
            }
            else
            {
                player.HoldItems.Clear();
                QueueEvent(new InventoryRootingEvent
                {
                    PlayerId = player.Id,
                });
            }
        }

        public void MoveRootedInventoryToHold(BoardPlayerMessage player)
        {
            if (player.RootedInventories.Count == 0)
                return;
            
            player.HoldItems.Clear();
            
            var inventory = player.RootedInventories[0];
            player.RootedInventories.RemoveAt(0);
            
            for (var r = 0; r < inventory.Rows.Count; r++)
            {
                var row = inventory.Rows[r];
                for (var c = 0; c < row.Items.Count; c++)
                {
                    var cell = row.Items[c];
                    if (cell.Id == 0)
                        continue;
                    
                    var index = AppendHoldItemWithShrink(player, cell);
                    QueueEvent(new InventorySpawnEvent
                    {
                        PlayerId = player.Id,
                        TargetType = BoardPlayerInventorySpawnUpdate.Types.Type.Hold,
                        Index = index,
                        ItemDataId = cell.ItemDataId,
                    });
                }
            }

            QueueEvent(new InventoryRootingEvent
            {
                PlayerId = player.Id,
                Rooted = true
            });
        }
        
        public void AddInventoryItem(BoardPlayerMessage player, PlayerItemMessage itemMessage, bool resetHold = false, bool isCreated = false, bool placeInInventory = false, bool luckApplied = false)
        {
            var inventory = player.Inventories[0];
            var placeableInventorySlot = FindFirstPlaceableSlot(inventory, itemMessage);
            if (placeableInventorySlot.row != -1 && 
                placeableInventorySlot.index != -1 &&
                !itemMessage.GetData()!.ContainsTag(Tag.InventoryExpand) && 
                placeInInventory)
            {
                inventory.Rows[placeableInventorySlot.row].Items[placeableInventorySlot.index] = itemMessage;
                _playerActiveInventoryDirty = true;
                QueueEvent(new InventorySpawnEvent
                {
                    PlayerId = player.Id,
                    TargetType = BoardPlayerInventorySpawnUpdate.Types.Type.Inventory,
                    Row = placeableInventorySlot.row,
                    Index = placeableInventorySlot.index,
                    ItemDataId = itemMessage.ItemDataId,
                    LuckApplied = luckApplied
                });   
            }
            else
            {
                var index = AppendHoldItemWithShrink(player, itemMessage);
                QueueEvent(new InventorySpawnEvent
                {
                    PlayerId = player.Id,
                    TargetType = BoardPlayerInventorySpawnUpdate.Types.Type.Hold,
                    Index = index,
                    ItemDataId = itemMessage.ItemDataId,
                    LuckApplied = luckApplied,
                });      
            }
            
            var playerUnit = GetUnitByPlayerId(player.Id);
            if (playerUnit != null)
            {
                InitAllPlayerUnitItemVariables(playerUnit);
            }

            if (isCreated)
            {
                var resItem = itemMessage.GetData()!;
                // GameplayAcquireWeaponAnyGrad
                player.IncreaseMission(
                    new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionAcquireWeaponAnyRarity,
                        ResourceAchievement.ConditionQuery.Comparer.Equal, resItem.Rarity),
                    1);
                var prevValue = playerUnit?.Variables.Get((int)TotalSpawnItemCount)!;
                playerUnit?.Variables.Set((int)TotalSpawnItemCount, (FixedFloat)(prevValue + 1));
            }

            if (luckApplied)
            {
                var prevValue = playerUnit?.Variables.GetInt((int)CumulativeLuckAppliedCount, 0)!;
                playerUnit?.Variables.Set((int)CumulativeLuckAppliedCount, (FixedFloat)(prevValue + 1));
            }
            
        }

        private (int row, int index) FindFirstPlaceableSlot(PlayerInventory inventory, PlayerItemMessage itemMessage)
        {
            using var filledCellIndexes = GetFilledCellIndexes(inventory);

            var resItem = itemMessage.GetData()!;
            for (var row = 0; row < inventory.Rows.Count; ++row)
            {
                for (var index = 0; index < inventory.Rows[row].Items.Count; ++index)
                {
                    if (!IsInventoryCellValid(inventory, row, index))
                        continue;
                    
                    if (filledCellIndexes.Contains(CellIndexToFlatIndex(row, index)))
                        continue;

                    var canNotPlace = false;
                    foreach (var cell in resItem.InventoryCells)
                    {
                        var newRow = row + cell.Dy;
                        var newIndex = index + cell.Dx;
                        if (!IsInventoryCellValid(inventory, newRow, newIndex))
                        {
                            canNotPlace = true;
                            break;
                        }

                        if (filledCellIndexes.Contains(CellIndexToFlatIndex(newRow, newIndex)))
                        {
                            canNotPlace = true;
                            break;
                        }
                    }

                    if (canNotPlace)
                        continue;

                    return (row, index);
                }
            }

            return (-1, -1);
        }
        
        public static int CellIndexToFlatIndex((int row, int index) tuple)
        {
            return CellIndexToFlatIndex(tuple.row, tuple.index);
        }

        public static int CellIndexToFlatIndex(Slot slot)
        {
            return CellIndexToFlatIndex(slot.row, slot.slot);
        }
        
        public static int CellIndexToFlatIndex(int row, int index)
        {
            const int PAD = 1000;
            return row * PAD + index;
        }

        private PooledHashSet<int> GetFilledCellIndexes(PlayerInventory inventory)
        {
            var filledCellIndexes = ConcurrentObjectPool<PooledHashSet<int>>.StaticPool.Pop();

            for (var row = 0; row < inventory.Rows.Count; ++row)
            {
                for (var index = 0; index < inventory.Rows[row].Items.Count; ++index)
                {
                    var item = inventory.Rows[row].Items[index];
                    if (item.ItemDataId == 0)
                        continue;

                    filledCellIndexes.Add(CellIndexToFlatIndex(row, index));

                    foreach (var inventoryCell in item.GetData()!.InventoryCells)
                    {
                        var newRow = row + inventoryCell.Dy;
                        var newIndex = index + inventoryCell.Dx;

                        filledCellIndexes.Add(CellIndexToFlatIndex(newRow, newIndex));
                    }
                }
            }

            return filledCellIndexes;
        }
        
        //private int InsertHoldItem(BoardPlayerMessage player, PlayerItemMessage itemMessage)
        //{
        //    var blankIndex = -1;
        //    for (var holdIndex = 0; holdIndex < player.HoldItems.Count; holdIndex++)
        //    {
        //        if (player.HoldItems[holdIndex].ItemDataId == 0)
        //        {
        //            blankIndex = holdIndex;
        //            break;
        //        }
        //    }
        //    
        //    var index = blankIndex;
        //    if (blankIndex != -1)
        //    {
        //        player.HoldItems[blankIndex] = itemMessage;
        //    }
        //    else
        //    {
        //        player.HoldItems.Add(itemMessage);
        //        index = player.HoldItems.Count - 1;
        //    }
        //
        //    return index;
        //}
        
        private void ShrinkHoldItems(BoardPlayerMessage player)
        {
            // remove all blank items
            player.HoldItems.RemoveAll(x => x.ItemDataId == 0);
        }
        
        //can use if you want shrink all blank items before append item
        private int AppendHoldItemWithShrink(BoardPlayerMessage player, PlayerItemMessage itemMessage)
        {
            ShrinkHoldItems(player);
            player.HoldItems.Add(itemMessage);
            return player.HoldItems.Count - 1;
        }

        private bool IsInventoryCellValid(PlayerInventory inventory, int row, int index)
        {
            if (row < 0 || row >= inventory.Rows.Count || index < 0 || index >= inventory.Rows[row].Items.Count)
                return false;
            if (inventory.Rows[row].Items[index].Id == -1)
                return false;
            return true;
        }
        
        private partial void HandleUpdateInternal(BoardPlayerInventoryMergeUpdate update)
        {
            HandleBoardInventoryUpdate(update);
        }

        private bool HandleBoardInventoryUpdate(BoardPlayerInventoryMergeUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            if (player == null || player.Inventories.Count == 0)
                return false;
            
            var inventory = player.Inventories[0]!;
            var unit = GetUnitByPlayerId(player.Id);
            
            PlayerItemMessage? sourceItem = null, targetItem = null;

            if (update.SourceType == BoardPlayerInventoryMergeUpdate.Types.Type.Hold)
            {
                // index bound check (might not happen)
                if (update.SourceIndex < 0 || update.SourceIndex >= player.HoldItems.Count)
                    return false;
                sourceItem = player.HoldItems[update.SourceIndex];
                // invalid event
                if (sourceItem.ItemDataId == 0)
                    return false;
            }
            else if (update.SourceType == BoardPlayerInventoryMergeUpdate.Types.Type.Inventory)
            {
                // index bound check (might not happen)
                if (IsInventoryCellValid(inventory, update.SourceRow, update.SourceIndex) == false)
                    return false;
                sourceItem = inventory.Rows[update.SourceRow].Items[update.SourceIndex];
            }
            else
            {
                //invalid event
                return false;
            }

            if (update.TargetType == BoardPlayerInventoryMergeUpdate.Types.Type.Hold)
            {
                // index bound check (might not happen)
                if (update.TargetIndex < 0 || update.TargetIndex >= player.HoldItems.Count)
                    return false;
                targetItem = player.HoldItems[update.TargetIndex];
                // invalid event
                if (targetItem.ItemDataId == 0)
                    return false;
            }
            else if (update.TargetType == BoardPlayerInventoryMergeUpdate.Types.Type.Inventory)
            {
                // index bound check (might not happen)
                if (IsInventoryCellValid(inventory, update.TargetRow, update.TargetIndex) == false)
                    return false;
                targetItem = inventory.Rows[update.TargetRow].Items[update.TargetIndex];
            }
            else
            {
                //invalid event
                return false;
            }

            if (sourceItem!.ItemDataId != targetItem.ItemDataId)
                return false;

            if (sourceItem.ItemDataId == 0)
                return false;

            if (targetItem.ItemDataId == 0)
                return false;
            
            var prevResItem = ResourceItem.Get(sourceItem.ItemDataId)!;
            if (prevResItem.Type != ResourceItem.Types.Type.InventorySkill)
                return false;

            int group;
            if (prevResItem.MergeGroups.Count == 0)
                group = prevResItem.Group;
            else
                group = prevResItem.MergeGroups.PickWeighted(this, prevResItem.MergeGroupWeights);
            var grade = prevResItem.Grade + 1;
            
            var onMergeAddSameGradeRandomWeapon = unit.Variables.GetInt((int)OnMergeAddSameGradeRandomWeapon);
            if (onMergeAddSameGradeRandomWeapon > 0)
            {
                 if (update.TargetType == BoardPlayerInventoryMergeUpdate.Types.Type.Hold)
                     player.HoldItems[update.TargetIndex] = GetEmptyBoardItem();
                 else if (update.TargetType == BoardPlayerInventoryMergeUpdate.Types.Type.Inventory)
                     inventory.Rows[update.TargetRow].Items[update.TargetIndex] = GetEmptyBoardItem();
                 if (update.SourceType == BoardPlayerInventoryMergeUpdate.Types.Type.Hold)
                     player.HoldItems[update.SourceIndex] = GetEmptyBoardItem();
                 else if (update.SourceType == BoardPlayerInventoryMergeUpdate.Types.Type.Inventory)
                     inventory.Rows[update.SourceRow].Items[update.SourceIndex] = GetEmptyBoardItem();
                 
                 var itemMessage = AddInventoryItemFromAvatarWeapons(player, inventory, -1, grade, sourceItem.GetData()!.Rarity, allowLowerRarity: true)!;
            }
            else
            {
                var nextResItem = ResourceItem.GetAllByType(ResourceItem.Types.Type.InventorySkill)
                    .FirstOrDefault(x => x.Group == group && x.Grade == grade);

                if (nextResItem == null)
                    return false;

                if (update.SourceType == BoardPlayerInventoryMergeUpdate.Types.Type.Hold)
                    player.HoldItems[update.SourceIndex] = GetEmptyBoardItem();
                else if (update.SourceType == BoardPlayerInventoryMergeUpdate.Types.Type.Inventory)
                    inventory.Rows[update.SourceRow].Items[update.SourceIndex] = GetEmptyBoardItem();
                else
                {
                    // invalid event
                    return false;
                }

                var nextItemId = GetNextId(player, inventory);
                if (update.TargetType == BoardPlayerInventoryMergeUpdate.Types.Type.Hold)
                    player.HoldItems[update.TargetIndex] = new PlayerItemMessage
                    {
                        Id = nextItemId,
                        ItemDataId = nextResItem.Id,
                    };
                else if (update.TargetType == BoardPlayerInventoryMergeUpdate.Types.Type.Inventory)
                    inventory.Rows[update.TargetRow].Items[update.TargetIndex] = new PlayerItemMessage
                    {
                        Id = nextItemId,
                        ItemDataId = nextResItem.Id,
                    };
                
                QueueEvent(new InventoryMergeEvent
                {
                    PlayerId = player.Id,
                    SourceType = ToInventoryType(update.SourceType),
                    SourceRow = update.SourceRow,
                    SourceIndex = update.SourceIndex,
                    TargetType = ToInventoryType(update.TargetType),
                    TargetRow = update.TargetRow,
                    TargetIndex = update.TargetIndex,
                    PrevItemDataId = prevResItem.Id,
                    NextItemDataId = nextResItem.Id,
                });
            }

            ShrinkHoldItems(player);
            _playerActiveInventoryDirty = true;
            
            if (unit != null)
            {
                if (prevResItem.MergeSkillDataId != 0 && !prevResItem.ContainsTag(Tag.Consumable))
                    unit.UseSkill(prevResItem.MergeSkillDataId, level: prevResItem.Grade, itemDataId: prevResItem.Id,
                        ignoreActable: true);
                
                unit.Variables.Set((int)CumulativeMergeCount, unit.Variables.Get((int)CumulativeMergeCount) + 1);
                InitAllPlayerUnitItemVariables(unit);
            }
            
            player.IncreaseMission(
                new ResourceAchievement.ConditionQuery(ResourceAchievement.Types.Condition.MissionAcquireWeaponAnyGrade,
                    ResourceAchievement.ConditionQuery.Comparer.Equal, grade),
                1);
            return true;
        }
        
        private partial void HandleUpdateInternal(BoardPlayerInventoryMoveUpdate update)
        {
            HandleBoardInventoryUpdate(update);
        }

        private void HandleBoardInventoryUpdate(BoardPlayerInventoryMoveUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            if (player == null || player.Inventories.Count == 0)
                return;

            var inventory = player.Inventories[0]!;
            var sourceItem = inventory.Rows[update.SourceRow].Items[update.SourceIndex];
            if (sourceItem.ItemDataId == 0)
                return;

            // invalid indices
            if (IsInventoryCellValid(inventory, update.TargetRow, update.TargetIndex) == false)
                return;
            if (IsInventoryCellValid(inventory, update.SourceRow, update.SourceIndex) == false)
                return;
            
            inventory.Rows[update.SourceRow].Items[update.SourceIndex] = GetEmptyBoardItem();
            
            // evict if the pivot overlaps
            foreach (var (occupiedItem, row, index) in MoveToHoldOccupiedInventoryItem(inventory, sourceItem, update.TargetRow, update.TargetIndex))
            {
                var holdIndex = AppendHoldItemWithShrink(player, occupiedItem);
                QueueEvent(new InventoryMoveEvent
                {
                    PlayerId = player.Id,
                    SourceType = InventoryMoveEvent.InventoryType.Inventory,
                    SourceRow = row,
                    SourceIndex = index,
                    TargetType = InventoryMoveEvent.InventoryType.Hold,
                    TargetIndex = holdIndex
                });   
            }
            
            inventory.Rows[update.TargetRow].Items[update.TargetIndex] = sourceItem;
            
            _playerActiveInventoryDirty = true;
            QueueEvent(new InventoryMoveEvent
            {
                PlayerId = player.Id,
                SourceType = InventoryMoveEvent.InventoryType.Inventory,
                SourceRow = update.SourceRow,
                SourceIndex = update.SourceIndex,
                TargetType = InventoryMoveEvent.InventoryType.Inventory,
                TargetRow = update.TargetRow,
                TargetIndex = update.TargetIndex,
            });
        }

        private static InventoryMoveEvent.InventoryType ToInventoryType(BoardPlayerInventoryTransferUpdate.Types.Type type)
        {
            return type switch
            {
                BoardPlayerInventoryTransferUpdate.Types.Type.Inventory => InventoryMoveEvent.InventoryType.Inventory,
                BoardPlayerInventoryTransferUpdate.Types.Type.Hold => InventoryMoveEvent.InventoryType.Hold,
                BoardPlayerInventoryTransferUpdate.Types.Type.Sell => InventoryMoveEvent.InventoryType.Sell,
                BoardPlayerInventoryTransferUpdate.Types.Type.Discard => InventoryMoveEvent.InventoryType.Discard,
                _ => InventoryMoveEvent.InventoryType.Inventory,
            };
        }

        private static InventoryMergeEvent.InventoryType ToInventoryType(BoardPlayerInventoryMergeUpdate.Types.Type type)
        {
            return type switch
            {
                BoardPlayerInventoryMergeUpdate.Types.Type.Inventory => InventoryMergeEvent.InventoryType.Inventory,
                BoardPlayerInventoryMergeUpdate.Types.Type.Hold => InventoryMergeEvent.InventoryType.Hold,
                _ => InventoryMergeEvent.InventoryType.Inventory,
            };
        }

        private void HandleSellItem(BoardPlayerMessage player, int itemDataId, List<int>? outReservedAddInventoryItems = null)
        {
            var resItem = ResourceItem.Get(itemDataId)!;
            var units = GetUnitsByPlayerId(player.Id);
            
            FixedFloat totalSellPrice = resItem.SellPrice;
            
            //Apply sell price ratio
            var priceRatio = FixedFloat.One;
            foreach (var unit in units)
                priceRatio += unit.SellPriceRatio - FixedFloat.One;
            totalSellPrice *= priceRatio;
            player.Gold += (long)FixedFloatMath.Ceiling(totalSellPrice);
            player.HandleGoldChange((int)totalSellPrice);
            
            foreach (var unit in units)
            {
                var addFreeRollCountProb = FixedFloatMath.Max(FixedFloat.Zero, unit.Variables.Get((int)AddFreeRollCountPercentBySell)) / FixedFloat.Hundred;
                if (addFreeRollCountProb > FixedFloat.Zero && RandomFloat() < addFreeRollCountProb)
                    unit.Variables.Set((int)FreeRollCount, unit.Variables.Get((int)FreeRollCount) + 1);

                if (resItem.ContainsTag(Tag.Consumable))
                {
                    var paybackProb = FixedFloatMath.Max(FixedFloat.Zero, unit.Variables.Get((int)PaybackBasicConsumablePercentBySell)) / FixedFloat.Hundred;
                    if (paybackProb > FixedFloat.Zero && RandomFloat() < paybackProb)
                    {
                        if (outReservedAddInventoryItems == null)
                        {
                            AddInventoryItem(player, player.Inventories[0], resItem.Group);   
                        }
                        else
                        {
                            outReservedAddInventoryItems.Add(resItem.Group);
                        }
                    }

                    var paybackGoldOnSellConsumable = unit.Variables.GetInt((int)PaybackGoldOnSellConsumable);
                    if (paybackGoldOnSellConsumable > 0)
                    {
                        player.Gold += (long) paybackGoldOnSellConsumable;
                    }
                }
            }
            
            foreach (var gameUnit in units)
            {
                gameUnit.AddItems(resItem.SellAddItemGroups, gameUnit);
            }
            
            if (resItem.DiscardSkillDataId != 0)
                units.FirstOrDefault()?.UseSkill(resItem.DiscardSkillDataId, level: resItem.Grade, itemDataId: itemDataId, ignoreActable: true);
            player.IncreaseMission(ResourceAchievement.Types.Condition.MissionSellWeapon, 1);
        }

        public (PlayerItemMessage?, int, int) GetRandomInventoryItem(BoardPlayerMessage player, int fallbackRarityLimit = -1, Func<PlayerItemMessage, bool>? predicate = null)
        {
            if (player.Inventories.Count == 0)
                return (null, -1, -1);

            var inventory = player.Inventories[0]!;
    
            var allItems = inventory.Rows
                .SelectMany((row, rowIndex) => row.Items.Select((item, itemIndex) => (item, rowIndex, itemIndex)))
                .Where(x => x.item.ItemDataId > 0 && (predicate == null || predicate(x.item)))
                .ToList();

            List<(PlayerItemMessage, int, int)> validItems;

            if (fallbackRarityLimit > -1)
            {
                validItems = allItems.Where(x => x.item.GetData()?.Rarity <= fallbackRarityLimit).ToList();

                if (!validItems.Any())
                {
                    validItems = allItems;
                }
            }
            else
            {
                validItems = allItems;
            }

            if (!validItems.Any())
                return (null, -1, -1);

            var randomIndex = (int)(RandomFloat() * validItems.Count);
            return validItems[randomIndex];
        }
        public void RemoveInventoryItem(BoardPlayerMessage player, int row, int slot, bool isSell = false)
        {
            if (player.Inventories.Count == 0)
                return;
            var inventory = player.Inventories[0]!;
            var item = inventory.Rows[row]?.Items[slot];

            if (item == null || item.ItemDataId == 0)
            {
                return;
            }
            if (isSell)
                HandleSellItem(player, item.ItemDataId);

            inventory.Rows[row].Items[slot] = GetEmptyBoardItem();
            _playerActiveInventoryDirty = true;
            QueueEvent(new InventoryMoveEvent
            {
                PlayerId = player.Id,
                SourceType = InventoryMoveEvent.InventoryType.Inventory,
                SourceRow = row,
                SourceIndex = slot,
                TargetType = isSell ? InventoryMoveEvent.InventoryType.Sell : InventoryMoveEvent.InventoryType.Discard
            });
        }
        
        private partial void HandleUpdateInternal(BoardPlayerInventoryTransferUpdate update)
        {
            HandleBoardInventoryUpdate(update);
        }
        
        private void HandleBoardInventoryUpdate(BoardPlayerInventoryTransferUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            if (player == null || player.Inventories.Count == 0)
                return;
            var inventory = player.Inventories[0]!;

            if (update.TargetType is BoardPlayerInventoryTransferUpdate.Types.Type.Sell
                or BoardPlayerInventoryTransferUpdate.Types.Type.Discard)
            {
                var isSell = update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Sell;
                if (update.SourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory)
                {
                    if (IsInventoryCellValid(inventory, update.SourceRow, update.SourceIndex) == false)
                        return;
                    var sourceItem = inventory.Rows[update.SourceRow].Items[update.SourceIndex];
                    if (sourceItem.ItemDataId == 0)
                        return;

                    if (update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Sell)
                        HandleSellItem(player, sourceItem.ItemDataId);

                    inventory.Rows[update.SourceRow].Items[update.SourceIndex] = GetEmptyBoardItem();
                    _playerActiveInventoryDirty = true;
                    QueueEvent(new InventoryMoveEvent
                    {
                        PlayerId = player.Id,
                        SourceType = InventoryMoveEvent.InventoryType.Inventory,
                        SourceRow = update.SourceRow,
                        SourceIndex = update.SourceIndex,
                        TargetType = isSell
                            ? InventoryMoveEvent.InventoryType.Sell
                            : InventoryMoveEvent.InventoryType.Discard,
                    });
                }
                else if (update.SourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Hold)
                {
                    if (update.SourceIndex >= player.HoldItems.Count || update.SourceIndex < 0)
                        return;
                    var sourceItem = player.HoldItems[update.SourceIndex];
                    if (sourceItem.ItemDataId == 0)
                        return;

                    if (update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Sell)
                        HandleSellItem(player, sourceItem.ItemDataId);

                    player.HoldItems[update.SourceIndex] = GetEmptyBoardItem();
                    ShrinkHoldItems(player);

                    QueueEvent(new InventoryMoveEvent
                    {
                        PlayerId = player.Id,
                        SourceType = InventoryMoveEvent.InventoryType.Hold,
                        SourceIndex = update.SourceIndex,
                        TargetType = isSell
                            ? InventoryMoveEvent.InventoryType.Sell
                            : InventoryMoveEvent.InventoryType.Discard,
                    });
                }

                return;
            }
            
            if (update.SourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory &&
                update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory)
            {
                // invalid indices
                if (IsInventoryCellValid(inventory, update.SourceRow, update.SourceIndex) == false)
                    return;
                if (IsInventoryCellValid(inventory, update.TargetRow, update.TargetIndex) == false)
                    return;

                var sourceItemData = ResourceItem.Get(inventory.Rows[update.SourceRow].Items[update.SourceIndex].ItemDataId)!;
                var targetItemData = ResourceItem.Get(inventory.Rows[update.TargetRow].Items[update.TargetIndex].ItemDataId);
                // merge items if the item is the same
                if (targetItemData != null && targetItemData.Id == sourceItemData.Id)
                {
                    if (HandleBoardInventoryUpdate(new BoardPlayerInventoryMergeUpdate
                        {
                            PlayerId = player.Id,
                            SourceType = BoardPlayerInventoryMergeUpdate.Types.Type.Inventory,
                            SourceRow = update.SourceRow,
                            SourceIndex = update.SourceIndex,
                            TargetType = BoardPlayerInventoryMergeUpdate.Types.Type.Inventory,
                            TargetRow = update.TargetRow,
                            TargetIndex = update.TargetIndex,
                        }))
                    {
                        return;
                    }
                }

                var boardPlayerInventoryMoveUpdate = new BoardPlayerInventoryMoveUpdate
                {
                    PlayerId = update.PlayerId,
                    SourceRow = update.SourceRow,
                    SourceIndex = update.SourceIndex,
                    TargetRow = update.TargetRow,
                    TargetIndex = update.TargetIndex,
                };
                HandleBoardInventoryUpdate(boardPlayerInventoryMoveUpdate);
            }
            // hold to hold
            else if (update.SourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Hold &&
                     update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Hold)
            {
                // invalid indices
                if (update.SourceIndex >= player.HoldItems.Count || update.TargetIndex >= player.HoldItems.Count || update.SourceIndex < 0 || update.TargetIndex < 0)
                    return;

                var sourceItemData = ResourceItem.Get(player.HoldItems[update.SourceIndex].ItemDataId)!;
                var targetItemData = ResourceItem.Get(player.HoldItems[update.TargetIndex].ItemDataId);

                // merge items if the item is the same
                if (targetItemData != null && targetItemData.Id == sourceItemData.Id)
                {
                    if (HandleBoardInventoryUpdate(new BoardPlayerInventoryMergeUpdate
                        {
                            PlayerId = player.Id,
                            SourceType = BoardPlayerInventoryMergeUpdate.Types.Type.Hold,
                            SourceIndex = update.SourceIndex,
                            TargetType = BoardPlayerInventoryMergeUpdate.Types.Type.Hold,
                            TargetIndex = update.TargetIndex,
                        })) return;
                }

                // swap items
                (player.HoldItems[update.TargetIndex], player.HoldItems[update.SourceIndex]) = (player.HoldItems[update.SourceIndex], player.HoldItems[update.TargetIndex]);
                QueueEvent(new InventoryMoveEvent
                {
                    PlayerId = player.Id,
                    SourceType = ToInventoryType(update.SourceType),
                    SourceRow = update.SourceRow,
                    SourceIndex = update.SourceIndex,
                    TargetType = ToInventoryType(update.TargetType),
                    TargetRow = update.TargetRow,
                    TargetIndex = update.TargetIndex,
                });
            }
            // inventory to hold
            else if (update.SourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory &&
                update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Hold)
            {
                // invalid indices
                if (IsInventoryCellValid(inventory, update.SourceRow, update.SourceIndex) == false)
                    return;

                var sourceItem = inventory.Rows[update.SourceRow].Items[update.SourceIndex];
                if (sourceItem.ItemDataId == 0)
                    return;

                var sourceItemData = ResourceItem.Get(inventory.Rows[update.SourceRow].Items[update.SourceIndex].ItemDataId)!;

                if (update.TargetIndex < player.HoldItems.Count && update.TargetIndex >= 0)
                {
                    var targetItemData = ResourceItem.Get(player.HoldItems[update.TargetIndex].ItemDataId);

                    // merge items if the item is the same
                    if (targetItemData != null && targetItemData.Id == sourceItemData.Id)
                    {
                        if (HandleBoardInventoryUpdate(new BoardPlayerInventoryMergeUpdate
                            {
                                PlayerId = player.Id,
                                SourceType = BoardPlayerInventoryMergeUpdate.Types.Type.Inventory,
                                SourceRow = update.SourceRow,
                                SourceIndex = update.SourceIndex,
                                TargetType = BoardPlayerInventoryMergeUpdate.Types.Type.Hold,
                                TargetIndex = update.TargetIndex,
                            })) return;
                    }
                }

                var index = AppendHoldItemWithShrink(player, inventory.Rows[update.SourceRow].Items[update.SourceIndex]);
                inventory.Rows[update.SourceRow].Items[update.SourceIndex] = GetEmptyBoardItem();
                _playerActiveInventoryDirty = true;
                QueueEvent(new InventoryMoveEvent
                {
                    PlayerId = player.Id,
                    SourceType = ToInventoryType(update.SourceType),
                    SourceRow = update.SourceRow,
                    SourceIndex = update.SourceIndex,
                    TargetType = ToInventoryType(update.TargetType),
                    TargetIndex = index,
                });
            }
            // hold to inventory
            else if (update.SourceType == BoardPlayerInventoryTransferUpdate.Types.Type.Hold &&
                     update.TargetType == BoardPlayerInventoryTransferUpdate.Types.Type.Inventory)
            {
                // invalid indices
                if (IsInventoryCellValid(inventory, update.TargetRow, update.TargetIndex) == false)
                    return;

                // invalid indices
                if (update.SourceIndex >= player.HoldItems.Count || update.SourceIndex < 0)
                    return;
                var sourceItem = player.HoldItems[update.SourceIndex];
                if (sourceItem.ItemDataId == 0)
                    return;

                var sourceResItem = ResourceItem.Get(sourceItem!.ItemDataId)!;
                var targetResItem = ResourceItem.Get(inventory.Rows[update.TargetRow].Items[update.TargetIndex].ItemDataId);

                // merge items if the item is the same
                if (targetResItem != null && targetResItem.Id == sourceResItem.Id)
                {
                    if (HandleBoardInventoryUpdate(new BoardPlayerInventoryMergeUpdate
                        {
                            PlayerId = player.Id,
                            SourceType = BoardPlayerInventoryMergeUpdate.Types.Type.Hold,
                            SourceIndex = update.SourceIndex,
                            TargetType = BoardPlayerInventoryMergeUpdate.Types.Type.Inventory,
                            TargetRow = update.TargetRow,
                            TargetIndex = update.TargetIndex,
                        })) return;
                }
                
                player.HoldItems[update.SourceIndex] = GetEmptyBoardItem();
                
                ShrinkHoldItems(player);

                foreach (var (occupiedItem, row, index) in MoveToHoldOccupiedInventoryItem(inventory, sourceItem, update.TargetRow, update.TargetIndex))
                {
                    var holdIndex = AppendHoldItemWithShrink(player, occupiedItem);
                    QueueEvent(new InventoryMoveEvent
                    {
                        PlayerId = player.Id,
                        SourceType = InventoryMoveEvent.InventoryType.Inventory,
                        SourceRow = row,
                        SourceIndex = index,
                        TargetType = InventoryMoveEvent.InventoryType.Hold,
                        TargetIndex = holdIndex,
                    });
                }
                
                // make sure sourceItem is not null.
                inventory.Rows[update.TargetRow].Items[update.TargetIndex] = sourceItem;

                _playerActiveInventoryDirty = true;
                QueueEvent(new InventoryMoveEvent
                {
                    PlayerId = player.Id,
                    SourceType = ToInventoryType(update.SourceType),
                    SourceIndex = update.SourceIndex,
                    TargetType = ToInventoryType(update.TargetType),
                    TargetRow = update.TargetRow,
                    TargetIndex = update.TargetIndex,
                });
            }
            else
            {
                // invalid event
                return;
            }
        }
        
        private partial void HandleUpdateInternal(BoardPlayerInventoryExpandUpdate update)
        {
            HandleBoardInventoryUpdate(update);
        }

        private void HandleBoardInventoryUpdate(BoardPlayerInventoryExpandUpdate update)
        {
            var player = GetPlayerById(update.PlayerId);
            if (player == null || player.Inventories.Count == 0)
                return;
            var inventory = player.Inventories[0]!;

            var item = inventory.Rows[update.Row].Items[update.Index];
            if (item.Id != -1) return;
            inventory.Rows[update.Row].Items[update.Index].Id = 0;
            QueueEvent(new InventoryExpandEvent
            {
                PlayerId = player.Id,
                Row = update.Row,
                Index = update.Index,
            });
            
            player.IncreaseMission(
                ResourceAchievement.Types.Condition.MissionInventoryExpand,
                1);
        }
        
        private partial void HandleUpdateInternal(BoardPlayerInventoryResetHoldUpdate update)
        {
            HandleBoardInventoryUpdate(update);
        }

        private void HandleBoardInventoryUpdate(BoardPlayerInventoryResetHoldUpdate update)
        {
            InventoryResetHold(GetPlayerById(update.PlayerId));
        }
        
        private void InventoryResetHold(BoardPlayerMessage? player, bool sendEvent = true)
        {
            if (player == null)
                return;
            
            using var toAddInventoryItemsByDiscard = ConcurrentObjectPool<PooledList<int>>.StaticPool.Pop();
            for (var i = 0; i < player.HoldItems.Count; i++)
            {
                if (player.HoldItems[i].ItemDataId == 0)
                    continue;
                HandleSellItem(player, player.HoldItems[i].ItemDataId, toAddInventoryItemsByDiscard);
            }
            player.HoldItems.Clear();
            
            foreach (var itemId in toAddInventoryItemsByDiscard)
            {
                AddInventoryItem(player, player.Inventories[0]!, itemId);
            }
            
            if (sendEvent)
            {
                QueueEvent(new InventoryResetHoldEvent
                {
                    PlayerId = player.Id,
                });
            }
        }

        private void RefreshPlayerActiveInventory(bool applyBuffs = true)
        {
            _playerActiveInventoryDirty = false;
            
            PlayerActiveInventorySkillCommands.Clear();
            foreach (var player in players_.Values)
            {
                if (player.Inventories.Count == 0)
                    continue;

                if (!PlayerActiveInventoryData.TryGetValue(player.Id, out var activeInventoryData))
                    PlayerActiveInventoryData[player.Id] = activeInventoryData = new();
                activeInventoryData.Clear();
                
                var inventory = player.Inventories[0]!;
                var commands = new List<ActiveInventorySkillCommand>();
                var commandBuffDataIdLevels = new Dictionary<int, int>();
                int validMinRow = Int32.MaxValue, validMaxRow = 0, validMinIndex = Int32.MaxValue, validMaxIndex = 0;
                for (var r = 0; r < inventory.Rows.Count; ++r)
                {
                    var row = inventory.Rows[r];
                    for (var i = 0; i < row.Items.Count; ++i)
                    {
                        var item = row.Items[i]; 

                        if (item.Id == -1)
                            continue;
                        
                        validMinRow = Math.Min(validMinRow, r);
                        validMaxRow = Math.Max(validMaxRow, r);
                        validMinIndex = Math.Min(validMinIndex, i);
                        validMaxIndex = Math.Max(validMaxIndex, i);

                        activeInventoryData.InventoryMaxSlotCount++;
                        
                        if (item.ItemDataId == 0)
                            continue;
                        
                        var resItem = ResourceItem.Get(item.ItemDataId)!;
                        if (resItem.Type != ResourceItem.Types.Type.InventorySkill)
                            continue;
                        
                        activeInventoryData.InventorySlotCount++;
                        activeInventoryData.InventorySlotCount += resItem.InventoryCells.Count;

                        var slots = new List<Slot> { new(r, i) };
                        foreach (var inventoryCell in resItem.InventoryCells)
                        {
                            slots.Add(new Slot(r + inventoryCell.Dy, i + inventoryCell.Dx));
                        }

                        activeInventoryData.SlotsByItemId[item.Id] = slots;
                        activeInventoryData.ItemCountByItemDataId[item.ItemDataId] = activeInventoryData.ItemCountByItemDataId.GetValueOrDefault(item.ItemDataId) + 1;
    
                        for (var commandIndex = 0; commandIndex < resItem.InventorySkillCommands.Count; ++commandIndex)
                        {
                            var command = resItem.InventorySkillCommands[commandIndex];
                            var active = true;
                            foreach (var commandItem in command.Items)
                            {
                                var commandItemRow = r + commandItem.Dy;
                                var commandItemIndex = i + commandItem.Dx;
                                var commandInventoryItem = inventory.Rows.GetSafe(commandItemRow)?.Items.GetSafe(commandItemIndex);
                                if (commandInventoryItem == null || commandInventoryItem.ItemDataId == 0)
                                {
                                    active = false;
                                    break;
                                }
                                var commandResItem = ResourceItem.Get(commandInventoryItem.ItemDataId)!;
                                if (commandResItem.Type != ResourceItem.Types.Type.InventorySkill
                                    || commandResItem.Group != commandItem.ItemGroup
                                    || (commandItem.ItemGrade != 0 && commandResItem.Grade != commandItem.ItemGrade))
                                {
                                    active = false;
                                    break;
                                }
                            }

                            if (active)
                            {
                                commands.Add(new ActiveInventorySkillCommand
                                {
                                    PlayerId = player.Id,
                                    Row = r,
                                    Index = i,
                                    ItemDataId = item.ItemDataId,
                                    CommandIndex = commandIndex,
                                    BuffDataId = command.BuffDataId,
                                });
                                if (applyBuffs && command.BuffDataId != 0)
                                    commandBuffDataIdLevels[command.BuffDataId] = resItem.Grade;
                            }
                        }
                    }
                }
                
                foreach (var slots in activeInventoryData.SlotsByItemId.Values)
                {
                    var addSlots = new List<Slot>();
                    
                    //Handle First & Last Row and Index
                    foreach (var baseSlot in slots)
                    {
                        var (row, index) = (baseSlot.row, baseSlot.slot);

                        if (row == validMinRow)
                            row = BoardFirstHandleValue;
                        else if (row == validMaxRow) 
                            row = BoardLastHandleValue;

                        if (index == validMinIndex)
                            index = BoardFirstHandleValue;
                        else if (index == validMaxIndex)
                            index = BoardLastHandleValue;

                        if (row is BoardFirstHandleValue or BoardLastHandleValue ||
                            index is BoardFirstHandleValue or BoardLastHandleValue)
                            addSlots.Add(new Slot(row, index));
                    }
                    
                    slots.AddRange(addSlots);
                }
                
                PlayerActiveInventorySkillCommands[player.Id] = commands;
                if (applyBuffs)
                {
                    foreach (var unit in GetUnitsByPlayerId(player.Id))
                    {
                        foreach (var buff in unit.Buffs.Values)
                        {
                            if (!buff.ResBuff.ContainsTag(Tag.InventorySkillCommandBuff))
                                continue;
                            if (!commandBuffDataIdLevels.Remove(buff.ResBuff.Id))
                                buff.Destroy();
                        }
                        
                        foreach (var (buffDataId, level) in commandBuffDataIdLevels)
                            unit.QueueAddBuff(new GameUnit.QueuedAddBuff(null, buffDataId, level));
                    }
                }

                if (activeInventoryData.EmptySlotCount == 0)
                {
                    player.IncreaseMission(ResourceAchievement.Types.Condition.MissionInventoryFull, 1);
                }
                    
            }
            
            
        }

        private void InitAllPlayerUnitItemVariables(GameUnit unit)
        {
            //todo: temp
            var player = unit.Player;
            if (player?.Inventories.Count > 0)
            {
                foreach (var row in player.Inventories[0].Rows)
                {
                    foreach (var item in row.Items)
                    {
                        InitPlayerUnitItemVariables(unit.VariablesByItemId, item);
                    }
                }
            }

            if (player?.HoldItems.Count > 0)
            {
                foreach (var holdItem in player.HoldItems)
                {
                    InitPlayerUnitItemVariables(unit.VariablesByItemId, holdItem);
                }
            }
        }

        private void InitPlayerUnitItemVariables(MapField<long, ResourceTrigger.Types.Variables> unitItemVariables, PlayerItemMessage item)
        {
            var itemId = item.Id; 
            var itemDataId = item.ItemDataId;
            if (item.Id <= 0 || item.ItemDataId == 0)
                return;
            
            unitItemVariables.Remove(itemId);
            var variables = unitItemVariables[itemId] = new ResourceTrigger.Types.Variables();

            var resItem = ResourceItem.Get(itemDataId)!;
            foreach (var addBuff in resItem.EquipAddBuffs) //need new column
            {
                var resBuff = ResourceBuff.Get(addBuff.BuffDataId);
                if (resBuff == null)
                    continue;
                
                foreach (var initVariable in resBuff.InitVariables)
                {
                    variables.Set(initVariable.CallerKey, initVariable.Value);
                }

                foreach (var addVariable in resBuff.AddVariables)
                {
                    var value = variables.Get(addVariable.CallerKey);
                    variables.Set(addVariable.CallerKey, value + addVariable.Value);
                }
            }
        }
        
        private long GetNextId(BoardPlayerMessage player, PlayerInventory inventory)
        {
            return ++nextInventoryItemId_;
            // if (player.HoldItems.Count == 0 && inventory.Rows.Count == 0)
            //     return 1;
            // if (player.HoldItems.Count == 0)
            //     return Math.Max(inventory.Rows.Max(r => r.Items.Max(i => i.Id)), 0) + 1;
            // if (inventory.Rows.Count == 0)
            //     return Math.Max(player.HoldItems.Max(i => i.Id), 0) + 1;
            // return Math.Max(player.HoldItems.Max(i => i.Id), inventory.Rows.Max(r => r.Items.Max(i => i.Id))) + 1;
        }

        private PlayerItemMessage GetEmptyBoardItem()
        {
            return new PlayerItemMessage
            {
                Id = 0,
                ItemDataId = 0,
            };
        }

        private IEnumerable<(PlayerItemMessage, int row, int index)> MoveToHoldOccupiedInventoryItem(PlayerInventory inventory, PlayerItemMessage scanItem, int row, int index)
        {
            using var reservedCellIndexes = ConcurrentObjectPool<PooledList<(int, int)>>.StaticPool.Pop();

            reservedCellIndexes.Add((row, index));
            
            foreach (var inventoryCell in scanItem.GetData()!.InventoryCells)
            {
                var newRow = row + inventoryCell.Dy;
                var newIndex = index + inventoryCell.Dx;
                if (newRow < 0 || newRow >= inventory.Rows.Count || newIndex < 0 || newIndex >= inventory.Rows[newRow].Items.Count)
                    continue;
                reservedCellIndexes.Add((newRow, newIndex));
            }
            
            for (var r = 0; r < inventory.Rows.Count; r++)
            {
                var rowItems = inventory.Rows[r].Items;
                for (var i = 0; i < rowItems.Count; i++)
                {
                    var item = rowItems[i];
                    if (scanItem.Id == item.Id)
                        continue;
                    
                    if (item.ItemDataId == 0)
                        continue;

                    if (reservedCellIndexes.Contains((r, i)))
                    {
                        yield return (item, r, i);
                        inventory.Rows[r].Items[i] = GetEmptyBoardItem();
                        continue;
                    }
                        
                    var resItem = ResourceItem.Get(rowItems[i].ItemDataId)!;
                    foreach (var inventoryCell in resItem.InventoryCells)
                    {
                        var newRow = r + inventoryCell.Dy;
                        var newIndex = i + inventoryCell.Dx;
                        if (reservedCellIndexes.Contains((newRow, newIndex)))
                        {
                            yield return (item, r, i);
                            inventory.Rows[r].Items[i] = GetEmptyBoardItem();
                            break;
                        }
                    }
                }
            }
        }
        
    }
}
