using Commons.Packets.Updates;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(BoardPlayerUpdate update)
    {
        if (Board == null)
            return Task.FromResult(true);

        if (update.Player?.Id != Id)
            throw new InvalidOperationException(
                $"{Board.ToDebugString()} {this} Invalid BoardPlayerInventorySpawnUpdate PlayerId {update.Player?.Id}");
        
        Board.QueueUpdate(update);
        
        return Task.FromResult(true);
    }
}
