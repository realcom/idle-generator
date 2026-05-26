#if UNITY_EDITOR
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Commons.Game;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Units;
using Google.Protobuf.Collections;
using UnityEditor;
using UnityEditor.Timeline;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace Commons.Resources
{
    
    [Serializable]
    public class SkillWrapper
    {
        public SkillForParser[] skills;
    }
    public partial class ResourceSkill
    {
        public static string SkillMetadataJsonFilePath = Path.Combine(Application.dataPath, "Scripts/Editor/SkillMetadata.json");
        public static string SkillsJsonFilePath = Path.Combine(Application.dataPath, "PatchResources/Skills.json");
        
        public void InjectTimeline(IEnumerable<Types.Timeline> timelines)
        {
            Timelines.Clear();
            Timelines.AddRange(timelines.OrderBy(x => x.Time));
        }
        
        public static SkillWrapper GetSkillMetadata()
        {
            var jsonString = File.ReadAllText(SkillMetadataJsonFilePath);
            var jsonWrapper = JsonUtility.FromJson<SkillWrapper>(jsonString);
            var parsedSkills = Config.JsonParser.Parse<Resources>(jsonString).Skills;

            foreach (var jsonWrapperSkill in jsonWrapper.skills)
            {
                jsonWrapperSkill.timelines =
                    parsedSkills.FirstOrDefault(x => x.Id == jsonWrapperSkill.id)!.Timelines.ToList();
            }

            return jsonWrapper;
        }
    }
}

[Serializable]
public class SkillForParser
{
    public int id;
    public string timelineFileName;

    public List<float> attackPercentDamages;
    
    public List<float> timelineDamage1;
    public List<float> timelineDamage2;
    public List<float> timelineDamage3;
    public List<float> timelineDamage4;
    
    public List<float> attackPercentHeals;
    
    public List<float> timelineHeal1;
    public List<float> timelineHeal2;
    public List<float> timelineHeal3;
    public List<float> timelineHeal4;
    
    public List<float> attackPercentSenderHeals;
    
    public List<float> timelineSenderHeal1;
    public List<float> timelineSenderHeal2;
    public List<float> timelineSenderHeal3;
    public List<float> timelineSenderHeal4;

    public List<ResourceSkill.Types.Timeline> timelines;
}

public static class ResourceSkillTimelineInjector
{
    public const string SKILL_TIMELINE_PATH = "Assets/PatchResources/TimelineAssets/";
    public const string SKILL_TIMELINE_FXSETTINGS_PATH = "Assets/PatchResources/Skills/FxSettings/";

