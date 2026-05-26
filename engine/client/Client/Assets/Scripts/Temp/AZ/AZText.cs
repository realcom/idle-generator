using Sirenix.OdinInspector;
using System;
using TMPro;
using UnityEngine;

namespace Share.AZ
{
    [Serializable]
    public class AZText_Color : AZOption<TMP_Text, Color>
    {
        protected override Color GetDefaultOption()
        {
            return Color.white;
        }

        protected override void SetOption(TMP_Text component, Color value)
        {
            component.color = value;
        }
    }

    [Serializable]
    public class AZText_FontSize : AZOption<TMP_Text, float>
    {
        protected override void SetOption(TMP_Text component, float value)
        {
            component.fontSize = value;
        }
    }

    [Serializable]
    public class AZText_ColorGradient : AZOption<TMP_Text, VertexGradient>
    {
        protected override VertexGradient GetDefaultOption()
        {
            return new VertexGradient(Color.white, Color.white, Color.white, Color.white);
        }

        protected override void SetOption(TMP_Text component, VertexGradient value)
        {
            component.colorGradient = value;
        }
    }

    public class AZText : AZBase
    {
        [SerializeField] [Required] private TMP_Text text;

        [ValidateInput(nameof(ValidateColor))]
        [SerializeField] private AZText_Color color;

        [ValidateInput(nameof(ValidateColorGradient))]
        [SerializeField] private AZText_ColorGradient colorGradient;

        [ValidateInput(nameof(ValidateFontSize))]
        [SerializeField] private AZText_FontSize fontSize;

        protected override void SetValue_(string value)
        {
            color.SetValue(text, value);
            colorGradient.SetValue(text, value);
            fontSize.SetValue(text, value);
        }

        protected override bool RequiredUpdateValue()
        {
            var _ = "";
            return !ValidateColor(color, ref _) ||
                   !ValidateFontSize(fontSize, ref _) ||
                   !ValidateColorGradient(colorGradient, ref _);
        }

        public override void SetOptionValues(string[] values)
        {
            color.SetValues(values);
            fontSize.SetValues(values);
            colorGradient.SetValues(values);
        }

        private bool ValidateColor(AZText_Color x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        private bool ValidateColorGradient(AZText_ColorGradient x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        private bool ValidateFontSize(AZText_FontSize x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        protected override void Reset()
        {
            base.Reset();
            text = GetComponent<TMP_Text>();
        }
    }
}