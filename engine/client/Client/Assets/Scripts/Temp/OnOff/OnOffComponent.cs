using Sirenix.OdinInspector;
using System;
using UnityEngine;

namespace Share.OnOff
{
    [Serializable]
    public class OnOffComponent : OnOffBase
    {
        [SerializeField] [Required] private MonoBehaviour component;
        [SerializeField] private bool invertOnOff;

        protected override void _OnOff(bool isOn)
        {
            if (invertOnOff)
                isOn = !isOn;

            component.enabled = isOn;
        }
    }
}