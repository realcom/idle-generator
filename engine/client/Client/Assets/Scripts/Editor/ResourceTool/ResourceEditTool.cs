using System.Collections.Generic;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEngine;
using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Reflection;
using Commons.Resources;
using Google.Protobuf;
using Google.Protobuf.Collections;
using Newtonsoft.Json;
using UnityEditor;
using UnityEngine.Pool;

namespace Commons.Resources
{
    public class ResourceEditTool : OdinMenuEditorWindow
    {
        [MenuItem("Tools/Resource Data Parser Tool/Parser Tool")]
        private static void OpenWindow()
        {
            var tool = GetWindow<ResourceEditTool>();
            tool.Show();

            //SkillTool.minSize = new Vector2(800, 400);
        }
        
        // [HorizontalGroup("Group 3", Width = 400)] [ShowInInspector] [Title("구글 스프레드시트")] [VerticalGroup("Group 3/Group 3-1")]
        // public string spreadsheetKey;

        protected override void OnEnable()
        {
            // var driveKeysJsonPath = Path.Combine(Application.dataPath, @"../../tools/spreadsheet_key.json");
            // var driveKeysJson = File.ReadAllText(driveKeysJsonPath);
            // var driveKeys = JsonConvert.DeserializeObject<Dictionary<string, string>>(driveKeysJson);
            // try
            // {
            //     spreadsheetKey = driveKeys["spreadsheet_key"];
            // }
            // catch (KeyNotFoundException)
            // {
            //     Debug.LogError("Spreadsheet key not set in spreadsheet_key.json.");
            // }
        }

        public void ParseAll()
        {
            ResourceEditToolParser.ParseAll();

            foreach (var resourceParseTool in tools)
            {
                resourceParseTool.PostRetrievalProcess();
            }
        }

        private readonly List<IResourceParseTool> tools = new();

        protected override OdinMenuTree BuildMenuTree()
        {
            tools.Clear();
            var tree = new OdinMenuTree();

            var list = TypeFinder.GetAllDerivedTypes<IResourceParseTool>();
            
            foreach (var type in list)
            {
                var instance = (IResourceParseTool)Activator.CreateInstance(type, this);
                instance.Init(this);

                tools.Add(instance);
                tree.AddObjectAtPath(type.Name, instance, true);
            }
            
            return tree;
        }
    }
}

public static class TypeFinder
{
    public static List<Type> GetAllDerivedTypes<T>()
    {
        // T 타입을 상속받은 모든 클래스를 찾는다
        return Assembly.GetAssembly(typeof(T)).GetTypes()
            .Where(type => type.IsClass && !type.IsAbstract && typeof(T).IsAssignableFrom(type))
            .ToList();
    }
}

public interface IResourceParseTool
{
    public void Init(ResourceEditTool tool);
    public Dictionary<string, string> GetPropertyToType();
    public string typeName { get; }
    public void PostRetrievalProcess();
}

public abstract class ResourceParseTool<T> : IResourceParseTool where T : IMessage<T>, new()
{

    [VerticalGroup("Buttons")]
    [Button("리소스 불러오기", ButtonHeight = 50)]
    private void RetrieveResource()
    {
        ResourceEditToolParser.Parse<T>();
        PostRetrievalProcess();
    }
    
    [VerticalGroup("Buttons")]
    [Button("리소스 전체 파싱", ButtonHeight = 50)]
    private void ParseAll()
    {
        resourceEditTool.ParseAll();
    }

    [VerticalGroup("Buttons")]
    [Button("리소스 쿼리", ButtonHeight = 50)]
    protected virtual void QueryResources() {}

    public Dictionary<string, string> GetPropertyToType()
    {
        Dictionary<string, string> propertyToType = new();
        Type type = typeof(T);

        PropertyInfo[] propertyInfos = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);

        foreach (var propertyInfo in propertyInfos)
        {
            propertyToType.Add(propertyInfo.Name, propertyInfo.PropertyType.Name);
        }

        return propertyToType;
    }

    public string typeName => typeof(T).Name;
    public abstract void PostRetrievalProcess();

    protected ResourceEditTool resourceEditTool;
    private IResourceParseTool _resourceParseToolImplementation;

    public void Init(ResourceEditTool tool)
    {
        resourceEditTool = tool;
    }
}