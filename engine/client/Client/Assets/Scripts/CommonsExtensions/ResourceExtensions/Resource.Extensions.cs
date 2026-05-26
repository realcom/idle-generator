using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Google.Protobuf.Collections;
using Interfaces;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.Pool;

namespace Commons.Resources
{
    
    public abstract partial class ResourceEntity
    {
        public static ResourceString.Types.Language Language = ResourceString.Types.Language.English;
        public abstract int GetId();
        public abstract ResourceString.Types.Category StringCategory { get; }
        public abstract bool CanDisplay { get; }
        
        public string ClientName { get; private set; }
        protected string _clientDesc;
        public virtual string ClientDesc => _clientDesc;
        public string ClientShortName { get; private set; }
        public string ClientShortDesc { get; private set; }
        public string ClientSeasonClosedDesc { get; private set; }
        public string ClientSeasonOpenDesc { get; private set; }
        public string ClientUnlockToast { get; private set; }
        
        public static void InitLanguage()
        {
            Enum.TryParse(PlatformManager.GetLanguage(), out Language);
        }

        protected virtual void InitEntity(ResourceString.Types.Category stringCategory, int id)
        {
            const string Name = nameof(Name);
            const string Desc = nameof(Desc);
            const string ShortName = nameof(ShortName);
            const string ShortDesc = nameof(ShortDesc);
            const string SeasonClosedDesc = nameof(SeasonClosedDesc);
            const string SeasonOpenDesc = nameof(SeasonOpenDesc);
            const string UnlockToast = nameof(UnlockToast);
            
            ClientName = ResourceString.Get(stringCategory, id, Name, Language);
            _clientDesc = ResourceString.Get(stringCategory, id, Desc, Language);
            ClientShortName = ResourceString.Get(stringCategory, id, ShortName, Language);
            ClientShortDesc = ResourceString.Get(stringCategory, id, ShortDesc, Language);
            ClientSeasonClosedDesc = ResourceString.Get(stringCategory, id, SeasonClosedDesc, Language);
            ClientSeasonOpenDesc = ResourceString.Get(stringCategory, id, SeasonOpenDesc, Language);
            ClientUnlockToast = ResourceString.Get(stringCategory, id, UnlockToast, Language);
            
            
            if (ClientName == Name || ClientName == id.ToString())
                ClientName = $"{stringCategory}_{id}_{Name}";
            if (_clientDesc == Desc || _clientDesc == id.ToString())
                _clientDesc = $"{stringCategory}_{id}_{Desc}";
            if (ClientShortName == ShortName || ClientShortName == id.ToString())
                ClientShortName = $"{stringCategory}_{id}_{ShortName}";
            if (ClientShortDesc == ShortDesc || ClientShortDesc == id.ToString())
                ClientShortDesc = $"{stringCategory}_{id}_{ShortDesc}";
            if (ClientSeasonClosedDesc == SeasonClosedDesc || ClientSeasonClosedDesc == id.ToString())
                ClientSeasonClosedDesc = $"{stringCategory}_{id}_{SeasonClosedDesc}";
            if (ClientSeasonOpenDesc == SeasonOpenDesc || ClientSeasonOpenDesc == id.ToString())
                ClientSeasonOpenDesc = $"{stringCategory}_{id}_{SeasonOpenDesc}";
            if (ClientUnlockToast == UnlockToast || ClientUnlockToast == id.ToString())
                ClientUnlockToast = $"{stringCategory}_{id}_{UnlockToast}";
        }
        
        public abstract bool HasRelevanceNotice();
        
        public string GetLocalizedString(string key, string @default = null)
        {
            if (!GetLocalizedString(out var result, key))
                return @default ?? result;
            return result;
        }
        
        public bool GetLocalizedString(out string result, string key)
        {
            var hasString = ResourceString.Get(out result, StringCategory, GetId(), key, Language);
            if (!hasString)
                result = $"{StringCategory}_{GetId()}_{key}";
            
            return hasString;
        }
        
        public IEnumerable<string> GetLocalizedStrings(string key, int startIndex = 1, int endIndex = int.MaxValue)
        {
            for (var i = startIndex; i <= endIndex; i++)
            {
                var realKey = key + "_" + i;
                if (!GetLocalizedString(out var localized, realKey))
                    break;

                yield return localized;
            }
        }
    
