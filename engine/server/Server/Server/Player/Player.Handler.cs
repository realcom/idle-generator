using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    public void SendUpdate()
    {
        var packet = Packet.Pop(GetNextPacketKey(), new PlayerUpdate
        {
            Player = ToMessage(),
        });
        SendPacket(packet);
    }
    
    public abstract void HandleLoginResponse(LoginRequest.Types.Response response);
    
    public virtual async Task<bool> HandlePacket(Packet packet)
    {
        switch (packet.PacketType)
        {
            case Packet.Type.Request:
            {
                var request = packet.Request;
                switch (request.RequestCase)
                {
                    case Request.RequestOneofCase.PingRequest:
                    {
                        var pingRequest = request.PingRequest;
                        var latency = (DateTime.UtcNow - pingRequest.Timestamp.ToDateTime()).TotalSeconds;
                        Latency = (Latency + latency) / 2;
                        return true;
                    }
                    default:
                    {
                        if (Config.IsDebug)
                            Logger.Info($"Player#{Id} HandlePacket: {packet.PacketType} {request.RequestCase}");
                        return false;
                    }
                }
                break;
            }
        }

        return false;
    }
}
