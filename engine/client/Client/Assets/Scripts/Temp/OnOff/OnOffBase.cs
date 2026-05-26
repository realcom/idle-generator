using R3;
using Sirenix.OdinInspector;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Share.OnOff
{
    [Required]
    public abstract class OnOffBase : MonoBehaviour
    {
        public ReadOnlyReactiveProperty<bool> IsOn => isOn;

        // 에디터용
        private Color colorOn => latest == true ? Color.green : Color.white;
        private Color colorOff => latest == false ? Color.green : Color.white;
        private bool? latest;
        private readonly ReactiveProperty<bool> isOn = new();
#if UNITY_EDITOR
        [HideInInspector]
        public GameObject holder { get; set; }
#endif

        public void OnOff(bool isOn)
        {
            this.isOn.Value = isOn;
            latest = isOn;
            _OnOff(isOn);
        }

        protected abstract void _OnOff(bool isOn);

        [Button("On [Shift + W]", ButtonHeight = 30)]
        [HorizontalGroup("Button")]
        [PropertyOrder(999)]
        [GUIColor(nameof(colorOn))]
        public void On()
        {
            OnOff(true);
        }

        [Button("Off [Shift + E]", ButtonHeight = 30)]
        [HorizontalGroup("Button")]
        [PropertyOrder(999)]
        [GUIColor(nameof(colorOff))]
        public void Off()
        {
            OnOff(false);
        }

#if UNITY_EDITOR
        [MenuItem("Window/OutGame/OnOff/On #w")]
        private static void Editor_On()
        {
            Editor_OnOff(true);
        }

        [MenuItem("Window/OutGame/OnOff/Off #e")]
        private static void Editor_Off()
        {
            Editor_OnOff(false);
        }

        private static void Editor_OnOff(bool onOff)
        {
            var objects = Selection.gameObjects;
            var onOffs = objects.Select(x => x.GetComponent<OnOffBase>())
                .Where(x => x != null);

            foreach (var component in onOffs)
            {
                component.OnOff(onOff);
                EditorUtility.SetDirty(component);
            }
        }
#endif

        protected virtual void OnValidate()
        {
            latest = null;
        }

        protected virtual void Reset()
        {
            SafeEditor.MoveComponentTop(this);
        }

#if UNITY_EDITOR
        static OnOffBase()
        {
            EditorApplication.hierarchyWindowItemOnGUI += HierarchyWindowCallback;
        }

        public static void HierarchyWindowCallback(int instanceID, Rect selectionRect)
        {
            var go = (GameObject)EditorUtility.InstanceIDToObject(instanceID);
            var onOff = go?.GetComponent<OnOffBase>();
            if (onOff == null)
                return;

            DrawToggleButton(onOff, selectionRect);
            DrawGroupChildren(onOff, selectionRect);
        }

        private static void DrawToggleButton(OnOffBase onOff, Rect selectionRect)
        {
            var rect = new Rect(
                // favorite이랑 위치가 겹쳐서 48이 최적의 위치임
                GUILayoutUtility.GetLastRect().width - selectionRect.height - 48,
                selectionRect.y,
                selectionRect.height,
                selectionRect.height
            );

            var prev = onOff.isOn.Value;
            EditorGUI.BeginDisabledGroup(onOff.holder != null);
            var curr = EditorGUI.Toggle(rect, prev);
            EditorGUI.EndDisabledGroup();
            if (prev != curr)
            {
                onOff.OnOff(curr);
                EditorUtility.SetDirty(onOff);
            }
        }

        private static void DrawGroupChildren(OnOffBase onOff, Rect selectionRect)
        {
            var focusedObject = Selection.activeGameObject;
            if (focusedObject == null || focusedObject != onOff.holder)
                return;

            // 토글버튼 왼쪽 24 위치에 보여주고 사각형 크기를 조금 줄임
            var rect2 = new Rect(
                GUILayoutUtility.GetLastRect().width - selectionRect.height - 72 + 3,
                selectionRect.y + 3,
                selectionRect.height - 6,
                selectionRect.height - 6
            );
            EditorGUI.DrawRect(rect2, Color.yellow);
        }
#endif
    }
}