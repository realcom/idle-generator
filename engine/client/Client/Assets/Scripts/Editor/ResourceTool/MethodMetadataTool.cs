using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Commons.Resources;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEngine;
using Google.Protobuf;
using Google.Protobuf.Collections;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

[Serializable]
public class SerializedResourceMethod
{
    public ResourceTrigger.Types.MethodMetadata.MethodOneofCase methodType;
    public string methodSubtype;
    public ParameterMetadata[] parameters;
    public bool hasReturn;
    public bool isClientMethod;

    [Serializable]
    public class ParameterMetadata
    {
        public ResourceTrigger.Types.Expression.Types.Operand.Types.Variable
            .Types.Parameter
            .Types
            .Type type;

        public string comment;
        public bool optional;
    }
}

namespace Commons.Resources
{
    public class MethodMetadataTool : OdinEditorWindow
    {
        private static readonly string path = Path.Combine(Application.dataPath, "PatchResources/Triggers.json");
        private static RepeatedField<ResourceTrigger.Types.MethodMetadata> _triggerMethods = new();
        private static RepeatedField<ResourceTrigger> _triggers = new();

        [MenuItem("Tools/Resource Data Parser Tool/Method Metadata Tool")]
        private static void OpenWindow()
        {
            var methodMetadataTool = GetWindow<MethodMetadataTool>();
            methodMetadataTool.Show();

            methodMetadataTool.minSize = new Vector2(800, 400);

            var json = File.ReadAllText(path);
            _triggerMethods = JsonParser.Default.Parse<Resources>(json).TriggerMethods;

            foreach (var triggerMethod in _triggerMethods)
            {
                var serializedResourceMethod = new SerializedResourceMethod();
                serializedResourceMethod.methodType = triggerMethod.MethodCase;
                serializedResourceMethod.methodSubtype = triggerMethod.MethodCase switch
                {
                    ResourceTrigger.Types.MethodMetadata.MethodOneofCase.BoardMethod =>
                        triggerMethod.BoardMethod.Type.ToString(),
                    ResourceTrigger.Types.MethodMetadata.MethodOneofCase.UnitMethod =>
                        triggerMethod.UnitMethod.Type.ToString(),
                    ResourceTrigger.Types.MethodMetadata.MethodOneofCase.SkillMethod =>
                        triggerMethod.SkillMethod.Type.ToString(),
                    ResourceTrigger.Types.MethodMetadata.MethodOneofCase.BuffMethod =>
                        triggerMethod.BuffMethod.Type.ToString(),
                    ResourceTrigger.Types.MethodMetadata.MethodOneofCase.DebugMethod =>
                        triggerMethod.DebugMethod.Type.ToString(),
                    _ => "Unknown"
                };
                serializedResourceMethod.parameters =
                    new SerializedResourceMethod.ParameterMetadata[triggerMethod.Parameters.Count];
                for (int i = 0; i < triggerMethod.Parameters.Count; i++)
                {
                    serializedResourceMethod.parameters[i] = new SerializedResourceMethod.ParameterMetadata
                    {
                        type = triggerMethod.Parameters[i].Parameter.Type,
                        comment = triggerMethod.Parameters[i].Comment,
                        optional = triggerMethod.Parameters[i].Optional
                    };
                }
                serializedResourceMethod.hasReturn = triggerMethod.HasReturn;
                serializedResourceMethod.isClientMethod = triggerMethod.IsClientMethod;

                methodMetadataTool.methodMetadataInformationList.Add(serializedResourceMethod);
            }
        }

        [TableList] [ListDrawerSettings(DefaultExpandedState = true, ShowFoldout = false, DraggableItems = false)]
        public List<SerializedResourceMethod> methodMetadataInformationList = new();

