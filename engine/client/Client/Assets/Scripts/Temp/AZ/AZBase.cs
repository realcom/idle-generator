using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace Share.AZ
{
    [LabelWidth(100)]
    [InlineProperty]
    public abstract class AZOption<TComponent, TOption>
    {
        public bool Use => use;

        [Serializable]
        private struct ValueOption
        {
            [TableColumnWidth(100, false)]
            public string Value;
            public TOption option;
        }

        protected virtual TOption GetDefaultOption()
        {
            return default;
        }

        [HideLabel]
        [SerializeField] private bool use;

        [ShowIf(nameof(use))]
        [TableList(AlwaysExpanded = true)]
        [SerializeField] private List<ValueOption> list;

        public bool IsValid(IEnumerable<string> expected, ref string errorMessage)
        {
            if (!use)
                return true;
            var ex = expected.OrderBy(x => x).ToArray();
            var cur = list.Select(x => x.Value).OrderBy(x => x).ToArray();
            var missing = ex.Except(cur).ToArray();
            var over = cur.Except(ex).ToArray();

            var isMissing = missing.Length != 0;
            var isOver = over.Length != 0;

            if (isMissing)
                errorMessage += $"부족함: {AZExtensions.SumAsString(missing)}";
            if (isOver)
                errorMessage += $"\n과도함: {AZExtensions.SumAsString(over)}";
            return !isMissing && !isOver;
        }

        public void SetValues(string[] values)
        {
            if (!use)
                return;

            // 지우는 건 문제 생길 것 같아서 안 함.
            var add = values.Except(list.Select(x => x.Value));

            foreach (var x in add)
            {
                ValueOption vo;
                vo.Value = x;
                vo.option = GetDefaultOption();
                list.Add(vo);
            }
        }

        public void SetValue(TComponent component, string value)
        {
            if (!use)
                return;

            foreach (var item in list)
                if (item.Value == value)
                    SetOption(component, item.option);
        }

        protected abstract void SetOption(TComponent component, TOption value);
    }

    // A부터 Z까지 다 대응해주는 UI라서 AZ
    [Required]
    public abstract class AZBase : MonoBehaviour
    {
        private static AZPresetTable table => AZPresetTable.Instance;

        public abstract void SetOptionValues(string[] values);
        protected abstract void SetValue_(string value);
        protected abstract bool RequiredUpdateValue();

        protected IEnumerable<string> GetValues()
        {
            return table.FindValuesById(id);
        }

        public string Id => id;

        [ValidateInput(nameof(ValidateId), "유효한 id가 아님.")]
        [ValueDropdown(nameof(GetIds))]
        [PropertyOrder(-2)]
        [SerializeField] private string id;

        private string value { get; set; }

        public void SetValue(string value)
        {
            this.value = value;
            SetValue_(value);
        }

        private bool IsValidId()
        {
            return ValidateId(Id);
        }

        private bool ValidateId(string id)
        {
            return !string.IsNullOrEmpty(id) && table.Contains(id);
        }

        private IEnumerable<string> GetIds()
        {
            return table.Ids;
        }

        private bool ShowUpdateValues()
        {
            return IsValidId() && RequiredUpdateValue();
        }

        [Button("[Update] Values")]
        [ShowIf(nameof(ShowUpdateValues))]
        public void UpdateValues()
        {
            SetOptionValues(GetValues().ToArray());
            SafeEditor.SetDirty(this);
        }

        public bool ValidateOption<TComponent, TOption>(AZOption<TComponent, TOption> option, ref string error)
        {
            // id부터 문제면, id에서 에러를 띄움.
            if (!IsValidId())
                return true;

            if (!option.Use)
                return true;

            var values = GetValues();
            return option.IsValid(values, ref error);
        }

#if UNITY_EDITOR
        [OnInspectorGUI]
        [ShowIf(nameof(IsValidId))]
        private void DrawButtons()
        {
            var changed = false;
            EditorGUILayout.BeginHorizontal();
            foreach (var value in GetValues())
            {
                var origin = GUI.color;
                GUI.color = this.value == value ? Color.green : Color.white;
                if (GUILayout.Button(value, GUILayout.Height(30)))
                {
                    changed = true;
                    SetValue(value);
                }

                GUI.color = origin;
            }

            EditorGUILayout.EndHorizontal();

            if (changed) SafeEditor.SetDirty(this);
        }
#endif

        protected virtual void Reset()
        {
            SafeEditor.MoveComponentTop(this);
        }

#if UNITY_EDITOR
        static AZBase()
        {
            EditorApplication.hierarchyWindowItemOnGUI += HierarchyWindowCallback;
        }

        public static void HierarchyWindowCallback(int instanceID, Rect selectionRect)
        {
            var go = (GameObject)EditorUtility.InstanceIDToObject(instanceID);
            var az = go?.GetComponent<AZBase>();
            if (az == null)
                return;

            var rect = new Rect(
                GUILayoutUtility.GetLastRect().width - selectionRect.height - 60,
                selectionRect.y,
                60,
                selectionRect.height
            );

            var prev = az.value;
            var values = az.GetValues().ToArray();
            var index = values.ToList().IndexOf(prev);
            var nextIndex = EditorGUI.Popup(rect, index, values);
            if (index != nextIndex)
            {
                az.SetValue(values[nextIndex]);
                SafeEditor.SetDirty(az);
            }
        }

#endif
    }


    public static class AZExtensions
    {
        public static string SumAsString<T>(IEnumerable<T> en, string sep = ", ")
        {
            var array = en as T[] ?? en.ToArray();
            if (array.Length == 0)
                return "";

            var builder = new StringBuilder();
            for (var i = 0; i < array.Length; i++)
            {
                var item = array[i];
                builder.Append(item);
                if (i != array.Length - 1)
                    builder.Append(sep);
            }

            return builder.ToString();
        }

        public static T FindOne<T, TKey>(IEnumerable<T> list, TKey key, Func<T, TKey> selector)
        {
            T ret = default;
            var found = 0;

            foreach (var element in list)
            {
                var elementKey = selector(element);

                if (elementKey == null || key == null)
                {
                    if (elementKey == null && key == null)
                    {
                        found++;
                        ret = element;
                    }

                    continue;
                }

                if (key.Equals(elementKey))
                {
                    found++;
                    ret = element;
                }
            }

            if (found == 0)
            {
                var errorMessage = $"({typeof(TKey).Name}<-{typeof(T).Name}) 키를 찾지 못함.\nKey = [{key}]\n" +
                                   CreateListString(list, selector);
                Debug.LogError(errorMessage);
                return list.FirstOrDefault();
            }

            if (1 < found)
            {
                var errorMessage = $"키가 중복임.\nKey = {key}.\n" +
                                   CreateListString(list, selector);
                Debug.LogError(errorMessage);
            }

            return ret;
        }

        private static string CreateListString<T, TKey>(this IEnumerable<T> list, Func<T, TKey> selector)
        {
            return SumAsString(list.Select(x => $"{x} -> {selector(x)}"), "\n");
        }
    }
}