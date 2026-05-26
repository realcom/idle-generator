using Commons.Packets.Updates;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private partial void HandleUpdateInternal(BoardPlayerUpdate update)
        {
            if (update.Left)
                RemovePlayer(update.Player.Id);
            else
                AddOrUpdatePlayer(update.Player, update.Avatar);
        }
    }
}