    public static void Inject(TimelineAsset timelineAsset, SkillForParser skillData)
    {
        if (timelineAsset == null)
            return;

        var timelines = new List<ResourceSkill.Types.Timeline>();

        var trackList = timelineAsset.GetOutputTracks().ToList();
        foreach (var track in trackList)
        {
            if (track.muted)
                continue;
            
            var trackIndex = trackList.IndexOf(track);
            
            var clipList = track.GetClips().ToList();
            foreach (var clip in clipList)
            {
                var clipIndex = clipList.IndexOf(clip);
                var clipFxName = $"{timelineAsset.name}'{track.name}'{trackIndex}'{clipIndex}";
                
                var timeline = new ResourceSkill.Types.Timeline
                {
                    Time = (float)Math.Round(clip.start, 3),
                };
                
                var duration = (float)Math.Round(clip.duration, 3);

                switch (clip.asset)
                {
                    case DisableActionClip<DisableMoveBehaviour> disableMoveClip:
                    {
                        timeline.UnitDisableMove = new ResourceSkill.Types.Timeline.Types.UnitDisableMove()
                        {
                            Duration = duration
                        };
                        
                        // DivideClipTimeline(clip, timeline, 1, clonedTimeline => clonedTimeline.UnitDisableMove.Duration = GameBoard.TickDuration);
                        break;
                    }
                    case DisableActionClip<DisableSkillBehaviour> disableSkillClip:
                    {
                        timeline.UnitDisableAction = new ResourceSkill.Types.Timeline.Types.UnitDisableAction()
                        {
                            Duration = duration,
                            Priority = disableSkillClip.template.priority,
                        };
                        break;
                    }
                    case UseSkillClip useSkillClip:
                    {
                        var useSkill = useSkillClip.template.settings.ToUseSkill();
                        switch (useSkillClip.template.useSkillType)
                        {
                            case UseSkillBehaviour.UseSkillType.AddSkill:
                                timeline.AddSkill = new ResourceSkill.Types.Timeline.Types.AddSkill
                                {
                                    UseSkill = useSkill
                                };       
                                break;
                            case UseSkillBehaviour.UseSkillType.UnitUseSkill:
                                timeline.UnitUseSkill = new ResourceSkill.Types.Timeline.Types.UnitUseSkill
                                {
                                    UseSkill = useSkill,
                                };
                                break;
                            case UseSkillBehaviour.UseSkillType.OwnerUseSkill:
                                timeline.OwnerUseSkill = new ResourceSkill.Types.Timeline.Types.OwnerUseSkill
                                {
                                    UseSkill = useSkill,
                                };
                                break;
                            default:
                                throw new ArgumentOutOfRangeException();
                        }
                        break;
                    }
                    case UseBuffClip useBuffClip:
                    {
                        timeline.SelfAddBuff = new ResourceSkill.Types.Timeline.Types.SelfAddBuff
                        {
                            AddBuff = new AddBuff
                            {
                                BuffDataId = useBuffClip.template.buffDataId,
                                Duration = duration <= 0.034f ? 0 : duration,
                            }
                        };
                        break;
                    }
                    case AttackClip attackClip:
                    {
                        var damages = attackClip.template.damage?.name switch
                        {
                            // TODO: find better way to handle this
                            "Skill/TIMELINE_DAMAGE_001" => skillData.timelineDamage1.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_DAMAGE_002" => skillData.timelineDamage2.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_DAMAGE_003" => skillData.timelineDamage3.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_DAMAGE_004" => skillData.timelineDamage4.Select(x => (long)x).ToList(),
                            _ => attackClip.template.damages
                        } ?? attackClip.template.damages;
                        
                        var heals = attackClip.template.heal?.name switch
                        {
                            // TODO: find better way to handle this
                            "Skill/TIMELINE_HEAL_001" => skillData.timelineHeal1.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_HEAL_002" => skillData.timelineHeal2.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_HEAL_003" => skillData.timelineHeal3.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_HEAL_004" => skillData.timelineHeal4.Select(x => (long)x).ToList(),
                            _ => attackClip.template.heals
                        } ?? attackClip.template.heals;

                        var senderHeals = attackClip.template.senderHeal?.name switch
                        {
                            "Skill/TIMELINE_SENDER_HEAL_001" => skillData.timelineSenderHeal1.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_SENDER_HEAL_002" => skillData.timelineSenderHeal2.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_SENDER_HEAL_003" => skillData.timelineSenderHeal3.Select(x => (long)x).ToList(),
                            "Skill/TIMELINE_SENDER_HEAL_004" => skillData.timelineSenderHeal4.Select(x => (long)x).ToList(),
                            _ => attackClip.template.senderHeals
                        } ?? attackClip.template.senderHeals ?? new();

                        var addDamage = damages.Count == 0 && skillData.attackPercentDamages.Count == 0
                            ? null
                            : new AddDamage
                            {
                                AttackPercentDamages = { skillData.attackPercentDamages },
                                Damages = { damages },
                                KnockbackDuration = attackClip.template.knockbackDuration,
                                KnockbackDistance = attackClip.template.knockbackDistance,
                                FxOnKnockback = clipFxName + "'OnKnockbackFx", // TODO: create method
                                DisableMoveDuration = attackClip.template.disableMoveDuration,
                                DisableActionDuration = attackClip.template.disableActionDuration,
                                FxOnHit = clipFxName + "'OnDamageFx", // TODO: create method
                                OnDamageUseSkill = attackClip.template.useOnDamageSkill ? 
                                    attackClip.template.onDamageSkill.ToUseSkill() : null
                            };

                        if (heals == null)
                            heals = new();
                        if (skillData.attackPercentHeals == null)
                            skillData.attackPercentHeals = new();
                        var addHeal = heals.Count == 0 && skillData.attackPercentHeals.Count == 0
                            ? null
                            : new AddHeal
                            {
                                Heals = { heals },
                                AttackPercentHeals = { skillData.attackPercentHeals },
                                FxOnHit = clipFxName + "'OnHealFx",
                                OnHealUseSkill = attackClip.template.useOnHealSkill ? 
                                    attackClip.template.onHealSkill.ToUseSkill() : null
                            };
                        
                        skillData.attackPercentSenderHeals ??= new();
                        var addSenderHeal = senderHeals.Count == 0 && skillData.attackPercentSenderHeals.Count == 0
                            ? null
                            : new AddHeal()
                            {
                                Heals = { senderHeals },
                                AttackPercentHeals = { skillData.attackPercentSenderHeals },
                                FxOnHit = clipFxName + "'OnSenderHealFx",
                                OnHealUseSkill = attackClip.template.useOnSenderHealSkill ? 
                                    attackClip.template.onSenderHealSkill.ToUseSkill() : null
                            };

                        var ontHitSkill = attackClip.template.useOnHitSkill ? 
                            attackClip.template.onHitSkill.ToUseSkill() : null;
                        
                        if (attackClip.template.onHitAddBuffs == null)
                            attackClip.template.onHitAddBuffs = new();
                        var addBuffs = attackClip.template.onHitAddBuffs.Select(x => new AddBuff
                        {
                            BuffDataId = x.buffDataId,
                            Duration = x.duration,
                        });
                        
                        //
                        timeline.Hit = new ResourceSkill.Types.Timeline.Types.Hit
                        {
                            Geometries = { attackClip.template.geometries.Select(x =>  x.GetConvertedGeometry(Mathf.Deg2Rad).ToGeometryMessage() ) },
                            AddDamage = addDamage,
                            AddHeal = addHeal,
                            SenderAddHeal = addSenderHeal,
                            HitAlly = attackClip.template.hitAlly,
                            IgnoreSender = attackClip.template.ignoreSender,
                            MaxHit = attackClip.template.maxHitPerTick,
                            UseSkill = ontHitSkill,
                            AddBuffs = { addBuffs },
                        };
                        
                        // 쪼개기
                        // TODO: better to use clip's attributes
                        DivideClipTimeline(clip, timeline, attackClip.template.hitInterval);
                        
                        break;
                    }
                    case AddForceClip addForceClip:
                    {
                        var angle =  Quaternion.LookRotation(addForceClip.template.direction).eulerAngles.z;
                        timeline.UnitCharge = new ResourceSkill.Types.Timeline.Types.UnitCharge()
                        {
                            Angle = -angle * Mathf.Deg2Rad, // due to inverted axis on commons 2d rotation, angle should be inverted too
                            Duration = duration,
                            Distance = addForceClip.template.distance,
                            AdjustDistanceToTarget = addForceClip.template.adjustDistanceToTarget,
                        };
                        break;
                    }
                    case PlayAnimationClip animationClip:
                    {
                        timeline.UnitPlayAnimation = new ResourceSkill.Types.Timeline.Types.UnitPlayAnimation()
                        {
                            Animation = animationClip.template.animationName.ToString(),
                        };
                        break;
                    }
                    case AudioPlayableAsset audioPlayableAsset:
                    {
                        timeline.PlayFx = new ResourceSkill.Types.Timeline.Types.PlayFx()
                        {
                            Prefab = clipFxName
                        };
                        
                        break;
                    }
                    case PlayTriggerClip playTriggerClip:
                    {
                        if (playTriggerClip.template.trigger.trigger != null)
                        {
                            timeline.RunTrigger = new ResourceSkill.Types.Timeline.Types.RunTrigger()
                            {
                                Name = playTriggerClip.template.trigger.trigger
                            };
                        }
                        
                        break;
                    }
                    case TimeScaleFxClip timeScaleFxClip:
                    {
                        if (timeScaleFxClip.template.timeScaleFxSettingsProperties != null)
                        {
                            timeline.SetUpdateSpeed = new ResourceSkill.Types.Timeline.Types.SetUpdateSpeed()
                            {
                                BoardSpeed = timeScaleFxClip.template.timeScaleFxSettingsProperties.boardSpeed,
                                EditorSpeed = timeScaleFxClip.template.timeScaleFxSettingsProperties.editorSpeed,
                                Duration = duration,
                            };
                        }
                        
                        break;
                    }
                    case IFxClip fxClip:
                    {
                        timeline.PlayFx = new ResourceSkill.Types.Timeline.Types.PlayFx()
                        {
                            Prefab = clipFxName
                        };
                        
                        break;
                    }
                    default:
                        continue;
                }
                
                timelines.Add(timeline);
            }
        }

        // if (timelines.Count == 0)
        // {
        //     //EditorUtility.DisplayDialog("Error", "끼아아악 타임라인은 비어있을 수 없습니다!!!!", "확인");
        //     return;
        // }
        
        timelines.Add(new ResourceSkill.Types.Timeline()
        {
            Time = (float)Math.Round(timelineAsset.duration, 3),
            Destroy = new ResourceSkill.Types.Timeline.Types.Destroy()
        });
        
        // InjectFxSettings(timelineAsset); 무결성 전제

        var resourceSkill = ResourceSkill.GetEditor(skillData.id);
        resourceSkill?.InjectTimeline(timelines);
        
        // ResourceSkill.SaveEditor(); 벌크로 처리
        
        Debug.Log($"Injected Timeline Data for skill id: {skillData.id} ({resourceSkill.Name}), asset: {timelineAsset.name}");
        
        void DivideClipTimeline(TimelineClip attackClip, ResourceSkill.Types.Timeline timeline, uint intervalInTick, Action<ResourceSkill.Types.Timeline> postDivision = null)
        {
            var durationInTick = GameBoard.TimeToTicks((float)attackClip.duration);
            var divisionCount = intervalInTick == 0 ? 1 : (uint)((float)(durationInTick - 1) / intervalInTick);

            if (divisionCount > 1)
            {
                // for (var i = 1; i < divisionCount; i++)
                // { 
                //     var additionalTimeline = timeline.Clone();
                //     postDivision?.Invoke(additionalTimeline);
                //     additionalTimeline.Time = (float)clip.start + (float)intervalInTick * i * GameBoard.TickDuration;
                //     timelines.Add(additionalTimeline);
                // }
                timeline.Hit.Repeat = (int)divisionCount;
                timeline.Hit.RepeatInterval = intervalInTick * GameBoard.TickDuration;
            }
        }
    }

