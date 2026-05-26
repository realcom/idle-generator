using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
#if UNITY_EDITOR
using UnityEditor;
#endif


[DisallowMultipleComponent]
public class UIStringsManager : MonoBehaviour
{
    [System.Serializable]
    public class UIStringData
    {
        public GameObject target;
        public string lStringKey;
    }

    public List<UIStringData> uiLocalizedStringDataRegistrationList;

    private void Start()
    {
        foreach (var uiStringData in uiLocalizedStringDataRegistrationList)
        {
            if (uiStringData.target == null) continue;

            if (uiStringData.target.TryGetComponent<TextMeshProUGUI>(out var tmp))
            {
                tmp.text = uiStringData.lStringKey != "<None>"
                    ? uiStringData.lStringKey.L()
                    : tmp.text;
            }
            else if (uiStringData.target.TryGetComponent<Text>(out var text))
            {
                text.text = uiStringData.lStringKey != "<None>"
                    ? uiStringData.lStringKey.L()
                    : text.text;
            }
        }
    }
}


#if UNITY_EDITOR
[CustomPropertyDrawer(typeof(UIStringsManager.UIStringData))]
public class LStringsKeyDrawer : PropertyDrawer
{
    private const string NoneOption = "<None>";
    private Dictionary<string, string> searchGroups = new ();
    private Dictionary<string, string> searchIDs = new ();

    private bool errorLogged;
    private static int lastGroupIndex = 0; 

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        EditorGUI.BeginProperty(position, label, property);

        string propertyPath = property.propertyPath;
    
        if (!searchGroups.ContainsKey(propertyPath))
        {
            searchGroups[propertyPath] = "";
        }
        if (!searchIDs.ContainsKey(propertyPath))
        {
            searchIDs[propertyPath] = "";
        }

        var targetProperty = property.FindPropertyRelative("target");
        var targetGameObject = targetProperty.objectReferenceValue as GameObject;
        string fieldType = "";
        if (targetGameObject != null)
        {
            if (targetGameObject.GetComponent<Text>() != null)
                fieldType = " (Text)";
            else if (targetGameObject.GetComponent<TextMeshProUGUI>() != null)
                fieldType = " (TMP)";
        }

        var targetLabel = new GUIContent($"Target{fieldType}");
        EditorGUI.PropertyField(new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
            targetProperty, targetLabel);
        
        var targetIsValid = false;
        if (targetGameObject != null && targetProperty.objectReferenceValue != null)
            targetIsValid = targetGameObject.GetComponent<Text>() != null || targetGameObject.GetComponent<TextMeshProUGUI>() != null;

        if (targetIsValid)
        {
            // Draw lStringKey field only if target is not null
            if (targetProperty.objectReferenceValue != null)
            {
                // Search UI
                position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                searchGroups[propertyPath] = EditorGUI.TextField(new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight), "Search Group", searchGroups[propertyPath]);
                position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                
                //
                (var groups, var ids) = GetGroupAndIDData();
                var filteredGroups = string.IsNullOrEmpty(searchGroups[propertyPath]) ? groups: groups.Where(group => group.IndexOf(searchGroups[propertyPath], StringComparison.OrdinalIgnoreCase) >= 0).ToArray();
                
                var selectedGroupIndex =
                    GetSelectedGroupIndex(filteredGroups, property.FindPropertyRelative("lStringKey").stringValue, ids[1]);

                var originalGroupIndex = filteredGroups.Length > 0 
                    ? Array.IndexOf(groups, filteredGroups[selectedGroupIndex]) 
                    : 0;

                var selectedIDIndex = GetSelectedIDIndex(ids[originalGroupIndex],
                    property.FindPropertyRelative("lStringKey").stringValue);

                // Draw group text input and popup
                EditorGUI.BeginChangeCheck();
                selectedGroupIndex =
                    EditorGUI.Popup(new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
                        "Group", selectedGroupIndex, filteredGroups);
                if (EditorGUI.EndChangeCheck())
                {
                    originalGroupIndex = Array.IndexOf(groups, filteredGroups[selectedGroupIndex]);

                    if (ids[originalGroupIndex].Length > 1)
                        property.FindPropertyRelative("lStringKey").stringValue = ids[originalGroupIndex][1];
                    else
                        property.FindPropertyRelative("lStringKey").stringValue = "";
                }

                // Draw id search text input and popup
                position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                EditorGUI.BeginChangeCheck();
                searchIDs[propertyPath] = EditorGUI.TextField(new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight), "Search String Key", searchIDs[propertyPath]);
                if (EditorGUI.EndChangeCheck())
                    selectedIDIndex = 0;

                position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                var filteredIDs = ids[originalGroupIndex].Where(id => id.IndexOf(searchIDs[propertyPath], StringComparison.OrdinalIgnoreCase) >= 0).ToArray();

                if (filteredIDs.Length == 0)
                    searchIDs[propertyPath] = "";

                var currentIndexInFiltered = Array.IndexOf(filteredIDs, property.FindPropertyRelative("lStringKey").stringValue);

