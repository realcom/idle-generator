using Sirenix.OdinInspector;
using System.Linq;
using UnityEngine;

namespace Share.ABC
{
    [Required]
    public class ABCGameObject : ABCBase
    {
        [HorizontalGroup("GameObjects")] [HideLabel] [ListDrawerSettings(ShowFoldout = true)] [Required] [SerializeField]
        private GameObject[] activeA, activeB, activeC;

        private GameObject[] GetObjects(ABCType type)
        {
            switch (type)
            {
                case ABCType.A: return activeA;
                case ABCType.B: return activeB;
                case ABCType.C: return activeC;
            }

            Debug.LogError("구현되지 않음. " + type);
            return activeA;
        }

        protected override void SetType_(ABCType type)
        {
            var targets = GetObjects(type).ToHashSet();

            // 한 오브젝트가 2그룹에 포함될 수도 있다.
            foreach (var obj in activeA.Concat(activeB).Concat(activeC).Distinct())
            {
                var show = targets.Contains(obj);
                obj.SetActive(show);
            }
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
            return activeA.Concat(activeB).Concat(activeC).ToArray();
        }
    }
}