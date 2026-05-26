using System.Collections.Generic;
using Commons.Resources;
using static Commons.Resources.ResourceSkill.Types.Timeline.Types.ShowDialog.Types;

namespace Commons.Game.Events
{
    public partial class ShowDialogEvent : BoardEvent
    {
        public override Type EventType => Type.ShowDialog;
        
        public readonly List<Portrait> Portraits = new();
        public string? Image;
        public string? Name;
        public string? Message;

        public bool PauseBoard;
        public string? PreFx;
        public string? PostFx;
        public float Duration;

        public int interactionKey;
        public readonly List<string> interactionChoices = new();
    }
}
