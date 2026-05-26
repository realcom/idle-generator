using Commons.Types.Players;

namespace Commons.Game.Events
{
    public partial class PlayerUpdatedEvent : BoardEvent
    {
        public override Type EventType => Type.PlayerUpdated;

        public BoardPlayerMessage Player = null!;
        public PlayerAvatar Avatar = null!;
    }
}
