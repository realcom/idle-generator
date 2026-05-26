using Sirenix.OdinInspector;
using System;
using UnityEngine;

namespace Share.OnOff
{
    [LabelWidth(100)]
    [InlineProperty]
    [Serializable]
    public abstract class OnOffOption<TField, TValue>
    {
        [HideLabel]
        [HorizontalGroup("Horizontal")]
        [SerializeField]
        private bool use;

        [HorizontalGroup("Horizontal")]
        [HideLabel]
        [ShowIf(nameof(use))]
        [SerializeField] private TValue on, off;

        public void Set(TField field, bool isOn)
        {
            if (!use)
                return;
            var value = GetValue(isOn);
            SetValue(field, value);
        }

        private TValue GetValue(bool isOn)
        {
            return isOn ? on : off;
        }

#if UNITY_EDITOR
        public void Swap()
        {
            (on, off) = (off, on);
        }
#endif

        public void Use(bool use)
        {
            this.use = use;
        }

        public void SetOnValue(TValue value)
        {
            on = value;
        }

        public void SetOffValue(TValue value)
        {
            off = value;
        }

        protected abstract void SetValue(TField field, TValue value);
    }
}