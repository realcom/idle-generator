#if UNITY_EDITOR
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Commons.Resources;
using Commons.Game;
using Google.Protobuf;
using JetBrains.Annotations;
using Sirenix.OdinInspector;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceSkill
    {
        private static readonly string path = Path.Combine(Application.dataPath, "PatchResources/Skills.json");

        public static Dictionary<int, ResourceSkill> editorSkills = new();
        public static Types.Global editorSkillsGlobal = new();
        
        public static void ReloadEditor()
        {
            var json = File.ReadAllText(path);
            var resource = Config.JsonParser.Parse<Resources>(json);
            var skills = resource.Skills;
            editorSkills = skills.ToDictionary(i => i.Id);
            editorSkillsGlobal = resource.SkillGlobal;
        }

        public static void SaveEditor()
        {
            var formatter = new JsonFormatter(JsonFormatter.Settings.Default.WithIndentation());
            File.WriteAllText(path, formatter.Format(new Resources
            {
                SkillGlobal = editorSkillsGlobal,
                Skills = { editorSkills.Values.OrderBy(i => i.Id) }
            }));
        }
        
        [CanBeNull]
        public static ResourceSkill GetEditor(int id)
        {
            return editorSkills.GetValueOrDefault(id);
        }
        
    }
}

#endif