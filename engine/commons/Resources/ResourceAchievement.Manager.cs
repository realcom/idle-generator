using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources.Interfaces;
using Commons.Utility;
using Google.Protobuf;
using static Commons.Resources.ResourceAchievement.Types;

namespace Commons.Resources
{
    public partial class ResourceAchievement : ResourceEntity, ITimeValidityResource
    {
        public override ResourceType ResourceType => ResourceType.Achievement;
        public override bool IsValid => !ContainsTag(Tag.Deprecated) && IsValidNow();
        
        private static readonly IReadOnlyList<ResourceAchievement> EmptyList = Array.Empty<ResourceAchievement>();
        
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
        
        public readonly struct ConditionQuery
        {
            public enum Comparer
            {
                None = 0,
                Equal,
                GreaterOrEqual,
                LessOrEqual,
            }

            public static (int, int) GetRange(IList<int> list, int value, Comparer comparer)
            {
                return comparer switch
                {
                    Comparer.None => (0, list.Count - 1),
                    Comparer.Equal => (list.BinarySearchLeft(value), list.BinarySearchRight(value)),
                    Comparer.GreaterOrEqual => (0, list.BinarySearchRight(value)),
                    Comparer.LessOrEqual => (list.BinarySearchLeft(value), list.Count - 1),
                    _ => throw new ArgumentOutOfRangeException(nameof(comparer)),
                };
            }
        
            public readonly Condition Condition;
            public readonly int ConditionValue1;
            public readonly Comparer ConditionComparer1;
            public readonly int ConditionValue2;
            public readonly Comparer ConditionComparer2;
            
            public ConditionQuery(Condition condition) : this()
            {
                Condition = condition;
            }
            
            public ConditionQuery(Condition condition, Comparer conditionComparer1, int conditionValue1) : this()
            {
                Condition = condition;
                ConditionValue1 = conditionValue1;
                ConditionComparer1 = conditionComparer1;
            }
            
            public ConditionQuery(Condition condition,
                Comparer conditionComparer1, int conditionValue1,
                Comparer conditionComparer2, int conditionValue2)
            {
                Condition = condition;
                ConditionValue1 = conditionValue1;
                ConditionComparer1 = conditionComparer1;
                ConditionValue2 = conditionValue2;
                ConditionComparer2 = conditionComparer2;
            }
        }
        
        public static Global Global = new();
        
        private static Dictionary<int, ResourceAchievement> _achievementById = new();
        private static Dictionary<Types.Type, List<ResourceAchievement>> _achievementsByType = new();
        private static Dictionary<Tag, List<ResourceAchievement>> _achievementsByTag = new();
        private static Dictionary<Condition, SortedList<int, SortedList<int, List<ResourceAchievement>>>> _achievementsByCondition = new();

        public static IEnumerable<ResourceAchievement> Achievements => _achievementById.Values;

        private static void Reload(Global global, IList<ResourceAchievement> achievements)
        {
            Global = global.Init();
            
            Reload();
            
            _achievementById = achievements.ToDictionary(a => a.Init().Id);
            _achievementsByType = achievements
                .GroupBy(a => a.Type)
                .ToDictionary(g => g.Key, g => g.ToList());
            _achievementsByTag = achievements
                .SelectMany(i => i.Tags.Select(t => (item: i, tag: t)))
                .GroupBy(x => x.tag)
                .ToDictionary(g => g.Key, g => g.Select(x => x.item).ToList());
            var achievementsByCondition = new Dictionary<Condition, SortedList<int, SortedList<int, List<ResourceAchievement>>>>();
            foreach (var achievement in achievements)
            {
                if (!achievementsByCondition.TryGetValue(achievement.Condition, out var conditionValues))
                {
                    conditionValues = new SortedList<int, SortedList<int, List<ResourceAchievement>>>();
                    achievementsByCondition[achievement.Condition] = conditionValues;
                }
                if (!conditionValues.TryGetValue(achievement.ConditionValue1, out var value2Achievements))
                {
                    value2Achievements = new SortedList<int, List<ResourceAchievement>>();
                    conditionValues[achievement.ConditionValue1] = value2Achievements;
                }
                if (!value2Achievements.TryGetValue(achievement.ConditionValue2, out var achievementsList))
                {
                    achievementsList = new List<ResourceAchievement>();
                    value2Achievements[achievement.ConditionValue2] = achievementsList;
                }
                achievementsList.Add(achievement);
            }
            _achievementsByCondition = achievementsByCondition;
        }

