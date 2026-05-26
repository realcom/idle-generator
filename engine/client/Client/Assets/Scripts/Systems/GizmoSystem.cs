using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

public class GizmoSystem : BaseSystem<GizmoSystem>
{
#if UNITY_EDITOR
    [InitializeOnLoadMethod]
    private static void Initialize()
    {
        seeUnitHitSize = LoadBool(nameof(seeUnitHitSize), seeUnitHitSize);
        seeUnitCollideSize = LoadBool(nameof(seeUnitCollideSize), seeUnitCollideSize);
        seeUnitDropItemPickUpSize = LoadBool(nameof(seeUnitDropItemPickUpSize), seeUnitDropItemPickUpSize);
        seeUnitTargetAwareDistance = LoadBool(nameof(seeUnitTargetAwareDistance), seeUnitTargetAwareDistance);
        seeUnitOffsets = LoadBool(nameof(seeUnitOffsets), seeUnitOffsets);
        seeSpawner = LoadBool(nameof(seeSpawner), seeSpawner);
        seeTerrain = LoadBool(nameof(seeTerrain), seeTerrain);
        fillEnabledTerrain = LoadBool(nameof(fillEnabledTerrain), fillEnabledTerrain);
        
        unitHitSizeColor = LoadColor(nameof(unitHitSizeColor), unitHitSizeColor);
        unitCollideSizeColor = LoadColor(nameof(unitCollideSizeColor), unitCollideSizeColor);
        unitDropItemPickUpSizeColor = LoadColor(nameof(unitDropItemPickUpSizeColor), unitDropItemPickUpSizeColor);
        unitTargetAwareDistanceColor = LoadColor(nameof(unitTargetAwareDistanceColor), unitTargetAwareDistanceColor);
        spawnerColor = LoadColor(nameof(spawnerColor), spawnerColor);
        terrainColor = LoadColor(nameof(terrainColor), terrainColor);
    }
    
    // Gizmo Enable Settings
    [Title("Unit Gizmos")]
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeUnitHitSize")]
    public static bool seeUnitHitSize = false;
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeUnitCollideSize")]
    public static bool seeUnitCollideSize = false;
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeUnitDropItemPickUpSize")]
    public static bool seeUnitDropItemPickUpSize = false;
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeUnitTargetAwareDistance")]
    public static bool seeUnitTargetAwareDistance = false;
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeUnitOffsets")]
    public static bool seeUnitOffsets = false;
    
    [Title("Spawner Gizmos")]
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeSpawner")]
    public static bool seeSpawner = false;
    
    [Title("Terrain Gizmos")]
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_seeTerrain")]
    public static bool seeTerrain = false;
    [TabGroup("Enable Settings"), ShowInInspector, OnValueChanged("OnValueChanged_fillEnabledTerrain")]
    public static bool fillEnabledTerrain = false;
    [TabGroup("Enable Settings"), ShowInInspector, ShowIf(nameof(fillEnabledTerrain))]
    public static List<int> editorDisabledTriangles = new ();
    
    // Gizmo Colors
    [Title("Unit Gizmos")]
    [TabGroup("Color Settings"), ShowInInspector, ColorPalette, OnValueChanged("OnValueChanged_unitHitSizeGizmoColor")]
    public static Color unitHitSizeColor = Color.cyan;
    [TabGroup("Color Settings"), ShowInInspector, ColorPalette, OnValueChanged("OnValueChanged_unitCollideSizeGizmoColor")]
    public static Color unitCollideSizeColor = Color.blue;
    [TabGroup("Color Settings"), ShowInInspector, ColorPalette, OnValueChanged("OnValueChanged_unitDropItemPickUpSizeGizmoColor")]
    public static Color unitDropItemPickUpSizeColor = Color.green;
    [TabGroup("Color Settings"), ShowInInspector, ColorPalette, OnValueChanged("OnValueChanged_unitTargetAwareDistanceGizmoColor")]
    public static Color unitTargetAwareDistanceColor = Color.yellow;
    
    [Title("Spawner Gizmos")]
    [TabGroup("Color Settings"), ShowInInspector, ColorPalette, OnValueChanged("OnValueChanged_spawnerColor")]
    public static Color spawnerColor = Color.red;
    
    [Title("Terrain Gizmos")]
    [TabGroup("Color Settings"), ShowInInspector, ColorPalette, OnValueChanged("OnValueChanged_terrainColor")]
    public static Color terrainColor = Color.gray;
    
    //
    private static void OnValueChanged_seeUnitHitSize() => SaveBool(nameof(seeUnitHitSize), seeUnitHitSize);
    private static void OnValueChanged_seeUnitCollideSize() => SaveBool(nameof(seeUnitCollideSize), seeUnitCollideSize);
    private static void OnValueChanged_seeUnitDropItemPickUpSize() => SaveBool(nameof(seeUnitDropItemPickUpSize), seeUnitDropItemPickUpSize);
    private static void OnValueChanged_seeUnitTargetAwareDistance() => SaveBool(nameof(seeUnitTargetAwareDistance), seeUnitTargetAwareDistance);
    private static void OnValueChanged_seeUnitOffsets() => SaveBool(nameof(seeUnitOffsets), seeUnitOffsets);
    private static void OnValueChanged_seeSpawner() => SaveBool(nameof(seeSpawner), seeSpawner);
    private static void OnValueChanged_seeTerrain() => SaveBool(nameof(seeTerrain), seeTerrain);
    private static void OnValueChanged_fillEnabledTerrain() => SaveBool(nameof(fillEnabledTerrain), fillEnabledTerrain);

    //
    private static void OnValueChanged_unitHitSizeGizmoColor() => SaveColor(nameof(unitHitSizeColor), unitHitSizeColor);
    private static void OnValueChanged_unitCollideSizeGizmoColor() => SaveColor(nameof(unitCollideSizeColor), unitCollideSizeColor);
    private static void OnValueChanged_unitDropItemPickUpSizeGizmoColor() => SaveColor(nameof(unitDropItemPickUpSizeColor), unitDropItemPickUpSizeColor);
    private static void OnValueChanged_unitTargetAwareDistanceGizmoColor() => SaveColor(nameof(unitTargetAwareDistanceColor), unitTargetAwareDistanceColor);
    private static void OnValueChanged_spawnerColor() => SaveColor(nameof(spawnerColor), spawnerColor);
    private static void OnValueChanged_terrainColor() => SaveColor(nameof(terrainColor), terrainColor);
#endif
}
