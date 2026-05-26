using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using UnityEditor;
using UnityEngine;
using UnityEngine.Timeline;

public class SkillTimelinePostProcessor : AssetPostprocessor
{
    public const string SKILL_TIMELINE_PATH = "Assets/_TimelineAssets/";
    
    private static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
    {
        FixSkillTimelineFrameRate(importedAssets);
    }
    
    [MenuItem("Assets/Fix Skill Timeline Frame Rate")]
    private static void FixSkillTimelineFrameRate()
    {
        FixSkillTimelineFrameRate(Selection.assetGUIDs.Select(AssetDatabase.GUIDToAssetPath));
    }

    private static void FixSkillTimelineFrameRate(IEnumerable<string> paths)
    {    
        foreach (var asset in paths)
        {
            if (!asset.StartsWith(SKILL_TIMELINE_PATH))
                continue;

            var timeline = AssetDatabase.LoadAssetAtPath<TimelineAsset>(asset);
            if (timeline == null)
                continue;
            
            EditorUtility.SetDirty(timeline);

            if (Math.Abs(timeline.editorSettings.frameRate - GameBoard.TicksPerSecond) >= float.Epsilon)
            {
                timeline.editorSettings.frameRate = GameBoard.TicksPerSecond;
            }
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
    
}
