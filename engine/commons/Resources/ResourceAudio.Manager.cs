using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Google.Protobuf;

namespace Commons.Resources
{
    public partial class ResourceAudio : ResourceEntity
    {
        public override ResourceType ResourceType => ResourceType.Audio;
        public override bool IsValid => !ContainsTag(Tag.Deprecated);
        
        private static readonly IReadOnlyList<ResourceAudio> EmptyList = Array.Empty<ResourceAudio>();
        
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

        private static Dictionary<int, ResourceAudio> _audioById = new();
        private static Dictionary<string, ResourceAudio> _audioByName = new();
        private static Dictionary<Types.Type, List<ResourceAudio>> _audiosByType = new();
        private static Dictionary<Tag, List<ResourceAudio>> _audiosByTag = new();

        private static void Reload(Types.Global global, IList<ResourceAudio> audios)
        {
            Global = global.Init();
            
            Reload();
            
            _audioById = audios.ToDictionary(i => i.Init().Id);
            _audioByName = audios.ToDictionary(i => i.Init().Name);
            _audiosByType = audios
                .GroupBy(i => i.Type)
                .ToDictionary(g => g.Key, g => g.ToList());
            _audiosByTag = audios
                .SelectMany(i => i.Tags.Select(t => (audio: i, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.audio).ToList());
        }
        
        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.AudioGlobal, resources.Audios);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.AudioGlobal, resources.Audios);
        }
        
        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.AudioGlobal.Init();
            //do not call Init() on each audio, as it will be done in the runtime logic
            _audioById = resources.Audios.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                AudioGlobal = Global,
                Audios = { _audioById.Values.OrderBy(i => i.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                AudioGlobal = Global,
                Audios = { _audioById.Values.OrderBy(i => i.Id) }
            }.ToByteArray();
        }
        
        public static ResourceAudio? Get(int id)
        {
            return _audioById.GetValueOrDefault(id);
        }

        public static ResourceAudio? Get(string name)
        {
            return _audioByName.GetValueOrDefault(name);
        }
        
        public static IReadOnlyList<ResourceAudio> GetAllByType(Types.Type type)
        {
            return _audiosByType.GetValueOrDefault(type) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceAudio> GetAllByTag(Tag tag)
        {
            return _audiosByTag.GetValueOrDefault(tag) ?? EmptyList;
        }

        private HashSet<Tag> _tags;
        
        private ResourceAudio Init()
        {
            _tags = new HashSet<Tag>(tags_);
            InitUnity();
            return this;
        }

        partial void InitUnity();
        
        public bool ContainsTag(Tag tag)
        {
            return _tags.Contains(tag);
        }
    }
}
