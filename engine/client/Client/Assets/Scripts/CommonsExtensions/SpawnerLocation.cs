using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Geometry;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;

#if UNITY_EDITOR
using System.Collections;
using UnityEditor;
#endif

public class SpawnerLocation : SerializedMonoBehaviour
{
    public bool usePredefinedIndex;
    
    [ShowIf(nameof(usePredefinedIndex))]
    public PredefinedLocationId predefinedIndex;

    [ShowIf("@usePredefinedIndex == true && predefinedIndex.name == \"Player\""),
     ValueDropdown("GetPlayerIndexKeys", DropdownTitle = "Select Key", OnlyChangeValueOnConfirm = true),
     OnValueChanged("OnValueChanged_PlayerIndex")]
    public string playerIndexKey = playerDefault;
    
    private const string playerDefault = "Default";
    
    [HideIf(nameof(usePredefinedIndex))]
    public KeyLocationId spawnerIndex;

    [OdinSerialize] public List<IGeometry> Geometries = new()
    {
        new Circle(new Vector2(0f, 0f), 1f),
    };
    
#if UNITY_EDITOR

    private IEnumerable GetPlayerIndexKeys()
    {
        var list = new List<string> { playerDefault };
        list.AddRange(Enumerable.Range(1, Mathf.Abs(ResourceMap.LocationId.PlayerMax) - Mathf.Abs(ResourceMap.LocationId.Player1)).Select(x => $"Player{x}"));
        list.AddRange(Enumerable.Range(1, Mathf.Abs(ResourceMap.LocationId.OffenseMax) - Mathf.Abs(ResourceMap.LocationId.Offense1)).Select(x => $"PlayerOffense{x}"));
        list.AddRange(Enumerable.Range(1, Mathf.Abs(ResourceMap.LocationId.DefenseMax) - Mathf.Abs(ResourceMap.LocationId.Defense1)).Select(x => $"PlayerDefense{x}"));
        return list;
    }
    
    private void OnValueChanged_PlayerIndex()
    {
        if (playerIndexKey == playerDefault)
            predefinedIndex.key = ResourceMap.LocationId.Player;
        else
        {
            if (playerIndexKey.Contains("Offense"))
                predefinedIndex.key = -int.Parse(playerIndexKey.Replace("PlayerOffense", "")) + ResourceMap.LocationId.Offense0;
            else if (playerIndexKey.Contains("Defense"))
                predefinedIndex.key = -int.Parse(playerIndexKey.Replace("PlayerDefense", "")) + ResourceMap.LocationId.Defense0;
            else
                predefinedIndex.key = -int.Parse(playerIndexKey.Replace("Player", "")) + ResourceMap.LocationId.Player0;
        }
    }

    public bool IsValidSpawnLocation()
    {
        // TODO: validate spawn location (update after EditorStringKey is implemented)
        return Geometries.Where(x => x != null).ToList().Count > 0;
    }

    public ResourceMap.Types.Location GetLocation()
    {
        var location = new ResourceMap.Types.Location();
        location.Id = usePredefinedIndex ? predefinedIndex : spawnerIndex;
        location.Position = new Vector2Message();
        location.Position.Set(transform.position.XZ());
        location.Geometries.AddRange(Geometries.Where(x => x != null).Select(x => x.GetConvertedGeometry(Mathf.Deg2Rad).ToGeometryMessage()));

        return location;
    }
    
    // private void OnDrawGizmos()
    // {
    //     if (GizmoSystem.seeSpawner)
    //     {
    //         foreach (var geometry in Geometries)
    //         {
    //             if (geometry != null)
    //                 transform.DrawGeometryGizmo(geometry, color: GizmoSystem.spawnerColor);
    //         }
    //         var textStyle = new GUIStyle(EditorStyles.textField);
    //         textStyle.normal.textColor = Color.white;
    //
    //         string index = usePredefinedIndex ? predefinedIndex : spawnerIndex;
    //         Handles.Label(transform.position, $"Spawner {index}", textStyle);
    //     }
    // }
    
    private void OnDrawGizmosSelected()
    {
        foreach (var geometry in Geometries)
        {
            if (geometry != null)
                transform.DrawGeometryGizmo(geometry, color: Color.red);
            
            var textStyle = new GUIStyle(EditorStyles.textField);
            textStyle.normal.textColor = Color.white;
            
            string index = usePredefinedIndex ? predefinedIndex : spawnerIndex;
            Handles.Label(transform.position, $"Spawner {index}", textStyle);
        }
    }
#endif
}