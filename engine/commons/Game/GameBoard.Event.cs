using System.Collections.Generic;
using Commons.Game.Events;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public readonly List<BoardEvent> Events = new();
        
        public void QueueEvent(BoardEvent e)
        {
            Events.Add(e);
        }
        
        public void ClearEvents()
        {
            Events.Clear();
        }
    }
}
