namespace Commons.Game.Events
{
    public partial class CompleteSelectTraitEvent : BoardEvent
    {
        public override Type EventType => Type.CompleteSelectTrait;

        public long PlayerId;
        public int TraitDataId;
    }
}   