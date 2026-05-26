using System.Collections.Concurrent;
using Commons.Game.Actions;
using Commons.Packets;

namespace Commons.Game;

public partial class GameBoard
{
    partial void ServerHandleAction(UnitMoveDirectionAction action)
    {
        if (AutoProgress)
        {
            action.MutateTick(tick_);
            SendPacket(key => Packet.Pop(key, action));
        }
    }
    
    partial void ServerHandleAction(UnitMovePositionAction action)
    {
        if (AutoProgress)
        {
            action.MutateTick(tick_);
            SendPacket(key => Packet.Pop(key, action));
        }
    }
    
    partial void ServerHandleAction(UnitUseSkillAction action)
    {
        if (AutoProgress)
        {
            action.MutateTick(tick_);
            SendPacket(key => Packet.Pop(key, action));
        }
    }
    
    partial void ServerHandleAction(UnitUseTargetSkillAction action)
    {
        if (AutoProgress)
        {
            action.MutateTick(tick_);
            SendPacket(key => Packet.Pop(key, action));
        }
    }
    
    partial void ServerHandleAction(UnitChangePlayerAvatarWeaponSlotAction action)
    {
        if (AutoProgress)
        {
            action.MutateTick(tick_);
            SendPacket(key => Packet.Pop(key, action));
        }
    }
}