        public IEnumerable<(string, string)> GetLocalizedStrings(string key1, string key2, int startIndex = 1, int endIndex = int.MaxValue)
        {
            using var list1 = PooledList<string>.Get();
            using var list2 = PooledList<string>.Get();

            list1.AddRange(GetLocalizedStrings(key1, startIndex, endIndex));
            list2.AddRange(GetLocalizedStrings(key2, startIndex, endIndex));

            for (var i = 0; i < list1.Count; i++)
            {
                yield return (list1.GetClamped(i), list2.GetClamped(i));
            }
        }
        
    }
    
    public partial class ResourceString
    {
    }
    
}

public static class ResourceEntityExtensions
{
    private static readonly Dictionary<Type, Func<int, ResourceEntity>> resourceGetter = new()
    {
        { typeof(ResourceAchievement), ResourceAchievement.Get },
        { typeof(ResourceBuff), ResourceBuff.Get },
        { typeof(ResourceItem), ResourceItem.Get },
        { typeof(ResourceMap), ResourceMap.Get },
        { typeof(ResourceSkill), ResourceSkill.Get },
        { typeof(ResourceUnit), ResourceUnit.Get },
    };
    
    public static T Get<T>(int Id) where T : ResourceEntity
    {
        if (resourceGetter.TryGetValue(typeof(T), out var getter))
        {
            return getter?.Invoke(Id) as T;
        }

        return null;
    }
    
    public static ResourceEntity Get(ResourceType type, int ID)
    {
        return type switch
        {
            ResourceType.Achievement => ResourceAchievement.Get(ID),
            ResourceType.Buff => ResourceBuff.Get(ID),
            ResourceType.Item => ResourceItem.Get(ID),
            ResourceType.Map => ResourceMap.Get(ID),
            ResourceType.Skill => ResourceSkill.Get(ID),
            ResourceType.Unit => ResourceUnit.Get(ID),
            _ => null
        };
    }
    
}

namespace Commons.Types
{
    public partial class MaterialItem
    {
        public ResourceItem GetData()
        {
            return ResourceItem.Get(id_);
        }
        
        public void ShowAcquisitionablePopup()
        {
            GetData()?.ShowAcquisitionablePopup();
        }
        
        public string ToStringWithIcon(int countMultiplier = 1, bool includeX = false)
        {
            var xString = includeX ? "X " : string.Empty;;       
            return $"{GetData()?.ClientSpriteIconString} {xString}{(count_ * countMultiplier).ToUnitString()}";
        }
        
        private static readonly object[] args = new object[20];
        public string ToStringWithIconFormat(string format = "{0} {1}/{2}", int countMultiplier = 1, float priceMultiplier = 1.0f)
        {
            for (var i = 0; i < args.Length; i++)
            {
                args[i] = "";
            }

            var handHoldCount = MyPlayer.GetValidMaterialCount(id_);
            var requiredCount = (int) (Count * countMultiplier * priceMultiplier);
            
            args[0] = GetData()?.ClientSpriteIconString;
            args[1] = handHoldCount.ToUnitString();
            args[2] = requiredCount.ToUnitString();
            args[3] = handHoldCount;
            args[4] = requiredCount;

            //colorized handHoldCount
            var colorHex = handHoldCount < requiredCount ? CRC.Get().notEnoughColorHex : CRC.Get().enoughColorHex;
            var onlyNotEnoughColorHex = handHoldCount < requiredCount ? CRC.Get().notEnoughColorHex : "FFFFFF";
            args[7] = $"<color=#{onlyNotEnoughColorHex}>{args[1]}</color>";
            args[8] = $"<color=#{onlyNotEnoughColorHex}>{args[2]}</color>";
            args[9] = $"<color=#{colorHex}>{args[1]}</color>";
            
            args[17] = $"<color=#{onlyNotEnoughColorHex}>{args[3]}</color>";
            args[18] = $"<color=#{onlyNotEnoughColorHex}>{args[4]}</color>";
            args[19] = $"<color=#{colorHex}>{args[3]}</color>";
            
            return string.Format(format, args);
        }
    }
    
    public partial class AddItem : IItemModelViewFormatter<AddItem>
    {
        public long Id => 0;
        
        public Sprite GetClientSpriteIcon()
        {
            return GetData()?.ClientSpriteIcon;
        }

