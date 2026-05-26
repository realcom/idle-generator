using System;
using System.IO;
using Commons.Game.Actions;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using Google.FlatBuffers;
using Google.Protobuf;

namespace Commons.Packets
{
    public partial class Packet : PooledObject<Packet>
    {
        public static class Type
        {
            public const byte None = 0x00;

            public const byte UnitMoveDirectionAction = 0x01;
            public const byte UnitMovePositionAction = 0x02;
            public const byte UnitUseSkillAction = 0x03;
            public const byte UnitUseTargetSkillAction = 0x04;
            public const byte UnitChangePlayerAvatarWeaponSlotAction = 0x05;

            public const byte Request = 0x11;
            public const byte Update = 0x12;
        }

        public const byte MagicNumber = 0x47;
        
        private static readonly ConcurrentObjectPool<Packet> Pool = new(16 * Environment.ProcessorCount);
        
        public static Packet PopWithoutInitialize()
        {
            return Pool.Pop();
        }

        public byte PacketType;
        public byte Key;

        public int GetDataLength()
        {
            switch (PacketType)
            {
                case Type.UnitMoveDirectionAction:
                    return 16;
                case Type.UnitMovePositionAction:
                    return 16;
                case Type.UnitUseSkillAction:
                    return 12;
                case Type.UnitUseTargetSkillAction:
                    return 16;
                case Type.UnitChangePlayerAvatarWeaponSlotAction:
                    return 12;
                case Type.Request:
                    return Request.CalculateSize();
                case Type.Update:
                    return Update.CalculateSize();
                default:
                    throw new NotImplementedException(PacketType.ToString());
            }
        }

        public int GetLength()
        {
            switch (PacketType)
            {
                case Type.Request:
                    return 6 + Request.CalculateSize();
                case Type.Update:
                    return 6 + Update.CalculateSize();
                default:
                    return 2 + GetDataLength();
            }
        }

        protected override void Clear()
        {
            PacketType = Type.None;
            Request.Id = 0L;
            
            Update.ClearUpdate();
            Request.ClearRequest();
        }

        public static byte Xor(byte a, byte b)
        {
            return (byte)(a ^ b);
        }

        // optional packet body encoder / decoder
        protected byte[] EncryptPacket(byte[] packet, byte key)
        {
            for (var i = 0; i < packet.Length; i++)
            {
                packet[i] = Xor(packet[i], key);
            }

            return packet;
        }

        protected byte[] DecryptPacket(byte[] packet, byte key)
        {
            for (var i = 0; i < packet.Length; i++)
            {
                packet[i] = Xor(packet[i], key);
            }

            return packet;
        }
        
        public static bool HasLengthField(byte packetType)
            => packetType == Type.Request
               || packetType == Type.Update;
        
        public static int GetFixedDataLength(byte packetType)
        {
            switch (packetType)
            {
                case Type.UnitMoveDirectionAction:               return 16;
                case Type.UnitMovePositionAction:                return 16;
                case Type.UnitUseSkillAction:                    return 12;
                case Type.UnitUseTargetSkillAction:              return 16;
                case Type.UnitChangePlayerAvatarWeaponSlotAction:return 12;
                default:
                    throw new NotImplementedException($"Unknown fixed‑length packetType: {packetType}");
            }
        }
        
        public bool Parse(Stream input)
        {
            // TODO: will this cause GC?
            if (!input.CanRead)
                return false;
            Key = (byte)input.ReadByte();
            if (!input.CanRead)
                return false;
            PacketType = (byte)input.ReadByte();
            PacketType = Xor(PacketType, Key);
            
            int length;
            if (PacketType == Type.Request || PacketType == Type.Update)
            {
                length = Xor((byte)input.ReadByte(), Key) | (Xor((byte)input.ReadByte(), Key) << 8) | (Xor((byte)input.ReadByte(), Key) << 16) | (Xor((byte)input.ReadByte(), Key) << 24);
            }
            else
            {
                length = GetDataLength();
            }

            var data = new byte[length];

            if (input.Read(data, 0, length) < length)
                return false;

            data = DecryptPacket(data, Key);

            var byteBuffer = new ByteBuffer(data);

            switch (PacketType)
            {
                case Type.UnitMoveDirectionAction:
                    UnitMoveDirectionAction.__assign(0, byteBuffer);
                    return true;
                case Type.UnitMovePositionAction:
                    UnitMovePositionAction.__assign(0, byteBuffer);
                    return true;
                case Type.UnitUseSkillAction:
                    UnitUseSkillAction.__assign(0, byteBuffer);
                    return true;
                case Type.UnitUseTargetSkillAction:
                    UnitUseTargetSkillAction.__assign(0, byteBuffer);
                    return true;
                case Type.UnitChangePlayerAvatarWeaponSlotAction:
                    UnitChangePlayerAvatarWeaponSlotAction.__assign(0, byteBuffer);
                    return true;
                case Type.Request:
                    Request.MergeFrom(Request.Parser.ParseFrom(data));
                    return true;
                case Type.Update:
                    Update.MergeFrom(Update.Parser.ParseFrom(data));
                    return true;
            }

            return false;
        }

