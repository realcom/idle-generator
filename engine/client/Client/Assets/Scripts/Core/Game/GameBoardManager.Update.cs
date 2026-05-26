using System.Collections.Generic;
using System.Linq;
using System.Text;
using Commons;
using Commons.Game;
using Commons.Game.Actions;
using Commons.Packets;
using Commons.Packets.Updates;
using Commons.Types.Players;
using Commons.Utility;
using Cysharp.Threading.Tasks;
using Google.FlatBuffers;
using Google.Protobuf;
using Google.Protobuf.Collections;
using UnityEngine;

public partial class GameBoardManager

{

    // BoardPlayerRunCheatUpdate

    public void UpdateBoardMyPlayer(PlayerAvatar avatar, bool left, BoardPlayerMessage player)
    {
        var boardPlayerUpdate = new BoardPlayerUpdate
        {
            Avatar = avatar,
            Left = left,
            Player = player,
            Tick = 0,
        };
        _gameBoard.QueueUpdate(boardPlayerUpdate);
    }

    public void UpdateBoardAchievement(IEnumerable<PlayerAchievementMessage> achievements)
    {
        var boardAchievementUpdate = new BoardAchievementUpdate
        {
            Tick = 0,
            Achievements = { achievements },
        };
        _gameBoard.QueueUpdate(boardAchievementUpdate);
    }

    public void UpdateBoardPlayerInventoryMerge(BoardPlayerInventoryMergeUpdate.Types.Type sourceType, int sourceRow, int sourceIndex, BoardPlayerInventoryMergeUpdate.Types.Type targetType, int targetRow, int targetIndex, long playerId)
    {
        var boardPlayerInventoryMergeUpdate = new BoardPlayerInventoryMergeUpdate
        {
            Tick = 0,
            PlayerId = playerId,
            SourceType = sourceType,
            SourceRow = sourceRow,
            SourceIndex = sourceIndex,
            TargetType = targetType,
            TargetRow = targetRow,
            TargetIndex = targetIndex,
        };
        _gameBoard.QueueUpdate(boardPlayerInventoryMergeUpdate);
    }

    public void UpdateBoardPlayerInventorySpawn(long playerId)
    {
        var boardPlayerInventorySpawnUpdate = new BoardPlayerInventorySpawnUpdate
        {
            Tick = 0,
            PlayerId = playerId,
        };
        _gameBoard.QueueUpdate(boardPlayerInventorySpawnUpdate);
    }

    public void UpdateBoardPlayerInventoryMove(int sourceRow, int sourceIndex, int targetRow, int targetIndex, long playerId)
    {
        var boardPlayerInventoryMoveUpdate = new BoardPlayerInventoryMoveUpdate
        {
            Tick = 0,
            PlayerId = playerId,
            SourceRow = sourceRow,
            SourceIndex = sourceIndex,
            TargetRow = targetRow,
            TargetIndex = targetIndex,
        };
        _gameBoard.QueueUpdate(boardPlayerInventoryMoveUpdate);
    }

    public void UpdateBoardPlayerInventoryTransfer(BoardPlayerInventoryTransferUpdate.Types.Type sourceType, int sourceRow, int sourceIndex, BoardPlayerInventoryTransferUpdate.Types.Type targetType, int targetRow, int targetIndex, long playerId)
    {
        var boardPlayerInventoryMoveUpdate = new BoardPlayerInventoryTransferUpdate
        {
            Tick = 0,
            PlayerId = playerId,
            SourceType = sourceType,
            SourceRow = sourceRow,
            SourceIndex = sourceIndex,
            TargetType = targetType,
            TargetRow = targetRow,
            TargetIndex = targetIndex,
        };
        _gameBoard.QueueUpdate(boardPlayerInventoryMoveUpdate);
    }