    public static void InjectFxSettings(TimelineAsset timelineAsset)
    {
        if (timelineAsset == null)
            return;

        if (!AssetDatabase.GetAssetPath(timelineAsset).Contains("PatchResources/TimelineAssets"))
            return;

        var fxSettings = new Dictionary<string, FxSettings>();

        var trackList = timelineAsset.GetOutputTracks().ToList();
        // var animationTrackCount = 0;
        foreach (var track in trackList)
        {
            if (track.muted)
                continue;
            
            // if (track is AnimationTrack)
                // animationTrackCount++;

            var trackIndex = trackList.IndexOf(track);

            var clipList = track.GetClips().ToList();
            foreach (var clip in clipList)
            {
                if (clip.GetParentTrack().GetType() != track.GetType())
                    continue;
                
                var clipIndex = clipList.IndexOf(clip);
                var clipFxName = $"{timelineAsset.name}'{track.name}'{trackIndex}'{clipIndex}";

                var duration = (float)clip.duration;

                switch (clip.asset)
                {
                    case AttackClip attackClip:
                    {
                        RefreshFxSettings(clipFxName+"'OnKnockbackFx", ref attackClip.template.onKnockbackFxSettings, ref fxSettings);
                        RefreshFxSettings(clipFxName+"'OnDamageFx", ref attackClip.template.onDamageFxSettings, ref fxSettings);
                        RefreshFxSettings(clipFxName+"'OnHealFx", ref attackClip.template.onHealFxSettings, ref fxSettings);
                        RefreshFxSettings(clipFxName+"'OnSenderHealFx", ref attackClip.template.onSenderHealFxSettings, ref fxSettings);

                        break;
                    }
                    case AudioPlayableAsset audioPlayableAsset:
                    {
                        AudioFxSettings blankSettings = null;
                        RefreshFxSettings(clipFxName, ref blankSettings, ref fxSettings);

                        var newSettings = fxSettings[clipFxName] as AudioFxSettings;
                        newSettings.audioFxSettingsProperties.audioClip = audioPlayableAsset.clip;

                        break;
                    }
                    case IFxClip fxClip:
                    {
                        fxClip.RefreshFxSettings(clipFxName, clip, ref fxSettings);

                        break;
                    }
                    default:
                        continue;
                }
            }
        }
        
        // if (animationTrackCount > 1)
            // EditorUtility.DisplayDialog("Error", $"{timelineAsset.name}: 타임라인에 애니메이션 트랙이 2개 이상 있습니다. 애니메이션 트랙은 1개만 있어야 합니다.", "확인");

        SaveFxSettings(timelineAsset.name, ref fxSettings);

        Debug.Log("Saved FxSettings for " + timelineAsset.name);
    }
    
