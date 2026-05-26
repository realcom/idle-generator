using Sirenix.OdinInspector;
using System;
using UnityEngine;

namespace Share.OnOff
{
    [Serializable]
    public class OnOffRectTransform_SizeDelta : OnOffOption<RectTransform, Vector2>
    {
        protected override void SetValue(RectTransform field, Vector2 value)
        {
            field.sizeDelta = value;
        }
    }

    [Serializable]
    public class OnOffRectTransform_AnchoredPosition : OnOffOption<RectTransform, Vector2>
    {
        protected override void SetValue(RectTransform field, Vector2 value)
        {
            field.anchoredPosition = value;
        }
    }

    [Serializable]
    public class OnOffRectTransform_Anchors : OnOffOption<RectTransform, RectTransformAnchors>
    {
        protected override void SetValue(RectTransform field, RectTransformAnchors value)
        {
            field.anchorMin = value.Min;
            field.anchorMax = value.Max;
        }
    }

    [Serializable]
    public class OnOffRectTransform_Scale : OnOffOption<RectTransform, Vector2>
    {
        protected override void SetValue(RectTransform field, Vector2 value)
        {
            field.localScale = new Vector3(value.x, value.y, field.localScale.z);
        }
    }

    [Serializable]
    public struct RectTransformAnchors
    {
        [LabelWidth(40)]
        public Vector2 Min;
        [LabelWidth(40)]
        public Vector2 Max;
    }

    [Required]
    public class OnOffRectTransform : OnOffBase
    {
        [SerializeField] [Required] private RectTransform rectTransform;
        [SerializeField] private OnOffRectTransform_SizeDelta sizeDelta;
        [SerializeField] private OnOffRectTransform_AnchoredPosition anchoredPosition;
        [SerializeField] private OnOffRectTransform_Anchors anchors;
        [SerializeField] private OnOffRectTransform_Scale scale;

        [Title("현재 값")]
        [ShowInInspector] private Vector2 m_sizeDelta => rectTransform.sizeDelta;

        [ShowInInspector] private Vector2 m_anchoredPosition => rectTransform.anchoredPosition;

        protected override void _OnOff(bool isOn)
        {
            sizeDelta.Set(rectTransform, isOn);
            anchoredPosition.Set(rectTransform, isOn);
            anchors.Set(rectTransform, isOn);
            scale.Set(rectTransform, isOn);
        }

        protected override void Reset()
        {
            base.Reset();
            rectTransform = GetComponent<RectTransform>();
            sizeDelta.SetOnValue(rectTransform.sizeDelta);
            sizeDelta.SetOffValue(rectTransform.sizeDelta);
            anchoredPosition.SetOnValue(rectTransform.anchoredPosition);
            anchoredPosition.SetOffValue(rectTransform.anchoredPosition);
            scale.SetOnValue(Vector2.one);
            scale.SetOffValue(Vector2.one);
        }
    }
}