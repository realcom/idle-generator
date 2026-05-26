using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Types;
using Commons.Types.Units;
using Commons.Utility;
using Google.Protobuf;

namespace Commons.Resources
{
    public partial class ResourceUnit : ResourceEntity
    {
        public override ResourceType ResourceType => ResourceType.Unit;
        public override bool IsValid => !ContainsTag(Tag.Deprecated);

        private static readonly IReadOnlyList<ResourceUnit> EmptyList = Array.Empty<ResourceUnit>();
        
        public partial class Types
        {
            public partial class Global
            {
                public partial class Types
                {
                    public partial class StatConstants
                    {
                        private readonly Dictionary<(ArmorType, DamageType), FixedFloat>
                            _damageCoefficientByArmorDamageTypes = new();

                        internal void Init()
                        {
                            foreach (var damageCoefficient in damageCoefficients_)
                                _damageCoefficientByArmorDamageTypes[(damageCoefficient.ArmorType, damageCoefficient.DamageType)] =
                                    damageCoefficient.DamagePercent / FixedFloat.Hundred;
                        }
                        
                        public FixedFloat GetDamageCoefficient(ArmorType armorType, DamageType damageType)
                        {
                            return _damageCoefficientByArmorDamageTypes.GetValueOrDefault((armorType, damageType), FixedFloat.One);
                        }
                    }
                }
                
                internal Global Init()
                {
                    DataId ??= new Types.DataId();
                    statConstants_ ??= new Types.StatConstants();
                    statConstants_.Init();
                    return this;
                }
            }
        }
        
        public static Types.Global Global = new();

        private static Dictionary<int, ResourceUnit> _unitById = new();
        private static Dictionary<Tag, List<ResourceUnit>> _unitsByTag = new();

        private static void Reload(Types.Global global, IList<ResourceUnit> units)
        {
            Global = global.Init();
            
            Reload();

            _unitById = units.ToDictionary(i => i.Init().Id);
            _unitsByTag = units
                .SelectMany(u => u.Tags.Select(t => (unit: u, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.unit).ToList());
        }
        
        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.UnitGlobal, resources.Units);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.UnitGlobal, resources.Units);
        }

        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.UnitGlobal.Init();
            //do not call Init() on each unit, as it will be done in the runtime logic
            _unitById = resources.Units.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                UnitGlobal = Global,
                Units = { _unitById.Values.OrderBy(b => b.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                UnitGlobal = Global,
                Units = { _unitById.Values.OrderBy(b => b.Id) }
            }.ToByteArray();
        }
        
        public static ResourceUnit? Get(int id)
        {
            return _unitById.GetValueOrDefault(id);
        }
        
        public static IReadOnlyList<ResourceUnit> GetAllByTag(Tag tag)
        {
            return _unitsByTag.GetValueOrDefault(tag) ?? EmptyList;
        }

        private HashSet<Tag> _tags;
        private Dictionary<ResourceTrigger.Types.Type, ResourceTrigger>? _triggerByType;

        private ResourceUnit Init()
        {
            _tags = new HashSet<Tag>(tags_);
            if (targetResetDistance_ == 0f)
                targetResetDistance_ = 1.15f * targetAwareDistance_;

            if (deadDestroyDelaySeconds_ != 0f)
                deadDestroyDelay_ = GameBoard.TimeToTicksDuration(deadDestroyDelaySeconds_);

            TypeGroup = Global.TypeGroups.GetValueOrDefault((int)type_);
            
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

        public Types.TypeGroup TypeGroup { get; private set; }
    }
}