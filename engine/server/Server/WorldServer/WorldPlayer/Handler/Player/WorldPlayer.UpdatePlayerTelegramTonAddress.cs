using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, UpdatePlayerTelegramTonAddressRequest request)
    {
        if (Telegram != null)
            await Telegram.UpdateTonAddressAsync(request.TonAddress).ConfigureAwait(false);

        var packet = Packet.Pop(GetNextPacketKey(), new UpdatePlayerTelegramTonAddressRequest.Types.Response(), requestId);
        SendPacket(packet);
        
        return true;
    }
}
