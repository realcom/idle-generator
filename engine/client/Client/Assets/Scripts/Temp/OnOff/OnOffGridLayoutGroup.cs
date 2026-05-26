using Sirenix.OdinInspector;
using System;
using UnityEngine;
using UnityEngine.UI;

namespace Share.OnOff
{
    [Serializable]
    public class OnOffGridLayoutGroup_ConstraintCount : OnOffOption<GridLayoutGroup, int>
    {
        protected override void SetValue(GridLayoutGroup field, int value)
        {
            field.constraintCount = value;
        }
    }

    [Required]
    public class OnOffGridLayoutGroup : OnOffBase
    {
        [SerializeField] [Required] private GridLayoutGroup layout;
        [SerializeField] private OnOffGridLayoutGroup_ConstraintCount constraintCount;

        protected override void _OnOff(bool isOn)
        {
            constraintCount.Set(layout, isOn);
        }

        protected override void Reset()
        {
            base.Reset();
            layout = GetComponent<GridLayoutGroup>();
        }
    }
}