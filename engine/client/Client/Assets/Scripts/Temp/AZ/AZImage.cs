using Sirenix.OdinInspector;
using System;
using UnityEngine;
using UnityEngine.UI;

namespace Share.AZ
{
    [Serializable]
    public class AZImage_Sprite : AZOption<Image, Sprite>
    {
        protected override void SetOption(Image component, Sprite value)
        {
            component.sprite = value;
        }
    }

    [Serializable]
    public class AZImage_Color : AZOption<Image, Color>
    {
        protected override Color GetDefaultOption()
        {
            return Color.white;
        }

        protected override void SetOption(Image component, Color value)
        {
            component.color = value;
        }
    }

    public class AZImage : AZBase
    {
        [SerializeField] [Required] private Image image;
        [ValidateInput(nameof(ValidateSprite))] [SerializeField]
        private AZImage_Sprite sprite;
        [ValidateInput(nameof(ValidateColor))] [SerializeField]
        private AZImage_Color color;

        protected override void SetValue_(string value)
        {
            sprite.SetValue(image, value);
            color.SetValue(image, value);
        }

        protected override bool RequiredUpdateValue()
        {
            var _ = "";
            return !ValidateColor(color, ref _) ||
                   !ValidateSprite(sprite, ref _);
        }

        public override void SetOptionValues(string[] values)
        {
            sprite.SetValues(values);
            color.SetValues(values);
        }

        private bool ValidateColor(AZImage_Color x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        private bool ValidateSprite(AZImage_Sprite x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        protected override void Reset()
        {
            base.Reset();
            image = GetComponent<Image>();
        }
    }
}