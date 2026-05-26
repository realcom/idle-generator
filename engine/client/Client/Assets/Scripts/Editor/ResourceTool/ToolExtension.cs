#if UNITY_EDITOR
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Commons.Resources;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

public static class ToolExtension
{
    public const string PATCH_RESOURCE_PREFIX_PATH = "Assets/Resources/";
    
    public static GameObject ToPrefab(string prefabPath)
    {
        return AssetDatabase.LoadAssetAtPath<GameObject>(Path.Combine(PATCH_RESOURCE_PREFIX_PATH, prefabPath));
    }

    public static string ToPatchResourcePath(GameObject prefab)
    {
        return AssetDatabase.GetAssetPath(prefab).Replace(PATCH_RESOURCE_PREFIX_PATH, "");
    }
    
}

#endif