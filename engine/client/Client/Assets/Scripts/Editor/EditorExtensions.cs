using System;
using Commons.Types;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine.Rendering;
using UnityEngine.Timeline;

public class RemoveAnimationEvents : EditorWindow
{
    [MenuItem("Assets/Remove Events")]
    static void RemoveEvents()
    {
        foreach (var guid in Selection.assetGUIDs)
        {
            var assetPath = AssetDatabase.GUIDToAssetPath(guid);
            var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(assetPath);

            if (clip == null)
                continue;
            
            AnimationUtility.SetAnimationEvents(clip, Array.Empty<AnimationEvent>());
            EditorUtility.SetDirty(clip);
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }  
    
    [MenuItem("Assets/Migrate UseSkillClip")]
    static void MigrateUseSkilClip()
    {
        foreach (var guid in Selection.assetGUIDs)
        {
            var assetPath = AssetDatabase.GUIDToAssetPath(guid);
            var timelineAsset = AssetDatabase.LoadAssetAtPath<TimelineAsset>(assetPath);

            if (timelineAsset == null)
                continue;
            
            foreach (var outputTrack in timelineAsset.GetOutputTracks())
            {
                foreach (var timelineClip in outputTrack.GetClips())
                {
                    if (timelineClip.asset is UseSkillClip clip)
                    {
                        //clip.template.settings = new AttackBehaviour.UseSkillSettings()
                        //{
                        //    skillID = clip.template.skillDataId
                        //};
                    }
                }
            }
            
            EditorUtility.SetDirty(timelineAsset);
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
    
    [MenuItem("Assets/Unit Material To AllIn1 Material")]
    static void FitMaterial()
    {
        var parent = AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath("2f32a541898365a459d976b5289b1ced"));
        
        foreach (var guid in Selection.assetGUIDs)
        {
            var assetPath = AssetDatabase.GUIDToAssetPath(guid);
            var asset = AssetDatabase.LoadAssetAtPath<Material>(assetPath);

            if (asset == null)
                continue;

            var texture = asset.mainTexture;
            
            asset.parent = parent;
            asset.RevertAllPropertyOverrides();
            asset.CopyPropertiesFromMaterial(parent);
            asset.mainTexture = texture;
            
            FitMaterialOption(asset);
            
            EditorUtility.SetDirty(asset);
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    [MenuItem("Assets/Fit Unit Material Options")]
    static void FitMaterialOptions()
    {
        var parent = AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath("2f32a541898365a459d976b5289b1ced"));
        
        foreach (var guid in Selection.assetGUIDs)
        {
            var assetPath = AssetDatabase.GUIDToAssetPath(guid);
            var asset = AssetDatabase.LoadAssetAtPath<Material>(assetPath);

            if (asset == null)
                continue;
            
            FitMaterialOption(asset);
            
            EditorUtility.SetDirty(asset);
        }
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    static void FitMaterialOption(Material material)
    {
        material.SetFloat("_MySrcMode", (float)BlendMode.One);
        material.SetFloat("_MyDstMode", (float)BlendMode.OneMinusSrcAlpha);
        material.DisableKeyword("PREMULTIPLYALPHA_ON");
    }
    
}