        protected void DumpUintAsByteArray(Stream buffer, uint value)
        {
            buffer.WriteByte(Xor((byte)(value & 0xFF), Key));
            buffer.WriteByte(Xor((byte)((value >> 8) & 0xFF), Key));
            buffer.WriteByte(Xor((byte)((value >> 16) & 0xFF), Key));
            buffer.WriteByte(Xor((byte)((value >> 24) & 0xFF), Key));
        }

        protected void DumpIntAsByteArray(Stream buffer, int value)
        {
            buffer.WriteByte(Xor((byte)(value & 0xFF), Key));
            buffer.WriteByte(Xor((byte)((value >> 8) & 0xFF), Key));
            buffer.WriteByte(Xor((byte)((value >> 16) & 0xFF), Key));
            buffer.WriteByte(Xor((byte)((value >> 24) & 0xFF), Key));
        }

        public void Dump(Stream buffer, ByteBuffer byteBuffer)
        {
            buffer.WriteByte(Key);
            var encryptedPacketType = (byte)(PacketType ^ Key);
            buffer.WriteByte(encryptedPacketType);

            for (var i = 0; i < byteBuffer.Length; i++)
            {
                buffer.WriteByte(Xor(byteBuffer.Get(i), Key));
            }
        }

        public void Dump(Stream buffer)
        {
            buffer.WriteByte(Key);
            var encryptedPacketType = (byte)(PacketType ^ Key);
            buffer.WriteByte(encryptedPacketType);

            int length;
            switch (PacketType)
            {
                case Type.UnitMoveDirectionAction:
                {
                    length = GetDataLength();
                    var data = UnitMoveDirectionAction.ByteBuffer.ToArraySegment(0, length);
                    for (var i = 0; i < length; i++)
                    {
                        data[i] = Xor(data[i], Key);
                    }

                    buffer.Write(data);
                    break;
                }
                case Type.UnitMovePositionAction:
                {
                    length = GetDataLength();
                    var data = UnitMovePositionAction.ByteBuffer.ToArraySegment(0, length);
                    for (var i = 0; i < length; i++)
                    {
                        data[i] = Xor(data[i], Key);
                    }

                    buffer.Write(data);
                    break;
                }
                case Type.UnitUseSkillAction:
                {
                    length = GetDataLength();
                    var data = UnitUseSkillAction.ByteBuffer.ToArraySegment(0, length);
                    for (var i = 0; i < length; i++)
                    {
                        data[i] = Xor(data[i], Key);
                    }

                    buffer.Write(data);
                    break;
                }
                case Type.UnitUseTargetSkillAction:
                {
                    length = GetDataLength();
                    var data = UnitUseTargetSkillAction.ByteBuffer.ToArraySegment(0, length);
                    for (var i = 0; i < length; i++)
                    {
                        data[i] = Xor(data[i], Key);
                    }

                    buffer.Write(data);
                    break;
                }
                case Type.UnitChangePlayerAvatarWeaponSlotAction:
                {
                    length = GetDataLength();
                    var data = UnitChangePlayerAvatarWeaponSlotAction.ByteBuffer.ToArraySegment(0, length);
                    for (var i = 0; i < length; i++)
                    {
                        data[i] = Xor(data[i], Key);
                    }

                    buffer.Write(data);
                    break;
                }
                case Type.Request:
                {
                    length = Request.CalculateSize();
                    DumpIntAsByteArray(buffer, length);
                    buffer.Write(EncryptPacket(Request.ToByteArray(), Key));
                    break;
                }
                case Type.Update:
                {
                    length = Update.CalculateSize();
                    DumpIntAsByteArray(buffer, length);
                    buffer.Write(EncryptPacket(Update.ToByteArray(), Key));
                    break;
                }
            }
        }
    }
}