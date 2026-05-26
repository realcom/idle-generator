using Commons;
using Commons.Packets;
using Server.Session;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    public const int MaxPacketsPerSecond = 128;

    private Session<TServer, TPlayer>? Session { get; set; } = session;
    
    private DateTime _packetCounterAt = DateTime.UtcNow;
    private int _packetCounterThisSecond;

    public string Ip => Session?.Ip ?? "";
    
    public byte GetNextPacketKey()
    {
        return Session?.GetNextPacketKey() ?? 0;
    }
    
    public void SendPacket(Packet packet)
    {
        if (!SentLoginResponse)
        {
            if (Config.IsDebug)
                Logger.Error($"Player#{Id} tried to send packet before login: {packet.PacketType}");
            
            return;
        }
        
        Session?.SendPacket(packet);
    }
    
    public void QueuePacket(Packet packet)
    {
        _packets.Enqueue(packet);
    }

    private async Task ProcessPackets()
    {
        if (_packets.IsEmpty)
            return;
        
        var now = DateTime.UtcNow;
        if (now.Second != _packetCounterAt.Second)
        {
            _packetCounterAt = now;
            _packetCounterThisSecond = 0;
        }
        _packetCounterThisSecond += _packets.Count;
        if (_packetCounterThisSecond >= MaxPacketsPerSecond)
        {
            Logger.Warn($"{this} exceeded MaxPacketsPerSecond");
            await DestroyInternal().ConfigureAwait(false);
            return;
        }
        
        _lastPacketAt = DateTime.UtcNow;
        while (_packets.TryDequeue(out var packet))
        {
            var handled = false;
            try
            {
                handled = await HandlePacket(packet).ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                Logger.Error($"Player#{Id} HandlePacket exception", ex);
            }
            
            if (!handled && Config.IsDebug)
                Logger.Info($"Player#{Id} HandlePacket failed: {packet.PacketType}");
            
            packet.Dispose();
        }
    }
}
