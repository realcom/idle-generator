using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Google.Protobuf;
using static Commons.Resources.ResourceTrigger.Types;
using static Commons.Resources.ResourceTrigger.Types.Call.Types;

namespace Commons.Resources
{
    public partial class ResourceTrigger : ResourceEntity
    {
        public override ResourceType ResourceType => ResourceType.Trigger;
        public override bool IsValid => true;

        private static readonly IReadOnlyList<ResourceTrigger> EmptyList = Array.Empty<ResourceTrigger>();
        
        public const uint DefaultPeriod = 15;

        public partial class Types
        {
            public partial class MethodMetadata : IComparable
            {
                public int CompareTo(object obj)
                {
                    if (obj is MethodMetadata other)
                        return string.CompareOrdinal(ToString(), other.ToString());
                    return 1;
                }
            }
            
            public partial class Call
            {
                public partial class Types
                {
                    public partial class RunTrigger : IComparable
                    {
                        public int CompareTo(object obj)
                        {
                            if (obj is MethodMetadata other)
                                return string.CompareOrdinal(ToString(), other.ToString());
                            return 1;
                        }
                        
                        private ResourceTrigger? _trigger;
                        public ResourceTrigger Trigger
                        {
                            get
                            {
                                _trigger ??= Get(name_)!;
                                return _trigger;
                            }
                        }
                    }

                    public partial class BoardMethod : IComparable
                    {
                        public int CompareTo(object obj)
                        {
                            if (obj is MethodMetadata other)
                                return string.CompareOrdinal(ToString(), other.ToString());
                            return 1;
                        }
                    }
                    
                    public partial class DebugMethod : IComparable
                    {
                        public int CompareTo(object obj)
                        {
                            if (obj is MethodMetadata other)
                                return string.CompareOrdinal(ToString(), other.ToString());
                            return 1;
                        }
                    }

                    public partial class UnitMethod : IComparable
                    {
                        public int CompareTo(object obj)
                        {
                            if (obj is MethodMetadata other)
                                return string.CompareOrdinal(ToString(), other.ToString());
                            return 1;
                        }
                    }

                    public partial class BuffMethod : IComparable
                    {
                        public int CompareTo(object obj)
                        {
                            if (obj is MethodMetadata other)
                                return string.CompareOrdinal(ToString(), other.ToString());
                            return 1;
                        }
                    }

                    public partial class SkillMethod : IComparable
                    {
                        public int CompareTo(object obj)
                        {
                            if (obj is MethodMetadata other)
                                return string.CompareOrdinal(ToString(), other.ToString());
                            return 1;
                        }
                    }
                }
            }
        }

        private static Dictionary<string, ResourceTrigger> _triggerByName = new();

        private static Dictionary<BoardMethod, MethodMetadata> _methodMetadataByBoardMethod = new();
        private static Dictionary<UnitMethod, MethodMetadata> _methodMetadataByUnitMethod = new();
        private static Dictionary<SkillMethod, MethodMetadata> _methodMetadataBySkillMethod = new();
        private static Dictionary<BuffMethod, MethodMetadata> _methodMetadataByBuffMethod = new();
        private static Dictionary<DebugMethod, MethodMetadata> _methodMetadataByDebugMethod = new();
        private static Dictionary<RunTrigger, MethodMetadata> _methodMetadataByRunTrigger = new();

        private static void Reload(IList<ResourceTrigger> triggers)
        {
            Reload();
            
            _triggerByName = triggers.ToDictionary(t => t.Init().Name);
        }
        
        static partial void Reload();

