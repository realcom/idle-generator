using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Actions;
using Commons.Packets;
using Commons.Types.Geometry;
using Commons.Utility;
using Cysharp.Threading.Tasks;
using Google.FlatBuffers;
using UnityEngine;

public partial class GameBoardManager
{
    public readonly Dictionary<uint, int> boardHashRecord = new();
    private uint lastBoardPacketSentTick = 0;
    
    public void UpdateDirectionMove(Vector2 direction)
    {
        var actionObject = FlatBufferUtility.GetUnitMoveDirectionAction(0, (ushort)MyPlayer.GameUnit.Id, direction);
        _gameBoard.QueueAction(actionObject);
    }

    public void UpdatePositionMove(Vector2 position)
    {
        var actionObject = FlatBufferUtility.GetUnitMovePositionAction(0, (ushort)MyPlayer.GameUnit.Id, position);
        _gameBoard.QueueAction(actionObject);
    }
    
    public void UpdatePositionMove(GameUnit unit, Vector2 position)
    {
        var actionObject = FlatBufferUtility.GetUnitMovePositionAction(0, (ushort)unit.Id, position);
        _gameBoard.QueueAction(actionObject);
    }

    public void UpdateWeaponSlot(int weaponSlot)
    {
        var actionObject = FlatBufferUtility.GetUnitChangePlayerAvatarWeaponSlotAction(0, (ushort)MyPlayer.GameUnit.Id, (sbyte)weaponSlot);
        _gameBoard.QueueAction(actionObject);
    }

    public void UseSkill(int skillDataId, ushort senderUnitId = 0)
    {
        if (senderUnitId == 0)
            senderUnitId = (ushort)MyPlayer.GameUnit.Id;
        
        var actionObject = FlatBufferUtility.GetUnitUseSkillAction(0, senderUnitId, skillDataId);
        _gameBoard.QueueAction(actionObject);
    }

    public void UseTargetSkill(int skillDataId, ushort targetUnitId)
    {
        var deserializedAction = FlatBufferUtility.GetUnitUseTargetSkillAction(0, (ushort)MyPlayer.GameUnit.Id, skillDataId, targetUnitId);
        _gameBoard.QueueAction(deserializedAction);
    }

    // Currently Only for debug usage
    public void SpawnUnit(int unitDataId, Vector2Message position)
    {
        _gameBoard.QueueAddUnit(new GameUnit
        {
            DataId = unitDataId,
            Offset = 0,
            Position = (Vector2Message)position,
            Direction = (Vector2Message) GeometricMath.AngleToUnitVector2(FixedFloatMath.TwoPi * _gameBoard.RandomFloat()),
            Velocity = new Vector2Message(),
            Team = GameBoard.Team.Enemy,
        });
    }

    public void AcquireWeapon(int weaponDataId)
    {
        _gameBoard.AddInventoryItem(MyPlayer.BoardPlayer, MyPlayer.BoardPlayer.Inventories[0],weaponDataId );
    }
    
    public void SendActionPacket(Packet packet)
    {
        ZWorldClient.Get().SendPacket(packet).Forget();
        
        lastBoardPacketSentTick = _gameBoard.Tick;
    }
    
    public void RecordTick()
    {
        if (boardHashRecord.ContainsKey(_gameBoard.Tick))
            return;
        
        boardHashRecord[_gameBoard.Tick] = _gameBoard.GetHashCode();
    }

    private void ClearTickRecords()
    {
        boardHashRecord.Clear();
    }
    //should not remove tick record
    private void CleanTickRecordsOlderThan(uint oldestAllowedTick)
    {
        // var oldestAllowedTick = currentTick - retentionPeriod;
        
        //tickOrder = new Queue<uint>(tickOrder.OrderBy(t => t));
        //while (tickOrder.Count > 0 && tickOrder.Peek() < oldestAllowedTick)
        //{
        //    var oldTick = tickOrder.Dequeue();
        //    boardHashRecord.Remove(oldTick);
        //}
    }

