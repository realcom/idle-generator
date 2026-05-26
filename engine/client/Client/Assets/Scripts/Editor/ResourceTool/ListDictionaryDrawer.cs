using System;
using System.Collections.Generic;
using System.Linq;
using Google.Protobuf.Collections;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEngine;
using System.Reflection;
using Commons.Types.Units;
using DG.DemiEditor;
using Color = UnityEngine.Color;
using FontStyle = UnityEngine.FontStyle;

namespace Commons.Resources
{
    public class ListDictionaryDrawer : OdinValueDrawer<List<Dictionary<string, object>>>
    {
        public ListDictionaryDrawer()
        {
            _customSkin1 = ScriptableObject.CreateInstance<GUISkin>();
            _customSkin1.box.normal.background = MakeTex(1, 1, new Color(0.5f, 0.5f, 0.5f, 0.3f));

            _customSkin2 = ScriptableObject.CreateInstance<GUISkin>();
            _customSkin2.box.normal.background = MakeTex(1, 1, Color.clear);

            _customSkin1.box.padding = _customSkin2.box.padding = new RectOffset(0, 0, 5, 5);
            _customSkin1.box.alignment = _customSkin2.box.alignment = TextAnchor.MiddleCenter;
            _customSkin1.button.alignment = _customSkin2.button.alignment = TextAnchor.MiddleCenter;
            _customSkin1.button.normal.textColor = _customSkin2.button.normal.textColor = Color.white;
            _customSkin1.button.hover.textColor = _customSkin2.button.hover.textColor = Color.grey;
            _customSkin1.button.active.textColor = _customSkin2.button.active.textColor = Color.white;
            _customSkin1.textField.clipping = _customSkin2.textField.clipping = TextClipping.Clip;
        }

        private Vector2 _scrollPosition;

        private readonly GUIStyle _originalStyle = new GUIStyle(GUI.skin.textField)
        {
            clipping = TextClipping.Clip
        };

        private readonly GUIStyle _headerStyle = new GUIStyle(GUI.skin.textField)
        {
            alignment = TextAnchor.MiddleCenter, fontStyle = FontStyle.Bold, fontSize = 16, clipping = TextClipping.Clip
        };

        private readonly GUISkin _customSkin1;
        private readonly GUISkin _customSkin2;

        private float _windowWidth;

        protected override void DrawPropertyLayout(GUIContent label)
        {
            _scrollPosition =
                EditorGUILayout.BeginScrollView(_scrollPosition, GUILayout.MaxHeight(1000),
                    GUILayout.MaxWidth(2400));
            _windowWidth = EditorGUILayout.GetControlRect().width;

            var listOfDictionaries = this.ValueEntry.SmartValue;

            if (listOfDictionaries == null)
            {
                listOfDictionaries = new List<Dictionary<string, object>>();
                this.ValueEntry.SmartValue = listOfDictionaries;
            }

            #region Header Row

            EditorGUILayout.BeginHorizontal(GUILayout.Height(50));
            var uniqueKeys = GetUniqueKeys(listOfDictionaries);

            foreach (var key in uniqueKeys)
            {
                GUI.enabled = false;

                _headerStyle.fontSize = Math.Clamp((int)(_windowWidth / uniqueKeys.Count / 12), 10, 16);
                EditorGUILayout.TextField(key, _headerStyle, GUILayout.Height(50));
                GUI.enabled = true;

                GUI.skin.textField = _originalStyle;
            }

            EditorGUILayout.EndHorizontal();

            #endregion

            #region Body Rows

            for (int i = 0; i < listOfDictionaries.Count; i++)
            {
                var dictionary = listOfDictionaries[i];
                if (i % 2 == 0)
                    GUI.skin = _customSkin1;
                else
                    GUI.skin = _customSkin2;


                GUILayout.BeginHorizontal(GUI.skin.box);

                foreach (var key in dictionary.Keys.ToList())
                {
                    var value = dictionary[key];
                    Type valueType = value != null ? value.GetType() : typeof(object);

                    GUILayout.Space(1);

                    #region Serializable FieldTypes

                    if (valueType == typeof(int))
                    {
                        int newValue = EditorGUILayout.IntField((int)value);
                        dictionary[key] = newValue;
                    }
                    else if (valueType == typeof(uint))
                    {
                        uint newValue = (uint)(int)EditorGUILayout.IntField((int)(uint)value);
                        dictionary[key] = newValue;
                    }
                    else if (valueType == typeof(float))
                    {
                        float newValue = EditorGUILayout.FloatField((float)value);
                        dictionary[key] = newValue;
                    }
                    else if (valueType == typeof(string))
                    {
                        string newValue = EditorGUILayout.TextField((string)value);
                        dictionary[key] = newValue;
                    }
                    else if (valueType == typeof(bool))
                    {
                        bool currentValue = (bool)value;
                        string[] enumNames = { "False", "True" };
                        int selectedIndex = currentValue ? 1 : 0;
                        selectedIndex = EditorGUILayout.Popup(selectedIndex, enumNames);
                        dictionary[key] = selectedIndex == 1;
                    }
                    else if (valueType.IsEnum)
                    {
                        Enum newValue = EditorGUILayout.EnumPopup((Enum)value);
                        dictionary[key] = newValue;
                    }

                    #endregion

                    else if (IsRepeatedField(valueType))
                    {
                        Type elementType = valueType.GetGenericArguments()[0];
                        MethodInfo toListMethod = typeof(Enumerable).GetMethod("ToList").MakeGenericMethod(elementType);
                        object list = toListMethod.Invoke(null, new[] { value });

                        RenderList((dynamic)list, dictionary, key);
                    }
                    else
                    {
                        GUI.enabled = false;
                        EditorGUILayout.TextField("Unsupported type");
                        GUI.enabled = true;
                    }
                }

                GUILayout.EndHorizontal();
            }

            GUI.skin = null;

            #endregion

            EditorGUILayout.EndScrollView();
        }

