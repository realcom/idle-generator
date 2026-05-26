using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources.Interfaces;
using Commons.Utility;
using Google.Protobuf;

namespace Commons.Resources
{
    public partial class ResourceItem : ResourceEntity, ITimeValidityResource, IRelativeItemDataIdGetter
    {
        public override ResourceType ResourceType => ResourceType.Item;
        public override bool IsValid
        {
            get
            {
                var result = !ContainsTag(Tag.Deprecated) && IsValidNow();
                CheckValidPartial(ref result);
                return result;
            }
        }

        private static readonly IReadOnlyList<ResourceItem> EmptyList = Array.Empty<ResourceItem>();
        
        public partial class Types
        {
            public partial class Global
            {
                internal Global Init()
                {
                    DataId ??= new Types.DataId();
                    AvatarConstants ??= new Types.AvatarConstants();
                    return this;
                }
            }
        }
        
        public static Types.Global Global = new();

        private static Dictionary<int, ResourceItem> _itemById = new();
        private static Dictionary<Types.Category, List<ResourceItem>> _itemsByCategory = new();
        private static Dictionary<Types.Type, List<ResourceItem>> _itemsByType = new();
        private static Dictionary<Tag, List<ResourceItem>> _itemsByTag = new();
        private static Dictionary<int, List<ResourceItem>> _itemsByParentId = new();
        private static Dictionary<int, List<ResourceItem>> _itemsByMaterialId = new();
        private static Dictionary<int, List<ResourceItem>> _itemsByGroup = new();

        private static List<ResourceItem> _initialCreateItems = new();
        private static List<ResourceItem> _hasAddStatsItems = new();
        
        public static IEnumerable<ResourceItem> InitialCreateItems => _initialCreateItems;
        public static IEnumerable<ResourceItem> HasAddStatsItems => _hasAddStatsItems;

        private static void Reload(Types.Global global, IList<ResourceItem> items)
        {
            Global = global.Init();

            Reload();
            
            _itemById = items.ToDictionary(i => i.Init().Id);
            _itemsByCategory = items
                .GroupBy(i => i.Category)
                .ToDictionary(g => g.Key, g => g.ToList());
            _itemsByType = items
                .GroupBy(i => i.Type)
                .ToDictionary(g => g.Key, g => g.ToList());
            _itemsByTag = items
                .SelectMany(i => i.Tags.Select(t => (item: i, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.item).ToList());
            _itemsByParentId = items
                .GroupBy(i => i.ParentId)
                .ToDictionary(g => g.Key, g => g.ToList());
            _itemsByMaterialId = items
                .GroupBy(i => i.MaterialId)
                .ToDictionary(g => g.Key, g => g.ToList());
            _itemsByGroup = items
                .GroupBy(i => i.Group)
                .ToDictionary(g => g.Key, g => g.ToList());

            _initialCreateItems = items.Where(i => i.InitialCreate).OrderBy(x =>
            {
                switch (x.Category)
                {
                    case Types.Category.System:
                        return int.MinValue;
                    case Types.Category.SlotRoot:
                        return -(int)x.Category;
                }
                
                return (int)x.Category;
            }).ToList();
            
            _hasAddStatsItems = items.Where(i => i.HasAddStats()).ToList();
            
        }

        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.ItemGlobal, resources.Items);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.ItemGlobal, resources.Items);
        }
        
        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.ItemGlobal.Init();
            //do not call Init() on each item, as it will be done in the runtime logic
            _itemById = resources.Items.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                ItemGlobal = Global,
                Items = { _itemById.Values.OrderBy(i => i.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                ItemGlobal = Global,
                Items = { _itemById.Values.OrderBy(i => i.Id) }
            }.ToByteArray();
        }
        
        public static ResourceItem? Get(int id)
        {
            return _itemById.GetValueOrDefault(id);
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByCategory(ResourceItem.Types.Category category)
        {
            return _itemsByCategory.GetValueOrDefault(category) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByType(ResourceItem.Types.Type type)
        {
            return _itemsByType.GetValueOrDefault(type) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByTag(Tag tag)
        {
            return _itemsByTag.GetValueOrDefault(tag) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByParentId(int parentId)
        {
            return _itemsByParentId.GetValueOrDefault(parentId) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByMaterialId(int materialId)
        {
            return _itemsByMaterialId.GetValueOrDefault(materialId) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByGroup(int group)
        {
            return _itemsByGroup.GetValueOrDefault(group) ?? EmptyList;
        }

        private HashSet<Tag> _tags;
        
        private ResourceItem Init()
        {
            _tags = new HashSet<Tag>(tags_);
            parentId_ = parentId_ == 0 ? id_ : parentId_;
            materialId_ = materialId_ == 0 ? id_ : materialId_;
            productItemDataId_ = productItemDataId_ == 0 ? id_ : productItemDataId_;
            achievementItemDataId_ = achievementItemDataId_ == 0 ? id_ : achievementItemDataId_;
            group_ = group_ == 0 ? id_ : group_;
            dropTtl_ = dropTtl_ <= 0f ? 10f : dropTtl_;
            purchaseUnit_ = Math.Max(1, purchaseUnit_);

            if (bonusCounts_.Count == 0 && bonusCount_ > 0)
                bonusCounts_.Add(bonusCount_);

            if (bonusCount_ == 0 && bonusCounts_.Count == 1)
                bonusCount_ = bonusCounts_[0];
            
            if (bonusItemDataIds_.Count == 0 && bonusItemDataId_ > 0)
                bonusItemDataIds_.Add(bonusItemDataId_);

            if (bonusItemDataId_ == 0 && bonusItemDataIds_.Count == 1)
                bonusItemDataId_ = bonusItemDataIds_[0];
            
            InitUnity();
            return this;
        }

        partial void InitUnity();
        
        public bool ContainsTag(Tag tag)
        {
            return _tags.Contains(tag);
        }
        
        public int GetRankingDate()
        {
            return GetRankingDate(DateTime.UtcNow);
        }
        
        public int GetRankingDate(DateTime date)
        {
            if (StartAt == null || date < StartAt.ToDateTime())
                return 0;
            return 1 + (date - StartAt.ToDateTime()).Days / RankingPeriodDays;
        }
        
        public DateTime GetRankingStartDate(int rankingDate)
        {
            if (StartAt == null)
                return default;
            return StartAt.ToDateTime().AddDays((rankingDate - 1) * RankingPeriodDays);
        }
        
        public DateTime GetRankingEndDate(int rankingDate)
        {
            if (StartAt == null)
                return default;
            return StartAt.ToDateTime().AddDays(rankingDate * RankingPeriodDays);
        }

        public bool HasAddStats()
        {
            return addStats_.Count > 0 || options_.Count > 0;
        }
        
        public bool HasPowerMultiplier()
        {
            return powerAttackMultiplyPercents_.Count > 0 || powerDefenseMultiplyPercents_.Count > 0 || powerHpMultiplyPercents_.Count > 0;
        }

        public bool IsValidNow(bool checkStartAt = true, bool checkUntilAt = true)
        {
            var now = DateTime.UtcNow;
            if (checkStartAt && StartAt != null && StartAt.ToDateTime() > now)
                return false;

            if (checkUntilAt && UntilAt != null && UntilAt.ToDateTime() < now)
                return false;

            return true;
        }

        partial void CheckValidPartial(ref bool result);

        public int GetRelativeItemDataId(string key, int _default = default)
        {
            return relativeItemDataIdGroups_.GetValueOrDefault(key, _default);
        }
    }
}
