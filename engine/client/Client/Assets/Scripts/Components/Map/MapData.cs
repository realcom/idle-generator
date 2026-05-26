using System;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "MapData", menuName = "MapData/MapData", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Boxed)]
public class MapData : SerializedScriptableObject
{
    public enum BackgroundType2
    {
        Sky,
        Ground,
        Object,
    }
    
    [Title("Border Settings")]
    public Vector2 boundsOffset;
    public Vector2 boundsSize;
    
    [ReadOnly]
    public Vector2 boundsMin;
    [ReadOnly]
    public Vector2 boundsMax;

    public void CalculatePostData()
    {
        boundsMin = boundsOffset - boundsSize / 2f;
        boundsMax = boundsOffset + boundsSize / 2f;
    }
    
    [Title("Background Settings")]
    public Dictionary<BackgroundType2, Sprite> sprites = new();
    public bool isScrollable;
}