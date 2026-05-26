using Sirenix.OdinInspector;
using System;
using UnityEngine;

namespace Share.OnOff
{
    [Serializable]
    public class OnOffCanvasGroup_Interactable : OnOffOption<CanvasGroup, bool>
    {
        protected override void SetValue(CanvasGroup field, bool value)
        {
            field.interactable = value;
        }
    }

    [Serializable]
    public class OnOffCanvasGroup_Alpha : OnOffOption<CanvasGroup, float>
    {
        protected override void SetValue(CanvasGroup field, float value)
        {
            field.alpha = value;
        }
    }

    [Serializable]
    public class OnOffCanvasGroup_BlocksRaycasts : OnOffOption<CanvasGroup, bool>
    {
        protected override void SetValue(CanvasGroup field, bool value)
        {
            field.blocksRaycasts = value;
        }
    }

    [Required]
    public class OnOffCanvasGroup : OnOffBase
    {
        [SerializeField] [Required] private CanvasGroup canvasGroup;
        [SerializeField] private OnOffCanvasGroup_Interactable interactable;
        [SerializeField] private OnOffCanvasGroup_Alpha alpha;
        [SerializeField] private OnOffCanvasGroup_BlocksRaycasts blocksRaycasts;

        protected override void _OnOff(bool isOn)
        {
            interactable.Set(canvasGroup, isOn);
            alpha.Set(canvasGroup, isOn);
            blocksRaycasts.Set(canvasGroup, isOn);
        }

        protected override void Reset()
        {
            base.Reset();
            canvasGroup = GetComponent<CanvasGroup>();
        }
    }
}