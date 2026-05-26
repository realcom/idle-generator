using Commons.Types.Players;

namespace Commons.Game.Events
{
    public partial class PlayerJoinedEvent : BoardEvent
    {
        public override Type EventType => Type.PlayerJoined;

        public BoardPlayerMessage Player = null!;
        public PlayerAvatar Avatar = null!;
    }
}
