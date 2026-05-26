using System.Net;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using DotNetty.Transport.Channels;
using log4net;

namespace Server.Session;

public class Session<TServer, TPlayer> : ISession
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType);
    
    private readonly TServer _server;
    private IChannel? _channel;
    private uint _nextPacketKey = 1;
    private uint _nextClientPacketKey = 1;
    public readonly string Ip;

    private bool _loginTried;
    private TPlayer? _player;
    
    public bool Closed { get; private set; }

    public Session(TServer server, IChannel channel, string? clientIp)
    {
        _server = server;
        _channel = channel;
        Ip = clientIp ?? ((IPEndPoint)channel.RemoteAddress).Address.ToString();
        // if (Config.IsDebug)
        Logger.Info("Session created: " + Ip);
    }
    
    internal void SetPlayer(TPlayer player)
    {
        lock (this)
        {
            if (_player != null)
                return;
            _player = player;
        }
    }
    
    public byte GetNextPacketKey()
    {
        var key = Interlocked.Add(ref _nextPacketKey, Packet.MagicNumber);
        return (byte)key;
    }
    
    public void SendPacket(Packet packet)
    {
        _channel?.WriteAndFlushAsync(packet);
    }
    
    public void HandlePacket(Packet packet)
    {
        // if (packet.Request.RequestCase != Request.RequestOneofCase.LoginRequest && _player == null)
        // {
        //     Logger.Error($"No player found for packet: {packet}, channel: {_channel}");
        //     Close();
        //     return;
        // }
        
        try
        {
            if (packet.Key != (byte)_nextClientPacketKey)
            {
                Logger.Error($"Invalid client packet key: {Ip} {_player?.Id} {_player?.Name}");
                Logger.Error($"Invalid client packet key: {packet.Key} : ${(byte)_nextClientPacketKey}");
                Close();
                return;
            }
            _nextClientPacketKey += Packet.MagicNumber;
        
            if (packet.PacketType == Packet.Type.Request &&
                packet.Request.RequestCase == Request.RequestOneofCase.LoginRequest)
            {
                if (_loginTried)
                    return;
                lock (this)
                {
                    if (_loginTried)
                        return;
                    _loginTried = true;
                    if (_player != null)
                        return;
                }
                _ = _server.Login(this, packet.Request.Id, packet.Request.LoginRequest);
                return;
            }
        
            _player?.QueuePacket(packet);
        }
        catch (Exception ex)
        {
            Logger.Error("Session.HandlePacket", ex);
        }
    }

    public void Close(StatusCode reason = StatusCode.NoReason)
    {
        lock (this)
        {
            if (Closed)
                return;
            Closed = true;
            
            var language = _player?.Language ?? ResourceString.Types.Language.English;
            
            SendPacket(Packet.Pop(GetNextPacketKey(), new PlayerDisconnectedUpdate
            {
                Status = reason,
                Message = ResourceString.Get(reason, language),
            }));
            _player?.SetSession(null);
            _player = null;
            _channel?.CloseAsync();
            _channel = null;
        }
    }
}
