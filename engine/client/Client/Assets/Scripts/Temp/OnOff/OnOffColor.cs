using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.UI;

namespace Share.OnOff
{
    public class OnOffColor : OnOffBase
    {
        [Required] [SerializeField] private Graphic graphic;
        [SerializeField] private Color colorOn = Color.white;
        [SerializeField] private Color colorOff = Color.gray;

        protected override void Reset()
        {
            base.Reset();
            graphic = GetComponent<Graphic>();
            if (graphic != null)
                colorOn = graphic.color;
        }

        protected override void _OnOff(bool isOn)
        {
            graphic.color = isOn ? colorOn : colorOff;
        }
    }
}