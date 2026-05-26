using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Commons.Resources;
using Google.Protobuf;
using UnityEditor;
using UnityEngine;
using UnityEngine.Timeline;
using Newtonsoft.Json.Linq;
using Sirenix.OdinInspector;
using Debug = UnityEngine.Debug;

public class SkillTool : ResourceParseTool<ResourceSkill>
{
    // [HorizontalGroup("Group 4", Width = 400)]
    // [Title("개별 스킬 ID")]
    // [VerticalGroup("Group 4/Group4-1")]
    // public int skillId;
    
    // [VerticalGroup("Group 4/Group4-1")]
    // [Button("지정 스킬 타임라인 추출", ButtonHeight = 50)]
    // private void InjectSelectedSkill()
    // {
    //     var skillsMetadata = ResourceSkill.GetSkillMetadata();
    //
    //     if (skillsMetadata == null)
    //     {
    //         Debug.LogError("스킬 메타데이터가 없습니다.");
    //         ResourceEditToolParser.Parse<ResourceSkill>();
    //         RemoveTimelineFileNameFromJson();
    //         return;
    //     }
    //
    //     var selectedSkill = skillsMetadata.skills.FirstOrDefault(x => x.id == skillId);
    //
    //     if (selectedSkill == null)
    //     {
    //         Debug.LogError("해당 ID의 스킬이 없습니다.");
    //         return;
    //     }
    //     
    //     ResourceSkill.ReloadEditor();
    //     var allAssets = AssetDatabase.GetAllAssetPaths();
    //     InjectTimelineForSkill(selectedSkill, allAssets, true);
    //     
    //     UpdateMetadata();
    // }

    private int loadCount;
    public override void PostRetrievalProcess()
    {
        var jsonString = File.ReadAllText(ResourceSkill.SkillsJsonFilePath);
        var skillsData = JsonUtility.FromJson<SkillWrapper>(jsonString);
        
        // RemoveTimelineFileNameFromJson();
        ResourceSkill.ReloadEditor();
        
        Debug.Log("스킬 데이터 시트 파싱 완료!");
        
        //
        // Build a dictionary for asset paths
        var timelineAssetPaths = AssetDatabase.GetAllAssetPaths()
            .Where(path => path.StartsWith("Assets/PatchResources/TimelineAssets/"))
            .ToDictionary(
                Path.GetFileNameWithoutExtension,
                path => path
            );
        
        // Create a cache for loaded TimelineAssets
        var timelineAssetCache = new Dictionary<string, TimelineAsset>();
        
        //var modifiedPlayableFileNames = GetModifiedTimelineFiles(ResourceSkillTimelineInjector.SKILL_TIMELINE_PATH);
        //var modifiedFxSettingFileNames = GetModifiedTimelineFiles(ResourceSkillTimelineInjector.SKILL_TIMELINE_FXSETTINGS_PATH);
        //var totalChangedFiles = modifiedPlayableFileNames.Concat(modifiedFxSettingFileNames).Distinct().ToArray();
        loadCount = 0;
        
        if (true)
        {
            //Debug.Log("변경된 타임라인 파일 목록:");
            //foreach (var changedFile in totalChangedFiles)
            //    Debug.Log(changedFile);
            //
            //Debug.Log("변경된 파일이 있습니다. 타임라인을 주입합니다.");
            
            foreach (var skill in skillsData.skills.OrderBy(x => x.id))
            {
                // var timelineUpdated= totalChangedFiles.Contains(skill.timelineFileName);
                var timelineUpdated = true;
                InjectTimelineForSkill(skill, timelineAssetPaths, ref timelineAssetCache);
            }
            
            ResourceSkill.SaveEditor();
        
            // UpdateMetadata();
        }
        else
            Debug.Log("변경된 타임라인 파일이 없습니다. 스킬 파싱을 종료합니다.");
        
        Debug.Log($"타임라인 주입 완료! 타임라인 에셋을 {loadCount}번 로드했습니다.");
    }

    private void UpdateMetadata()
    {
        // cache timelines to metadata
        var metaString = File.ReadAllText(ResourceSkill.SkillMetadataJsonFilePath);
        var metaJson = JObject.Parse(metaString);
        var skillsArray = (JArray)metaJson["skills"];
        if (skillsArray != null)
        {
            foreach (var jToken in skillsArray)
            {
                var skillObject = (JObject)jToken;
                var formatter = new JsonFormatter(JsonFormatter.Settings.Default.WithIndentation());
                    
                var skillId = int.Parse(skillObject.GetValue("id")!.ToString());
                var timelineObjs = ResourceSkill.editorSkills[skillId].Timelines.Select(x => JObject.Parse(formatter.Format(x)));
                skillObject["timelines"] = new JArray(timelineObjs);
            }
        }

        var updatedMetaJsonString = metaJson.ToString();
            
        File.WriteAllText(ResourceSkill.SkillMetadataJsonFilePath, updatedMetaJsonString);
    }

