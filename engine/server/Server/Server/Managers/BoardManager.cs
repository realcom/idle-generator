using System.Collections.Concurrent;
using Commons;
using Commons.Game;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.Protobuf;
using Google.Protobuf.WellKnownTypes;
using log4net;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Player;

namespace Server.Managers;

public static class BoardManager
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

    public static float BoardServerUpdateIntervalSeconds = GameBoard.TickDuration;
    public static bool BoardAutoProgress = true;

    public static IServer Server = null!;
    private static readonly ConcurrentDictionary<long, GameBoard> BoardById = new();
    private static readonly ConcurrentDictionary<int, ConcurrentDictionary<long, GameBoard>> BoardsByMapDataId = new();
    
    public static GameBoard? GetBoardById(long boardId)
    {
        return BoardById.GetValueOrDefault(boardId);
    }
    
    public static IEnumerable<GameBoard> GetBoardsByMapDataId(int mapDataId)
    {
        return BoardsByMapDataId.GetValueOrDefault(mapDataId)?.Values ?? Enumerable.Empty<GameBoard>();
    }

    private static void AddBoard(GameBoard board)
    {
        BoardById[board.Id] = board;
        if (!BoardsByMapDataId.TryGetValue(board.DataId, out var boards))
            BoardsByMapDataId[board.DataId] = boards = new ConcurrentDictionary<long, GameBoard>();
        boards[board.Id] = board;
    }
    
    public static void RemoveBoard(GameBoard board)
    {
        BoardById.TryRemove(board.Id, out _);
        BoardsByMapDataId[board.DataId].TryRemove(board.Id, out _);
    }

    public static StatusCode CanJoinBoard(GameBoard board, IPlayer player)
    {
        if (Server.OnMaintenance && !player.IsAdmin)
            return StatusCode.ServerMaintenance;
        if (board.Destroyed)
            return StatusCode.BoardDestroyed;
        if (player.Board != null)
            return StatusCode.BoardAlreadyJoined;

        var resMap = board.ResMap;
        if (resMap.PlayerUnitCount > 0 && resMap.RequiredUnitStamina > 0)
        {
            var unitCountLeft = resMap.PlayerUnitCount;
            IList<PlayerItemMessage> units = resMap.Type switch
            {
                ResourceMap.Types.Type.DefenseRank => player.Avatar.OffenseUnits,
                _ => player.Avatar.Units
            };
            for (var i = 0; i < units.Count; ++i)
            {
                var unitItemMessage = units[i];
                if (unitItemMessage.Id == 0)
                    continue;
                var unitItem = player.GetItemById(unitItemMessage.Id);
                if (unitItem == null)
                    return StatusCode.BadRequest;
                var stamina = unitItem.GetCurrentUnitStamina(player.MaxStaminaBoostRatio,
                    player.StaminaRegenBoostRatio, out _);
                if (stamina < resMap.RequiredUnitStamina)
                    return StatusCode.ItemNotEnoughStamina;
                if (--unitCountLeft == 0)
                    break;
            }

            if (unitCountLeft > 0)
                return StatusCode.ItemNotEnoughStamina;
        }

        switch (resMap.Type)
        {
            case ResourceMap.Types.Type.DefenseRank:
            {
                if (player.OpponentBoardPlayer == null || player.OpponentBoardPlayerAvatar == null)
                    return StatusCode.BadRequest;
                break;
            }
        }
        
        return StatusCode.Ok;
    }
    
    public static (StatusCode, GameBoard?) CreateBoard(IPlayer? player, int mapDataId)
    {
        return CreateBoardInternal(player, mapDataId);
    }

    private static bool ResolveBoardAutoProgress(ResourceMap resMap)
    {
        if (resMap.UsesBoardNoReplaySync())
            return true;

        return BoardAutoProgress;
    }
    
    private static (StatusCode, GameBoard?) CreateBoardInternal(IPlayer? player, int mapDataId)
    {
        var resMap = ResourceMap.Get(mapDataId)!;
        var board = new GameBoard
        {
            Server = Server,
            DataId = mapDataId,
            TickSeconds = BoardServerUpdateIntervalSeconds,
            AutoProgress = ResolveBoardAutoProgress(resMap),
            Creator = player
        }.Init();

        if (player != null)
        {
            var canJoinBoard = CanJoinBoard(board, player);
            if (!canJoinBoard.IsSuccess())
                return (canJoinBoard, null);
        }

        var boardHistory = new BoardHistoryModel();
        boardHistory.SetBoard(board);
        if (player != null)
            boardHistory.player_ids = [player.Id];
        boardHistory.Save();

        board.Id = boardHistory.id;
        board.CreatedAt = new Timestamp().Set(boardHistory.created_at);
        AddBoard(board);

        switch (board.ResMap.Type)
        {
            case ResourceMap.Types.Type.DefenseRank:
            {
                board.DefensePlayer = player?.OpponentBoardPlayer;
                board.DefensePlayerAvatar = player?.OpponentBoardPlayerAvatar;
                break;
            }
        }
        
        if (player != null)
        {
            
            board.JoinPlayer(board.Tick, player);
            player.InitBoard(board);
        }
        board.ProgressTick();
        board.Run();
        
        Logger.Info($"{player} created {board.ToDebugString()} sync={resMap.GetBoardSyncMode()} autoProgress={board.AutoProgress} (Total: {BoardById.Count})");
        
        player?.PlayerLogManager.Queue(PlayerLogModel.Type.CreateBoard, new
        {
            MapDataId = mapDataId,
            BoardId = board.Id,
        });
        
        return (StatusCode.Ok, board);
    }
    
    public static void JoinBoardById(IPlayer player, long boardId,
        Action<StatusCode, GameBoard?>? callBack = null)
    {
        var board = GetBoardById(boardId);
        if (board == null)
        {
            callBack?.Invoke(StatusCode.BoardNotFound, null);
            return;
        }

        board.QueueServerPostAction(() =>
        {
            var status = JoinBoardInternal(board, player);
            callBack?.Invoke(status, status.IsSuccess() ? board : null);
        });
    }

    public static void JoinBoardByMapDataId(IPlayer player, int mapDataId,
        Action<StatusCode, GameBoard?>? callBack = null)
    {
        foreach (var board in GetBoardsByMapDataId(mapDataId))
        {
            if (!CanJoinBoard(board, player).IsSuccess())
                continue;
            board.QueueServerPostAction(() =>
            {
                var status = JoinBoardInternal(board, player);
                callBack?.Invoke(status, status.IsSuccess() ? board : null);
            });
            return;
        }

        var (status, newBoard) = CreateBoardInternal(player, mapDataId);
        callBack?.Invoke(status, newBoard);
    }

    private static StatusCode JoinBoardInternal(GameBoard board, IPlayer player)
    {
        var canJoinBoard = CanJoinBoard(board, player);
        if (!canJoinBoard.IsSuccess())
            return canJoinBoard;

        board.JoinPlayer(board.Tick, player);
        
        if (Config.IsDebug)
            Logger.Info($"{player} joined {board.ToDebugString()}");
        
        player.PlayerLogManager.Queue(PlayerLogModel.Type.JoinBoard, new
        {
            BoardId = board.Id,
            BoardMapDataId = board.ResMap.Id,
        });
        
        return StatusCode.Ok;
    }

    public static void AutoPlayToTickBoard(IPlayer player, uint toTick, Action<StatusCode>? callback = null)
    {
        var board = player.Board;
        if (board == null)
        {
            callback?.Invoke(StatusCode.BoardNotJoined);
            return;
        }
        
        board.AutoPlayToTick(toTick, callback);
    }
    
    public static void LeaveBoard(IPlayer player, bool force = false, Action<StatusCode>? callback = null)
    {
        var board = player.Board;
        if (board == null)
        {
            callback?.Invoke(StatusCode.BoardNotJoined);
            return;
        }

        board.QueueServerPostAction(() =>
        {
            player.LeaveBoardCallback = callback;
            var status = LeaveBoardInternal(board, player, force);
            if (!status.IsSuccess())
            {
                player.LeaveBoardCallback = null;
                callback?.Invoke(status);
            }
        });
        if (!board.AutoProgress)
        {
            board.ClearUpdates();
            board.ClearActions();
            board.AutoProgress = true;
        }
    }
    
    private static StatusCode LeaveBoardInternal(GameBoard board, IPlayer player, bool force = false)
    {
        if (!ReferenceEquals(player.Board, board))
            return StatusCode.BoardNotJoined;
        if (!force && !board.Destroyed)
        {
            if (board.ResMap.LockLeaveUntilEnd && board.WinningTeam == 0)
                return StatusCode.BoardNotEnded;
        }
        
        board.LeavePlayer(board.Tick, player);
        
        if (Config.IsDebug)
            Logger.Info($"{player} left {board.ToDebugString()}");
        
        player.PlayerLogManager.Queue(PlayerLogModel.Type.LeaveBoard, new
        {
            BoardId = board.Id,
            BoardMapDataId = board.ResMap.Id,
        });
        
        return StatusCode.Ok;
    }
}