        #region Helper Methods

        private HashSet<string> GetUniqueKeys(List<Dictionary<string, object>> listOfDictionaries)
        {
            HashSet<string> keys = new HashSet<string>();
            foreach (var dictionary in listOfDictionaries)
            {
                foreach (var key in dictionary.Keys)
                {
                    keys.Add(key);
                }
            }

            return keys;
        }

        private bool IsRepeatedField(Type type)
        {
            if (!type.IsGenericType)
                return false;

            return type.GetGenericTypeDefinition() == typeof(RepeatedField<>);
        }

        private void RenderList<T>(List<T> list, Dictionary<string, object> dictionary, string key)
        {
            EditorGUILayout.BeginVertical();

            if (list.Count == 0)
            {
                EditorGUILayout.BeginHorizontal();
                GUI.enabled = false;
                EditorGUILayout.TextField("Empty");
                GUI.enabled = true;
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.BeginHorizontal();
                if (GUILayout.Button("+"))
                {
                    list.Add(CreateDefault<T>());
                    dictionary[key] = ConvertListToRepeatedField(list);
                }

                EditorGUILayout.EndHorizontal();
            }

            else
            {
                for (int i = 0; i < list.Count; i++)
                {
                    EditorGUILayout.BeginHorizontal();

                    var valueType = typeof(T);

                    #region Serializable FieldTypes

                    if (valueType == typeof(int))
                    {
                        list[i] = (T)(object)EditorGUILayout.IntField((int)(object)list[i]);
                    }
                    else if (valueType == typeof(float))
                    {
                        list[i] = (T)(object)EditorGUILayout.FloatField((float)(object)list[i]);
                    }
                    else if (valueType == typeof(string))
                    {
                        list[i] = (T)(object)EditorGUILayout.TextField((string)(object)list[i]);
                    }
                    else if (valueType == typeof(bool))
                    {
                        bool currentValue = (bool)(object)list[i];
                        string[] enumNames = { "False", "True" };
                        int selectedIndex = currentValue ? 1 : 0;
                        selectedIndex = EditorGUILayout.Popup(selectedIndex, enumNames);
                        list[i] = (T)(object)(selectedIndex == 1);
                    }
                    else if (valueType.IsEnum)
                    {
                        list[i] = (T)(object)EditorGUILayout.EnumPopup((Enum)(object)list[i]);
                    }

                    #endregion

                    #region ResourceUnit

                    else if (valueType == typeof(AddUnitStat))
                    {
                        EditorGUILayout.BeginVertical();
                        PropertyInfo typeProperty = valueType.GetProperty("Type");
                        PropertyInfo valueProperty = valueType.GetProperty("Value");


                        object typeValue = null;
                        object valueValue = null;

                        if (typeProperty != null)
                        {
                            typeValue = typeProperty.GetValue(list[i]);
                            typeValue = EditorGUILayout.EnumPopup((Enum)typeValue);
                        }
                        else
                            EditorGUILayout.TextField("Unsupported type");


                        if (valueProperty != null)
                        {
                            valueValue = valueProperty.GetValue(list[i]);
                            valueValue = EditorGUILayout.TextField(valueValue?.ToString() ?? "null");
                        }
                        else
                            EditorGUILayout.TextField("Unsupported type");

                        EditorGUILayout.EndVertical();
                        var newAddUnitStat = new AddUnitStat
                        {
                            Type = (UnitStatType)typeValue
                        };
                        newAddUnitStat.Value.AddRange(ConvertStringToListOfFloats(valueValue.ToString()));

                        list[i] = (T)(object)newAddUnitStat;
                    }

                    #endregion

                    else
                    {
                        GUI.enabled = false;
                        EditorGUILayout.TextField("Unsupported type");
                        GUI.enabled = true;
                    }

                    EditorGUILayout.EndHorizontal();
                }

                EditorGUILayout.BeginHorizontal();

                if (GUILayout.Button("+"))
                {
                    list.Add(CreateDefault<T>());
                    dictionary[key] = ConvertListToRepeatedField(list);
                }

                if (GUILayout.Button("-"))
                {
                    list.RemoveAt(list.Count - 1);
                    dictionary[key] = ConvertListToRepeatedField(list);
                }

                EditorGUILayout.EndHorizontal();
            }

            dictionary[key] = ConvertListToRepeatedField(list);
            EditorGUILayout.EndVertical();
        }

