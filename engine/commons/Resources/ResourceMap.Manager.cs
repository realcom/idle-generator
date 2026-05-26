using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources.Interfaces;
using Commons.Utility;
using Google.Protobuf;
using static Commons.Resources.ResourceMap.Types;

namespace Commons.Resources
{
    public partial class ResourceMap : ResourceEntity, IRelativeItemDataIdGetter
    {
        public override ResourceType ResourceType => ResourceType.Map;
        public override bool IsValid => !ContainsTag(Tag.Deprecated);

        private static readonly IReadOnlyList<ResourceMap> EmptyList = Array.Empty<ResourceMap>();
        
        public partial class Types
        {
            public partial class Global
            {
                public partial class Types
                {
                    public partial class BoardConstants
                    {
                        public int BoardMaxX => DefaultPlayerInventoryShapes.First().Rows.First().Cells.Count;
                        public int BoardMaxY => DefaultPlayerInventoryShapes.First().Rows.Count;

                        public const int BoardFirstHandleValue = -1;
                        public const int BoardLastHandleValue = -2;
                    }
                }
                
                internal Global Init()
                {
                    DataId ??= new Types.DataId();
                    BoardConstants ??= new Types.BoardConstants();
                    return this;
                }
            }
        }
        
        public static Global Global = new();

        private static Dictionary<int, ResourceMap> _mapById = new();
        private static Dictionary<Tag, List<ResourceMap>> _mapsByTag = new();
        private static Dictionary<Types.Type, List<ResourceMap>> _mapsByType = new();
        private static Dictionary<int, List<ResourceMap>> _mapsByGroup = new();
        
        public Terrain UnitTerrain { get; private set; }
        public Terrain SkillTerrain { get; private set; }

        private static void Reload(Global global, IList<ResourceMap> maps)
        {
            Global = global.Init();
            
            Reload();

            _mapById = maps.ToDictionary(m => m.Init().Id);
            _mapsByTag = maps
                .SelectMany(m => m.Tags.Select(t => (map: m, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.map).ToList());
            _mapsByType = maps
                .GroupBy(m => m.Type)
                .ToDictionary(g => g.Key, g => g.Select(x => x).ToList());
            _mapsByGroup = maps
                .GroupBy(m => m.Group)
                .ToDictionary(g => g.Key, g => g.Select(x => x).ToList());
        }

        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.MapGlobal, resources.Maps);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.MapGlobal, resources.Maps);
        }
        
        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.MapGlobal.Init();
            //do not call Init() on each map, as it will be done in the runtime logic
            _mapById = resources.Maps.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                MapGlobal = Global,
                Maps = { _mapById.Values.OrderBy(m => m.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                MapGlobal = Global,
                Maps = { _mapById.Values.OrderBy(m => m.Id) }
            }.ToByteArray();
        }
        
        public static ResourceMap? Get(int id)
        {
            return _mapById.GetValueOrDefault(id);
        }
        
        public static IReadOnlyList<ResourceMap> GetAllByTag(Tag tag)
        {
            return _mapsByTag.GetValueOrDefault(tag) ?? EmptyList;
        }

        public static IReadOnlyList<ResourceMap> GetAllByType(Types.Type type)
        {
            return _mapsByType.GetValueOrDefault(type) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceMap> GetAllByGroup(int group)
        {
            return _mapsByGroup.GetValueOrDefault(group) ?? EmptyList;
        }

        private HashSet<Tag> _tags;
        private Dictionary<ResourceTrigger.Types.Type, ResourceTrigger>? _triggerByType;
        
        private ResourceMap Init()
        {
            _tags = new HashSet<Tag>(tags_);
            
            foreach (var terrain in terrains_)
            {
                switch (terrain.Type)
                {
                    case Terrain.Types.Type.Unit:
                        UnitTerrain = terrain;
                        break;
                    case Terrain.Types.Type.Skill:
                        SkillTerrain = terrain;
                        break;
                }
            }

            achievementMapDataId_ = achievementMapDataId_ == 0 ? Id : achievementMapDataId_;

            InitLocation();

            InitUnity();
            return this;
        }

        partial void InitUnity();

        private void InitTrigger()
        {
            if (_triggerByType != null)
                return;
            _triggerByType = Triggers.Select(name => ResourceTrigger.Get(name)!).ToDictionary(t => t.Type);
        }
        
        public bool ContainsTag(Tag tag)
        {
            return _tags.Contains(tag);
        }
        
        public ResourceTrigger? GetTrigger(ResourceTrigger.Types.Type type)
        {
            InitTrigger();
            return _triggerByType!.GetValueOrDefault(type);
        }

        public int GetRelativeItemDataId(string key, int _default = default)
        {
            return relativeItemDataIdGroups_.GetValueOrDefault(key, _default);
        }
    }
}
