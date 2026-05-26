using Sirenix.OdinInspector;
using System;
using UnityEngine;
using UnityEngine.UI;

namespace Share.ABC
{
    [Serializable]
    public class ABCImageSprite : ABCOption<Image, Sprite>
    {
        protected override void SetValue(Image field, Sprite value)
        {
            field.sprite = value;
        }
    }

    [Serializable]
    public class ABCImageColor : ABCOption<Image, Color>
    {
        protected override void SetValue(Image field, Color value)
        {
            field.color = value;
        }
    }

    [Serializable]
    public class ABCImage : ABCBase
    {
        [LabelWidth(80)] [SerializeField] [Required]
        private Image image;

        public ABCImageSprite Sprite;
        public ABCImageColor Color;

        protected override void SetType_(ABCType type)
        {
            Sprite.Set(image, type);
            Color.Set(image, type);
        }

        protected override void Reset()
        {
            base.Reset();
            image = GetComponentInChildren<Image>();
            Color.SetAValue(UnityEngine.Color.white);
            Color.SetBValue(UnityEngine.Color.white);
            Color.SetCValue(UnityEngine.Color.white);
        }
    }
}