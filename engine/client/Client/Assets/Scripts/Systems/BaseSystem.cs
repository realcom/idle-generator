using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

#if UNITY_EDITOR

using Sirenix.OdinInspector.Editor;
using UnityEditor;

#endif

public interface ISystem
{
    
}

public abstract class BaseSystem<TSystem> : ISystem where TSystem : BaseSystem<TSystem>, new()
{
#if UNITY_EDITOR
    private const string prefsKey = "System.0907";
#endif
    
    protected static void SaveEnum<T>(string key, T value) where T : Enum
    {
#if UNITY_EDITOR
        EditorPrefs.SetInt($"{prefsKey}.{key}", Convert.ToInt32(value));
#endif
    }
    
    protected static T LoadEnum<T>(string key, T defaultValue = default) where T : Enum
    {
#if UNITY_EDITOR
        return (T)Enum.ToObject(typeof(T), EditorPrefs.GetInt($"{prefsKey}.{key}", Convert.ToInt32(defaultValue)));
#endif
        return defaultValue;
    }
    
    protected static void SaveBool(string key, bool value)
    {
#if UNITY_EDITOR
        EditorPrefs.SetBool($"{prefsKey}.{key}", value);
#endif
    }
    
    protected static bool LoadBool(string key, bool defaultValue = default)
    {
#if UNITY_EDITOR
        return EditorPrefs.GetBool($"{prefsKey}.{key}", defaultValue);
#endif
        return defaultValue;
    }
    
    protected static void SaveInt(string key, int value)
    {
#if UNITY_EDITOR
        EditorPrefs.SetInt($"{prefsKey}.{key}", value);
#endif
    }
    
    protected static int LoadInt(string key, int defaultValue = default)
    {
#if UNITY_EDITOR
        return EditorPrefs.GetInt($"{prefsKey}.{key}", defaultValue);
#endif
        return defaultValue;
    }
    
    protected static void SaveFloat(string key, float value)
    {
#if UNITY_EDITOR
        EditorPrefs.SetFloat($"{prefsKey}.{key}", value);
#endif
    }
    
    protected static float LoadFloat(string key, float defaultValue = default)
    {
#if UNITY_EDITOR
        return EditorPrefs.GetFloat($"{prefsKey}.{key}", defaultValue);
#endif
        return defaultValue;
    }
    
    protected static void SaveString(string key, string value)
    {
#if UNITY_EDITOR
        EditorPrefs.SetString($"{prefsKey}.{key}", value);
#endif
    }
    
    protected static string LoadString(string key, string defaultValue = default)
    {
#if UNITY_EDITOR
        return EditorPrefs.GetString($"{prefsKey}.{key}", defaultValue);
#endif
        return defaultValue;
    }
    
    protected static void SaveColor(string key, Color value)
    {
#if UNITY_EDITOR
        EditorPrefs.SetInt($"{prefsKey}.{key}", (int)value.ToColor());
#endif
    }
    
    protected static Color LoadColor(string key, Color defaultValue = default)
    {
#if UNITY_EDITOR
        var colorInt = (uint)EditorPrefs.GetInt($"{prefsKey}.{key}", (int)defaultValue.ToColor());
        return Utility.ColorFrom(colorInt);
#endif
        return defaultValue;
    }
    
}

#if UNITY_EDITOR
    
public class SystemEditor : OdinMenuEditorWindow
{
    [MenuItem("System/System Editor")]
    public static void ShowWindow()
    {
        GetWindow<SystemEditor>();
    }

    private void OnInspectorUpdate()
    {
        Repaint();
    }
    
    protected override OdinMenuTree BuildMenuTree()
    {
        var tree = new OdinMenuTree();

        var scriptFiles = Directory.GetFiles(Path.Combine(Application.dataPath, "Scripts/Systems"), "*.cs", SearchOption.AllDirectories);

        foreach (var filePath in scriptFiles)
        {
            // 파일 이름에서 클래스 이름 추출
            var className = Path.GetFileNameWithoutExtension(filePath);

            if (Type.GetType(className) is { } classType && typeof(ISystem).IsAssignableFrom(classType))
            {
                // 클래스 이름으로 트리에 추가
                tree.AddObjectAtPath(className, Activator.CreateInstance(classType), true);
            }
        }
			
        return tree;
    }
    
}

#endif