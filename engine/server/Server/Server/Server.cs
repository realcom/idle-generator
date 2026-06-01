using Commons;
using DotNetty.Buffers;
using DotNetty.Codecs;
using DotNetty.Codecs.Http;
using DotNetty.Codecs.Http.WebSockets;
using DotNetty.Handlers.Timeout;
using DotNetty.Transport.Bootstrapping;
using DotNetty.Transport.Channels;
using DotNetty.Transport.Channels.Sockets;
using DotNetty.Transport.Libuv;
using log4net;
using Server.Codecs;
using Server.Services;


namespace Server;

public enum ServerProtocol
{
    Tcp,
    WebSocket,
    TcpAndWebSocket,
}

public abstract partial class Server<TServer, TPlayer>(int port) : IServer
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    protected static readonly ILog Logger = LogManager.GetLogger("", typeof(TServer));
    
    public const double TickSeconds = 0.1;
    public const double ReloadConfigIntervalSeconds = 3;
    public const double ReloadPriceIntervalSeconds = 86400;
    
    private readonly SemaphoreSlim _semaphore = new(1, 1);
    
    private IChannel? _channel;
    private IEventLoopGroup? _bossLoopGroup;
    private IEventLoopGroup? _workerLoopGroup;

    public readonly int Port = port;
    
    public bool IsRunning => _channel != null;
    
    private DateTime _nextConfigReloadAt = DateTime.UtcNow;
    private DateTime _nextPriceReloadAt = DateTime.UtcNow;
    private PushService? _pushService;
    private PushCronService? _pushCronService;

    public async Task<TServer> Start(ServerProtocol protocol = ServerProtocol.TcpAndWebSocket)
    {
        await _semaphore.WaitAsync().ConfigureAwait(false);
        try
        {
            if (IsRunning)
                return (TServer)this;
            return await StartInternal(protocol).ConfigureAwait(false);
        }
        finally
        {
            _semaphore.Release();
        }
    }

    public Task<TServer> Start(bool webSocket)
    {
        return Start(webSocket ? ServerProtocol.WebSocket : ServerProtocol.Tcp);
    }

    private async Task<TServer> StartInternal(ServerProtocol protocol)
    {
        if (Config.IsLinux)
        {
            var dispatcher = new DispatcherEventLoopGroup();
            _bossLoopGroup = dispatcher;
            _workerLoopGroup = new WorkerEventLoopGroup(dispatcher, 4 * Environment.ProcessorCount);
        }
        else
        {
            _bossLoopGroup = new MultithreadEventLoopGroup(1);
            _workerLoopGroup = new MultithreadEventLoopGroup(4);
        }
        
        var bootstrap = new ServerBootstrap();
        bootstrap.Group(_bossLoopGroup, _workerLoopGroup);
        
        if (Config.IsLinux)
            bootstrap.Channel<TcpServerChannel>();
        else
            bootstrap.Channel<TcpServerSocketChannel>();

        bootstrap
            .Option(ChannelOption.SoBacklog, 1024)
            .Option(ChannelOption.TcpNodelay, true)
            .Option(ChannelOption.SoReuseaddr, true)
            .ChildOption(ChannelOption.TcpNodelay, true)
            .ChildOption(ChannelOption.SoReuseaddr, true)
            .ChildOption(ChannelOption.SoKeepalive, true)
            .ChildHandler(new ActionChannelInitializer<IChannel>(channel =>
            {
                var pipeline = channel.Pipeline;
                pipeline.AddLast(new IdleStateHandler(360, 0, 0));
                AddProtocolPipeline(pipeline, (TServer)this, protocol);
            }));
        
        _channel = await bootstrap.BindAsync(Port).ConfigureAwait(false);
        Run();
        if (Config.IsLinux && Config.Server.EnablePushServices)
        {
            _pushService = new PushService();
            _pushCronService = new PushCronService();
            await _pushService.StartAsync(CancellationToken.None);
            await _pushCronService.StartAsync(CancellationToken.None);
        }
        Logger.Info($"Server started on port {Port} ({protocol})");
        return (TServer)this;
    }

    private static void AddProtocolPipeline(IChannelPipeline pipeline, TServer server, ServerProtocol protocol)
    {
        switch (protocol)
        {
            case ServerProtocol.Tcp:
                AddTcpPipeline(pipeline, server);
                break;
            case ServerProtocol.WebSocket:
                AddWebSocketPipeline(pipeline, server);
                break;
            case ServerProtocol.TcpAndWebSocket:
                pipeline.AddLast(new ProtocolSwitchHandler(server));
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(protocol), protocol, null);
        }
    }

    private static void AddTcpPipeline(IChannelPipeline pipeline, TServer server)
    {
        pipeline.AddLast(new PacketDecoder());
        pipeline.AddLast(new PacketEncoder());
        pipeline.AddLast(new ChannelHandler<TServer, TPlayer>(server));
    }

    private static void AddWebSocketPipeline(IChannelPipeline pipeline, TServer server)
    {
        pipeline.AddLast(new HttpServerCodec());
        pipeline.AddLast(new HttpObjectAggregator(64000));
        pipeline.AddLast(new WebSocketServerProtocolHandler("/"));
        pipeline.AddLast(new PacketWebSocketDecoder());
        pipeline.AddLast(new WebSocketEncoder());
        pipeline.AddLast(new PacketEncoder());
        pipeline.AddLast(new ChannelHandler<TServer, TPlayer>(server));
    }

    internal sealed class ProtocolSwitchHandler(TServer server) : ByteToMessageDecoder
    {
        protected override void Decode(IChannelHandlerContext context, IByteBuffer input, List<object> output)
        {
            var protocol = DetectProtocol(input);
            if (protocol == null)
                return;

            var remaining = input.ReadBytes(input.ReadableBytes);
            var pipeline = context.Channel.Pipeline;
            try
            {
                switch (protocol)
                {
                    case ServerProtocol.WebSocket:
                        AddWebSocketPipeline(pipeline, server);
                        break;
                    case ServerProtocol.Tcp:
                        AddTcpPipeline(pipeline, server);
                        break;
                }

                pipeline.Remove(this);
                output.Add(remaining);
                remaining = null;
            }
            finally
            {
                remaining?.Release();
            }
        }

        internal static ServerProtocol? DetectProtocol(IByteBuffer buffer)
        {
            if (buffer.ReadableBytes <= 0)
                return null;

            var readerIndex = buffer.ReaderIndex;
            if (buffer.GetByte(readerIndex) != (byte)'G')
                return ServerProtocol.Tcp;

            if (buffer.ReadableBytes < 4)
                return null;

            return buffer.GetByte(readerIndex + 1) == (byte)'E'
                   && buffer.GetByte(readerIndex + 2) == (byte)'T'
                   && buffer.GetByte(readerIndex + 3) == (byte)' '
                ? ServerProtocol.WebSocket
                : ServerProtocol.Tcp;
        }
    }

    private async void Run()
    {
        while (IsRunning)
        {
            var updateAt = DateTime.UtcNow;
            try
            {
                await Update().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                Logger.Error($"{this}.Update", ex);
            }

            await Task.Delay(Math.Max(10,
                    (int)(updateAt + TimeSpan.FromSeconds(TickSeconds) - DateTime.UtcNow).TotalMilliseconds))
                .ConfigureAwait(false);
        }
    }
    
    private async Task Update()
    {
        await _semaphore.WaitAsync().ConfigureAwait(false);
        try
        {
            if (!IsRunning)
                return;
            if (DateTime.UtcNow >= _nextConfigReloadAt)
            {
                _nextConfigReloadAt = DateTime.UtcNow.AddSeconds(ReloadConfigIntervalSeconds);
                await Config.Reload().ConfigureAwait(false);
                ReloadMaintenance();
                ReloadReload();
                TryReloadServer();
                ReloadDynamicConfig();
            }
            // 코인 price manager 주석 처리
            // if (DateTime.UtcNow >= _nextPriceReloadAt)
            // {
            //     _nextPriceReloadAt = DateTime.UtcNow.AddSeconds(ReloadPriceIntervalSeconds);
            //     await CoinPriceManager.Update().ConfigureAwait(false);
            // }
        }
        finally
        {
            _semaphore.Release();
        }
    }
    
    public async Task Stop()
    {
        await _semaphore.WaitAsync().ConfigureAwait(false);
        try
        {
            if (!IsRunning)
                return;
            await StopAsync().ConfigureAwait(false);
        }
        finally
        {
            _semaphore.Release();
        }
        
        if (Config.IsLinux && Config.Server.EnablePushServices)
        {
            if (_pushService != null)
                await _pushService.StopAsync(CancellationToken.None);
            if (_pushCronService != null)
                await _pushCronService.StopAsync(CancellationToken.None);
        }
    }

    private async Task StopAsync()
    {
        if (_channel != null)
            await _channel.CloseAsync().ConfigureAwait(false);
        if (_bossLoopGroup != null)
            await _bossLoopGroup.ShutdownGracefullyAsync().ConfigureAwait(false);
        if (_workerLoopGroup != null)
            await _workerLoopGroup.ShutdownGracefullyAsync().ConfigureAwait(false);
        
        _channel = null;
        _bossLoopGroup = null;
        _workerLoopGroup = null;
        
        Logger.Info("Server stopped");
    }
}
