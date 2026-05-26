using System;
using System.IO;
using Commons.Packets;
using DotNetty.Buffers;
using DotNetty.Codecs;
using DotNetty.Transport.Channels;

namespace Server.Codecs
{
    public class PacketEncoder : MessageToByteEncoder<Packet>
    {
        protected override void Encode(IChannelHandlerContext context, Packet packet, IByteBuffer output)
        {
            try
            {
                // Packet이 기록할 총 바이트 수를 계산
                int length = packet.GetLength();
                output.EnsureWritable(length);
                
                // 현재 버퍼의 writer index를 저장합니다.
                int initialWriterIndex = output.WriterIndex;
                
                if (output.HasArray)
                {
                    // output이 배열 기반인 경우, 내부 배열을 재사용합니다.
                    byte[] underlyingArray = output.Array;
                    int arrayOffset = output.ArrayOffset;
                    int bufferStart = initialWriterIndex + arrayOffset;

                    // MemoryStream을 내부 배열의 해당 영역에 매핑 (가상 스트림은 길이만큼만 쓸 수 있음)
                    using (var ms = new MemoryStream(underlyingArray, bufferStart, length, writable: true, publiclyVisible: true))
                    {
                        packet.Dump(ms);
                        // Dump 후 실제로 기록된 바이트 수를 가져옵니다.
                        int written = (int)ms.Position;
                        // writer index를 기록된 길이만큼 증가시킵니다.
                        output.SetWriterIndex(initialWriterIndex + written);
                    }
                }
                else
                {
                    // output이 배열 기반이 아닌 경우 임시 버퍼를 사용합니다.
                    byte[] tempBuffer = new byte[length];
                    using (var ms = new MemoryStream(tempBuffer))
                    {
                        packet.Dump(ms);
                        int written = (int)ms.Position;
                        output.WriteBytes(tempBuffer, 0, written);
                    }
                }
            }
            finally
            {
                packet.Dispose();
            }
        }
    }
}
