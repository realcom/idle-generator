using Commons;
using Commons.Packets.Requests;
using Commons.Packets;
using Commons.Packets.Updates;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    public override async Task<bool> HandlePacket(Packet packet)
    {
        if (await base.HandlePacket(packet).ConfigureAwait(false))
            return true;

        if (Board != null)
            Board.GameSpeedMultiplier = GameSpeedMultiplier;
        
        switch (packet.PacketType)
        {
            case Packet.Type.Update:
            {
                _updateCounterThisSecond += 1;
                var update = packet.Update;
                if (Config.IsDebug)
                    Logger.Info($"{this} HandlePacket: {update.UpdateCase}");
                return await HandleUpdate(update);
            }
            case Packet.Type.Request:
            {
                _requestCounterThisSecond += 1;
                var request = packet.Request;
                var requestId = request.Id;
                if (Config.IsDebug)
                    Logger.Info($"{this} HandlePacket: {request.RequestCase}");
                return await HandleRequest(requestId, request);
            }
            case Packet.Type.UnitMoveDirectionAction:
            {
                if (Board == null)
                    return true;
                if (Board.ResMap.PlayerUnitCount != 0)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} is not controllable");
                var unit = Board.GetUnitById(packet.UnitMoveDirectionAction.UnitId);
                if (unit?.PlayerId != Id)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} {unit} is not controllable");
                Board.QueueAction(packet.UnitMoveDirectionAction);
                // TODO: check packet count
                // if (Config.IsDebug)
                //     Logger.Info($"{this} HandlePacket: UnitMoveDirectionAction {board.ToDebugString()} {packet.UnitMoveDirectionAction.Tick} {packet.UnitMoveDirectionAction.DirX} {packet.UnitMoveDirectionAction.DirY}");;
                return true;
            }
            case Packet.Type.UnitMovePositionAction:
            {
                if (Board == null)
                    return true;
                if (Board.ResMap.PlayerUnitCount != 0)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} is not controllable");
                var unit = Board.GetUnitByPlayerId(packet.UnitMovePositionAction.UnitId);
                if (unit?.PlayerId != Id)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} {unit} is not controllable");
                Board.QueueAction(packet.UnitMovePositionAction);
                // TODO: check packet count
                // if (Config.IsDebug)
                //     Logger.Info($"{this} HandlePacket: UnitMovePositionAction {board.ToDebugString()} {packet.UnitMovePositionAction.Tick} {packet.UnitMovePositionAction.PosX} {packet.UnitMovePositionAction.PosY}");;
                return true;
            }
            case Packet.Type.UnitUseSkillAction:
            {
                if (Board == null)
                    return true;
                var unit = Board.GetUnitById(packet.UnitUseSkillAction.UnitId);
                if (unit?.PlayerId != Id)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} {unit} is not controllable");
                if (!CanUseSkill(packet.UnitUseSkillAction.Tick, packet.UnitUseSkillAction.SkillDataId))
                    return true;
                Board.QueueAction(packet.UnitUseSkillAction);
                if (Config.IsDebug)
                    Logger.Info($"{this} HandlePacket: UnitUseSkillAction {Board.ToDebugString()} {packet.UnitUseSkillAction.Tick} {packet.UnitUseSkillAction.SkillDataId}");;
                return true;
            }
            case Packet.Type.UnitUseTargetSkillAction:
            {
                if (Board == null)
                    return true;
                var unit = Board.GetUnitById(packet.UnitUseTargetSkillAction.UnitId);
                if (unit?.PlayerId != Id)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} {unit} is not controllable");
                if (!CanUseSkill(packet.UnitUseTargetSkillAction.Tick, packet.UnitUseTargetSkillAction.SkillDataId))
                    return true;
                Board.QueueAction(packet.UnitUseTargetSkillAction);
                if (Config.IsDebug)
                    Logger.Info($"{this} HandlePacket: UnitUseTargetSkillAction {Board.ToDebugString()} {packet.UnitUseTargetSkillAction.Tick} {packet.UnitUseTargetSkillAction.SkillDataId} {packet.UnitUseTargetSkillAction.TargetUnitId}");;
                return true;
            }
            case Packet.Type.UnitChangePlayerAvatarWeaponSlotAction:
            {
                if (Board == null)
                    return true;
                if (Board.ResMap.PlayerUnitCount != 0)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} is not controllable");
                var unit = Board.GetUnitByPlayerId(packet.UnitChangePlayerAvatarWeaponSlotAction.UnitId);
                if (unit?.PlayerId != Id)
                    throw new InvalidOperationException($"{this} {Board.ToDebugString()} {unit} is not controllable");
                Board.QueueAction(packet.UnitChangePlayerAvatarWeaponSlotAction);
                if (Config.IsDebug)
                    Logger.Info($"{this} HandlePacket: UnitChangePlayerAvatarWeaponSlotAction {Board.ToDebugString()} {packet.UnitChangePlayerAvatarWeaponSlotAction.Tick} {packet.UnitChangePlayerAvatarWeaponSlotAction.WeaponSlot}");;
                return true;
            }
        }

        return false;
    }
}
