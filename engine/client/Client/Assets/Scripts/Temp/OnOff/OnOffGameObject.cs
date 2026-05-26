using Sirenix.OdinInspector;
using System.Linq;
using UnityEngine;

namespace Share.OnOff
{
    public class OnOffGameObject : OnOffBase
    {
        [HorizontalGroup("GameObjects")]
        [ListDrawerSettings(DefaultExpandedState = true)]
        [Required]
        [SerializeField] private GameObject[] OnObjs;

        [HorizontalGroup("GameObjects")]
        [ListDrawerSettings(DefaultExpandedState = true)]
        [Required]
        [SerializeField] private GameObject[] OffObjs;

        protected override void _OnOff(bool isOn)
        {
            foreach (var obj in OnObjs)
                obj.SetActive(isOn);

            foreach (var obj in OffObjs)
                obj.SetActive(!isOn);
        }

        [Button]
        [HorizontalGroup("Show")]
        private void ShowAll()
        {
            foreach (var obj in GetAll())
                obj.SetActive(true);
        }

        [Button]
        [HorizontalGroup("Show")]
        private void HideAll()
        {
            foreach (var obj in GetAll())
                obj.SetActive(false);
        }

        private GameObject[] GetAll()
        {
            return OnObjs.Concat(OffObjs).ToArray();
        }

        private bool ShowMe()
        {
            return (OnObjs == null || OnObjs.Length == 0) && (OffObjs == null || OffObjs.Length == 0);
        }

        [GUIColor(0, 1, 0)]
        [ShowIf(nameof(ShowMe))]
        [Button(40)]
        private void Me()
        {
            OnObjs = new[] { gameObject };
        }
    }
}