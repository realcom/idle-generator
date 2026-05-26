// ReSharper disable once CheckNamespace

using Commons.Packets.Updates;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(BoardPlayerInventoryRootingUpdate update)
    {
        if (Board == null)
            return Task.FromResult(true);

        if (update.PlayerId != Id)
            throw new InvalidOperationException(
                $"{Board.ToDebugString()} {this} Invalid BoardPlayerInventoryRootingUpdate PlayerId {update.PlayerId}");

        Board.QueueUpdate(update);

        return Task.FromResult(true);
    }
}
