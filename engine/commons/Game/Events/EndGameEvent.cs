namespace Commons.Game.Events
{
    public partial class EndGameEvent : BoardEvent
    {
        public override Type EventType => Type.EndGame;

        public int WinningTeam;
    }
}
