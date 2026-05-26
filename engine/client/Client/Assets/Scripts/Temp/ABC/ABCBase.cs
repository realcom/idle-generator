using Sirenix.OdinInspector;
using System;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditorInternal;
#endif
using UnityEngine;

namespace Share.ABC
{
    [EnumToggleButtons]
    public enum ABCType
    {
        None,
        A,
        B,
        C
    }

    [Required]
    public abstract class ABCBase : MonoBehaviour
    {
        [Button("A", ButtonHeight = 30)] [HorizontalGroup("Button")] [PropertyOrder(999)] [GUIColor(nameof(colorA))]
        private void A()
        {
            SetType(ABCType.A);
        }

        [Button("B", ButtonHeight = 30)] [HorizontalGroup("Button")] [PropertyOrder(999)] [GUIColor(nameof(colorB))]
        private void B()
        {
            SetType(ABCType.B);
        }

        [Button("C", ButtonHeight = 30)] [HorizontalGroup("Button")] [PropertyOrder(999)] [GUIColor(nameof(colorC))]
        private void C()
        {
            SetType(ABCType.C);
        }

        private Color colorA => latest == ABCType.A ? Color.green : Color.white;
        private Color colorB => latest == ABCType.B ? Color.green : Color.white;
        private Color colorC => latest == ABCType.C ? Color.green : Color.white;
        private ABCType latest;

        public void SetType(ABCType type)
        {
            latest = type;
            SetType_(type);
        }

        public void Set<T>(T value, T a, T b, T c) where T : Enum
        {
            if (value.Equals(a)) SetType(ABCType.A);
            else if (value.Equals(b)) SetType(ABCType.B);
            else if (value.Equals(c)) SetType(ABCType.C);
            else
            {
                Debug.LogError($"확인되지 않은 값: {value}. 후보: ({a}, {b}, {c})", this);
                SetType(ABCType.A);
            }
        }

        protected abstract void SetType_(ABCType type);

        protected virtual void Reset()
        {
#if UNITY_EDITOR
            ComponentUtility.MoveComponentUp(this);
#endif
        }

        protected virtual void OnValidate()
        {
            latest = ABCType.None;
        }


#if UNITY_EDITOR
        static ABCBase()
        {
            EditorApplication.hierarchyWindowItemOnGUI += HierarchyWindowCallback;
        }

        public static void HierarchyWindowCallback(int instanceID, Rect selectionRect)
        {
            var go = (GameObject)EditorUtility.InstanceIDToObject(instanceID);
            var abc = go?.GetComponent<ABCBase>();
            if (abc == null)
                return;

            var size = selectionRect.height;
            var interval = 5;
            var rect = new Rect(
                GUILayoutUtility.GetLastRect().width - size - 60 - size * 3 - interval * 2,
                selectionRect.y,
                size + 5,
                size
            );

            var prev = abc.latest;
            var curr = ABCType.None;

            void Draw(ABCType type)
            {
                GUI.contentColor = prev == type ? Color.green : Color.white;
                rect.x += size + interval;
                if (GUI.Button(rect, type.ToString()))
                    curr = type;
                GUI.contentColor = Color.white;
            }

            Draw(ABCType.A);
            Draw(ABCType.B);
            Draw(ABCType.C);
            if (prev != curr && curr != ABCType.None)
            {
                abc.SetType(curr);
                EditorUtility.SetDirty(abc);
            }
        }

#endif
    }

    [LabelWidth(100)]
    [InlineProperty]
    [Serializable]
    public abstract class ABCOption<TField, TValue>
    {
        [HideLabel] [HorizontalGroup("Horizontal")] [SerializeField]
        private bool use;

        [HorizontalGroup("Horizontal")] [HideLabel] [ShowIf(nameof(use))] [SerializeField]
        private TValue a, b, c;

        public void Set(TField field, ABCType type)
        {
            if (!use)
                return;
            var value = GetValue(type);
            SetValue(field, value);
        }

        private TValue GetValue(ABCType type)
        {
            switch (type)
            {
                case ABCType.A: return a;
                case ABCType.B: return b;
                case ABCType.C: return c;
            }

            Debug.LogError("확인되지 않은 타입 " + type);
            return a;
        }

        public void SetAValue(TValue value)
        {
            a = value;
        }

        public void SetBValue(TValue value)
        {
            b = value;
        }

        public void SetCValue(TValue value)
        {
            c = value;
        }

        protected abstract void SetValue(TField field, TValue value);
    }
}