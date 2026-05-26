using Sirenix.OdinInspector;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Share.OnOff
{
    public class OnOffGroup : OnOffBase
    {
        [Required]
        [ListDrawerSettings(DefaultExpandedState = true)]
        [ValidateInput(nameof(ValidateCircularReference), "순환참조가 발생했습니다.")]
        [SerializeField] private OnOffBase[] onOffs = { };

        [HideInInspector]
        public OnOffBase[] OnOffs
        {
            get => onOffs;
            set => onOffs = OnOffs;
        }

#if UNITY_EDITOR
        private OnOffBase[] prevSubViews;
#endif

        protected override void _OnOff(bool isOn)
        {
            foreach (var onOff in onOffs)
                if (onOff == null)
                    Debug.LogError("child가 null임.", this);
                else
                    onOff.OnOff(isOn);
        }

        [Button]
        public void FindAll(RectTransform parent)
        {
            if (parent == null)
                parent = transform as RectTransform;

            var childGroups = parent.GetComponentsInChildren<OnOffGroup>()
                .Where(c => c.gameObject != gameObject);

            var ignores = childGroups.Select(c => c.onOffs).SelectMany(c => c);

            onOffs = parent.GetComponentsInChildren<OnOffBase>()
                .Where(c => c != this)
                .Except(ignores)
                .ToArray();
        }

        private bool ValidateCircularReference(OnOffBase[] _)
        {
            var visited = new HashSet<OnOffBase>();
            return ValidateCircularReferenceRec(this, visited);
        }

        private bool ValidateCircularReferenceRec(OnOffBase curr, HashSet<OnOffBase> visited)
        {
            if (!visited.Add(curr))
                return false;
            if (curr is OnOffGroup gr)
            {
                foreach (var child in gr.onOffs)
                    if (!ValidateCircularReferenceRec(child, visited))
                        return false;
                return true;
            }

            return true;
        }


#if UNITY_EDITOR

        static OnOffGroup()
        {
            EditorApplication.hierarchyWindowItemOnGUI += HierarchyWindowCallbackOnOffGroup;
        }

        public static void HierarchyWindowCallbackOnOffGroup(int instanceID, Rect selectionRect)
        {
            var go = (GameObject)EditorUtility.InstanceIDToObject(instanceID);
            var onOff = go?.GetComponent<OnOffGroup>();
            if (onOff == null)
                return;

            DrawGroup(onOff, selectionRect);
        }

        private static void DrawGroup(OnOffGroup onOff, Rect selectionRect)
        {
            var focusedOnOff = Selection.activeGameObject?.GetComponent<OnOffBase>();
            if (focusedOnOff == null)
                return;
            var childs = onOff.GetSafeChildren();
            if (!childs.Contains(focusedOnOff))
                return;

            var rect2 = new Rect(
                GUILayoutUtility.GetLastRect().width - selectionRect.height - 72 + 3,
                selectionRect.y + 3,
                selectionRect.height - 6,
                selectionRect.height - 6
            );
            EditorGUI.DrawRect(rect2, Color.cyan);
        }

        protected override void OnValidate()
        {
            base.OnValidate();

            if (prevSubViews != null)
            {
                foreach (var view in prevSubViews)
                    if (view != null)
                        view.holder = null;
            }

            var children = GetSafeChildren();
            prevSubViews = children;
            foreach (var view in children)
                if (view != null)
                    view.holder = gameObject;
        }

        private OnOffBase[] GetSafeChildren()
        {
            if (onOffs == null)
                return new OnOffBase[0];
            return onOffs;
        }
#endif
    }
}