using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Security;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Utility;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public BoardPlayerMessage? GetPlayerById(long playerId)
        {
            return players_.GetValueOrDefault(playerId);
        }

        private void JoinPlayerUnit(BoardPlayerMessage player, PlayerAvatar avatar,
            PlayerItemMessage? character, FixedVector2 position, int offset = 0, int team = Team.Player)
        {
            if (character == null || character.ItemDataId == 0)
                return;
        
            var unit = new GameUnit
            {
                DataId = ResourceItem.Get(character.ItemDataId)!.UnitDataId,
                PlayerId = player.Id,
                Level = player.Level,
                PlayerAvatar = avatar,
                Position = (Vector2Message)position,
                Direction = (Vector2Message)FixedVector2.right,
                Velocity = new Vector2Message(),
                Team = team,
                Offset = offset,
            };
            unit.BaseStat.Clear();
            unit.BaseStat.AddRange(player.ItemStat);
            
            QueueAddUnit(unit);
        }

        private void AddOrUpdatePlayer(BoardPlayerMessage player, PlayerAvatar avatar)
        {
            var prevPlayer = players_.GetValueOrDefault(player.Id);
            players_[player.Id] = player;
            player.Board = this;
            if (prevPlayer == null)
            {
                if (ResMap.InitGold != 0)
                    player.Gold = ResMap.InitGold;

                if (ResMap.InitLevel != 0)
                    player.Level = ResMap.InitLevel;

                if (ResMap.ContainsTag(Tag.ContainPlayerInventory))
                {
                    var playerInventory = new PlayerInventory();
                    var inventoryExpandStartBonus = 0;
                    foreach (var trait in player.AppliedTraits)
                    {
                        if (trait.GetData()!.ContainsTag(Tag.InventoryExpandStartBonus))
                            inventoryExpandStartBonus += (int)trait.Count;
                    }

                    var inventoryShape = ResMap.PlayerInventoryShape ?? 
                                         ResourceMap.Global.BoardConstants.DefaultPlayerInventoryShapes.GetClamped(inventoryExpandStartBonus);
                    if (inventoryShape != null)
                    {
                        foreach (var shapeRow in inventoryShape.Rows)
                        {
                            var inventoryRow = new PlayerInventoryRow();
                            foreach (var cell in shapeRow.Cells)
                                inventoryRow.Items.Add(cell
                                    ? new PlayerItemMessage()
                                    : new PlayerItemMessage { Id = -1L, });
                            playerInventory.Rows.Add(inventoryRow);
                        }

                        // handle out-game items
                        // note: only the first item is placed
                        // foreach (var equipItem in avatar.Equipments)

                        // {
                        var unitItemMessage = avatar.Character;
                        if (unitItemMessage.ItemDataId != 0)
                        {
                            var unitItem = ResourceItem.Get(unitItemMessage.ItemDataId);
                            var equipItemId = unitItem?.EquipAddItemGroups.GetAddItem()?.ItemDataId ?? 0;
                            var equipItem = ResourceItem.Get(equipItemId);
                            if (equipItem != null)
                            {
                                var placeable = false;
                                int itemX = 0, itemY = 0;
                                for (var pivotX = 0; pivotX < playerInventory.Rows.Count; ++pivotX)
                                {
                                    for (var pivotY = 0;
                                         pivotY < playerInventory.Rows[pivotX].Items.Count;
                                         ++pivotY)
                                    {
                                        var pivot = playerInventory.Rows[pivotX].Items[pivotY];
                                        // blocked cell: item cannot be placed
                                        if (pivot.Id == -1)
                                            continue;
                                        var placableForPivot = true;
                                        foreach (var cell in equipItem.InventoryCells)
                                        {
                                            var x = pivotX + cell.Dx;
                                            var y = pivotY + cell.Dy;
                                            // item cannot be placed
                                            if (x < 0 || y < 0 || x >= playerInventory.Rows.Count ||
                                                y >= playerInventory.Rows[x].Items.Count)
                                            {
                                                placableForPivot = false;
                                                break;
                                            }

                                            if (playerInventory.Rows[x].Items[y].Id == -1)
                                            {
                                                placableForPivot = false;
                                                break;
                                            }
                                        }

                                        if (placableForPivot)
                                        {
                                            placeable = true;
                                            itemX = pivotX;
                                            itemY = pivotY;
                                            break;
                                        }
                                    }

                                    if (placeable)
                                        break;
                                }

                                if (placeable)
                                {
                                    playerInventory.Rows[itemX].Items[itemY] = new PlayerItemMessage
                                    {
                                        Id = GetNextId(player, playerInventory),
                                        ItemDataId = equipItem.Id,
                                    };
                                }
                            }
                        }

                        _playerActiveInventoryDirty = true;
                    }

                    if (ResMap.MissionDataIds.Count > 0)
                    {
                        player.InitMissions(ResMap);
                    }

                    if (player.Inventories.Count == 0)
                        player.Inventories.Add(playerInventory);
                    else
                        player.Inventories[0] = playerInventory;
                }

                if (ResMap.ContainsTag(Tag.ContainPlayerTrait))
                {
                    player.RerollLevelUpSelectTrait = -1;
                }
                // InitPlayerNextItems();
                // InitPlayerHoldItems();
                
                
                // join units by map type
                switch (ResMap.Type)
                {
                    case ResourceMap.Types.Type.DefenseRank:
                    {
                        var unitCountLeft = ResMap.PlayerUnitCount;
                        for (var i = 0; i < avatar.OffenseUnits.Count; i++)
                        {
                            var unit = avatar.OffenseUnits[i];
                            if (unit.ItemDataId == 0)
                                continue;
                            var location = ResMap.GetLocationById(ResourceMap.LocationId.Offense1 - i, this)!;
                            JoinPlayerUnit(player, avatar, unit, location.GetRandomPoint(this), offset: -(i + 1), Team.PlayerRed);
                            if (--unitCountLeft == 0)
                                break;
                        }

                        if (defensePlayer_ != null)
                        {
                            for (var i = 0; i < defensePlayerAvatar_.DefenseUnits.Count; i++)
                            {
                                var unit = defensePlayerAvatar_.DefenseUnits[i];
                                if (unit.ItemDataId == 0)
                                    continue;
                                var location = ResMap.GetLocationById(ResourceMap.LocationId.Defense1 - i, this)!;
                                JoinPlayerUnit(defensePlayer_, defensePlayerAvatar_, unit, location.GetRandomPoint(this), offset: -(i + 1), Team.PlayerBlue);
                                if (--unitCountLeft == 0)
                                    break;
                            }
                        }
                        
                        break;
                    }
                    default:
                    {
                        if (ResMap.PlayerUnitCount == 0)
                            JoinPlayerUnit(player, avatar, avatar.Character,
                                ResMap.GetLocationById(ResourceMap.LocationId.Player, this)!.GetRandomPoint(this));
                        else
                        {
                            if (ResMap.HasLocationById(ResourceMap.LocationId.Player1))
                            {
                                var unitCountLeft = ResMap.PlayerUnitCount;
                                for (var i = 0; i < avatar.Units.Count; i++)
                                {
                                    var unit = avatar.Units[i];
                                    if (unit.ItemDataId == 0)
                                        continue;
                                    var location = ResMap.GetLocationById(ResourceMap.LocationId.Player1 - i, this)!;
                                    JoinPlayerUnit(player, avatar, unit, location.GetRandomPoint(this), offset: -(i + 1));
                                    if (--unitCountLeft == 0)
                                        break;
                                }
                            }
                            else
                            {
                                var unitIdx = 0;
                                foreach (var position in ResMap.GetBalancedLocationsById(ResourceMap.LocationId.Player,
                                             ResMap.PlayerUnitCount, this))
                                    JoinPlayerUnit(player, avatar, avatar.Units.GetSafe(unitIdx++), position.GetRandomPoint(this));
                            }
                        }
                        break;
                    }
                }
            }
            else
            {
                player.Kills = prevPlayer.Kills;
                player.Deaths = prevPlayer.Deaths;
                
                if (player.Inventories.Count == 0)
                    player.Inventories.AddRange(prevPlayer.Inventories);
                
                foreach (var unit in GetUnitsByPlayerId(player.Id))
                {
                    // Note: This is a temporary solution dedicated to IdleZ
                    //unit.Level = player.Level;
                    unit.DataId = ResourceItem.Get(avatar.Character.ItemDataId)!.UnitDataId;
                    unit.PlayerAvatar = avatar;
                    unit.BaseStat.Clear();
                    unit.BaseStat.AddRange(player.ItemStat);
                    unit.SetStatDirty();
                }
            }
            
            if (prevPlayer == null)
                QueueEvent(new PlayerJoinedEvent
                {
                    Player = player,
                    Avatar = avatar,
                });
            else
                QueueEvent(new PlayerUpdatedEvent
                {
                    Player = player,
                    Avatar = avatar,
                });
        }
        
        public void RemovePlayer(long playerId)
        {
            if (players_.Remove(playerId, out var player))
                QueueEvent(new PlayerLeftEvent
                {
                    Player = player,
                });
        }
        
        public void ClearPlayers()
        {
            foreach (var player in players_.Values)
                QueueEvent(new PlayerLeftEvent
                {
                    Player = player,
                });
            players_.Clear();
        }
        
    }
}