    public void UpdateBoardPlayerInventoryExpand(int row, int index, long playerId)
    {
        var boardPlayerInventoryExpandUpdate = new BoardPlayerInventoryExpandUpdate
        {
            Tick = 0,
            PlayerId = playerId,
            Row = row,
            Index = index,
        };
        _gameBoard.QueueUpdate(boardPlayerInventoryExpandUpdate);
    }

    public void UpdateBoardPlayerInventoryResetHold(long playerId)
    {
        var boardPlayerInventoryResetHoldUpdate = new BoardPlayerInventoryResetHoldUpdate
        {
            Tick = 0,
            PlayerId = playerId,
        };
        _gameBoard.QueueUpdate(boardPlayerInventoryResetHoldUpdate);
    }

    public void UpdateBoardVariable(int key, int value, long playerId)
    {
        var boardVariableUpdate = new VariableUpdate
        {
            Tick = 0,
            PlayerId = playerId,
            Key = key,
            Value = value,
        };
        _gameBoard.QueueUpdate(boardVariableUpdate);
    }

    public void UpdateSelectTrait(long playerId)
    {
        var selectTraitUpdate = new SelectTraitUpdate
        {
            Tick = 0,
            PlayerId = playerId,
        };
        _gameBoard.QueueUpdate(selectTraitUpdate);
    }

    public void UpdateRerollSelectTraitUpdate(SelectTraitUpdate.Types.Type traitType, long playerId)
    {
        _gameBoard.QueueUpdate(new RerollSelectTraitUpdate()
        {
            Tick = 0,
            PlayerId = playerId,
            Type = traitType
        });
    }

    public void UpdateBoardState(long playerId, GameBoard.Types.State state)
    {
        var update = new BoardStateUpdate()
        {
            Tick = 0,
            PlayerId = playerId,
            State = (int)state
        };
        _gameBoard.QueueUpdate(update);
    }

    public void UpdateBoardPlayerRunCheat(long playerId, BoardPlayerRunCheatUpdate.Types.CheatType type, int[] parameters)
    {
        var boardPlayerRunCheatUpdate = new BoardPlayerRunCheatUpdate
        {
            Tick = 0,
            PlayerId = playerId,
            CheatType = type,
        };
         if (parameters != null)
            boardPlayerRunCheatUpdate.Parameters.AddRange(parameters);

        _gameBoard.QueueUpdate(boardPlayerRunCheatUpdate);
    }
    public void SendUpdatePacket(Packet packet)
    {
        ZWorldClient.Get().SendPacket(packet).Forget();
        lastBoardPacketSentTick = _gameBoard.Tick;
    }
}

namespace Commons.Game
{
    public partial class GameBoard
    {
        private readonly Queue<Packet> _toSendUpdatePacketQueue = new();
        
        public void FlushUpdates()
        {
            HandleUpdatesInternal();
        }
        
        partial void PostHandleUpdatesInternal()
        {
            var gameBoardManager = GameBoardManager.Get();
            if (!gameBoardManager.CanSendBoardPacket())
                return;

            while (_toSendUpdatePacketQueue.TryDequeue(out var packet))
            {
                gameBoardManager.SendUpdatePacket(packet);
            }
        }
        
        partial void ServerHandleUpdate(BoardPlayerUpdate update)
        {
            update = update.Clone();
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardAchievementUpdate update)
        {
            update = update.Clone();
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardPlayerInventoryMergeUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardPlayerInventorySpawnUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardPlayerInventoryMoveUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardPlayerInventoryTransferUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardPlayerInventoryExpandUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(BoardPlayerInventoryResetHoldUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(VariableUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(SelectTraitUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
        
        partial void ServerHandleUpdate(CompleteSelectTraitUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }

        partial void ServerHandleUpdate(RerollSelectTraitUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }

        partial void ServerHandleUpdate(BoardStateUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }

        partial void ServerHandleUpdate(BoardPlayerRunCheatUpdate update)
        {
            _toSendUpdatePacketQueue.Enqueue(Packet.Pop(0, update));
        }
    }
}