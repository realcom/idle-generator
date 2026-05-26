using Commons.Types;

namespace Commons.Game.Events
{
    public partial class ShowPopupEvent : BoardEvent
    {
        public override Type EventType => Type.ShowPopup;
        
        public long PlayerId;
        public string ArgumentString;
        public FixedFloat[] ArgumentExpressions;
    }
}