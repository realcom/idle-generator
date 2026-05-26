using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Google.Protobuf;

namespace Commons.Resources
{
    public partial class ResourceBuff : ResourceEntity
    {
        public override ResourceType ResourceType => ResourceType.Buff;
        public override bool IsValid => !ContainsTag(Tag.Deprecated);
        
        private static readonly IReadOnlyList<ResourceBuff> EmptyList = Array.Empty<ResourceBuff>();
        
        public partial class Types
        {
            public partial class Global
            {
                internal Global Init()
                {
                    DataId ??= new Types.DataId();
                    return this;
                }
            }
        }
        
        public static Types.Global Global = new();
        
        private static Dictionary<int, ResourceBuff> _buffById = new();
        private static Dictionary<Tag, List<ResourceBuff>> _buffsByTag = new();

        private static void Reload(Types.Global global, IList<ResourceBuff> buffs)
        {
            Global = global.Init();
            
            Reload();
            
            _buffById = buffs.ToDictionary(b => b.Init().Id);
            _buffsByTag = buffs
                .SelectMany(b => b.Tags.Select(t => (buff: b, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.buff).ToList());
        }

        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.BuffGlobal, resources.Buffs);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.BuffGlobal, resources.Buffs);
        }
        
        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.BuffGlobal.Init();
            //do not call Init() on each buff, as it will be done in the runtime logic
            _buffById = resources.Buffs.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                BuffGlobal = Global,
                Buffs = { _buffById.Values.OrderBy(b => b.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                BuffGlobal = Global,
                Buffs = { _buffById.Values.OrderBy(b => b.Id) }
            }.ToByteArray();
        }
        
        public static ResourceBuff? Get(int id)
        {
            return _buffById.GetValueOrDefault(id);
        }
        
        public static IReadOnlyList<ResourceBuff> GetAllByTag(Tag tag)
        {
            return _buffsByTag.GetValueOrDefault(tag) ?? EmptyList;
        }

        private HashSet<Tag> _tags;
        private Dictionary<ResourceTrigger.Types.Type, ResourceTrigger>? _triggerByType;
        
        public uint AddState { get; private set; }
        
        private ResourceBuff Init()
        {
            _tags = new HashSet<Tag>(tags_);
            foreach (var state in addStates_)
                AddState |= (uint)1 << (int)state;
            group_ = group_ == 0 ? id_ : group_;
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

        public bool HasAddStats()
        {
            if (AddStats.Count > 0)
                return true;
            
            if (AddArmorTypeStats.Count > 0)
                return true;

            if (AddDamageTypeStats.Count > 0)
                return true;

            if (AddItemGroupStats.Count > 0)
                return true;

            if (AddSlotStats.Count > 0)
                return true;

            if (AddBuffGroupStats.Count > 0)
                return true;

            if (AddSkillGroupStats.Count > 0)
                return true;

            return false;
        }
        
    }
}
