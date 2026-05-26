using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Sirenix.OdinInspector;

#if UNITY_EDITOR
using Sirenix.OdinInspector.Editor;
using UnityEditor;
#endif

public class UITableViewSizeFitter : LayoutElement, IUITableViewEventSubscribers
{
    [SerializeField] private UITableViewEx tableView;

    [SerializeField] private float maxWidth = -1f;
    [SerializeField] private float maxHeight = -1f;

    public void OnTableViewContentSizeChanged(Vector2 changedSize)
    {
        FitSize(changedSize);
    }

    private void FitSize(Vector2 size)
    {
        if (preferredWidth >= 0)
        {
            preferredWidth = maxWidth >= 0 ? Mathf.Min(maxWidth, size.x) : size.x;
        }

        if (preferredHeight >= 0)
        {
            preferredHeight = maxHeight >= 0 ? Mathf.Min(maxHeight, size.y) : size.y;
        }
    }

#if UNITY_EDITOR

    public void FitSizeByCount(int count, int size = 0)
    {
        if (tableView == null)
            return;

        var sizeVec = tableView.GetContentSize(count, size);
        FitSize(sizeVec);
    }

#endif
}

#if UNITY_EDITOR
[CustomEditor(typeof(UITableViewSizeFitter), true)]
[CanEditMultipleObjects]
public class UITableViewSizeFitterEditor : OdinEditor
{
    SerializedProperty m_IgnoreLayout;
    SerializedProperty m_MinWidth;
    SerializedProperty m_MinHeight;
    SerializedProperty m_PreferredWidth;
    SerializedProperty m_PreferredHeight;
    SerializedProperty m_FlexibleWidth;
    SerializedProperty m_FlexibleHeight;
    SerializedProperty m_LayoutPriority;
    SerializedProperty m_UITableViewEx;
    SerializedProperty m_MaxWidth;
    SerializedProperty m_MaxHeight;

    private int _count;
    private int _size;

    protected override void OnEnable()
    {
        base.OnEnable();
        
        m_IgnoreLayout = serializedObject.FindProperty("m_IgnoreLayout");
        m_MinWidth = serializedObject.FindProperty("m_MinWidth");
        m_MinHeight = serializedObject.FindProperty("m_MinHeight");
        m_PreferredWidth = serializedObject.FindProperty("m_PreferredWidth");
        m_PreferredHeight = serializedObject.FindProperty("m_PreferredHeight");
        m_FlexibleWidth = serializedObject.FindProperty("m_FlexibleWidth");
        m_FlexibleHeight = serializedObject.FindProperty("m_FlexibleHeight");
        m_LayoutPriority = serializedObject.FindProperty("m_LayoutPriority");
        m_UITableViewEx = serializedObject.FindProperty("tableView");
        m_MaxWidth = serializedObject.FindProperty("maxWidth");
        m_MaxHeight = serializedObject.FindProperty("maxHeight");
    }

    public override void OnInspectorGUI()
    {
        //base.OnInspectorGUI();
        
        serializedObject.Update();
        
        EditorGUILayout.PropertyField(m_IgnoreLayout);

        if (!m_IgnoreLayout.boolValue)
        {
            EditorGUILayout.Space();
            
            EditorGUILayout.PropertyField(m_UITableViewEx);

            LayoutElementField(m_MinWidth, 0);
            LayoutElementField(m_MinHeight, 0);
            LayoutElementField(m_PreferredWidth, t => t.rect.width);
            LayoutElementField(m_PreferredHeight, t => t.rect.height);
            LayoutElementField(m_MaxWidth,  t => t.rect.width);
            LayoutElementField(m_MaxHeight, t => t.rect.height);
            LayoutElementField(m_FlexibleWidth, 1);
            LayoutElementField(m_FlexibleHeight, 1);
        }

        EditorGUILayout.PropertyField(m_LayoutPriority);
        
        EditorGUILayout.Space();
        
        _count = EditorGUILayout.IntField("Count", _count);
        _size  = EditorGUILayout.IntField("Size",  _size);

        using (new EditorGUILayout.HorizontalScope())
        {
            if (GUILayout.Button("Fit Size"))
            {
                if (target is UITableViewSizeFitter sizeFitter)
                {
                    sizeFitter.FitSizeByCount(_count, _size);
                }
            }
        }

        serializedObject.ApplyModifiedProperties();
    }

    void LayoutElementField(SerializedProperty property, float defaultValue)
    {
        LayoutElementField(property, _ => defaultValue);
    }

    void LayoutElementField(SerializedProperty property, System.Func<RectTransform, float> defaultValue)
    {
        Rect position = EditorGUILayout.GetControlRect();

        // Label
        GUIContent label = EditorGUI.BeginProperty(position, null, property);

        // Rects
        Rect fieldPosition = EditorGUI.PrefixLabel(position, label);

        Rect toggleRect = fieldPosition;
        toggleRect.width = 16;

        Rect floatFieldRect = fieldPosition;
        floatFieldRect.xMin += 16;

        // Checkbox
        EditorGUI.BeginChangeCheck();
        bool enabled = EditorGUI.ToggleLeft(toggleRect, GUIContent.none, property.floatValue >= 0);
        if (EditorGUI.EndChangeCheck())
        {
            // This could be made better to set all of the targets to their initial width, but mimizing code change for now
            property.floatValue = (enabled ? defaultValue((target as LayoutElement).transform as RectTransform) : -1);
        }

        if (!property.hasMultipleDifferentValues && property.floatValue >= 0)
        {
            // Float field
            EditorGUIUtility.labelWidth = 4; // Small invisible label area for drag zone functionality
            EditorGUI.BeginChangeCheck();
            float newValue = EditorGUI.FloatField(floatFieldRect, new GUIContent(" "), property.floatValue);
            if (EditorGUI.EndChangeCheck())
            {
                property.floatValue = Mathf.Max(0, newValue);
            }

            EditorGUIUtility.labelWidth = 0;
        }

        EditorGUI.EndProperty();
    }
}
#endif