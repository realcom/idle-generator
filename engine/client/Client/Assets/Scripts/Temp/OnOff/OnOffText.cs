using Sirenix.OdinInspector;
using System;
using TMPro;
using UnityEngine;

namespace Share.OnOff
{
    [Serializable]
    public class OnOffTextColorGradient : OnOffOption<TMP_Text, VertexGradient>
    {
        protected override void SetValue(TMP_Text field, VertexGradient value)
        {
            field.enableVertexGradient = true;
            field.colorGradient = value;
        }
    }

    [Serializable]
    public class OnOffTextFontSize : OnOffOption<TMP_Text, float>
    {
        protected override void SetValue(TMP_Text field, float value)
        {
            field.fontSize = value;
        }
    }

    [Serializable]
    public class OnOffTextAlpha : OnOffOption<TMP_Text, float>
    {
        protected override void SetValue(TMP_Text field, float value)
        {
            field.alpha = value;
        }
    }

    [Serializable]
    public class OnOffTextColor : OnOffOption<TMP_Text, Color>
    {
        protected override void SetValue(TMP_Text field, Color value)
        {
            field.color = value;
        }
    }

    [Required]
    public class OnOffText : OnOffBase
    {
        [SerializeField] [Required]
        private TMP_Text text;

        [SerializeField] private OnOffTextColor color;
        [SerializeField] private OnOffTextFontSize fontSize;
        [SerializeField] private OnOffTextAlpha alpha;
        [SerializeField] private OnOffTextColorGradient colorGradient;

        protected override void _OnOff(bool isOn)
        {
            color.Set(text, isOn);
            fontSize.Set(text, isOn);
            alpha.Set(text, isOn);
            colorGradient.Set(text, isOn);
        }

        protected override void Reset()
        {
            base.Reset();
            text = GetComponent<TextMeshProUGUI>();
            var white = new VertexGradient
            {
                bottomLeft = Color.white,
                bottomRight = Color.white,
                topLeft = Color.white,
                topRight = Color.white
            };

            color.SetOnValue(Color.white);
            color.SetOffValue(Color.white);
            alpha.SetOnValue(1);
            alpha.SetOffValue(0.4f);
            fontSize.SetOnValue(text.fontSize);
            fontSize.SetOffValue(text.fontSize - 5);
            colorGradient ??= new OnOffTextColorGradient();
            colorGradient.SetOnValue(white);
            colorGradient.SetOffValue(white);
        }

#if UNITY_EDITOR
        [Button]
        private void Swap()
        {
            color.Swap();
            fontSize.Swap();
            alpha.Swap();
            colorGradient.Swap();
        }
#endif
    }
}