    // private void ReplayActionsUntilTick(uint latestTick)
    // {
    //     tickOrder = new Queue<uint>(tickOrder.OrderBy(t => t));
    //     while (tickOrder.Count > 0 && tickOrder.Peek() <= latestTick)
    //     {
    //         var tick = tickOrder.Dequeue();
    //
    //         if (tick <= _gameBoard.Tick)
    //             continue;
    //         // if (tick == _gameBoard.Tick)
    //         // {
    //         //     RecordTick();
    //         //     continue;
    //         // }
    //         
    //         Debug.LogWarning("보드 리플레이 | 틱: " + tick);
    //         _gameBoard.Update();
    //         RecordTick();
    //     }
    // }
}

public static class FlatBufferUtility
{
    public static UnitMoveDirectionAction GetUnitMoveDirectionAction(uint gameBoardTick, ushort unitId, Vector2 direction)
    {
        var action = new UnitMoveDirectionAction();
        action.__init(0, new ByteBuffer(16));
        action.MutateTick(gameBoardTick);
        action.MutateUnitId(unitId);
        action.MutateDirX(direction.x);
        action.MutateDirY(direction.y);

        return action;
    }
    
    public static UnitMovePositionAction GetUnitMovePositionAction(uint gameBoardTick, ushort unitId, Vector2 position)
    {
        var action = new UnitMovePositionAction();
        action.__init(0, new ByteBuffer(16));
        action.MutateTick(gameBoardTick);
        action.MutateUnitId(unitId);
        action.MutatePosX(position.x);
        action.MutatePosY(position.y);

        return action;
    }
    
    public static UnitUseSkillAction GetUnitUseSkillAction(uint gameBoardTick, ushort unitId, int skillDataId)
    {
        var action = new UnitUseSkillAction();
        action.__init(0, new ByteBuffer(12));
        action.MutateTick(gameBoardTick);
        action.MutateUnitId(unitId);
        action.MutateSkillDataId(skillDataId);

        return action;
    }
    
    public static UnitUseTargetSkillAction GetUnitUseTargetSkillAction(uint gameBoardTick, ushort unitId, int skillDataId, ushort targetUnitId)
    {
        var action = new UnitUseTargetSkillAction();
        action.__init(0, new ByteBuffer(16));
        action.MutateTick(gameBoardTick);
        action.MutateUnitId(unitId);
        action.MutateSkillDataId(skillDataId);
        action.MutateTargetUnitId(targetUnitId);

        return action;
    }
    
    public static UnitChangePlayerAvatarWeaponSlotAction GetUnitChangePlayerAvatarWeaponSlotAction(uint gameBoardTick, ushort unitId, sbyte weaponSlot)
    {
        var action = new UnitChangePlayerAvatarWeaponSlotAction();
        action.__init(0, new ByteBuffer(12));
        action.MutateTick(gameBoardTick);
        action.MutateUnitId(unitId);
        action.MutateWeaponSlot(weaponSlot);

        return action;
    }
}

namespace Commons.Game
{
    public partial class GameBoard
    {
        private readonly Queue<Packet> _toSendActionPacketQueue = new();

        partial void PostHandleActionsInternal()
        {
            var gameBoardManager = GameBoardManager.Get();
            if (!gameBoardManager.CanSendBoardPacket())
                return;

            while (_toSendActionPacketQueue.TryDequeue(out var packet))
            {
                gameBoardManager.SendActionPacket(packet);
            }
        }
        
        partial void ServerHandleAction(UnitMoveDirectionAction action)
        {
            _toSendActionPacketQueue.Enqueue(Packet.Pop(0, action));
        }

        partial void ServerHandleAction(UnitMovePositionAction action)
        {
            _toSendActionPacketQueue.Enqueue(Packet.Pop(0, action));
        }
        
        partial void ServerHandleAction(UnitUseSkillAction action)
        {
            _toSendActionPacketQueue.Enqueue(Packet.Pop(0, action));
        }

        partial void ServerHandleAction(UnitUseTargetSkillAction action)
        {
            _toSendActionPacketQueue.Enqueue(Packet.Pop(0, action));
        }

        partial void ServerHandleAction(UnitChangePlayerAvatarWeaponSlotAction action)
        {
            _toSendActionPacketQueue.Enqueue(Packet.Pop(0, action));
        }

    }
}
