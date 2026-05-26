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
using Sirenix.OdinInspector;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceString
    {
        public static readonly string path = Path.Combine(Application.dataPath, "PatchResources/Strings.json");

        private static IEnumerable<EditorStringKey> editorStrings;
        
        public static void ReloadEditor()
        {
            var json = File.ReadAllText(path);
            var Strings = Config.JsonParser.Parse<Resources>(json).Strings;
            editorStrings = Strings.Where(i => i.Category == Types.Category.Editor).Select(i => new EditorStringKey(i.English, i.Id)).OrderBy(x => x.name);
        }

        public static void SaveEditor()
        {
            if (editorStrings == null)
                return;
            
            var json = File.ReadAllText(path);
            
            //에디터 카테고리 수정 적용
            IEnumerable<ResourceString> Strings = JsonParser.Default.Parse<Resources>(json).Strings.ToList();
            Strings = Strings.Where(i => i.Category != Types.Category.Editor).Concat(editorStrings.Select(i => new ResourceString
            {
                Id = i,
                Category = Types.Category.Editor,
                English = i,
            }));
            
            var formatter = new JsonFormatter(JsonFormatter.Settings.Default.WithIndentation());
            
            File.WriteAllText(path, formatter.Format(new Resources
            {
                Strings = { Strings.OrderBy(i => (i.Category, i.Id)) }
            }));
            
            ReloadEditor();
        }
        
        public static IEnumerable<EditorStringKey> GetEditorStringKeys()
        {
            if (editorStrings == null)
                ReloadEditor();
            
            foreach (var key in editorStrings!)
            {
                yield return key;
            }
        }

        public static IEnumerable<string> GetEditorStringPaths()
        {
            return GetEditorStringKeys()
                .Where(x => x.name.Contains('/'))
                .Select(x => $"StringKeys/{x.name[..x.name.LastIndexOf('/')]}")
                .Append("StringKeys");
        }

        public static void AddKey(string keyName)
        {
            ReloadEditor();
            
            var hash = 1;
            foreach (var key in GetEditorStringKeys().OrderBy(x => x.hash))
            {
                if (key.hash != hash)
                    break;

                hash++;
            }

            editorStrings = editorStrings.Append(new EditorStringKey(keyName, hash)).OrderBy(i => i.hash);
        }
        
    }
}

#endif