        public string FormatCount(string countReplaceText, int unitDigitLimit)
        {
            if (minCount_ == maxCount_)
                return ItemModelViewFormatterExtensions.DefaultFormatCount(GetCount(), countReplaceText, unitDigitLimit);
            
            return $"{minCount_.ToUnitString(unitDigitLimit)}~{maxCount_.ToUnitString(unitDigitLimit)}";
        }

        public string FormatLevel()
        {
            if (minLevel_ == maxLevel_)
                return ItemModelViewFormatterExtensions.DefaultFormatLevel(GetLevel());
            
            return $"{minLevel_}~{maxLevel_}";
        }

        public string GetClientCountString(string countReplaceText = null)
        {
            if (count_ < 2 && !string.IsNullOrEmpty(countReplaceText))
                return countReplaceText;
            
            return Count.ToUnitString();
        }

        public string GetString()
        {
            return GetData().ClientName + " " + GetClientCountString();
        }

        private static readonly StringBuilder m_Builder = new();
        public string GetStringWithIcon()
        {
            m_Builder.Clear();
            m_Builder.AppendFormat("{0} {1}", GetData()?.ClientSpriteIconString, GetClientCountString());
            return m_Builder.ToString();
        }
        
    }
    
    public partial class AddItemGroup
    {
        public string GetString()
        {
            return string.Join(", ", AddItems.Select(x => x.GetString()));
        }
    }

    public static partial class ItemUtility
    {
        public static void Shrink(this IList<AddItemGroupExtensions.PredictionItem> items, bool checkCanDisplay = true)
        {
            using var list = PooledList<AddItemGroupExtensions.PredictionItem>.Get();
            using var indexDict = PooledDictionary<int, int>.Get();
            
            foreach (var predictionItem in items)
            {
                var resItem = predictionItem.GetData()!;
                if (checkCanDisplay && !resItem.CanDisplay)
                    continue;
                
                if (resItem.ContainsTag(Tag.HideFromAcquiredItems))
                    continue;
                
                if (resItem.Unstackable || !resItem.ContainsTag(Tag.CombineCountInDisplay))
                {
                    list.Add(predictionItem);
                }
                else
                {
                    if (indexDict.TryGetValue(resItem.Id, out var index))
                    {
                        var oldItem = list[index];
                        list[index] = new AddItemGroupExtensions.PredictionItem()
                        {
                            ItemDataId = oldItem.ItemDataId,
                            Count = oldItem.Count + predictionItem.Count,
                            Level = Math.Max(oldItem.Level, predictionItem.Level)
                        };
                    }
                    else
                    {
                        indexDict[resItem.Id] = list.Count;
                        list.Add(predictionItem);
                    }
                }
            }
            
            items.Clear();
            items.AddRange(list);
            
        }

        public static void Shrink(this IList<AddItem> items, bool checkCanDisplay = true)
        {
            using var list = PooledList<AddItem>.Get();
            using var indexDict = PooledDictionary<int, int>.Get();
            
            foreach (var addItem in items)
            {
                var resItem = addItem.GetData()!;
                if (checkCanDisplay && !resItem.CanDisplay)
                    continue;
                
                if (resItem.Unstackable)
                {
                    list.Add(addItem.Clone());
                }
                else
                {
                    if (indexDict.TryGetValue(resItem.Id, out var index))
                    {
                        list[index].Count += addItem.Count;
                    }
                    else
                    {
                        indexDict[resItem.Id] = list.Count;
                        list.Add(addItem.Clone());
                    }
                }
            }
            
            items.Clear();
            items.AddRange(list);
        }

        public static void Shrink(this IList<PlayerItemMessage> items, bool checkCanDisplay = true)
        {
            using var list = PooledList<PlayerItemMessage>.Get();
            using var indexDict = PooledDictionary<int, int>.Get();
            
            foreach (var item in items)
            {
                var resItem = ResourceItem.Get(item.ItemDataId)!;
                if (checkCanDisplay && !resItem.CanDisplay)
                    continue;

                if (resItem.ContainsTag(Tag.HideFromAcquiredItems))
                    continue;
                
                if (resItem.Unstackable || !resItem.ContainsTag(Tag.CombineCountInDisplay))
                {
                    list.Add(item.Clone());
                }
                else
                {
                    if (indexDict.TryGetValue(resItem.Id, out var index))
                    {
                        list[index].Count += item.Count;
                    }
                    else
                    {
                        indexDict[resItem.Id] = list.Count;
                        list.Add(item.Clone());
                    }
                }
            }
            
            items.Clear();
            items.AddRange(list);
        }
        
    }
    
