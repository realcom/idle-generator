using System.Diagnostics.Contracts;
using Commons.Packets;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using DotNetty.Buffers;
using DotNetty.Codecs;
using DotNetty.Codecs.Http.WebSockets;
using DotNetty.Transport.Channels;

namespace Server.Codecs;

public class PacketWebSocketDecoder : MessageToMessageDecoder<BinaryWebSocketFrame>
{
    protected override void Decode(IChannelHandlerContext context, BinaryWebSocketFrame frame, List<object> output)
    {
        var input = frame.Content;
        if (input.ReadableBytes == 0)
            return;
        
        var packet = Packet.PopWithoutInitialize();
        
        input.MarkReaderIndex();
        if (!packet.Parse(new ReadOnlyByteBufferStream(input, false)))
        {
            input.ResetReaderIndex();
            return;
        }
            
        output.Add(packet);
    }
}
