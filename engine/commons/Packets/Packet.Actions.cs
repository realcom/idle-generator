using Commons.Game.Actions;

namespace Commons.Packets
{
    public partial class Packet
    {
        public UnitMoveDirectionAction UnitMoveDirectionAction;
        public UnitMovePositionAction UnitMovePositionAction;
        public UnitUseSkillAction UnitUseSkillAction;
        public UnitUseTargetSkillAction UnitUseTargetSkillAction;
        public UnitChangePlayerAvatarWeaponSlotAction UnitChangePlayerAvatarWeaponSlotAction;
        
        public static Packet Pop(byte key, UnitMoveDirectionAction unitMoveDirectionAction)
        {
            var packet = Pool.Pop();
            packet.PacketType = Type.UnitMoveDirectionAction;
            packet.Key = key;
            packet.UnitMoveDirectionAction = unitMoveDirectionAction;
            return packet;
        }

        public static Packet Pop(byte key, UnitMovePositionAction unitMovePositionAction)
        {
            var packet = Pool.Pop();
            packet.PacketType = Type.UnitMovePositionAction;
            packet.Key = key;
            packet.UnitMovePositionAction = unitMovePositionAction;
            return packet;
        }
        
        public static Packet Pop(byte key, UnitUseSkillAction unitUseSkillAction)
        {
            var packet = Pool.Pop();
            packet.PacketType = Type.UnitUseSkillAction;
            packet.Key = key;
            packet.UnitUseSkillAction = unitUseSkillAction;
            return packet;
        }
        
        public static Packet Pop(byte key, UnitUseTargetSkillAction unitUseTargetSkillAction)
        {
            var packet = Pool.Pop();
            packet.PacketType = Type.UnitUseTargetSkillAction;
            packet.Key = key;
            packet.UnitUseTargetSkillAction = unitUseTargetSkillAction;
            return packet;
        }
        
        public static Packet Pop(byte key, UnitChangePlayerAvatarWeaponSlotAction unitChangePlayerAvatarWeaponSlotAction)
        {
            var packet = Pool.Pop();
            packet.PacketType = Type.UnitChangePlayerAvatarWeaponSlotAction;
            packet.Key = key;
            packet.UnitChangePlayerAvatarWeaponSlotAction = unitChangePlayerAvatarWeaponSlotAction;
            return packet;
        }
    }
}
