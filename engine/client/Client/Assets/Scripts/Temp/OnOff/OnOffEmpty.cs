using Sirenix.OdinInspector;

namespace Share.OnOff
{
    [Required]
    public class OnOffEmpty : OnOffBase
    {
        [ValidateInput(nameof(ItsImsiCode), "임시로 쓰는 OnOffSubView", InfoMessageType.Warning)]
        private bool ItsImsiCode()
        {
            return false;
        }

        protected override void _OnOff(bool _)
        {
        }
    }
}