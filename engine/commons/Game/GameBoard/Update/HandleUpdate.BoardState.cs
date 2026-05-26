using Commons.Game.Events;
using Commons.Packets.Updates;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private partial void HandleUpdateInternal(BoardStateUpdate update)
        {
            //todo: grant role to player
            if (GetMainPlayer()?.Id != update.PlayerId)
                return;

            var state = (Types.State)update.State;
            if (state_ >= state)
                return;

            state_ = state;
            QueueEvent(new BoardStateChangedEvent());
        }
    }
}