using Sirenix.OdinInspector;
using System;
using UnityEngine;

namespace Share.ABC
{
    [Serializable]
    public class ABCSpriteRendererSprite : ABCOption<SpriteRenderer, Sprite>
    {
        protected override void SetValue(SpriteRenderer field, Sprite value)
        {
            field.sprite = value;
        }
    }

    [Serializable]
    public class ABCSpriteRendererColor : ABCOption<SpriteRenderer, Color>
    {
        protected override void SetValue(SpriteRenderer field, Color value)
        {
            field.color = value;
        }
    }

    [Serializable]
    public class ABCSpriteRenderer : ABCBase
    {
        [LabelWidth(80)] [SerializeField] [Required]
        private SpriteRenderer spriteRenderer;

        public ABCSpriteRendererSprite Sprite;
        public ABCSpriteRendererColor Color;

        protected override void SetType_(ABCType type)
        {
            Sprite.Set(spriteRenderer, type);
            Color.Set(spriteRenderer, type);
        }

        protected override void Reset()
        {
            base.Reset();
            spriteRenderer = GetComponentInChildren<SpriteRenderer>();
            Color.SetAValue(UnityEngine.Color.white);
            Color.SetBValue(UnityEngine.Color.white);
            Color.SetCValue(UnityEngine.Color.white);
        }
    }
}