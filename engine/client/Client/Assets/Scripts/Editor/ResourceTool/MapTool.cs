using System;
using System.IO;
using Commons.Resources;
using UnityEditor;
using UnityEngine;

[Serializable]
public class MapForParser
{
    public string scene;
}

[Serializable]
public class MapWrapper
{
    public MapForParser[] maps;
}

public class MapTool : ResourceParseTool<ResourceMap>
{

    private string MapsJsonFilePath = Path.Combine(Application.dataPath, "PatchResources/Maps.json");

    public override void PostRetrievalProcess()
    {
        string jsonString = File.ReadAllText(MapsJsonFilePath);
        MapWrapper mapsData = JsonUtility.FromJson<MapWrapper>(jsonString);
        
        Extensions.ExportSceneTerrainLocationWithPath($"Assets/PatchResources/Maps/MAP_MAKING_SCENE.unity");

        // foreach (MapForParser map in mapsData.maps)
        // {
            // if (string.IsNullOrEmpty(map.scene))
                // continue;
            // Extensions.ExportSceneTerrainLocationWithPath($"Assets/PatchResources/Maps/{map.scene}.unity");
        // }
    }
}