    private static void RefreshFxSettings<T>(string clipFxName, ref T clipFxSettings, ref Dictionary<string, FxSettings> settingsList) where T : FxSettings
    {
        T newFxSettings;

        if (clipFxSettings == null)
        {
            newFxSettings = ScriptableObject.CreateInstance<T>();
            clipFxSettings = newFxSettings;
        }
        else if (clipFxSettings.name != clipFxName)
        {
            newFxSettings = ScriptableObject.CreateInstance<T>();
            FxSettings.CopyValuesWithName(clipFxSettings, newFxSettings, clipFxName);
            clipFxSettings = newFxSettings;
        }
        else
            newFxSettings = clipFxSettings;

        // newFxSettings.MigrateValuesToProperties();
        
        settingsList[clipFxName] = newFxSettings;
    }

    private static void SaveFxSettings(string timelineName, ref Dictionary<string, FxSettings> settingsList)
    {
        var path = SKILL_TIMELINE_FXSETTINGS_PATH + $"{timelineName}/";
        var directoryPath = Path.GetDirectoryName(path);

        if (settingsList.Count > 0)
            ClearOrCreateFolder(directoryPath, settingsList.Keys.ToList());
        
        foreach (var fx in settingsList)
        {
            var fileFullPath = Path.Combine(directoryPath, $"{fx.Key}.asset");
            var existingObject = (FxSettings)AssetDatabase.LoadAssetAtPath(fileFullPath, typeof(FxSettings));
            if (existingObject == null)
            {
                AssetDatabase.CreateAsset(fx.Value, fileFullPath);
                EditorUtility.SetDirty(fx.Value);
            }
            else if (existingObject.GetHashCode() != fx.Value.GetHashCode())
            {
                AssetDatabase.DeleteAsset(fileFullPath);
                AssetDatabase.CreateAsset(fx.Value, fileFullPath);
                EditorUtility.SetDirty(fx.Value);
            }
            else
            {
                FxSettings.CopyValuesWithName(fx.Value, existingObject, existingObject.name);
                EditorUtility.SetDirty(existingObject);
            }
        }
        
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
    
    private static void ClearOrCreateFolder(string directoryPath, ICollection<string> fileNames)
    {
        if (Directory.Exists(directoryPath))
        {
            var files = Directory.GetFiles(directoryPath);
            foreach (var file in files)
            {
                if (file.EndsWith(".meta"))
                    continue;
                if (!fileNames.Contains(Path.GetFileNameWithoutExtension(file)))
                {
                    Debug.Log("Deleting unreferenced Fx Setting file:  " + file);
                    AssetDatabase.DeleteAsset(file);
                }
            }

            AssetDatabase.Refresh();
        }
        else
        {
            Directory.CreateDirectory(directoryPath);
        }
    }
    
    private sealed class TimeLinePostProcessor : AssetPostprocessor
    {
        private static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
        {
            foreach (var asset in importedAssets)
            {
                if (!asset.StartsWith(SKILL_TIMELINE_PATH))
                    continue;
    
                var timeline = AssetDatabase.LoadAssetAtPath<TimelineAsset>(asset);
                if (timeline == null)
                    continue;
                if (timeline == TimelineEditor.inspectedAsset)
                    InjectFxSettings(timeline);
            }
        }
    }
}

[InitializeOnLoad]
public static class TimeLineInjectionHelper
{
    static TimeLineInjectionHelper()
    {
        Selection.selectionChanged += OnSelectionChanged;
        EditorApplication.update += OnEditorUpdate;
    }

