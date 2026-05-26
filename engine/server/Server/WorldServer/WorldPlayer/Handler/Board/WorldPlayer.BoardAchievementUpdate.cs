using Commons;
using Commons.Packets.Updates;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(BoardAchievementUpdate update)
    {
        if (Board == null)
            return Task.FromResult(true);

        if (!ValidateBoardAchievements(Board, update.Achievements))
        {
            if (Config.IsDebug)
                Logger.Error($"{Board.ToDebugString()} {this} Invalid BoardAchievementUpdate");
            return Task.FromResult(true);
        }
        Board.QueueUpdate(update);
        
        return Task.FromResult(true);
    }
}