                if (currentIndexInFiltered == -1)
                    selectedIDIndex = 0;
                else
                    selectedIDIndex = currentIndexInFiltered;

                EditorGUI.BeginChangeCheck();
                selectedIDIndex =
                    EditorGUI.Popup(new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
                        "String Key",
                        selectedIDIndex, filteredIDs);

                if (EditorGUI.EndChangeCheck())
                    property.FindPropertyRelative("lStringKey").stringValue = filteredIDs[selectedIDIndex];
                
                var currentGroup = groups[originalGroupIndex];
                
                if(string.IsNullOrEmpty(currentGroup) || currentGroup == NoneOption)
                {
                    position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                    EditorGUI.HelpBox(
                        new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
                        "Warning: The Group is not properly selected. Please choose a valid one.",
                        MessageType.Error);
                }
                else
                {
                    var currentID = property.FindPropertyRelative("lStringKey").stringValue;
                    if(string.IsNullOrEmpty(currentID))
                    {
                        position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                        EditorGUI.HelpBox(
                            new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
                            "Warning: The String Key is empty. Please choose a valid one.",
                            MessageType.Error);
                    }
                    else if(string.IsNullOrEmpty(currentID) || currentID == NoneOption) 
                    {
                        position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
                        EditorGUI.HelpBox(
                            new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight),
                            "Warning: The String Key is not properly selected. Please choose a valid one.",
                            MessageType.Error);
                    }
                }
                position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;

                // if (selectedIDIndex == 0 && !errorLogged)
                // {
                //     EditorGUI.HelpBox(
                //         new Rect(position.x, position.y + EditorGUIUtility.singleLineHeight, position.width,
                //             EditorGUIUtility.singleLineHeight),
                //         "Please select a valid String Key.", MessageType.Error);
                //     // Debug.LogError(
                //     //     $"UIStringsManager: GameObject '{targetGameObject.GetComponentInParent<UIStringsManager>().gameObject.name}' contains an entry with <None> String Key. Please fix it before entering Play Mode.");
                //     errorLogged = true;
                // }
            }
            else
            {
                property.FindPropertyRelative("lStringKey").stringValue = "";
            }
        }
        else
        {
            // If the target is not valid, show an error message and reset the lStringKey
            if (targetProperty.objectReferenceValue != null)
            {
                EditorGUI.HelpBox(
                    new Rect(position.x, position.y + EditorGUIUtility.singleLineHeight, position.width,
                        EditorGUIUtility.singleLineHeight),
                    "Target GameObject must have a Text or TextMeshProUGUI component.", MessageType.Error);
            }

            property.FindPropertyRelative("lStringKey").stringValue = "";
        }

        EditorGUI.EndProperty();
    }


    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        return EditorGUIUtility.singleLineHeight * 7 + EditorGUIUtility.standardVerticalSpacing * 6;
    }

    private static int GetSelectedGroupIndex(string[] groups, string lStringKey, string[] commonGroup)
    {
        if (string.IsNullOrEmpty(lStringKey) || lStringKey == NoneOption)
            return lastGroupIndex;

        var sortedGroups = groups.OrderByDescending(s => s.Length).ToArray();
        for (var i = 1; i < sortedGroups.Length; i++)
        {
            if (lStringKey.StartsWith(sortedGroups[i]))
            {
                lastGroupIndex = Array.IndexOf(groups, sortedGroups[i]);
                return lastGroupIndex;
            }
            if (commonGroup.Any(x => x == lStringKey))
            {
                lastGroupIndex = 1;
                return lastGroupIndex;
            }
        }

        return 0;
    }

    private static int GetSelectedIDIndex(string[] ids, string lStringKey)
    {
        if (string.IsNullOrEmpty(lStringKey) || lStringKey == NoneOption)
            return 0;

        for (var i = 1; i < ids.Length; i++)
        {
            if (lStringKey == ids[i])
            {
                return i;
            }
        }

        return 0;
    }

    private (string[] groups, string[][] ids) GetGroupAndIDData()
    {
        var lStringsType = typeof(StringKeys);
        var nestedTypes = lStringsType.GetNestedTypes();
        var groups = new List<string> { NoneOption };
        var ids = new List<string[]> { new string[] { NoneOption } };

        foreach (var type in nestedTypes)
        {
            if (type.DeclaringType == typeof(StringKeys.LocalizableStringKey))
                continue;

            var stringKeys = type.GetFields(BindingFlags.Public | BindingFlags.Static)
                .Where(fieldInfo => fieldInfo.FieldType == typeof(StringKeys.LocalizableStringKey))
                .Select(fieldInfo => ((StringKeys.LocalizableStringKey)fieldInfo.GetValue(null)).Key)
                .ToArray();
            
            if (stringKeys.Length == 0)
                continue;
            
            groups.Add(type.Name);

            stringKeys = (new string[] { NoneOption }).Concat(stringKeys).ToArray();
            ids.Add(stringKeys);
        }

        return (groups.ToArray(), ids.ToArray());
    }

}
#endif
