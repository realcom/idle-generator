using System;
using System.Linq;
using Sirenix.Utilities;
using UnityEditor;
using UnityEditor.AI;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Timeline;

[InitializeOnLoad]
public class EditorEventListener
{
    static EditorEventListener()
    {
        PrefabStage.prefabStageOpened += OnPrefabStageOpened;

        PrefabStage.prefabSaving += OnSaving;
        
        PrefabStage.prefabSaved += OnSaved;
        PrefabStage.prefabSaved += LoggingLegacyMaker;
        
        EditorSceneManager.sceneSaving += OnSceneSaving;
        EditorSceneManager.sceneSaved += OnSceneSaved;
    }

    // 프리팹 스테이지가 열릴 때 호출될 메소드
    private static void OnPrefabStageOpened(PrefabStage stage)
    {
        var obj = stage.prefabContentsRoot;
        if (obj == null)
            return;
        
        LoggingLegacyMaker(obj);
        
        obj.GetComponentsInChildren<ZMonoBehaviour>().ForEach(behaviour => behaviour.OnPrefabStageOpened(obj));
        PrefabUtility.SavePrefabAsset(AssetDatabase.LoadAssetAtPath<GameObject>(stage.assetPath));
        AssetDatabase.SaveAssets();
    }

    private static void LoggingLegacyMaker(GameObject obj)
    {
        if (obj == null)
            return;
        
        foreach (var (component, attribute) in obj.GetComponentsViaAttribute<LegacyMarkerAttribute>())
        {
            Debug.LogError($"{component.GetType().Name}::{component.name} is marked as legacy.\nDescription: {attribute.Description}");
        }
    }

    private static void OnSaving(GameObject obj)
    {
        if (obj == null)
            return;

        obj.GetComponentsInChildren<ZMonoBehaviour>().ForEach(behaviour => behaviour.OnSaving(obj));
    }

    private static void OnSaved(GameObject obj)
    {
        if (obj == null)
            return;

        var path = AssetDatabase.GetAssetPath(obj);
        
        obj.GetComponentsInChildren<ZMonoBehaviour>().ForEach(behaviour => behaviour.OnSaved(obj));
    }
    
    private static void OnSceneSaving(Scene scene, string path)
    {
        if (!scene.IsValid())
            return;

        foreach (var obj in scene.GetRootGameObjects())
        {
            if (EditorUtility.IsDirty(obj))
            {
                obj.GetComponentsInChildren<ZMonoBehaviour>().ForEach(behaviour => behaviour.OnSaving(obj));
            }
        }
    }
    
    private static void OnSceneSaved(Scene scene)
    {
        BakeMap();
        
        void BakeMap()
        {
            if (!scene.path.Contains("Maps"))
                return;
            
            //BakeOcclusionCulling();
            //BakeNavMesh()
            //BakeMinimap();
            // BakeMapTerrainAndLocation();

            void BakeOcclusionCulling()
            {        
                if (!StaticOcclusionCulling.isRunning)
                {
                    Debug.Log("오클루전 컬링 데이터 베이킹 시작...");
                    StaticOcclusionCulling.GenerateInBackground();
                }
                else
                {
                    Debug.Log("오클루전 컬링 데이터가 이미 베이킹 중입니다...");
                }
            }
            
            void BakeNavMesh()
            {
                Debug.Log("NavMesh 베이킹 시작...");
                NavMeshBuilder.BuildNavMesh();
            }

            void BakeMinimap()
            {
                Debug.Log("미니맵 추출 시작...");
                Extensions.ExportCurrentSceneMinimap();
            }
            
            void BakeMapTerrainAndLocation()
            {
                Debug.Log("Terrain & Location 추출 시작...");
                Extensions.ExportCurrentSceneTerrainLocation();
            }
        }
    }

    public class EditorAssetPostProcessor : AssetPostprocessor
    {
        private static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
        {
            foreach (var asset in importedAssets)
            {
                if (string.IsNullOrEmpty(asset))
                    continue;
                
                OnSaveTimelineAsset(asset);
            }
        }

        private static void OnSaveTimelineAsset(string assetPath)
        {
            if (!assetPath.Contains(".playable"))
                return;

            OnSaveStorylineAsset(assetPath);
        }

        private static void OnSaveStorylineAsset(string assetPath)
        {
            if (!assetPath.Contains("Storyline"))
                return;

            var timelineAsset = AssetDatabase.LoadAssetAtPath<TimelineAsset>(assetPath);
            
            var max = 0d;
            foreach (var trackAsset in timelineAsset.GetRootTracks())
            {
                foreach (var clip in trackAsset.GetClips())
                {
                    max = Math.Max(clip.end, max);
                }
            }

            timelineAsset.durationMode = TimelineAsset.DurationMode.FixedLength;
            timelineAsset.fixedDuration = max + 0.1;
        }
    }
}