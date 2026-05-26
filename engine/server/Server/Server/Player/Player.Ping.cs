using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Utility.Protobuf;
using Google.Protobuf.WellKnownTypes;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    private readonly PingRequest _pingRequest = new()
    {
        Timestamp = new Timestamp(),
    };
    public double Latency { get; private set; }
    
    private DateTime _lastPingAt = DateTime.UtcNow;
    private DateTime _lastPacketAt = DateTime.UtcNow;

    public void SendPing()
    {
        _lastPingAt = DateTime.UtcNow;
        _pingRequest.Timestamp.Set(DateTime.UtcNow);
        _pingRequest.LatencyMilliseconds = (uint)(1000d * Latency);
        var packet = Packet.Pop(GetNextPacketKey(), _pingRequest);
        SendPacket(packet);
    }
}
