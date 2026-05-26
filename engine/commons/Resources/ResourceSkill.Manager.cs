using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Google.Protobuf;

namespace Commons.Resources
{
    public partial class ResourceSkill : ResourceEntity
    {
        public override ResourceType ResourceType => ResourceType.Skill;
        public override bool IsValid => !ContainsTag(Tag.Deprecated);

        private static readonly IReadOnlyList<ResourceSkill> EmptyList = Array.Empty<ResourceSkill>();
        
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

        private static Dictionary<int, ResourceSkill> _skillById = new();
        private static Dictionary<Tag, List<ResourceSkill>> _skillsByTag = new();

        private static void Reload(Types.Global global, IList<ResourceSkill> skills)
        {
            Global = global.Init();
            
            Reload();

            _skillById = skills.ToDictionary(s => s.Init().Id);
            _skillsByTag = skills
                .SelectMany(s => s.Tags.Select(t => (skill: s, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.skill).ToList());
        }

        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.SkillGlobal, resources.Skills);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.SkillGlobal, resources.Skills);
        }

        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.SkillGlobal.Init();
            //do not call Init() on each skill, as it will be done in the runtime logic
            _skillById = resources.Skills.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                SkillGlobal = Global,
                Skills = { _skillById.Values.OrderBy(s => s.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                SkillGlobal = Global,
                Skills = { _skillById.Values.OrderBy(s => s.Id) }
            }.ToByteArray();
        }
        
        public static ResourceSkill? Get(int id)
        {
            return _skillById.GetValueOrDefault(id);
        }
        
        public static IReadOnlyList<ResourceSkill> GetAllByTag(Tag tag)
        {
            return _skillsByTag.GetValueOrDefault(tag) ?? EmptyList;
        }

        private HashSet<Tag> _tags;
        private Dictionary<ResourceTrigger.Types.Type, ResourceTrigger>? _triggerByType;
        
        private ResourceSkill Init()
        {
            _tags = new HashSet<Tag>(tags_);

            if (Math.Abs(scale_) < float.Epsilon)
                scale_ = 1f;

            if (hitOncePerUnit_)
                maxHitByUnit_ = 1;

            achievementSkillDataId_ = achievementSkillDataId_ == 0 ? Id : achievementSkillDataId_;

            var timelines = timelines_.ToList();
            var modified = false;
            foreach (var timeline in timelines_)
            {
                if (timeline.ActionCase == Types.Timeline.ActionOneofCase.Hit)
                {
                    var hit = timeline.Hit;
                    if (hit.Repeat > 1)
                    {
                        modified = true;
                        for (var i = 1; i < hit.Repeat; ++i)
                        {
                            timelines.Add(new Types.Timeline
                            {
                                Time = timeline.Time + i * hit.RepeatInterval,
                                Hit = hit,
                            });
                        }
                    }
                }
            }
            if (modified)
            {
                timelines_.Clear();
                timelines_.AddRange(timelines.OrderBy(t => t.Time));
            }

            if (Config.IsDebug)
            {
                if (Timelines.LastOrDefault()?.ActionCase != Types.Timeline.ActionOneofCase.Destroy)
                    throw new ArgumentException($"Last timeline must be Destroy action: {Id} {Name}");
                
                if (ContainsTag(Tag.AutoAim) && initAcceleration_ != null)
                    throw new ArgumentException($"AutoAim skill cannot have initAcceleration: {Id} {Name}");
            }
            
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
    }
}
