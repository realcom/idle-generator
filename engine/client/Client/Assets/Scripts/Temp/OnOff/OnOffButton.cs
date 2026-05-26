using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.UI;

namespace Share.OnOff
{
    [Required]
    public class OnOffButton : OnOffBase
    {
        [SerializeField] [Required] private Button button;
        [SerializeField] private bool interactable;

        protected override void _OnOff(bool isOn)
        {
            if (interactable && button != null)
                button.interactable = isOn;
        }

        protected override void Reset()
        {
            base.Reset();
            button = GetComponent<Button>();
            interactable = true;
        }
    }
}