    public static TimelineAsset lastSelectedTimelineAsset;
    private static void OnSelectionChanged()
    {
        if (Selection.activeObject is TimelineAsset selectedTimeline)
        {
            if (lastSelectedTimelineAsset != null && lastSelectedTimelineAsset != selectedTimeline)
            {
                // update when timeline is deselected
                ResourceSkillTimelineInjector.InjectFxSettings(lastSelectedTimelineAsset);
            }

            lastSelectedTimelineAsset = selectedTimeline;
        }
        else if (lastSelectedTimelineAsset != null)
        {
            // update when timeline is deselected
            ResourceSkillTimelineInjector.InjectFxSettings(lastSelectedTimelineAsset);
            lastSelectedTimelineAsset = null;
        }
    }

    private static TimelineAsset _lastTimelineAsset;
    private static TimelineClip _lastTimelineClip;
    private static int _lastClipCount = 0;

    private static void OnEditorUpdate()
    {
        if (TimelineEditor.inspectedAsset != _lastTimelineAsset)
        {
            // New Timeline selected
            _lastTimelineAsset = TimelineEditor.inspectedAsset;
            
            if (_lastTimelineAsset != null)
            {
                _lastClipCount = GetClipCount(_lastTimelineAsset);
            }
        }
        else if (_lastTimelineAsset != null)
        {
            // Check for changes in the clip count
            var currentClipCount = GetClipCount(_lastTimelineAsset);
            if (currentClipCount != _lastClipCount && TimelineEditor.selectedClip != _lastTimelineClip)
            {
                ResourceSkillTimelineInjector.InjectFxSettings(_lastTimelineAsset);
                _lastClipCount = currentClipCount;
            }
            _lastTimelineClip = TimelineEditor.selectedClip;
        }
    }

    private static int GetClipCount(TimelineAsset timeline)
    {
        var count = 0;
        if (timeline != null)
        {
            foreach (var track in timeline.GetOutputTracks())
            {
                count += track.GetClips().Count();
            }
        }
        return count;
    }
}
#endif
