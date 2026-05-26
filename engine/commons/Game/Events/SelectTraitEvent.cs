namespace Commons.Game.Events
{
    public partial class SelectTraitEvent : BoardEvent
    {
        public override Type EventType => Type.SelectTrait;
        public bool Reroll = false;
    }
}