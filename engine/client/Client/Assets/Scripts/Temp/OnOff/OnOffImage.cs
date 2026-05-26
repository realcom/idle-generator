using Sirenix.OdinInspector;
using System;
using UnityEngine;
using UnityEngine.UI;

namespace Share.OnOff
{
    [Serializable]
    public class OnOffImageSprite : OnOffOption<Image, Sprite>
    {
        protected override void SetValue(Image field, Sprite value)
        {
            field.sprite = value;
        }
    }

    [Serializable]
    public class OnOffImageColor : OnOffOption<Image, Color>
    {
        protected override void SetValue(Image field, Color value)
        {
            field.color = value;
        }
    }

    [Serializable] // 던전에 이미 OnOffImageMaterial이 있어서!!
    public class OnOffImageMaterial_ : OnOffOption<Image, Material>
    {
        protected override void SetValue(Image field, Material value)
        {
            field.material = value;
        }
    }

    [Serializable]
    public class OnOffImage : OnOffBase
    {
        [SerializeField] [Required] private Image image;
        [SerializeField] private OnOffImageSprite sprite;
        [SerializeField] private OnOffImageColor color;
        [SerializeField] private OnOffImageMaterial_ material;

        protected override void _OnOff(bool isOn)
        {
            sprite.Set(image, isOn);
            color.Set(image, isOn);
            material.Set(image, isOn);
        }

        protected override void Reset()
        {
            base.Reset();
            image = GetComponent<Image>();
            color.SetOnValue(Color.white);
            color.SetOffValue(Color.white);
        }

#if UNITY_EDITOR
        [Button]
        private void Swap()
        {
            sprite.Swap();
            color.Swap();
            material.Swap();
        }
#endif
    }
}