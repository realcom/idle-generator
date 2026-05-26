using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Google.Protobuf;
using UnityEditor;
using UnityEngine;
using Commons.Resources;
using Resources = Commons.Resources.Resources;

public class StringTool : ResourceParseTool<ResourceString>
{
    public const string stringKeyPath = "Scripts/Data/StringKeys.cs";
    
    public override void PostRetrievalProcess()
    {
        ResourceString.ReloadEditor();

        GenerateStringKeys();
    }

    public void GenerateStringKeys()
    {
        var data = LoadClientResourceStrings();

        var categories = new Dictionary<string, List<string>>();

        foreach (var resString in data)
        {
            var category = resString.Category.ToString();
            var id = resString.Id.ToString();
            var key = resString.Key;
            
            if (!string.IsNullOrEmpty(category))
            {
                if (!categories.ContainsKey(category))
                    categories[category] = new List<string>();
                
                // if (!string.IsNullOrEmpty(id))
                // {
                //     var modifiedId = NumberToWords(id);
                //     if (!modifiedId.Contains("--"))
                //         categories[category].Add(modifiedId);
                // }
                
                if (!string.IsNullOrEmpty(key))
                {
                    if (!key.Contains("--"))
                        categories[category].Add(key);
                }
            }
        }

        var output = "public static partial class StringKeys\n{\n";
        output += "    public partial class LocalizableStringKey\n";
        output += "    {\n";
        output += "        private string _key;\n";
        output += "        public LocalizableStringKey(string key)\n";
        output += "        {\n";
        output += "            this._key = key;\n";
        output += "        }\n";
        output += "        public string Key\n";
        output += "        {\n";
        output += "            get => _key;\n";
        output += "            private set => _key = value;\n";
        output += "        }\n";
        output += "        public string L(params object[] args)\n";
        output += "        {\n";
        output += "            return this._key.L(args);\n";
        output += "        }\n";
        output += "    }\n";

        foreach (var group in categories)
        {
            output += $"    public static partial class {group.Key}\n    {{\n";
            foreach (var key in group.Value)
            {
                output += $"        public static readonly LocalizableStringKey {key} = new LocalizableStringKey(\"{key}\");\n";
            }
            output += "    }\n";
        }
        output += "}";

        //File.WriteAllText(Path.Combine(Application.dataPath, stringKeyPath), output);
        Debug.Log("StringKeys class generated.");
    }

    private IEnumerable<ResourceString> LoadClientResourceStrings()
    {
        var json = File.ReadAllText(ResourceString.path);
        var editorStrings = JsonParser.Default.Parse<Resources>(json).Strings
            .Where(i => i.Category == ResourceString.Types.Category.Client);

        return editorStrings;
    }
    
    private string NumberToWords(string numberString)
    {
        if (char.IsDigit(numberString[0]) || (numberString[0] == '-' && char.IsDigit(numberString[1])))
        {
            if (numberString == "0") return "N_Zero";
            if (numberString[0] == '-') return "N_Minus" + numberString[1..];
            return "N_Plus" + numberString;
        }
        return numberString.Replace(":", "___");
    }

    private string IdToValue(string id, string category)
    {
        if (id == "N_Zero") return "0";
        if (id.StartsWith("N_Minus"))
        {
            if (category == "Server") return "-" + id.Substring(7);
            return category + "_-" + id[7..];
        }
        if (id.StartsWith("N_Plus"))
        {
            if (category == "Server") return id.Substring(6);
            return category + "_" + id[6..];
        }
        if (category == "Server") return id;
        if (id == "itself") return category;
        return category + "_" + id.Replace("___", ":");
    }
}