    public static partial class AddItemGroupExtensions
    {
        public struct PredictionItem : IItemModelViewFormatter<PredictionItem>
        {
            public int ItemDataId;
            public long Count;
            public int Level;

            public ResourceItem GetData()
            {
                return ResourceItem.Get(ItemDataId);
            }

            public long Id => 0;

            public long GetCount()
            {
                return Count;
            }

            public int GetLevel()
            {
                return Level;
            }

            public PredictionItem Clone()
            {
                return new PredictionItem()
                {
                    ItemDataId = ItemDataId,
                    Count = Count,
                    Level = Level
                };
            }
        }
        
        public static IEnumerable<PredictionItem> GetPredictionItems(this IEnumerable<AddItemGroup> group, 
            long count = 1,
            IRng rng = null)
        {
            using var addedItems = PooledList<PredictionItem>.Get();

            foreach (var addItemGroup in group)
            {
                addedItems.AddRange(addItemGroup.GetPredictionItems(count, rng));
            }

            foreach (var addedItem in addedItems)
            {
                yield return addedItem;
            }
        }

        public static IEnumerable<PredictionItem> GetPredictionItems(this AddItemGroup addItemGroup, 
            long count = 1,
            IRng rng = null,
            float countMultiplier = 1.0f)
        {
            using var addedItems = PooledList<PredictionItem>.Get();

            for (var i = 0; i < count; i++)
            {
                if (addItemGroup.ShouldAddAll)
                {
                    foreach (var item in addItemGroup.AddItems)
                    {
                        addedItems.AddRange(rng != null ? 
                            item.GetPredictionItems((long)(item.GetCount(rng) * countMultiplier), item.GetLevel(rng), rng) : 
                            item.GetPredictionItems((long)(item.GetCount() * countMultiplier), item.Level));
                    }
                }
                else
                {
                    var item = rng != null ? addItemGroup.Sample(rng) : addItemGroup.Sample();
                    if (item == null)
                        continue;

                    addedItems.AddRange(rng != null ? 
                        item.GetPredictionItems((long)(item.GetCount(rng) * countMultiplier), item.GetLevel(rng), rng) : 
                        item.GetPredictionItems((long)(item.GetCount() * countMultiplier), item.Level));
                }
            }
         
            foreach (var addedItem in addedItems)
            {
                yield return addedItem;
            }
        }

        public static IEnumerable<PredictionItem> GetPredictionItems(this AddItem addItem, long count = 1, int level = 1, IRng rng = null)
        {
            if (count <= 0)
                yield break;
            
            using var addedItems = PooledList<PredictionItem>.Get();
            
            var resItem = addItem.GetData();

            if (resItem.Type == ResourceItem.Types.Type.Gacha)
            {
                addedItems.AddRange(resItem.AddItemGroups.GetPredictionItems(count, rng));
            }
            else
            {
                if (resItem.Unstackable)
                {
                    if (count == 1)
                    {
                        addedItems.Add(new PredictionItem()
                        {
                            ItemDataId = resItem.Id,
                            Count = 1,
                            Level = level
                        });
                    }
                    else
                    {
                        for (var i = 0; i < count; i++)
                        {
                            addedItems.AddRange(addItem.GetPredictionItems(1, level, rng));
                        }
                    }
                }
                else
                {
                    var foundIndex = addedItems.FindIndex(x => x.ItemDataId == resItem.Id);
                    if (foundIndex != -1)
                    {
                        var oldItem = addedItems[foundIndex];
                        addedItems[foundIndex] = new PredictionItem()
                        {
                            ItemDataId = oldItem.ItemDataId,
                            Count = oldItem.Count + count,
                            Level = Math.Max(oldItem.Level, level)
                        };
                    }
                    else
                    {
                        addedItems.Add(new PredictionItem()
                        {
                            ItemDataId = resItem.Id,
                            Count = count,
                            Level = level
                        });
                    }
                }
            }

            foreach (var addedItem in addedItems)
            {
                yield return addedItem;
            }
        }

    }
    
}