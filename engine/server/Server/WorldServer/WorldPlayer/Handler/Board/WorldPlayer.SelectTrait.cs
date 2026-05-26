using Commons;
using Commons.Packets.Updates;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(SelectTraitUpdate update)
    {
        if (Board == null)
            return Task.FromResult(true);

        if (update.PlayerId != Id)
            throw new InvalidOperationException(
                $"{Board.ToDebugString()} {this} Invalid LevelUpChoiceUpdate PlayerId {update.PlayerId}");

        Board.QueueUpdate(update);

        return Task.FromResult(true);
    }
}