    private bool InjectTimelineForSkill(SkillForParser skill, IReadOnlyDictionary<string, string> timelineAssetPaths, ref Dictionary<string, TimelineAsset> timelineAssetCache)
    {
        // if (!timelineUpdated)
        // {
        //     var cachedTimelines = ResourceSkill.GetSkillMetadata().skills
        //         .FirstOrDefault(x => x.id == skill.id)?.timelines;
        //     ResourceSkill.GetEditor(skill.id)?.InjectTimeline(cachedTimelines);
        //     return;
        // }

        var timelineFileName = skill.timelineFileName;

        if (String.IsNullOrEmpty(timelineFileName))
        {
            Debug.LogError($"타임라인이 설정되어 있지 않습니다!: id: {skill.id}");
            return false;
        }

        if (!timelineAssetPaths.TryGetValue(timelineFileName, out var timelineAssetPath))
        {
            Debug.LogError($"타임라인 파일이 없습니다!: id: {skill.id} / 타임라인 파일이름: {timelineFileName}");
            return false;
        }

        if (!timelineAssetCache.TryGetValue(timelineAssetPath, out var timelineAsset))
        {
            timelineAsset = AssetDatabase.LoadAssetAtPath<TimelineAsset>(timelineAssetPath);
            loadCount++;
            if (timelineAsset == null)
            {
                Debug.LogError($"타임라인 파일이 없습니다!: {timelineAssetPath}");
                return false;
            }
            timelineAssetCache.Add(timelineAssetPath, timelineAsset);
        }

        try
        {
            ResourceSkillTimelineInjector.Inject(timelineAsset, skill);
            return true;
        }
        catch (Exception e)
        {
            Debug.LogError($"스킬 인젝션에 실패하였습니다 {skill.id}: {e.Message}");
        }

        return false;
    }
    
    private static List<string> GetModifiedTimelineFiles(string folderPath)
    {
        var results = new List<string>();
        var startInfo = new ProcessStartInfo("git")
        {
            UseShellExecute = false,
            RedirectStandardOutput = true,
            Arguments = $"status --porcelain  -- \"{folderPath}\"",
            CreateNoWindow = true
        };

        using (var process = Process.Start(startInfo))
        {
            using (var reader = process.StandardOutput)
            {
                while (reader.ReadLine() is { } line)
                {
                    results.Add(line.Trim());
                }
            }
            process.WaitForExit();
        }
        
        var filteredResults = results.Where(x => !x.EndsWith(".meta")).Select(Path.GetFileNameWithoutExtension).ToList();
        
        return filteredResults;
    }

    private void RemoveTimelineFileNameFromJson()
    {
        var jsonString = File.ReadAllText(ResourceSkill.SkillsJsonFilePath);

        var json = JObject.Parse(jsonString);

        var skillsArray = (JArray)json["skills"];
        if (skillsArray != null)
        {
            foreach (var jToken in skillsArray)
            {
                var skillObject = (JObject)jToken;
                var formatter = new JsonFormatter(JsonFormatter.Settings.Default.WithIndentation());
                var skillId = int.Parse(skillObject.GetValue("id")!.ToString());
                var skillMeta = ResourceSkill.GetSkillMetadata().skills.FirstOrDefault(x => x.id == skillId);
                if (skillMeta == null)
                {
                    Debug.Log($"새로 생성된 스킬: {skillId}");
                    continue;
                }
                var timelineObjs =  skillMeta.timelines.Select(x => JObject.Parse(formatter.Format(x)));
                skillObject["timelines"] = new JArray(timelineObjs);
            }
            
            File.WriteAllText(ResourceSkill.SkillMetadataJsonFilePath, json.ToString());
            
            foreach (var jToken in skillsArray)
            {
                // todo: use SkillWrapper mirroring
                var skillObject = (JObject)jToken;
                skillObject.Remove("timelineFileName");
                skillObject.Remove("timelineDamage1");
                skillObject.Remove("timelineDamage2");
                skillObject.Remove("timelineDamage3");
                skillObject.Remove("timelineDamage4");
                skillObject.Remove("timelineHeal1");
                skillObject.Remove("timelineHeal2");
                skillObject.Remove("timelineHeal3");
                skillObject.Remove("timelineHeal4");
                skillObject.Remove("attackPercentDamages");
                skillObject.Remove("attackPercentHeals");
            }
        }

        var updatedJsonString = json.ToString();

        File.WriteAllText(ResourceSkill.SkillsJsonFilePath, updatedJsonString);
    }
}