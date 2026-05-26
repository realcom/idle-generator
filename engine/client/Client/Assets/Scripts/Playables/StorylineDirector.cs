using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

#if UNITY_EDITOR
using UnityEditor;
#endif

[RequireComponent(typeof(PlayableDirector))]
[ExecuteAlways]
public class StorylineDirector : ZPlayableDirector
{
}

#if UNITY_EDITOR
[CustomEditor(typeof(StorylineDirector))]
public class StorylineDirector_Editor : Editor
{
    public override void SaveChanges()
    {
        base.SaveChanges();
        
        Debug.LogError("SSSSS");
        
        // serializedObject.Update();

        var obj = target as StorylineDirector;
        var timelineAsset = obj.playableAsset as TimelineAsset;

        double totalClipsDuration = 0;
        foreach (var trackAsset in timelineAsset.GetRootTracks())
        {
            foreach (var clip in trackAsset.GetClips())
            {
                totalClipsDuration += clip.duration;
            }
        }
        timelineAsset.durationMode = TimelineAsset.DurationMode.FixedLength;
        timelineAsset.fixedDuration = totalClipsDuration + 1;
        
        // serializedObject.ApplyModifiedProperties();

        // var prefabStage = PrefabStageUtility.GetCurrentPrefabStage();
        // if (modified && prefabStage != null)
        //     EditorSceneManager.MarkSceneDirty(prefabStage.scene);
    }
}
#endif
