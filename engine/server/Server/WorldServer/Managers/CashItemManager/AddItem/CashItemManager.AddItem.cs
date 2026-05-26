using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Events;
using Server.Models;
using Server.Stuffs;
using static Commons.Resources.ResourceItem.Types.Category;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private PlayerItemModel CreateItem(int itemDataId, long count = 1, int level = 0, TimeSpan? duration = null)
    {
        var resItem = ResourceItem.Get(itemDataId);
        if (resItem == null)
            throw new ArgumentException($"Invalid itemDataId: {itemDataId}");
        
        if (level <= 0)
            level = 1;
        
        var item = new PlayerItemModel(Player.Id, itemDataId, count, level, duration == null ? null : GetDate(duration.Value) + duration);
        item.CashItemManager = this;
        _createdItems.Add(item);
        AddItemToCachedDictionary(resItem, item);

        SetDirty();
        
        return item;
    }

    private PlayerItemModel GetOrCreateItem(int itemDataId, out bool isCreated, long count = 1, int level = 0 )
    {
        var item = GetItemByDataId(itemDataId);
        isCreated = item == null;
        return item ?? CreateItem(itemDataId, count, level);
    }

    private PlayerItemModel? GetOrCreateItemIfValid(int itemDataId, long count = 1, int level = 0)
    {
        if (ResourceItem.Get(itemDataId) == null)
            return null;
        return GetOrCreateItem(itemDataId, out _, count, level);
    }

    private void AddAddedItemMessage(PlayerItemModel itemModel, int itemDataId, long count, int level,
        IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (addedItemStuffs == null)
            return;
        var stuff = addedItemStuffs.FirstOrDefault(m => m.item.ItemDataId == itemDataId);
        if (stuff == default)
            addedItemStuffs.Add(new (itemModel, new PlayerItemMessage()
            {
                ItemDataId = itemDataId,
                Count = count,
                Level = level,
            }));
        else
        {
            stuff.item.Count += count;
            stuff.item.Level = Math.Max(stuff.item.Level, level);
        }
    }

    internal void AddItemPostProcess(PlayerItemModel item, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resItem = item.Data;
        
        switch (resItem.Category)
        {
            case Unit:
            {
                AddItemPostProcessUnit(item, count, level, duration, addedItems, addedItemStuffs);
                break;
            }

            case GamePass:
            {
                AddItemPostProcessGamePass(item, count, level, duration, addedItems, addedItemStuffs);
                break;
            }

            case Utility:
            {
                AddItemPostProcessUtility(item, count, level, duration, addedItems, addedItemStuffs);
                break;
            }
            case Pet:
            {
                AddItemPostProcessPet(item, count, level, duration, addedItems, addedItemStuffs);
                break;
            }
            case Product:
            {
                AddItemPostProcessProduct(item, count, level, duration, addedItems, addedItemStuffs);
                break;
            }
        }
        
        Player.PublishEvent(new ItemAddedEvent
        {
            Item = item,
            Count = count,
            Level = level,
            Duration = duration,
            AddedItemStuffs = addedItemStuffs,
        });
    }

    public StatusCode AddItem(PlayerMailAddItem mailAddItem, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        TimeSpan? duration = null;
        if (mailAddItem.ItemDays != 0 || mailAddItem.ItemHours != 0)
            duration = new TimeSpan(mailAddItem.ItemDays, mailAddItem.ItemHours, 0, 0);
        
        var option = mailAddItem.ItemOption;
        var addedItems = option == null ? null : new List<PlayerItemModel>();
        
        var statusCode = AddItem(mailAddItem.ItemDataId, mailAddItem.ItemCount, mailAddItem.ItemLevel, duration,
            addedItems: addedItems, addedItemStuffs: addedItemStuffs);
            
        if (option != null && addedItems!.Count == 1)
        {
            using var optionScope = addedItems[0].GetOptionScope();
            optionScope.OverrideOption(option);
        }
        
        return statusCode;
    }
    
    public StatusCode AddItem(int itemDataId, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null, long exp = 0, IRng? rng = null)
    {
        if (count <= 0)
            return StatusCode.Ok;
        if (level <= 0)
            level = 1;

        var resItem = ResourceItem.Get(itemDataId);
        if (resItem == null)
            return StatusCode.BadRequest;

        switch (resItem.Type)
        {
            case ResourceItem.Types.Type.Gacha:
            case ResourceItem.Types.Type.Bundle:
            {
                var addItemGroups = resItem.AddItemGroups
                    .FilterByLevel(GetItemLevelWithBonusLevel, resItem.AddItemLevelReferenceItemDataId).ToList();
                return AddItem(addItemGroups, count, addedItems, addedItemStuffs, rng: rng);
            }
        }

        if (resItem.Unstackable)
        {
            if (count == 1)
            {
                var item = CreateItem(itemDataId, level: level, duration: duration);
                AddExp(item, exp);
                addedItems?.Add(item);
                addedItemStuffs?.Add(new(item, item.ToMessage()));
                AddItemPostProcess(item, count, level, duration, addedItems, addedItemStuffs);
            }
            else
            {
                for (var i = 0; i < count; i++)
                {
                    var status = AddItem(itemDataId, 1, level, duration, addedItems, addedItemStuffs, rng: rng);
                    if (i == 0 && !status.IsSuccess())
                        return status;
                }
            }
        }
        else
        {
            var item = GetOrCreateItem(itemDataId, out var created, 0, level);
            var hasLevelChangeRequest = level > 1;
            
            //생성 시점에 count 처리 분기 (count가 0으로 시작하는 아이템을 위해)
            if (created)
            {
                item.count += count;
                
                //해당 태그 보유한 아이템은 생성 처리에 카운트 하나 소모
                if (resItem.ContainsTag(Tag.EachProcessCreateAndAdd))
                    item.count--;
            }
            else if (!hasLevelChangeRequest)
            {
                item.count += count;
            }

            if (resItem.MaxCount > 0 && item.count > resItem.MaxCount)
            {
                var remainedCount = (int)(item.count - resItem.MaxCount);
                item.count = resItem.MaxCount;

                if (remainedCount > 0 && resItem.ContainsTag(Tag.AddParam1ToCount))
                    item.param1 += remainedCount;
            }
            
            var levelDiff = level - item.level;
            item.level = Math.Max(item.level, level);
            if (levelDiff > 0)
            {
                Player.PublishEvent(new ItemLevelUpEvent()
                {
                    Item = item,
                    Count = levelDiff,
                });
            }
            
            if (duration != null)
            {
                var baseDate = GetDate(duration.Value);
                
                duration *= count;
                if (item.until_at == null)
                    item.until_at = baseDate + duration;
                else
                    item.until_at = DateTimeExtensions.Max(item.until_at.Value, baseDate) + duration;
                
                _heldUntilAtItems.Add(item);
            }
            AddExp(item, exp);
            addedItems?.Add(item);
            AddAddedItemMessage(item, itemDataId, count, level, addedItemStuffs);
            AddItemPostProcess(item, count, level, duration, addedItems, addedItemStuffs);
        }
        
        return StatusCode.Ok;
    }
    
    public StatusCode AddItem(AddItem addItem,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        return AddItem(addItem.ItemDataId, addItem.GetCount(), addItem.GetLevel(), addItem.GetDuration(), addedItems, addedItemStuffs);
    }
    
    public StatusCode AddItem(AddItemGroup addItemGroup, long count = 1,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null, IRng? rng = null, Action<AddItem, long>? onItemAdded = null)
    {
        for (var i = 0; i < count; i++)
        {
            if (addItemGroup.ShouldAddAll)
            {
                var canSampleGroup = rng != null ? addItemGroup.CanSampleGroup(rng) : addItemGroup.CanSampleGroup();
                if (!canSampleGroup)
                    continue;

                foreach (var item in addItemGroup.AddItems)
                {
                    var status = rng != null ? 
                        AddItem(item.ItemDataId, item.GetCount(rng), item.GetLevel(rng), item.GetDuration(), addedItems, addedItemStuffs, item.GetExp(rng), rng) : 
                        AddItem(item.ItemDataId, item.GetCount(), item.GetLevel(), item.GetDuration(), addedItems, addedItemStuffs, item.GetExp());
                    if (!status.IsSuccess())
                        return status;    
                }
            }
            else
            {
                var item = rng != null ? addItemGroup.Sample(rng) : addItemGroup.Sample();
                if (item == null)
                    continue;

                var calculatedCount = rng != null ? item.GetCount(rng) : item.GetCount();
                var calculatedLevel = rng != null ? item.GetLevel(rng) : item.GetLevel();
                var calculatedExp = rng != null ? item.GetExp(rng) : item.GetExp();

                var status = AddItem(item.ItemDataId, calculatedCount, calculatedLevel, item.GetDuration(), addedItems,
                    addedItemStuffs, calculatedExp, rng);
                onItemAdded?.Invoke(item, calculatedCount);
                if (!status.IsSuccess())
                    return status;    
            }
            
        }
        
        return StatusCode.Ok;
    }
    
    public StatusCode AddItem(IList<AddItemGroup> addItemGroups, long count = 1,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null, IRng? rng = null, Action<AddItem, long>? onItemAdded = null)
    {
        for (var i = 0; i < addItemGroups.Count; ++i)
        {
            var addItemGroup = addItemGroups[i]!;
            var status = AddItem(addItemGroup, count, addedItems, addedItemStuffs, rng, onItemAdded);
            if (!status.IsSuccess())
                return status;
        }
        return StatusCode.Ok;
    }

    private DateTime GetDate(TimeSpan duration)
    {
        //Day 이상 지급은 다음날 자정으로 Ceiling 후 계산
        return duration.Days > 0 ? DateTime.UtcNow.AddDays(1).Date : DateTime.UtcNow;
    }
    
}
