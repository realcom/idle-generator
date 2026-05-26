using Commons.Packets;
using DotNetty.Buffers;
using DotNetty.Codecs;
using DotNetty.Codecs.Http.WebSockets;
using DotNetty.Transport.Channels;

namespace Server.Codecs;

public class WebSocketEncoder : MessageToMessageEncoder<IByteBuffer>
{
    protected override void Encode(IChannelHandlerContext context, IByteBuffer message, List<object> output)
    {
        var frame = new BinaryWebSocketFrame((IByteBuffer)message.Retain());
        output.Add(frame);
    }
}
