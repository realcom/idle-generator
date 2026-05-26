using System.Net;
using Commons;
using Commons.Packets;
using DotNetty.Codecs.Http;
using DotNetty.Common.Utilities;
using DotNetty.Transport.Channels;
using log4net;
using Server.Session;

namespace Server;

public class ChannelHandler<TServer, TPlayer>(TServer server) : ChannelHandlerAdapter
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType);

    private Session<TServer, TPlayer>? _session;
    
    public override void ChannelActive(IChannelHandlerContext ctx)
    {
        base.ChannelActive(ctx);
    }

    public override void ChannelInactive(IChannelHandlerContext ctx)
    {
        base.ChannelInactive(ctx);
        _session?.Close();
        _session = null;
    }

    public override void ChannelRead(IChannelHandlerContext ctx, object message)
    {
        if (message is IFullHttpRequest httpRequest)
        {
            // For websocket connections: handle HTTP requests prior to WebSocket handler
            if (_session == null)
            {
                HandleHttpRequest(ctx, httpRequest);
                ctx.Channel.Pipeline.Remove(this);
            }
        }
        else if (message is Packet packet)
        {
            // plain TCP connection
            if (_session == null)
            {
                _session = new Session<TServer, TPlayer>(server, ctx.Channel, null);
            }
            _session?.HandlePacket(packet);
        }
    }

    private void HandleHttpRequest(IChannelHandlerContext ctx, IFullHttpRequest httpRequest)
    {
        var clientIp = GetClientIp(ctx, httpRequest);
        _session = new Session<TServer, TPlayer>(server, ctx.Channel, clientIp);
        ctx.FireChannelRead(httpRequest.Retain());
    }

    private string GetClientIp(IChannelHandlerContext ctx, IFullHttpRequest request)
    {
        string clientIp;
        if (request.Headers.TryGet(AsciiString.Cached("X-Forwarded-For"), out var xForwardedForValue))
        {
            clientIp = xForwardedForValue.ToString().Split(',')[0].Trim();
        }
        else if (request.Headers.TryGet(AsciiString.Cached("X-Real-IP"), out var xRealIpValue))
        {
            clientIp = xRealIpValue.ToString();
        }
        else
        {
            clientIp = ((IPEndPoint)ctx.Channel.RemoteAddress).Address.ToString();
        }
        if (Config.IsDebug)
            Logger.Info("Client IP: " + clientIp);
        return clientIp;
    }

    public override void ExceptionCaught(IChannelHandlerContext ctx, Exception cause)
    {
        base.ExceptionCaught(ctx, cause);
        Logger.Error("ChannelHandler.ExceptionCaught", cause);
    }
}
