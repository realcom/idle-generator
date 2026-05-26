using System.Diagnostics.Contracts;
using Commons.Packets;
using Commons.Utility.ObjectPool;
using Commons.Utility.ObjectPool.ConcurrentObjectPool;
using DotNetty.Buffers;
using DotNetty.Codecs;
using DotNetty.Transport.Channels;

namespace Server.Codecs;

public class PacketDecoder : ByteToMessageDecoder
{
    protected override void Decode(IChannelHandlerContext context, IByteBuffer input, List<object> output)
    {
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
