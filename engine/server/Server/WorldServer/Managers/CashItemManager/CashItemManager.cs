using System.Data;
using Commons;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Utility;
using log4net;
using Server.Managers;
using Server.Models;
using Server.Utility;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager(WorldPlayer.WorldPlayer constructorPlayer) : ICashItemManager
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType!);

    public readonly WorldPlayer.WorldPlayer Player = constructorPlayer;
    
    private readonly Dictionary<long, PlayerItemModel> _itemById = new();
    private readonly Dictionary<int, List<PlayerItemModel>> _itemsByDataId = new();
    private readonly Dictionary<int, List<PlayerItemModel>> _itemsByParentId = new();
    private readonly Dictionary<int, List<PlayerItemModel>> _itemsByMaterialId = new();
    private readonly Dictionary<ResourceItem.Types.Type, List<PlayerItemModel>> _itemsByType = new();
    private readonly Dictionary<ResourceItem.Types.Category, List<PlayerItemModel>> _itemsByCategory = new();
    private readonly Dictionary<Tag, List<PlayerItemModel>> _itemsByTag = new();
    
    private readonly HashSet<PlayerItemModel> _heldUntilAtItems = new();
    
    private readonly List<PlayerItemModel> _createdItems = new();
    
    public IEnumerable<PlayerItemModel> Items => _itemById.Values;

    private bool _updated;
    private bool _dirty;
    public bool ItemsCreated => _createdItems.Count > 0;

    public async Task Init()
    {
        foreach (var item in await PlayerItemModel.GetAllByPlayerIdAsync(Player.Id).ConfigureAwait(false))
        {
            item.CashItemManager = this;
            _itemById[item.id] = item;
            var resItem = item.Data;
            if (resItem == null)
            {
                Logger.Info($"{item.item_data_id} is not exist");
            }
            else
                AddItemToCachedDictionary(resItem, item);
        }
        
        await CreateDefaultItems().ConfigureAwait(false);
        await InitAvatar().ConfigureAwait(false);
        await SetDefaultAvatar().ConfigureAwait(false);
        
        RefreshItemStat();
        RefreshBoosts();
        RefreshTickets();
        
        FixMines();
    }
    
    public Task CreateDefaultItems()
    {

        foreach (var resItem in ResourceItem.InitialCreateItems)
        {
            // initialCreateCount 명시적으로 넣어줘야 함.
            var level = resItem.InitialCreateLevel > 0 ? resItem.InitialCreateLevel : 1;
            var item = GetOrCreateItem(resItem.Id, out var isCreated, resItem.InitialCreateCount,
                level);
            if (isCreated)
                AddItemPostProcess(item, resItem.InitialCreateCount, level);
        }
        return Task.CompletedTask;
    }
    
    public PlayerItemModel? GetItemById(long id)
    {
        var item = _itemById.GetValueOrDefault(id);
        if (item?.deleted == true)
            return null;
        return item;
    }

    public PlayerItemModel? GetItemByDataId(int itemDataId, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return GetItemsByDataId(itemDataId, checkCount, checkUntilAt, checkDeprecated).FirstOrDefault();
    }
    
    public IEnumerable<PlayerItemModel> GetItemsByType(ResourceItem.Types.Type type, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return _itemsByType.GetValueOrDefault(type)?.Where(item =>
        {
            if (item.deleted)
                return false;
            if (checkCount && item.count <= 0)
                return false;
            if (checkUntilAt && item.until_at != null && item.until_at < DateTime.UtcNow)
                return false;
            if (checkDeprecated && item.Data.ContainsTag(Tag.Deprecated))
                return false;
            return true;
        }) ?? Enumerable.Empty<PlayerItemModel>();
    }
    
    public IEnumerable<PlayerItemModel> GetItemsByTag(Tag tag, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return _itemsByTag.GetValueOrDefault(tag)?.Where(item =>
        {
            if (item.deleted)
                return false;
            if (checkCount && item.count <= 0)
                return false;
            if (checkUntilAt && item.until_at != null && item.until_at < DateTime.UtcNow)
                return false;
            if (checkDeprecated && item.Data.ContainsTag(Tag.Deprecated))
                return false;
            return true;
        }) ?? Enumerable.Empty<PlayerItemModel>();
    }
    
    public IEnumerable<PlayerItemModel> GetItemsByCategory(ResourceItem.Types.Category category, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return _itemsByCategory.GetValueOrDefault(category)?.Where(item =>
        {
            if (item.deleted)
                return false;
            if (checkCount && item.count <= 0)
                return false;
            if (checkUntilAt && item.until_at != null && item.until_at < DateTime.UtcNow)
                return false;
            if (checkDeprecated && item.Data.ContainsTag(Tag.Deprecated))
                return false;
            return true;
        }) ?? Enumerable.Empty<PlayerItemModel>();
    }
    
    public IEnumerable<PlayerItemModel> GetItemsByParentId(int parentDataId, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return _itemsByParentId.GetValueOrDefault(parentDataId)?.Where(item =>
        {
            if (item.deleted)
                return false;
            if (checkCount && item.count <= 0)
                return false;
            if (checkUntilAt && item.until_at != null && item.until_at < DateTime.UtcNow)
                return false;
            if (checkDeprecated && item.Data.ContainsTag(Tag.Deprecated))
                return false;
            return true;
        }) ?? Enumerable.Empty<PlayerItemModel>();
    }
    
    public IEnumerable<PlayerItemModel> GetItemsByDataId(int itemDataId, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return _itemsByDataId.GetValueOrDefault(itemDataId)?.Where(item =>
        {
            if (item.deleted)
                return false;
            if (checkCount && item.count <= 0)
                return false;
            if (checkUntilAt && item.until_at != null && item.until_at < DateTime.UtcNow)
                return false;
            if (checkDeprecated && item.Data.ContainsTag(Tag.Deprecated))
                return false;
            return true;
        }) ?? Enumerable.Empty<PlayerItemModel>();
    }

    
    
    public IEnumerable<PlayerItemModel> GetItemsByMaterialId(int materialDataId, bool checkCount = false, bool checkUntilAt = false, bool checkDeprecated = true)
    {
        return _itemsByMaterialId.GetValueOrDefault(materialDataId)?.Where(item =>
        {
            if (item.deleted)
                return false;
            if (checkCount && item.count <= 0)
                return false;
            if (checkUntilAt && item.until_at != null && item.until_at < DateTime.UtcNow)
                return false;
            if (checkDeprecated && item.Data.ContainsTag(Tag.Deprecated))
                return false;
            return true;
        }) ?? Enumerable.Empty<PlayerItemModel>();
    }
    
    public async Task Update()
    {
        try
        {
            await UpdateInternal().ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error($"{Player}.CashItemManager.Update failed", ex);
        }
    }

    private Task UpdateInternal()
    {
        if (RefreshBoostsAt != null && RefreshBoostsAt < DateTime.UtcNow)
            RefreshBoosts();
        if (RefreshTicketsAt < DateTime.UtcNow)
            RefreshTickets();
        return Task.CompletedTask;
    }

    private DateTime _nextUpdatePerMinuteAt = DateTime.UtcNow;
    public async Task UpdatePerMinute()
    {
        var now = DateTime.UtcNow;
        if (now < _nextUpdatePerMinuteAt)
            return;
        
        //floor less than a minute
        now = now.AddMinutes(1);
        now = new DateTime(now.Year, now.Month, now.Day, now.Hour, now.Minute, 0);
        _nextUpdatePerMinuteAt = now;
        
        try
        {
            await UpdatePerMinuteInternal().ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error($"{Player}.CashItemManager.UpdatePerMinute failed", ex);
        }
    }

    private async Task UpdatePerMinuteInternal()
    {
        await UpdateTimeExpiredItems().ConfigureAwait(false);
    }

    private async Task UpdateTimeExpiredItems()
    {
        foreach (var item in _heldUntilAtItems.Where(item =>
                 {
                     if (item.deleted)
                         return false;
                     if (item.Data.ContainsTag(Tag.Deprecated))
                         return false;
                     
                     if (item.until_at > DateTime.UtcNow)
                         return false;
                     if (item.time_expiration_process_at != null && item.time_expiration_process_at >= item.until_at)
                         return false;

                     return true;
                 }))
        {
            await ProcessTimeExpirationInternal(item).ConfigureAwait(false);
            
            Player.PlayerLogManager.Queue(PlayerLogModel.Type.TimeExpiredItem, new
            {
                Item = item.ToMessage(),
            });
        }
    }

    internal PlayerItemUpdate? GetUpdate()
    {
        if (!_updated)
            return null;
        _updated = false;
        
        RefreshAvatar();

        var statDirty = false;
        var boostDirty = false;
        var update = new PlayerItemUpdate();
        foreach (var item in _itemById.Values)
        {
            if (item.Updated)
            {
                item.Updated = false;
                update.Items.Add(item.ToMessage());

                var hasAddStats = item.Data.HasAddStats();
                if (!statDirty && hasAddStats)
                    statDirty = true;
                
                if (!boostDirty && (item.Data.Category == ResourceItem.Types.Category.Boost ||
                                   item.Data.GetGameSpeedMultiplier() > ResourceItem.MinGameSpeedMultiplier))
                    boostDirty = true;
            }
        }

        if (statDirty)
            RefreshItemStat();
        if (boostDirty)
            RefreshBoosts();
        
        return update;
    }
    
    internal async Task Save(IDbConnection db, IDbTransaction transaction)
    {
        if (!_dirty)
            return;
        _dirty = false;
        
        // if (Config.IsDebug)
        //     Logger.Info($"{Player} CashItemManager saving");

        foreach (var item in _itemById.Values)
        {
            if (item.Dirty)
            {
                await item.SaveAsync(db, transaction).ConfigureAwait(false);
                if (Config.IsDebug)
                    Logger.Info($"{Player} Item saved: {item.id} {item.item_data_id}");
            }
        }

        foreach (var item in _createdItems)
        {
            await item.SaveAsync(db, transaction).ConfigureAwait(false);
            _itemById[item.id] = item;
            if (Config.IsDebug)
                Logger.Info($"{Player} Item created: {item.id} {item.item_data_id}");
        }
        _createdItems.Clear();

        await SetDefaultAvatar().ConfigureAwait(false);
        RefreshAvatar();
        await SaveAvatar(db, transaction).ConfigureAwait(false);
    }

    public void SetDirty()
    {
        _updated = true;
        _dirty = true;
        Player.MarkPowerDirty();
    }

    private void AddItemToCachedDictionary(ResourceItem resItem, PlayerItemModel item)
    {
        if (!_itemsByDataId.TryGetValue(resItem.Id, out var items))
        {
            items = new List<PlayerItemModel>();
            _itemsByDataId[resItem.Id] = items;
        }
        items.Add(item);
        if (!_itemsByParentId.TryGetValue(resItem.ParentId, out items))
        {
            items = new List<PlayerItemModel>();
            _itemsByParentId[resItem.ParentId] = items;
        }
        items.Add(item);
        if (!_itemsByMaterialId.TryGetValue(resItem.MaterialId, out items))
        {
            items = new List<PlayerItemModel>();
            _itemsByMaterialId[resItem.MaterialId] = items;
        }
        items.Add(item);
        if (!_itemsByMaterialId.TryGetValue(resItem.MaterialId, out items))
        {
            items = new List<PlayerItemModel>();
            _itemsByMaterialId[resItem.MaterialId] = items;
        }
        items.Add(item);
        if (!_itemsByType.TryGetValue(resItem.Type, out items))
        {
            items = new List<PlayerItemModel>();
            _itemsByType[resItem.Type] = items;
        }
        items.Add(item);
        if (!_itemsByCategory.TryGetValue(resItem.Category, out items))
        {
            items = new List<PlayerItemModel>();
            _itemsByCategory[resItem.Category] = items;
        }
        items.Add(item);
        
        foreach (var resItemTag in resItem.Tags)
        {
            if (!_itemsByTag.TryGetValue(resItemTag, out items))
            {
                items = new List<PlayerItemModel>();
                _itemsByTag[resItemTag] = items;
            }
            items.Add(item);
        }

        if (item.until_at != null)
            _heldUntilAtItems.Add(item);

    }

    public StatusCode TryConsumeMaterials(
        out IEnumerable<(PlayerItemModel, int)> selectedMaterialItemModels,
        MaterialItemGroup? materialItemGroup,
        IEnumerable<PlayerItemModel>? selectedMaterialItems = null,
        int count = 1,
        float priceMultiplier = 1f)
    {
        selectedMaterialItemModels = [];
        if (materialItemGroup == null)
            return StatusCode.BadRequest;

        return TryConsumeMaterials(out selectedMaterialItemModels, [materialItemGroup], selectedMaterialItems, count, priceMultiplier);
    }

    public StatusCode TryConsumeMaterials(
        out IEnumerable<(PlayerItemModel, int)> selectedMaterialItemModels,
        IEnumerable<MaterialItemGroup> materialItemGroups,
        IEnumerable<PlayerItemModel>? selectedMaterialItems = null,
        int count = 1,
        float priceMultiplier = 1f)
    {
        var selectedMaterialItemsByMaterialId = selectedMaterialItems?.GroupBy(i => i.Data.MaterialId)
            .ToDictionary(g => g.Key, g => g.ToList()) ?? new Dictionary<int, List<PlayerItemModel>>();
        var selectedModels = new Dictionary<long, (PlayerItemModel, int)>();
        selectedMaterialItemModels = [];

        foreach (var materialItemGroup in materialItemGroups)
        {
            var groupSatisfied = materialItemGroup.ShouldAllValid;

            foreach (var materialItem in materialItemGroup.MaterialItems)
            {
                var itemSatisfied = false;
                var requiredCount = (int)(materialItem.Count * count * priceMultiplier);
                foreach (var resourceItem in ResourceItem.GetAllByMaterialId(materialItem.Id))
                {
                    if (resourceItem.Unstackable)
                    {
                        var allSatisfied = true;
                        for (var i = 0; i < requiredCount; i++)
                        {
                            if (!HasEnoughMaterial(materialItem, 1))
                            {
                                allSatisfied = false;
                                break;
                            }
                        }

                        if (allSatisfied)
                        {
                            itemSatisfied = true;
                            break;
                        }
                    }
                    else
                    {
                        if (HasEnoughMaterial(materialItem, requiredCount))
                        {
                            itemSatisfied = true;
                            break;
                        }
                    }
                }

                if (materialItemGroup.ShouldAllValid)
                {
                    if (!itemSatisfied)
                    {
                        return StatusCode.ItemNotEnough;
                    }
                }
                else
                {
                    if (itemSatisfied)
                    {
                        groupSatisfied = true;
                        break;
                    }
                }
            }

            if (!groupSatisfied)
            {
                return StatusCode.ItemNotEnough;
            }
        }

        selectedMaterialItemModels = selectedModels.Values.ToList();
        return StatusCode.Ok;

        bool HasEnoughMaterial(MaterialItem materialItem, int requiredCount)
        {
            PlayerItemModel? materialItemModel = null;

            if (selectedMaterialItemsByMaterialId.TryGetValue(materialItem.Id, out var preSelectedModels))
            {
                materialItemModel = preSelectedModels.FirstOrDefault(item => materialItem.IsValid(item, requiredCount));
                if (materialItemModel != null)
                    preSelectedModels.Remove(materialItemModel);
            }

            if (materialItemModel == null)
            {
                foreach (var itemModel in GetItemsByMaterialId(materialItem.Id))
                {
                    var resItem = itemModel.Data;
                    if (resItem.Unstackable && selectedModels.ContainsKey(itemModel.id))
                        continue;

                    if (!materialItem.IsValid(itemModel, requiredCount))
                        continue;
                    materialItemModel = itemModel;
                    break;
                }
            }

            if (materialItemModel == null)
                return false;
            
            var (_, prevRequiredCount) = selectedModels.GetValueOrDefault(materialItemModel.id);

            var removalStatus = CanRemoveItem(materialItemModel, prevRequiredCount + requiredCount);
            if (!removalStatus.IsSuccess())
                return false;

            if (selectedModels.ContainsKey(materialItemModel.id))
            {
                var current = selectedModels[materialItemModel.id];
                selectedModels[materialItemModel.id] = (materialItemModel, current.Item2 + requiredCount);
            }
            else
            {
                selectedModels.Add(materialItemModel.id, (materialItemModel, requiredCount));
            }
            return true;
        }
    }

    public int GetItemLevelWithBonusLevel(int itemDataId)
    {
        return GetItemLevelWithBonusLevel(itemDataId, level: 1);
    }

    public int GetItemLevelWithBonusLevel(int itemDataId, int level)
    {
        return GetOrCreateItem(itemDataId, out _, level: level).level
               + GetItemsByTag(Tag.BonusItemLevel, checkCount: true, checkUntilAt: true, checkDeprecated: true)
                   .Where(item => item.Data.TargetItemDataIds.Contains(itemDataId))
                   .Sum(x => x.Data.BonusItemLevel);
    }

    public StatusCode ValidationAchievements(ResourceItem? resItem, StatusCode badStatusCode = StatusCode.BadRequest)
    {
        if (resItem == null)
            return badStatusCode;
        
        foreach (var achievementDataId in resItem.RequiredAchievementDataIds)
        {
            if (!Player.AchievementManager.IsAchievementCompleted(achievementDataId))
                return badStatusCode;
        }
        foreach (var achievementDataId in resItem.ExclusiveAchievementDataIds)
        {
            if (Player.AchievementManager.IsAchievementCompleted(achievementDataId))
                return badStatusCode;
        }
        foreach (var itemDataId in resItem.RequiredItemDataIds)
        {
            if (GetItemByDataId(itemDataId, checkCount: true, checkUntilAt: true, checkDeprecated: true) == null)
                return badStatusCode;
        }
        foreach (var itemDataId in resItem.ExclusiveItemDataIds)
        {
            if (GetItemByDataId(itemDataId, checkCount: true, checkUntilAt: true, checkDeprecated: true) != null)
                return badStatusCode;
        }
        foreach (var tag in resItem.RequiredItemTags)
        {
            if (!GetItemsByTag(tag, checkCount: true, checkUntilAt: true, checkDeprecated: true).Any())
                return badStatusCode;
        }
        foreach (var tag in resItem.ExclusiveItemTags)
        {
            if (GetItemsByTag(tag, checkCount: true, checkUntilAt: true, checkDeprecated: true).Any())
                return badStatusCode;
        }

        return StatusCode.Ok;
    }

}