        static partial void Reload();

        public static void ReloadJson(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Reload(resources.AchievementGlobal, resources.Achievements);
        }
        
        public static void ReloadBinary(byte[] bytes)
        {
            var resources = Resources.Parser.ParseFrom(bytes);
            Reload(resources.AchievementGlobal, resources.Achievements);
        }
        
        public static byte[] ReloadJsonToBinarySerialize(string json)
        {
            var resources = Config.JsonParser.Parse<Resources>(json);
            Global = resources.AchievementGlobal.Init();
            //do not call Init() on each achievement, as it will be done in the runtime logic
            _achievementById = resources.Achievements.ToDictionary(i => i.Id);

            return FormatBinary();
        }

        public static string FormatJson()
        {
            return new Resources
            {
                AchievementGlobal = Global,
                Achievements = { _achievementById.Values.OrderBy(a => a.Id) }
            }.FormatJson();
        }
        
        public static byte[] FormatBinary()
        {
            return new Resources
            {
                AchievementGlobal = Global,
                Achievements = { _achievementById.Values.OrderBy(a => a.Id) }
            }.ToByteArray();
        }
        
        public static ResourceAchievement? Get(int id)
        {
            return _achievementById.GetValueOrDefault(id);
        }

        public static IReadOnlyList<ResourceAchievement> GetAllByType(Types.Type type)
        {
            return _achievementsByType.GetValueOrDefault(type) ?? EmptyList;
        }
        
        public static IReadOnlyList<ResourceAchievement> GetAllByTag(Tag tag)
        {
            return _achievementsByTag.GetValueOrDefault(tag) ?? EmptyList;
        }
        
        public static IEnumerable<ResourceAchievement> GetAllByCondition(Condition condition)
        {
            if (!_achievementsByCondition.TryGetValue(condition, out var conditionValues))
                return EmptyList;
            return conditionValues.Values.SelectMany(value2Achievements => value2Achievements.Values.SelectMany(achievements => achievements));
        }
        
        public static IEnumerable<ResourceAchievement> GetAllByConditionQuery(ConditionQuery query)
        {
            if (!_achievementsByCondition.TryGetValue(query.Condition, out var conditionValues))
                yield break;
            var (value1IndexLeft, value1IndexRight) = ConditionQuery.GetRange(conditionValues.Keys, query.ConditionValue1, query.ConditionComparer1);
            for (var value1Index = value1IndexLeft; value1Index <= value1IndexRight; ++value1Index)
            {
                var value2Achievements = conditionValues.Values[value1Index];
                var (value2IndexLeft, value2IndexRight) = ConditionQuery.GetRange(value2Achievements.Keys, query.ConditionValue2, query.ConditionComparer2);
                for (var value2Index = value2IndexLeft; value2Index <= value2IndexRight; ++value2Index)
                {
                    var achievements = value2Achievements.Values[value2Index];
                    foreach (var achievement in achievements)
                        yield return achievement;
                }
            }
        }

        private HashSet<Tag> _tags;
        private ResourceAchievement Init()
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

        public bool IsValidNow(bool checkStartAt = true, bool checkUntilAt = true)
        {
            var now = DateTime.UtcNow;
            if (checkStartAt && StartAt != null && StartAt.ToDateTime() > now)
                return false;
            if (checkUntilAt && UntilAt != null && UntilAt.ToDateTime() < now)
                return false;

            return true;
        }
    }
}
