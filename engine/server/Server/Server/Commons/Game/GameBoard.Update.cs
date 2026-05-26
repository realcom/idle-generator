using Commons.Packets;
using Commons.Packets.Updates;

namespace Commons.Game;

public partial class GameBoard
{
    partial void ServerHandleUpdate(BoardPlayerRunCheatUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
    partial void ServerHandleUpdate(BoardPlayerUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
    partial void ServerHandleUpdate(BoardAchievementUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
    partial void ServerHandleUpdate(BoardPlayerInventoryMergeUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
    partial void ServerHandleUpdate(BoardPlayerInventorySpawnUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
    partial void ServerHandleUpdate(BoardPlayerInventoryMoveUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }

    partial void ServerHandleUpdate(BoardStateUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
    partial void ServerHandleUpdate(BoardPlayerInventoryRootingUpdate update)
    {
        if (AutoProgress)
        {
            update.Tick = tick_;
            SendPacket(key => Packet.Pop(key, update));
        }
    }
    
}