        [Button("저장", Icon = SdfIconType.Save, ButtonHeight = 50)]
        private void Save()
        {
            var json = File.ReadAllText(path);

            _triggers = JsonParser.Default.Parse<Resources>(json).Triggers;
            _triggerMethods.Clear();

            foreach (var methodInfo in methodMetadataInformationList)
            {
                ResourceTrigger.Types.MethodMetadata metadata = new();
                RepeatedField<ResourceTrigger.Types.MethodMetadata.Types.ParameterMetadata> parameters = new();
                foreach (var param in methodInfo.parameters)
                {
                    var parameterMetadata = new ResourceTrigger.Types.MethodMetadata.Types.ParameterMetadata
                    {
                        Comment = param.comment ?? string.Empty,
                        Optional = param.optional,
                        Parameter = new ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.Parameter
                        {
                            Type = param.type
                        }
                    };
                    parameters.Add(parameterMetadata);
                }

                switch (methodInfo.methodType)
                {
                    case ResourceTrigger.Types.MethodMetadata.MethodOneofCase.BoardMethod:
                        metadata = new ResourceTrigger.Types.MethodMetadata()
                        {
                            BoardMethod = new()
                            {
                                Type = (ResourceTrigger.Types.Call.Types.BoardMethod.Types.Type)Enum.Parse(
                                    typeof(ResourceTrigger.Types.Call.Types.BoardMethod.Types.Type),
                                    methodInfo.methodSubtype.ToString()),
                            },
                            Parameters = { parameters }
                        };
                        break;
                    case ResourceTrigger.Types.MethodMetadata.MethodOneofCase.UnitMethod:
                        metadata = new ResourceTrigger.Types.MethodMetadata()
                        {
                            UnitMethod = new()
                            {
                                Type = (ResourceTrigger.Types.Call.Types.UnitMethod.Types.Type)Enum.Parse(
                                    typeof(ResourceTrigger.Types.Call.Types.UnitMethod.Types.Type),
                                    methodInfo.methodSubtype.ToString()),
                            },
                            Parameters = { parameters }
                        };
                        break;
                    case ResourceTrigger.Types.MethodMetadata.MethodOneofCase.SkillMethod:
                        metadata = new ResourceTrigger.Types.MethodMetadata()
                        {
                            SkillMethod = new()
                            {
                                Type = (ResourceTrigger.Types.Call.Types.SkillMethod.Types.Type)Enum.Parse(
                                    typeof(ResourceTrigger.Types.Call.Types.SkillMethod.Types.Type),
                                    methodInfo.methodSubtype.ToString()),
                            },
                            Parameters = { parameters }
                        };
                        break;
                    case ResourceTrigger.Types.MethodMetadata.MethodOneofCase.BuffMethod:
                        metadata = new ResourceTrigger.Types.MethodMetadata()
                        {
                            BuffMethod = new()
                            {
                                Type = (ResourceTrigger.Types.Call.Types.BuffMethod.Types.Type)Enum.Parse(
                                    typeof(ResourceTrigger.Types.Call.Types.BuffMethod.Types.Type),
                                    methodInfo.methodSubtype.ToString()),
                            },
                            Parameters = { parameters }
                        };
                        break;
                    case ResourceTrigger.Types.MethodMetadata.MethodOneofCase.DebugMethod:
                        metadata = new ResourceTrigger.Types.MethodMetadata()
                        {
                            DebugMethod = new()
                            {
                                Type = (ResourceTrigger.Types.Call.Types.DebugMethod.Types.Type)Enum.Parse(
                                    typeof(ResourceTrigger.Types.Call.Types.DebugMethod.Types.Type),
                                    methodInfo.methodSubtype.ToString()),
                            },
                            Parameters = { parameters }
                        };
                        break;
                    case ResourceTrigger.Types.MethodMetadata.MethodOneofCase.RunTrigger:
                        metadata = new ResourceTrigger.Types.MethodMetadata()
                        {
                            RunTrigger = new(),
                            Parameters = { parameters }
                        };
                        break;
                }

                metadata.HasReturn = methodInfo.hasReturn;
                metadata.IsClientMethod = methodInfo.isClientMethod;

                _triggerMethods.Add(metadata);
            }

            var settings = new JsonFormatter.Settings(false).WithIndentation();
            var updatedJsonString = new JsonFormatter(settings).Format(
                new Resources()
                {
                    Triggers = { _triggers },
                    TriggerMethods = { _triggerMethods }
                });

            updatedJsonString = SortJsonByKey(updatedJsonString);

            File.WriteAllText(path, updatedJsonString);
        }

        public static string SortJsonByKey(string json)
        {
            var jsonObject = JObject.Parse(json);
            var sortedJsonObject = SortJObject(jsonObject);
            return JsonConvert.SerializeObject(sortedJsonObject, Formatting.Indented);
        }

        private static JObject SortJObject(JObject original)
        {
            var sorted = new JObject();
            foreach (var property in original.Properties().OrderBy(p => p.Name))
            {
                if (property.Value is JObject)
                {
                    sorted.Add(property.Name, SortJObject((JObject)property.Value));
                }
                else if (property.Value is JArray)
                {
                    sorted.Add(property.Name, SortJArray((JArray)property.Value));
                }
                else
                {
                    sorted.Add(property.Name, property.Value);
                }
            }
            return sorted;
        }

        private static JArray SortJArray(JArray original)
        {
            var sorted = new JArray();
            foreach (var item in original)
            {
                if (item is JObject)
                {
                    sorted.Add(SortJObject((JObject)item));
                }
                else if (item is JArray)
                {
                    sorted.Add(SortJArray((JArray)item));
                }
                else
                {
                    sorted.Add(item);
                }
            }
            return sorted;
        }
    }
}