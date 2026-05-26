using Commons;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;

using Commons.Utility;
using Newtonsoft.Json.Linq;
using Server;
using Server.Events;
using Server.Models;
using Server.Stuffs;
using static Commons.Game.Events.BoardEvent.Type;
using BoardEvent = Server.Events.BoardEvent;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    protected override void HandleEventInternal(ServerEvent @event)
    {
        base.HandleEventInternal(@event);
        switch (@event.EventType)
        {
            case ServerEvent.Type.BoardEvent:
            {
                var boardEvent = ((BoardEvent)@event).Event;
                switch (boardEvent.EventType)
                {
                    case UnitGetDropItem:
                    {
                        var unitGetDropItem = (UnitGetDropItemEvent)boardEvent;
                        if (unitGetDropItem.Exp > 0L)
                        {
                            var item = CashItemManager.GetItemByDataId(unitGetDropItem.ItemDataId);
                            if (item == null)
                                break;
                            CashItemManager.AddExp(item, unitGetDropItem.Exp);
                        }
                        else if (unitGetDropItem.ItemDataId == ResourceItem.Global.DataId.Gold)
                        {
                            // Gold is already reflected through board state updates.
                        }
                        else
                            CashItemManager.AddItem(unitGetDropItem.ItemDataId, unitGetDropItem.Count, unitGetDropItem.Level);
                        
                        if (Config.IsDebug)
                            Logger.Info($"{this} received {Board?.ToDebugString()} UnitGetDropItem: {unitGetDropItem.ItemDataId} {unitGetDropItem.Count} {unitGetDropItem.Level} {unitGetDropItem.Exp}");
                        
                        break;
                    }
                    case EndGame:
                    {
                        var endGame = (EndGameEvent)boardEvent;

                        IsSavePending = true;

                        var board = Board;
                        if (board == null)
                        {
                            Logger.Warn($"{this} received EndGame without an active board");
                            break;
                        }
                        var resMap = board.ResMap;
                        if (endGame.WinningTeam != 0)
                        {
                            var playerUnit = board.GetUnitByPlayerId(Id);
                            if (playerUnit != null && playerUnit.Team == endGame.WinningTeam)
                            {
                                var addedItemStuffs = new List<AddedItemStuff>();
                                CashItemManager.AddItem(board.ResMap.RewardAddItemGroups, addedItemStuffs: addedItemStuffs);
                                SendAcquiredItemsUpdate(addedItemStuffs.ToPlayerItemMessages(), type: PlayerAcquiredItemsUpdate.Types.Type.EndGame, mapDataId: board.ResMap.Id);
                            }

                            switch (board.ResMap.Type)
                            {
                                case ResourceMap.Types.Type.DefenseRank:
                                {
                                    var defenseTargetUnit = board.Units.Values.FirstOrDefault(u => u.ResUnit.ContainsTag(Tag.DefenseTarget));
                                    var defenseHpPercent = defenseTargetUnit == null ? 0f : 100f * defenseTargetUnit.Hp / defenseTargetUnit.MaxHp;

                                    var rankPointBonus = 0;
                                    var opponentRankPointBonus = 0;
                                    var rankPointTakeRatio = 0f;

                                    if (defenseHpPercent > board.ResMap.DefenseFailHpPercent)
                                        opponentRankPointBonus = board.ResMap.DefenseFailBonusRankPoint;
                                    else if (defenseHpPercent > 0f)
                                    {
                                        rankPointBonus = board.ResMap.DefenseEndBonusRankPoint;
                                        rankPointTakeRatio = (1f - defenseHpPercent / 100f) * board.ResMap.DefenseEndRankPointPercent / 100f;
                                    }
                                    else
                                    {
                                        rankPointBonus = board.ResMap.DefenseSuccessBonusRankPoint;
                                        rankPointTakeRatio = board.ResMap.DefenseSuccessRankPointPercent / 100f;
                                    }

                                    var playerContext = new Server<WorldServer, WorldPlayer>.MultiPlayerTaskContext(Id);
                                    var opponentContext = new Server<WorldServer, WorldPlayer>.MultiPlayerTaskContext(OpponentBoardPlayer!.Id);
                                    _ = Server.RunMultiPlayerTasks(async () =>
                                    {
                                        var resRankPointItem = ResourceItem.Get(ResourceItem.Global.DataId.RankPoint)!;
                                        
                                        var playerRankPoint =
                                            playerContext.Player?.CashItemManager.GetItemByDataId(resRankPointItem.Id)
                                            ?? (await PlayerItemModel.GetAsync(playerContext.PlayerId, resRankPointItem.Id).ConfigureAwait(false))!;
                                        var opponentRankPoint =
                                            opponentContext.Player?.CashItemManager.GetItemByDataId(resRankPointItem.Id)
                                            ?? (await PlayerItemModel.GetAsync(opponentContext.PlayerId, resRankPointItem.Id).ConfigureAwait(false))!;
                                        
                                        var rankPointTake = (int)(rankPointTakeRatio * opponentRankPoint.count);
                                        var prevPlayerRankPoint = playerRankPoint.count;
                                        playerRankPoint.count += rankPointBonus + rankPointTake;
                                        var prevOpponentRankPoint = opponentRankPoint.count;
                                        opponentRankPoint.count = Math.Max(resRankPointItem.MinCount, opponentRankPoint.count + opponentRankPointBonus - rankPointTake);
                                        
                                        if (playerContext.Player == null)
                                            playerContext.SaveFunctions.Add(playerRankPoint.SaveAsync);
                                        if (opponentContext.Player == null)
                                            opponentContext.SaveFunctions.Add(opponentRankPoint.SaveAsync);
                                        
                                        if (resRankPointItem.RankingItemDataId != 0)
                                        {
                                            var resRankingItem = ResourceItem.Get(resRankPointItem.RankingItemDataId)!;
                                            var date = resRankingItem.GetRankingDate();
                                            
                                            if (playerContext.Player == null)
                                                playerContext.SaveFunctions.Add((db, transaction) => PlayerRankingModel.UpdateSetScoreAsync(db, transaction, resRankingItem.RankingId, date, playerContext.PlayerId, playerRankPoint.count));
                                            else
                                                playerContext.Player.RankingManager.QueueRankingScore(resRankingItem, date, playerRankPoint.count);
                                            
                                            if (opponentContext.Player == null)
                                                opponentContext.SaveFunctions.Add((db, transaction) => PlayerRankingModel.UpdateSetScoreAsync(db, transaction, resRankingItem.RankingId, date, opponentContext.PlayerId, opponentRankPoint.count));
                                            else
                                                opponentContext.Player.RankingManager.QueueRankingScore(resRankingItem, date, opponentRankPoint.count);
                                        }

                                        var logData = new
                                        {
                                            PlayerId = playerContext.PlayerId,
                                            PrevRankPoint = prevPlayerRankPoint,
                                            RankPoint = playerRankPoint.count,
                                            
                                            OpponentPlayerId = opponentContext.PlayerId,
                                            PrevOpponentRankPoint = prevOpponentRankPoint,
                                            OpponentRankPoint = opponentRankPoint.count,
                                            
                                            BoardId = board.Id,
                                            BoardMapDataId = board.ResMap.Id,
                                            WinningTeam = endGame.WinningTeam,
                                            
                                            DefenseHpPercent = defenseHpPercent,
                                            RankPointBonus = rankPointBonus,
                                            RankPointTake = rankPointTake,
                                            OpponentRankPointBonus = opponentRankPointBonus,
                                        };
                                        if (playerContext.Player == null)
                                            playerContext.SaveFunctions.Add(new PlayerLogModel
                                            {
                                                player_id = playerContext.PlayerId,
                                                type = PlayerLogModel.Type.DefenseRankResult,
                                                data = JObject.FromObject(logData),
                                            }.SaveAsync);
                                        else
                                            playerContext.Player.PlayerLogManager.Queue(PlayerLogModel.Type.DefenseRankResult, logData);
                                        
                                        if (opponentContext.Player == null)
                                            opponentContext.SaveFunctions.Add(new PlayerLogModel
                                            {
                                                player_id = opponentContext.PlayerId,
                                                type = PlayerLogModel.Type.DefenseRankResult,
                                                data = JObject.FromObject(logData),
                                            }.SaveAsync);
                                        else
                                            opponentContext.Player.PlayerLogManager.Queue(PlayerLogModel.Type.DefenseRankResult, logData);
                                        
                                        await new PlayerPushModel
                                        {
                                            player_id = opponentContext.PlayerId,
                                            message = opponentContext.Model.GetString("Push/DefenseRankLose", playerContext.Model.name),
                                        }.SaveAsync().ConfigureAwait(false);
                                    }, playerContext, opponentContext);
                                    
                                    break;
                                }
                            }
                        }
                        
                        if (Config.IsDebug)
                            Logger.Info($"{this} received {Board?.ToDebugString()} EndGame: {endGame.WinningTeam}");
                        
                        break;
                    }
                    case IncreaseAchievement:
                    {
                        var increaseAchievement = (IncreaseAchievementEvent)boardEvent;
                        if (increaseAchievement.PlayerId != 0L && increaseAchievement.PlayerId != Id)
                            break;
                        var addedItemStuffs = new List<AddedItemStuff>();
                        AchievementManager.IncreaseAchievement(increaseAchievement.AchievementDataId, increaseAchievement.Progress, addedItemStuffs);
                        if (addedItemStuffs.Count > 0)
                        {
                            var board = Board;
                            SendAcquiredItemsUpdate(
                                addedItemStuffs.ToPlayerItemMessages(),
                                type: PlayerAcquiredItemsUpdate.Types.Type.WinWave,
                                mapDataId: board?.ResMap.Id ?? 0);
                        }

                        if (Config.IsDebug)
                            Logger.Info($"{this} received {Board?.ToDebugString()} IncreaseAchievement: {increaseAchievement.AchievementDataId} {increaseAchievement.Progress}");
                        
                        break;
                    }
                    case PlayerLeft:
                    {
                        var playerLeft = (PlayerLeftEvent)boardEvent;
                        if (playerLeft.Player.Id == Id)
                        {
                            var board = Board!;
                            var resMap = board.ResMap;
                            
                            LeaveBoardCallback?.Invoke(StatusCode.Ok);
                            ClearBoard();
                            board.Unsubscribe(this);
                            SendUpdate();
                            
                            if (resMap.PlayerUnitCount > 0)
                            {
                                if (resMap.UnitStaminaPenalty > 0 || resMap.UnitStaminaPenaltyOnDeath > 0)
                                {
                                    var aliveUnitOffsets = new HashSet<int>();
                                    foreach (var unit in board.GetUnitsByPlayerId(Id))
                                    {
                                        if (unit.IsAlive)
                                            aliveUnitOffsets.Add(unit.Offset);
                                    }
                                    
                                    var unitCountLeft = resMap.PlayerUnitCount;
                                    IList<PlayerItemMessage> units = resMap.Type switch
                                    {
                                        ResourceMap.Types.Type.DefenseRank => Avatar.OffenseUnits,
                                        _ => Avatar.Units
                                    };
                                    for (var i = 0; i < units.Count; ++i)
                                    {
                                        var unit = units[i];
                                        if (unit.Id == 0L)
                                            continue;
                                        var unitItem = CashItemManager.GetItemById(unit.Id)!;
                                        int penalty;
                                        if (aliveUnitOffsets.Contains(-(i + 1)))
                                            penalty = resMap.UnitStaminaPenalty;
                                        else
                                            penalty = resMap.UnitStaminaPenaltyOnDeath;
                                        if (!unitItem.HasMineBinding())
                                        {
                                            var stamina = unitItem.GetCurrentUnitStamina(CashItemManager.MaxStaminaBoostRatio,
                                                CashItemManager.StaminaRegenBoostRatio, out var offsetTime);
                                            unitItem.param1 = Math.Max(0, stamina - penalty);
                                            unitItem.param2 = offsetTime;
                                        }
                                        else
                                            unitItem.param1 = Math.Max(0, unitItem.param1 - penalty);
                                        if (--unitCountLeft == 0)
                                            break;
                                    }
                                }
                            }
                            
                            // 생성자의 경우 refund Material
                            if (board.Creator?.Id == Id && board.ResMap.ContainsTag(Tag.RefundMaterialsWhenFail))
                            {
                                //방생성시 기록한 소모 재화 돌려주기.
                                if (GameBoard.Team.Player != board.WinningTeam)
                                {
                                    var usedMaterialItems = board.UsedMaterialItems;
                                    if (usedMaterialItems != null)
                                    {
                                        foreach (var (usedMaterialItem, usedMaterialItemCount) in usedMaterialItems)
                                        {
                                            usedMaterialItem.deleted = false;
                                            usedMaterialItem.count += usedMaterialItemCount;
                                        }
                                    }

                                    board.UsedMaterialItems = null;    
                                }
                            }
                            
                            
                            var boardHistory = BoardHistoryModel.Get(board.Id);
                            if (boardHistory == null)
                                Logger.Error($"{board.ToDebugString()} history not found");
                            else
                            {
                                boardHistory.SetBoard(board);

                                var summary = new JObject
                                {
                                    ["playtime"] = board.TickSeconds * board.Tick,
                                    ["mapId"] = board.ResMap.Id,
                                    ["WinningTeam"] = board.WinningTeam,
                                    ["wave"] = board.Variables.GetInt(601),
                                };
                                
                                var boardPlayer = playerLeft.Player;
                                var playerSummary = new JObject
                                {
                                    ["id"] = boardPlayer.Id
                                };
                                var inventoryItems = boardPlayer.Inventories[0].Rows.SelectMany(row => row.Items.Select(item => item.DataId));
                                playerSummary["inventoryItems"] = JArray.FromObject(inventoryItems);
                                playerSummary["traits"] = JArray.FromObject(boardPlayer.AppliedTraits);
                                playerSummary["missions"] = JArray.FromObject(boardPlayer.Missions.Values);
                                playerSummary["acquiredItems"] = JArray.FromObject(boardPlayer.AcquiredItems);
                                
                                summary["player"] = playerSummary;

                                var boardPlayerUnit = board.GetUnitByPlayerId(boardPlayer.Id);
                                if (boardPlayerUnit != null)
                                {
                                    var playerUnitSummary = new JObject
                                    {
                                        ["level"] = boardPlayerUnit.Level,
                                        ["stats"] = JObject.FromObject(boardPlayerUnit.Stat.ToDoubleDictionary()),
                                        ["pets"] = JArray.FromObject(boardPlayerUnit.PlayerAvatar.Pets),
                                        ["CumulativeSpawnCountWithoutReset"] = boardPlayerUnit.Variables.GetInt((int) Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type.CumulativeSpawnCountWithoutReset)
                                    };
                                    summary["playerUnit"] = playerUnitSummary;
                                }

                                boardHistory.summary = summary;

                                boardHistory.Save();
                            }
                        }
                        break;
                    }
                }

                break;
            }
        }
    }
}