        private static void Reload(IList<MethodMetadata> methodMetadata)
        {
            var methodMetadataByBoardMethod = new Dictionary<BoardMethod, MethodMetadata>();
            var methodMetadataByUnitMethod = new Dictionary<UnitMethod, MethodMetadata>();
            var methodMetadataBySkillMethod = new Dictionary<SkillMethod, MethodMetadata>();
            var methodMetadataByBuffMethod = new Dictionary<BuffMethod, MethodMetadata>();
            var methodMetadataByDebugMethod = new Dictionary<DebugMethod, MethodMetadata>();
            var methodMetadataByRunTrigger = new Dictionary<RunTrigger, MethodMetadata>();

            foreach (var metadata in methodMetadata)
            {
                switch (metadata.MethodCase)
                {
                    case MethodMetadata.MethodOneofCase.BoardMethod:
                    {
                        methodMetadataByBoardMethod[metadata.BoardMethod] = metadata;
                        break;
                    }
                    case MethodMetadata.MethodOneofCase.UnitMethod:
                    {
                        methodMetadataByUnitMethod[metadata.UnitMethod] = metadata;
                        break;
                    }
                    case MethodMetadata.MethodOneofCase.SkillMethod:
                    {
                        methodMetadataBySkillMethod[metadata.SkillMethod] = metadata;
                        break;
                    }
                    case MethodMetadata.MethodOneofCase.BuffMethod:
                    {
                        methodMetadataByBuffMethod[metadata.BuffMethod] = metadata;
                        break;
                    }
                    case MethodMetadata.MethodOneofCase.DebugMethod:
                    {
                        methodMetadataByDebugMethod[metadata.DebugMethod] = metadata;
                        break;
                    }
                    case MethodMetadata.MethodOneofCase.RunTrigger:
                    {
                        methodMetadataByRunTrigger[metadata.RunTrigger] = metadata;
                        break;
                    }
                }
            }

            _methodMetadataByBoardMethod = methodMetadataByBoardMethod;
            _methodMetadataByUnitMethod = methodMetadataByUnitMethod;
            _methodMetadataBySkillMethod = methodMetadataBySkillMethod;
            _methodMetadataByBuffMethod = methodMetadataByBuffMethod;
            _methodMetadataByDebugMethod = methodMetadataByDebugMethod;
            _methodMetadataByRunTrigger = methodMetadataByRunTrigger;
        }

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.Triggers);
            Reload(resources.TriggerMethods);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.Triggers);
            Reload(resources.TriggerMethods);
        }

        public static string FormatJson()
        {
            var resources = new Resources
            {
                Triggers = { _triggerByName.Values.OrderBy(t => t.Name) },
            };
            resources.TriggerMethods.AddRange(_methodMetadataByBoardMethod.Values.OrderBy(m => m.BoardMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByUnitMethod.Values.OrderBy(m => m.UnitMethod));
            resources.TriggerMethods.AddRange(_methodMetadataBySkillMethod.Values.OrderBy(m => m.SkillMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByBuffMethod.Values.OrderBy(m => m.BuffMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByDebugMethod.Values.OrderBy(m => m.DebugMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByRunTrigger.Values.OrderBy(m => m.RunTrigger));
            
            return resources.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            var resources = new Resources
            {
                Triggers = { _triggerByName.Values.OrderBy(t => t.Name) },
            };
            resources.TriggerMethods.AddRange(_methodMetadataByBoardMethod.Values.OrderBy(m => m.BoardMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByUnitMethod.Values.OrderBy(m => m.UnitMethod));
            resources.TriggerMethods.AddRange(_methodMetadataBySkillMethod.Values.OrderBy(m => m.SkillMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByBuffMethod.Values.OrderBy(m => m.BuffMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByDebugMethod.Values.OrderBy(m => m.DebugMethod));
            resources.TriggerMethods.AddRange(_methodMetadataByRunTrigger.Values.OrderBy(m => m.RunTrigger));
            
            return resources.ToByteArray();
        }
        
        public static ResourceTrigger? Get(string name)
        {
            return _triggerByName.GetValueOrDefault(name);
        }

        private ResourceTrigger Init()
        {
            if (period_ == 0)
                period_ = DefaultPeriod;
            InitUnity();
            return this;
        }

        partial void InitUnity();
    }
}