        private static List<T> ConvertRepeatedFieldToList<T>(RepeatedField<T> repeatedField)
        {
            return repeatedField.ToList();
        }

        private T CreateDefault<T>()
        {
            var elementType = typeof(T);
            if (elementType == typeof(int))
                return (T)(object)0;
            if (elementType == typeof(float))
                return (T)(object)0f;
            if (elementType == typeof(string))
                return (T)(object)"";
            if (elementType == typeof(bool))
                return (T)(object)false;
            if (elementType.IsEnum)
                return (T)Enum.GetValues(elementType).GetValue(0);

            #region ResourceUnit

            if (elementType == typeof(AddUnitStat))
                return (T)(object)new AddUnitStat();

            #endregion


            #region ResourceSkill

            if (elementType == typeof(ResourceSkill.Types.Timeline))
                return (T)(object)new AddUnitStat();

            #endregion

            return default;
        }

        private static RepeatedField<T> ConvertListToRepeatedField<T>(List<T> list)
        {
            var repeatedField = new RepeatedField<T>();
            repeatedField.AddRange(list.Where(item => item != null));
            return repeatedField;
        }

        private static Texture2D MakeTex(int width, int height, Color color)
        {
            Color[] pix = new Color[width * height];
            for (int i = 0; i < pix.Length; ++i)
            {
                pix[i] = color;
            }

            Texture2D result = new Texture2D(width, height);
            result.SetPixels(pix);
            result.Apply();
            return result;
        }

        private static List<float> ConvertStringToListOfFloats(string input)
        {
            List<float> result = new List<float>();

            if (string.IsNullOrEmpty(input))
                return result;

            input = input.Trim('[', ']');

            string[] stringValues = input.Split(',');

            foreach (string stringValue in stringValues)
            {
                if (stringValue.IsNullOrEmpty())
                    break;
                if (float.TryParse(stringValue.Trim(), out float floatValue))
                    result.Add(floatValue);
                else
                    Debug.LogError($"Could not parse '{stringValue}' as an integer.");
            }

            return result;
        }

        #endregion
    }
}