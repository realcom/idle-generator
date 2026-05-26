using Commons.Types.Players;

namespace Commons.Game.Events
{
    public partial class PlayerLeftEvent : BoardEvent
    {
        public override Type EventType => Type.PlayerLeft;

        public BoardPlayerMessage Player = null!;
    }
}
