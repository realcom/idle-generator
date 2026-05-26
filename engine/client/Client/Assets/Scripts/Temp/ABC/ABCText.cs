using Sirenix.OdinInspector;
using System;
using TMPro;
using UnityEngine;

namespace Share.ABC
{
    [Serializable]
    public class ABCTextColor : ABCOption<TMP_Text, Color>
    {
        protected override void SetValue(TMP_Text field, Color value)
        {
            field.color = value;
        }
    }

    [Serializable]
    public class ABCTextColorGradient : ABCOption<TMP_Text, VertexGradient>
    {
        protected override void SetValue(TMP_Text field, VertexGradient value)
        {
            field.enableVertexGradient = true;
            field.colorGradient = value;
        }
    }

    [Serializable]
    public class ABCFontSize : ABCOption<TMP_Text, float>
    {
        protected override void SetValue(TMP_Text field, float value)
        {
            field.fontSize = value;
        }
    }

    [Required]
    public class ABCText : ABCBase
    {
        private const float LABEL_WIDTH = 94;

        [SerializeField] [Required] private TMP_Text text;

        [SerializeField] private ABCTextColor color;
        [SerializeField] private ABCTextColorGradient colorGradient;
        [SerializeField] private ABCFontSize fontSize;

        protected override void SetType_(ABCType type)
        {
            color.Set(text, type);
            colorGradient.Set(text, type);
            fontSize.Set(text, type);
        }

        protected override void Reset()
        {
            base.Reset();
            text = GetComponentInChildren<TMP_Text>();
            var white = new VertexGradient
            {
                bottomLeft = Color.white,
                bottomRight = Color.white,
                topLeft = Color.white,
                topRight = Color.white
            };
            colorGradient.SetAValue(white);
            colorGradient.SetBValue(white);
            colorGradient.SetCValue(white);
        }
    }
}