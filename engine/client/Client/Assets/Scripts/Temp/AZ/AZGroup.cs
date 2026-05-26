using Sirenix.OdinInspector;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Share.AZ
{
    public class AZGroup : AZBase
    {
        [ListDrawerSettings(DefaultExpandedState = true)]
        [ValidateInput(nameof(Validate))]
        [ValidateInput(nameof(ValidateCircularReference), "순환참조가 발생했습니다.")]
        [Required]
        [SerializeField] private AZBase[] list;

        protected override void SetValue_(string value)
        {
            foreach (var item in list)
                if (item != null)
                    item.SetValue(value);
        }

        protected override bool RequiredUpdateValue()
        {
            return false;
        }

        public override void SetOptionValues(string[] values)
        {
            foreach (var item in list)
                if (item != null)
                    item.SetOptionValues(values);
        }

        private bool Validate(AZBase[] list, ref string errorMessage)
        {
            var invalids = list.Where(x => x.Id != Id).ToArray();
            if (invalids.Length != 0)
            {
                errorMessage = $"id가 {Id}가 아닌 child 목록";
                foreach (var item in invalids)
                {
                    if (item == null)
                        continue;
                    errorMessage += $"\n- {item.name}: {item.Id}";
                }
            }

            return invalids.Length == 0;
        }

        private bool IsValidList()
        {
            var message = "";
            return Validate(list, ref message);
        }

        [Button]
        [HideIf(nameof(IsValidList))]
        private void PickInvalid()
        {
            var invalids = list.Where(x => x.Id != Id).ToArray();
#if UNITY_EDITOR
            Selection.objects = invalids;
            EditorGUIUtility.PingObject(invalids[0].gameObject);
#endif
        }

        private bool ValidateCircularReference(AZBase[] _)
        {
            var visited = new HashSet<AZBase>();
            return ValidateCircularReferenceRec(this, visited);
        }

        private bool ValidateCircularReferenceRec(AZBase curr, HashSet<AZBase> visited)
        {
            if (visited.Contains(curr))
                return false;
            visited.Add(curr);
            if (curr is AZGroup gr)
            {
                foreach (var child in gr.list)
                    if (!ValidateCircularReferenceRec(child, visited))
                        return false;
                return true;
            }

            return true;
        }

        [Button]
        private void FindAll(RectTransform parent)
        {
            if (parent == null)
                parent = transform as RectTransform;
            var childGroups = parent.GetComponentsInChildren<AZGroup>()
                .Where(c => c.gameObject != gameObject);
            var ignores = childGroups.Select(c => c.list).SelectMany(c => c);
            list = parent.GetComponentsInChildren<AZBase>()
                .Where(c => c != this)
                .Except(ignores)
                .ToArray();
        }
    }
}