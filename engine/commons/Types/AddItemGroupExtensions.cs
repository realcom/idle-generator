using System;
using System.Collections.Generic;

namespace Commons.Types
{
    public static partial class AddItemGroupExtensions
    {
        public static IEnumerable<AddItem> Sample(this IEnumerable<AddItemGroup> addItemGroups)
        {
            foreach (var addItemGroup in addItemGroups)
            {
                if (addItemGroup.ShouldAddAll)
                {
                    if (!addItemGroup.CanSampleGroup())
                        continue;

                    foreach (var addItem in addItemGroup.AddItems)
                    {
                        yield return addItem;
                    }
                    
                    continue;
                }
                
                var item = addItemGroup.Sample();
                if (item != null)
                    yield return item;
            }
        }
        
        public static IEnumerable<AddItem> Sample(this IEnumerable<AddItemGroup> addItemGroups, IRng rng)
        {
            foreach (var addItemGroup in addItemGroups)
            {
                if (addItemGroup.ShouldAddAll)
                {
                    if (!addItemGroup.CanSampleGroup(rng))
                        continue;

                    foreach (var addItem in addItemGroup.AddItems)
                    {
                        yield return addItem;
                    }
                    
                    continue;
                }
                
                var item = addItemGroup.Sample(rng);
                if (item != null)
                    yield return item;
            }
        }

        public static IEnumerable<AddItemGroup> FilterByLevel(this IEnumerable<AddItemGroup> addItemGroups, Func<int, int> itemLevelGetter, int levelReferenceItemDataId = 0)
        {
            foreach (var addItemGroup in addItemGroups)
            {
                if (addItemGroup.Level == 0)
                {
                    yield return addItemGroup;
                    continue;
                }

                var referenceItemDataId = levelReferenceItemDataId;
                if (addItemGroup.LevelReferenceItemDataId != 0)
                    referenceItemDataId = addItemGroup.LevelReferenceItemDataId;
                if (referenceItemDataId == 0)
                {
                    yield return addItemGroup;
                    continue;
                }
                
                var level = itemLevelGetter(referenceItemDataId);
                if (addItemGroup.Level == level)
                    yield return addItemGroup;
            }
        }
        
        public static AddItem GetAddItem(this IEnumerable<AddItemGroup> addItemGroups, Func<AddItem, bool>? predicate = null, Func<AddItemGroup, bool>? groupPredicate = null)
        {
            foreach (var addItemGroup in addItemGroups)
            {
                if (groupPredicate?.Invoke(addItemGroup) == false)
                    continue;

                foreach (var addItem in addItemGroup.AddItems)
                {
                    if (predicate is null || predicate(addItem))
                        return addItem;
                }
            }

            return null;
        }

        public static IEnumerable<AddItem> GetAddItems(this IEnumerable<AddItemGroup> addItemGroups, Func<AddItem, bool>? predicate = null, Func<AddItemGroup, bool>? groupPredicate = null)
        {
            foreach (var addItemGroup in addItemGroups)
            {
                if (groupPredicate?.Invoke(addItemGroup) == false)
                    continue;

                foreach (var addItem in addItemGroup.AddItems)
                {
                    if (predicate is null || predicate(addItem))
                        yield return addItem;
                }
            }
        }
        
    }
}
