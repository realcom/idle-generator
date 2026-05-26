using Sirenix.OdinInspector;
using System.Collections.Generic;
using UnityEngine;

namespace Share.ABC
{
    [Required]
    public class ABCGroup : ABCBase
    {
        [ListDrawerSettings(ShowFoldout = true)]
        [ValidateInput(nameof(ValidateCircularReference), "순환참조가 발생했습니다.")]
        [Required]
        [SerializeField]
        private ABCBase[] abc;

        protected override void SetType_(ABCType type)
        {
            foreach (var option in abc)
            {
                if (option == this)
                    continue;
                option.SetType(type);
            }
        }

        [Button]
        private void 레퍼런스자동연결(RectTransform parent)
        {
            /*if (parent == null)
            parent = transform as RectTransform;
        var options = parent.GetComponentsInChildren<ABCBase>().Except(this);
        abc = abc.Concat(options).Distinct().ToArray();*/
        }

        private bool ValidateCircularReference(ABCBase[] _)
        {
            var visited = new HashSet<ABCBase>();
            return ValidateCircularReferenceRec(this, visited);
        }

        private bool ValidateCircularReferenceRec(ABCBase curr, HashSet<ABCBase> visited)
        {
            if (visited.Contains(curr))
                return false;
            visited.Add(curr);
            if (curr is ABCGroup gr)
            {
                foreach (var child in gr.abc)
                    if (!ValidateCircularReferenceRec(child, visited))
                        return false;

                return true;
            }

            return true;
        }
    }
}