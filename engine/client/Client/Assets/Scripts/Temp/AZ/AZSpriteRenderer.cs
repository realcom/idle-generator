using Sirenix.OdinInspector;
using System;
using UnityEngine;

namespace Share.AZ
{
    [Serializable]
    public class AZSpriteRenderer_Sprite : AZOption<SpriteRenderer, Sprite>
    {
        protected override void SetOption(SpriteRenderer component, Sprite value)
        {
            component.sprite = value;
        }
    }

    [Serializable]
    public class AZSpriteRenderer_Color : AZOption<SpriteRenderer, Color>
    {
        protected override Color GetDefaultOption()
        {
            return Color.white;
        }

        protected override void SetOption(SpriteRenderer component, Color value)
        {
            component.color = value;
        }
    }


    public class AZSpriteRenderer : AZBase
    {
        [SerializeField] [Required] private SpriteRenderer SpriteRenderer;
        [ValidateInput(nameof(ValidateSprite))] [SerializeField]
        private AZSpriteRenderer_Sprite sprite;
        [ValidateInput(nameof(ValidateColor))] [SerializeField]
        private AZSpriteRenderer_Color color;

        protected override void SetValue_(string value)
        {
            sprite.SetValue(SpriteRenderer, value);
            color.SetValue(SpriteRenderer, value);
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

        private bool ValidateColor(AZSpriteRenderer_Color x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        private bool ValidateSprite(AZSpriteRenderer_Sprite x, ref string error)
        {
            return ValidateOption(x, ref error);
        }

        protected override void Reset()
        {
            base.Reset();
            SpriteRenderer = GetComponent<SpriteRenderer>();
        }
    }
}