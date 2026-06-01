using System;
using System.Buffers;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Google.Protobuf.Collections;
using JetBrains.Annotations;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.SocialPlatforms.Impl;
using ZLinq;


public static class MyPlayer
{
    public static BoardPlayerMessage BoardPlayer
    {
        get
        {
            if (_boardPlayer == null || !GameBoardManager.Get().gameBoard.Equals(_boardPlayer.Board))
            {
                _boardPlayer = GameBoardManager.Get()?.gameBoard.GetPlayerById(Player.Id);
            }

            return _boardPlayer;
        }
    } // GameBoardManager.Get()?.gameBoard.GetPlayerById(Player.Id);
    
    [NotNull]
    public static PlayerMessage Player
    {
        get => _player;
        set
        {
            _player = value;
            GameManager.Get().DispatchEvent(GameEventType.MyPlayerUpdated);
        }
    }

    public static WorldMessage World = null;

    private static GameBoard _myGameBoard;
    
    private static Commons.Packets.Requests.GetBoardRequest.Types.Response _myGameBoardResponse;
    
    //
    public static GameBoard GameBoard => _myGameBoard;

    public static GameUnit GameUnit =>
        GameBoardManager.Get()?.gameBoard?.GetUnitByPlayerId(_player?.Id ?? 0) ?? new GameUnit
        {
            Position = new Vector2Message(),
            Direction = new Vector2Message(),
        };

    public static Commons.Packets.Requests.GetBoardRequest.Types.Response GameBoardResponse => _myGameBoardResponse;

    public static readonly UnitStat PlayerItemStat = new();
    public static readonly ClientUnitStat PlayerUnitStat = new();
    
    public static List<PlayerItemMessage> ResultRewardItems = new();

    public static PlayerAvatar PlayerAvatar
    {
        get => _playerAvatar;
        private set
        {
            _playerAvatar = value;
            
            ShouldUpdateMyPlayerGameUnit = true;
        }
    }

    public static int PlayerLevel
    {
        get => _playerLevel;
        private set
        {
            if (_playerLevel == 0 || _playerLevel < value)
                _playerLevel = value;

            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MY_PLAYER_LEVEL_UP));

            ShouldUpdateMyPlayerGameUnit = true;
            ShouldUpdateMyPlayerHUD = true;
        }
    }

    public static float PlayerExp
    {
        get => _playerExp;
        private set
        {
            _playerExp = value;
            ShouldUpdateMyPlayerHUD = true;
        }
    }

    public static float PlayerRequiredExp
    {
        get => _playerRequiredExp;
        private set
        {
            _playerRequiredExp = value;
            ShouldUpdateMyPlayerHUD = true;
        }
    }

    public static long PlayerCredit
    {
        get => _playerCredit;
        private set
        {
            _playerCredit = value;
            ShouldUpdateMyPlayerHUD = true;
        }
    }

    public static long PlayerRuby => PlayerPurchasedRuby + PlayerFreeRuby;

    public static float GameSpeedMultiplier { get; private set; } = ResourceItem.MinGameSpeedMultiplier;

    public static long PlayerPurchasedRuby
    {
        get => _playerPurchasedRuby;
        private set
        {
            _playerPurchasedRuby = value;
            ShouldUpdateMyPlayerHUD = true;
        }
    }

    public static long PlayerFreeRuby
    {
        get => _playerFreeRuby;
        private set
        {
            _playerFreeRuby = value;
            ShouldUpdateMyPlayerHUD = true;
        }
    }

    private static BoardPlayerMessage _boardPlayer;
    private static PlayerMessage _player = new();
    
    private static long _playerFreeRuby;
    private static long _playerPurchasedRuby;
    private static long _playerCredit;
    private static float _playerRequiredExp;
    private static float _playerExp;
    private static int _playerLevel;
    private static PlayerAvatar _playerAvatar;

    //
    public static bool ShouldUpdateReplaceBoard;
    public static bool ShouldUpdateMyPlayerGameUnit;
    public static bool ShouldUpdateGameboardAchievements;
    public static bool ShouldUpdateMyPlayerHUD; // check if this should be divided into flags
    
    private static readonly Dictionary<long, PlayerItemMessage> _items = new ();
    private static readonly Dictionary<ResourceItem.Types.Category, Dictionary<long, PlayerItemMessage>> _itemsByCategory = new ();
    private static readonly Dictionary<ResourceItem.Types.Type, Dictionary<long, PlayerItemMessage>> _itemsByType = new ();
    private static readonly Dictionary<Tag, Dictionary<long, PlayerItemMessage>> _itemsByTag = new ();
    private static readonly Dictionary<int, Dictionary<long, PlayerItemMessage>> _itemsByMaterialId = new ();
    private static readonly Dictionary<int, PlayerItemMessage> _itemsByDataID = new ();
    
    private static readonly Dictionary<int, PlayerAchievementMessage> _achievementsByDataID = new ();
    private static readonly Dictionary<ResourceAchievement.Types.Type, Dictionary<int, PlayerAchievementMessage>> _achievementsByType = new ();
    private static readonly Dictionary<Tag, Dictionary<int, PlayerAchievementMessage>> _achievementsByTag = new ();
    private static readonly Dictionary<ResourceAchievement.Types.Condition, Dictionary<int, PlayerAchievementMessage>> _achievementsByCondition = new ();
    
    public static Dictionary<long, long> tempAccDamage = new();

    public static void SetGameBoardResponse(Commons.Packets.Requests.GetBoardRequest.Types.Response gameBoardResponse)
    {
        _myGameBoardResponse = gameBoardResponse;
        
        GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.GAMEBOARD_HASH_UPDATED));
    }
    
    public static void SetGameBoard(GameBoard gameBoard)
    {
        _myGameBoard = gameBoard;
        gameBoard.CacheResMap();
        ShouldUpdateMyPlayerGameUnit = true;
        ResultRewardItems.Clear();
        GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.GAMEBOARD_UPDATED));
    }

    public static GameBoard SetGameBoardLocal(int dataId)
    {
        var localBoard = new GameBoard(true)
        {
            DataId = dataId, // resMap dataId
            Id = -dataId
        };

        SetGameBoard(localBoard);
        return localBoard;
    }
    
    // public static void SetGameUnit(GameUnit gameUnit)
    // {
    //     _myGameUnit = gameUnit;
    // }
    
    public static void CacheLevel(int level)
    {
        var prevLevel = PlayerLevel;
        PlayerLevel = level;
    }

    private static int _cachedAvatarDefenseUnitsCount;
    public static bool HasDefenseUnitNotice;
    private static int _cachedAvatarOffenseUnitsCount;
    public static bool HasOffenseUnitNotice;

    public static void CacheAvatar(PlayerAvatar avatar)
    {
        PlayerAvatar = avatar;

        var defenseCount = PlayerAvatar.DefenseUnits.Count(x => x != null && x.ItemDataId != default && GetItem(x.Id) is { Count: > 0 });
        if (_cachedAvatarDefenseUnitsCount != defenseCount)
        {
            if (_cachedAvatarDefenseUnitsCount != 0)
                HasDefenseUnitNotice = true; // false is set in Page_Conquest - formation
            
            _cachedAvatarDefenseUnitsCount = defenseCount;
        }
        
        var offenseCount = PlayerAvatar.OffenseUnits.Count(x => x != null && x.ItemDataId != default && GetItem(x.Id) is { Count: > 0 });
        if (_cachedAvatarOffenseUnitsCount != offenseCount)
        {
            if (_cachedAvatarOffenseUnitsCount != 0)
                HasOffenseUnitNotice = true; // false is set in Page_Conquest - formation
            
            _cachedAvatarOffenseUnitsCount = offenseCount;
        }
        
        GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MY_PLAYER_AVATAR_UPDATED));
        
        RecalculateStats();
    }

    private static readonly ClientUnitStat _oldPlayerUnitStat = new();

    private static void RecalculateStats()
    {
        PlayerUnitStat.CopyTo(_oldPlayerUnitStat);
        PlayerUnitStat.Clear();
        
        PlayerItemStat.Clear();
        
        PlayerItemModelExtensions.ApplyItemStats(id => GetItemByDataID(id, true), PlayerItemStat);
        PlayerItemStat.CopyTo(PlayerUnitStat);
        _playerAvatar.ApplyAvatarStats(PlayerUnitStat);
        _playerAvatar.ApplyAvatarEquipBuffStats(PlayerUnitStat);
        
        PlayerUnitStat.ClearGameplayStats();

        if (PlayerUnitStat != _oldPlayerUnitStat)
        {
            // ShouldUpdateMyPlayerGameUnit = true;
            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MY_STATS_UPDATED));    
        }
    }

    // public static void SyncGameUnitFromCache()
    // {
    //     var prevLevel = _myGameUnit.Level;
    //     
    //     _myGameUnit.PlayerAvatar = PlayerAvatar;
    //     _myGameUnit.DataId = ResourceItem.Get(PlayerAvatar.Character.ItemDataId)!.UnitDataId;
    //     
    //     _myGameUnit.Level = PlayerLevel;
    //     _myGameUnit.SetStatDirty();
    //     
    //     GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MY_STATS_UPDATED));
    //     
    //     if (prevLevel != 0 && prevLevel < PlayerLevel)
    //         GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MY_PLAYER_LEVEL_UP));
    // }
    
    public static void OverrideItems(RepeatedField<PlayerItemMessage> items)
    {
        _items.Clear();
        _itemsByCategory.Clear();
        _itemsByType.Clear();
        _itemsByTag.Clear();
        _itemsByMaterialId.Clear();
        _itemsByDataID.Clear();
        
        UpdateItems(items);
    }
    
    public static void OverrideAchievements(RepeatedField<PlayerAchievementMessage> achievements)
    {
        _achievementsByDataID.Clear();
        _achievementsByType.Clear();
        _achievementsByCondition.Clear();
        
        UpdateAchievements(achievements);
    }

    public static void UpdateAchievementsParams(params PlayerAchievementMessage[] achievements)
    {
        UpdateAchievements(achievements);
    }

    public static void UpdateAchievements(IList<PlayerAchievementMessage> achievements)
    {
        foreach (var achievement in achievements)
        {
            var resAchievement = ResourceAchievement.Get(achievement.AchievementDataId);
            if (resAchievement == null)
            {
#if UNITY_EDITOR
                Debug.LogError($"Achievement data not found for achievement {achievement.AchievementDataId} of myplayer");
#endif
                continue;
            }
            
            _achievementsByDataID[achievement.AchievementDataId] = achievement;
            
            if (!_achievementsByType.ContainsKey(resAchievement.Type))
                _achievementsByType[resAchievement.Type] = new Dictionary<int, PlayerAchievementMessage>();
            _achievementsByType[resAchievement.Type][achievement.AchievementDataId] = achievement;
            
            if (!_achievementsByCondition.ContainsKey(resAchievement.Condition))
                _achievementsByCondition[resAchievement.Condition] = new Dictionary<int, PlayerAchievementMessage>();
            _achievementsByCondition[resAchievement.Condition][achievement.AchievementDataId] = achievement;
            
            if (GameBoardManager.Get()?.gameBoard?.ResMap != null)
            {
                var refDataIds = GameBoardManager.Get().gameBoard.ResMap.ReferenceAchievementDataIds;
                if (refDataIds.Contains(achievement.AchievementDataId))
                    ShouldUpdateGameboardAchievements = true;
            }
            
        }

        GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MyPlayerAchievementUpdated, achievements));
    }
    
    public static void UpdateItemsArgs(params PlayerItemMessage[] items)
    {
        UpdateItems(items);
    }

    public static HashSet<int> PeriodicUpdateItemDataIds;

    public static void UpdateItems(IList<PlayerItemMessage> items)
    {
        PeriodicUpdateItemDataIds ??= new HashSet<int>(ResourceItem.GetAllByTag(Tag.ClientPeriodicUpdate).Select(x => x.Id));
        
        //for DispatchEvent
        using var addedItems = PooledList<PlayerItemMessage>.Get();
        using var levelUpItems = PooledList<PlayerItemMessage>.Get();
        
        //for postprocessing
        using var updatedSlotRootItems = PooledList<PlayerItemMessage>.Get();
        using var updatedEquipmentItems = PooledList<PlayerItemMessage>.Get();
        
        foreach (var item in items)
        {
            if (item.Id == 0)
                continue;
            
            var resItem = item.GetData();
            if (resItem == null)
            {
#if UNITY_EDITOR
                Debug.LogError($"Item data not found for item {item.ItemDataId}");
#endif
                continue;
            }
            
            PreHandleGlobalItems(item, resItem);
            
            var oldItem = _items.GetValueOrDefault(item.Id);
            
            if (oldItem == null)
                addedItems.Add(item);

            _items[item.Id] = item;
            
            if (!_itemsByCategory.ContainsKey(resItem.Category))
                _itemsByCategory[resItem.Category] = new Dictionary<long, PlayerItemMessage>();
            _itemsByCategory[resItem.Category][item.Id] = item;
            
            if (!_itemsByType.ContainsKey(resItem.Type))
                _itemsByType[resItem.Type] = new Dictionary<long, PlayerItemMessage>();
            _itemsByType[resItem.Type][item.Id] = item;
            
            foreach (var tag in resItem.Tags)
            {
                if (!_itemsByTag.ContainsKey(tag))
                    _itemsByTag[tag] = new Dictionary<long, PlayerItemMessage>();
                _itemsByTag[tag][item.Id] = item;
            }

            if (!_itemsByMaterialId.ContainsKey(resItem.MaterialId))
                _itemsByMaterialId[resItem.MaterialId] = new Dictionary<long, PlayerItemMessage>();
            _itemsByMaterialId[resItem.MaterialId][item.Id] = item;
            
            _itemsByDataID[item.ItemDataId] = item;
            
            if (oldItem != null && oldItem.Level != item.Level)
                levelUpItems.Add(item);

            if (PeriodicUpdateItemDataIds.Contains(item.ItemDataId))
                ItemPeriodicUpdateManager.Get().DispatchItemUpdate(item.ItemDataId);
            
            if (resItem.Type == ResourceItem.Types.Type.MaxStaminaBoost)
                RefreshTotalMaxStaminaBoost();
            else if (resItem.Type == ResourceItem.Types.Type.StaminaRegenBoost)
                RefreshTotalStaminaRegenBoost();
            else if (resItem.Type == ResourceItem.Types.Type.MineBoost)
            {
                RefreshTotalMineEfficiencyBoost();
            }

            switch (resItem.Category)
            {
                case ResourceItem.Types.Category.SlotRoot:
                {
                    updatedSlotRootItems.Add(item);
                    break;
                }
                case ResourceItem.Types.Category.Equipment:
                {
                    updatedEquipmentItems.Add(item);
                    break;
                }
            }
        }
        
        // postprocessing
        foreach (var updatedSlotRootItem in updatedSlotRootItems)
        {
            var resSlotRoot = updatedSlotRootItem.GetData()!;
            foreach (var equipment in GetItemsByType(resSlotRoot.Type))
            {
                if (!equipment.IsValid())
                    continue;

                var resEquipment = equipment.GetData()!;
                if (resEquipment.Category != ResourceItem.Types.Category.Equipment)
                    continue;

                equipment.Level = updatedSlotRootItem.Level;
            }
        }

        //장비가 추가되거나 했을 때 postprocessing
        if (updatedSlotRootItems.Count == 0)
        {
            foreach (var equipment in updatedEquipmentItems)
            {
                var resEquipment = equipment.GetData();
                if (resEquipment == null || !resEquipment.TryGetSlotRootItem(out var resSlotRootItem))
                    continue;
                
                var slotRootItem = GetItemByDataID(resSlotRootItem.Id);
                if (slotRootItem == null)
                    continue;

                equipment.Level = slotRootItem.Level;
            }
        }
        
        RecalculateStats();

        if (addedItems.Count > 0)
        {
            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MyPlayerItemAdded, addedItems));
        }

        if (levelUpItems.Count > 0)
        {
            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MyPlayerItemLevelUp, levelUpItems));
        }

        if (items.Count > 0)
        {
            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MyPlayerItemUpdated, items));
        }

        RefreshGameSpeedMultiplier();
    }

    public static float RefreshGameSpeedMultiplier()
    {
        var multiplier = ResourceItem.MinGameSpeedMultiplier;
        foreach (var item in _items.Values)
        {
            if (!item.IsValid())
                continue;

            var resItem = item.GetData();
            if (resItem == null)
                continue;

            multiplier = Math.Max(multiplier, resItem.GetGameSpeedMultiplier());
        }

        GameSpeedMultiplier = multiplier;
        var gameBoardManager = GameBoardManager.Get();
        if (gameBoardManager != null)
            gameBoardManager.GameSpeedScale = multiplier;

        return multiplier;
    }

    private static void PreHandleGlobalItems(PlayerItemMessage item, ResourceItem resItem = null)
    {
        resItem ??= item.GetData()!;
        
        if (resItem.Id == ResourceItem.Global.DataId.PlayerLevel)
        {
            PlayerExp = item.Exp;
            PlayerRequiredExp = resItem.RequiredExps.GetClamped(PlayerLevel - 1);
            PlayerLevel = item.Level;
            RecalculateStats();
        }
        else if (resItem.Id == ResourceItem.Global.DataId.Credit)
        {
            PlayerCredit = item.Count;
        }
        else if (resItem.Id == ResourceItem.Global.DataId.Ruby)
        {
            PlayerPurchasedRuby = item.Count;
        }
        else if (resItem.Id == ResourceItem.Global.DataId.FreeRuby)
        {
            PlayerFreeRuby = item.Count;
        }
    }
    
    private static BoardPlayerMessage _cachedBoardPlayer;
    public static void HandleBoardPlayer(BoardPlayerMessage boardPlayer)
    {
        if (boardPlayer == null)
            return;

        var init = false;
        if (_cachedBoardPlayer == null)
        {
            _cachedBoardPlayer = boardPlayer.Clone();
            init = true;
            boardPlayer.Board = GameBoardManager.Get()?.gameBoard;
        }

        if (init || _cachedBoardPlayer.Gold != boardPlayer.Gold)
        {
            var prevGold = _cachedBoardPlayer.Gold;
            _cachedBoardPlayer.Gold = boardPlayer.Gold;
            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.MyBoardPlayerGoldUpdated, prevGold));
        }
    }
    
    public static PlayerItemMessage GetItem(long id)
    {
        return _items.GetValueOrDefault(id);
    }
    
    public static IEnumerable<PlayerItemMessage> GetItemsByCategory(ResourceItem.Types.Category category)
    {
        return _itemsByCategory.GetValueOrDefault(category)?.Values ?? Enumerable.Empty<PlayerItemMessage>();
    }
        
    public static IEnumerable<PlayerItemMessage> GetItemsByType(ResourceItem.Types.Type type)
    {
        return _itemsByType.GetValueOrDefault(type)?.Values ?? Enumerable.Empty<PlayerItemMessage>();
    }
    
    public static IEnumerable<PlayerItemMessage> GetItemsByTag(Tag tag)
    {
        return _itemsByTag.GetValueOrDefault(tag)?.Values ?? Enumerable.Empty<PlayerItemMessage>();
    }
    
    public static IEnumerable<PlayerItemMessage> GetItemsByMaterialId(int materialId)
    {
        return _itemsByMaterialId.GetValueOrDefault(materialId)?.Values ?? Enumerable.Empty<PlayerItemMessage>();
    }
    
    public static long GetValidMaterialCount(int materialId)
    {
        return GetItemsByMaterialId(materialId)
            .AsValueEnumerable()
            .Where(x => x.IsValidAsMaterial())
            .Sum(i => i.GetCount());
    }
    
    public static PlayerItemMessage GetItemByDataID(int dataID, bool checkCount = false, bool checkTimeValid = true, bool checkDeprecated = true, bool checkRequiredAndExclusive = false)
    {
        if (!_itemsByDataID.TryGetValue(dataID, out var playerItem))
            return null;

        if (!playerItem.IsValid(checkCount, checkTimeValid, checkDeprecated, checkRequiredAndExclusive))
            return null;

        return playerItem;
    }
    
    public static bool HasEnoughMaterial(MaterialItem materialItem, int unitCount = 1, float multiplier = 1f)
    {
        if (materialItem == null)
            return true;

        unitCount = Math.Max(unitCount, 1);
        return GetValidMaterialCount(materialItem.Id) >= (int)(materialItem.Count * unitCount * multiplier);
    }

    public static (bool hasEnoughMaterial, MaterialItem notEnoughMaterialItem) HasEnoughMaterial(IEnumerable<MaterialItem> materialItems, int unitCount = 1, float multiplier = 1f)
    {
        foreach (var materialItem in materialItems)
        {
            if (!HasEnoughMaterial(materialItem, unitCount, multiplier))
            {
                return (false, materialItem);
            }
        }
        
        return (true, null);
    }

    public static (bool hasEnoughMaterial, MaterialItem notEnoughMaterialItem) HasEnoughMaterial(MaterialItemGroup materialItemGroup, int unitCount, float multiplier = 1f)
    {
        MaterialItem notEnoughMaterialItem = null;
        if (materialItemGroup == null)
            return (true, null);
        
        if (materialItemGroup.ShouldAllValid)
        {
            return HasEnoughMaterial(materialItemGroup.MaterialItems, unitCount, multiplier);
        }

        foreach (var materialItem in materialItemGroup.MaterialItems)
        {
            if (HasEnoughMaterial(materialItem, unitCount, multiplier))
            {
                return (true, null);
            }
            
            notEnoughMaterialItem = materialItem;
        }

        return (false, notEnoughMaterialItem);
    }

    public static (bool hasEnough, PooledDictionary<int, long> selectedMaterialCounts) HasEnoughMaterial(Dictionary<int, long> myMaterialCounts, MaterialItemGroup materialItemGroups, int unitCount = 1, float multiplier = 1f)
    {
        var pool = ArrayPool<MaterialItemGroup>.Shared.Rent(1);
        pool[0] = materialItemGroups;
        var result = HasEnoughMaterial(myMaterialCounts, new ArraySegment<MaterialItemGroup>(pool, 0, 1), unitCount, multiplier);
        ArrayPool<MaterialItemGroup>.Shared.Return(pool);
        return result;
    }

    public static (bool hasEnough, PooledDictionary<int, long> selectedMaterialCounts) HasEnoughMaterial(Dictionary<int, long> myMaterialCounts, IEnumerable<MaterialItemGroup> materialItemGroups, int unitCount = 1, float multiplier = 1f)
    {
        using var shouldAllValidMaterialRequiredCounts = PooledDictionary<int, long>.Get();
        using var anyValidMaterialItemGroups = PooledList<MaterialItemGroup>.Get();
        
        var selectedMaterialCounts = PooledDictionary<int, long>.Get();
        
        unitCount = Math.Max(unitCount, 1);
        foreach (var materialItemGroup in materialItemGroups)
        {
            if (materialItemGroup.ShouldAllValid)
            {
                foreach (var materialItem in materialItemGroup.MaterialItems)
                {
                    if (!myMaterialCounts.TryGetValue(materialItem.Id, out _))
                        myMaterialCounts[materialItem.Id] = GetValidMaterialCount(materialItem.Id);

                    shouldAllValidMaterialRequiredCounts[materialItem.Id] =
                        shouldAllValidMaterialRequiredCounts.GetValueOrDefault(materialItem.Id)
                        + (long)(materialItem.Count * unitCount * multiplier);
                }
            }
            else
            {
                anyValidMaterialItemGroups.Add(materialItemGroup);
            }
        }
        
        foreach (var (materialId, count) in shouldAllValidMaterialRequiredCounts)
        {
            var requiredCount = count + selectedMaterialCounts.GetValueOrDefault(materialId);
            if (!myMaterialCounts.TryGetValue(materialId, out var myCount) || myCount < requiredCount)
            {
                selectedMaterialCounts.Dispose();
                return (false, selectedMaterialCounts); // Not enough material for all valid items
            }

            selectedMaterialCounts[materialId] = requiredCount;
        }
        
        foreach (var materialItemGroup in anyValidMaterialItemGroups)
        {
            var anyValid = false;
            foreach (var materialItem in materialItemGroup.MaterialItems)
            {
                if (!myMaterialCounts.TryGetValue(materialItem.Id, out _))
                    myMaterialCounts[materialItem.Id] = GetValidMaterialCount(materialItem.Id);

                var count = (long)(materialItem.Count * unitCount * multiplier);
                var requiredCount = count + selectedMaterialCounts.GetValueOrDefault(materialItem.Id);
                if (myMaterialCounts.TryGetValue(materialItem.Id, out var myCount) && myCount >= requiredCount)
                {
                    anyValid = true;
                    selectedMaterialCounts[materialItem.Id] = requiredCount;
                    break; // Found a valid material item
                }
            }

            if (!anyValid)
            {
                selectedMaterialCounts.Dispose();
                return (false, selectedMaterialCounts); // Not enough material for any valid item in the group
            }
        }

        return (true, selectedMaterialCounts);
    }
    
    public static bool HasEnoughMaterial(IEnumerable<MaterialItemGroup> materialItemGroups, int unitCount = 1, float multiplier = 1f)
    {
        using var myMaterialCounts = PooledDictionary<int, long>.Get();
        
        var (hasEnough, selectedMaterialCounts) = HasEnoughMaterial(myMaterialCounts, materialItemGroups, unitCount, multiplier);
        if (hasEnough)
            selectedMaterialCounts.Dispose();

        return hasEnough;
    }

    public static PlayerAchievementMessage GetAchievementByDataID(ResourceAchievement resourceAchievement)
    {
        if (resourceAchievement == null)
            return null;

        if (_achievementsByDataID.TryGetValue(resourceAchievement.Id, out var achievement))
            return achievement;

        achievement = new PlayerAchievementMessage { AchievementDataId = resourceAchievement.Id, State = PlayerAchievementMessage.Types.State.Disabled };
        if (resourceAchievement.InitialOpen && resourceAchievement.IsValidNow())
        {
            achievement.State = PlayerAchievementMessage.Types.State.InProgress;
            
            if (resourceAchievement.InitialProgress > 0)
                achievement.Progress = resourceAchievement.InitialProgress;
        }

        return achievement;
    }
    
    public static PlayerAchievementMessage GetAchievementByDataID(int dataID)
    {
        if (dataID == int.MinValue)
            return null;
        
        var resAchievement = ResourceAchievement.Get(dataID);
        if (resAchievement == null)
        {
            Debug.LogError($"Achievement data not found: {dataID}");
            return null;
        }

        return GetAchievementByDataID(resAchievement);
    }
    
    public static IEnumerable<PlayerAchievementMessage> GetAchievementsByType(ResourceAchievement.Types.Type type)
    {
        return ResourceAchievement.GetAllByType(type).Select(x => GetAchievementByDataID(x.Id));
        // return _achievementsByType.GetValueOrDefault(type)?.Values ?? Enumerable.Empty<PlayerAchievementMessage>();
    }
    
    public static IEnumerable<PlayerAchievementMessage> GetAchievementsByTag(Tag tag)
    {
        return ResourceAchievement.GetAllByTag(tag).Select(x => GetAchievementByDataID(x.Id));
        // return _achievementsByTag.GetValueOrDefault(tag)?.Values ?? Enumerable.Empty<PlayerAchievementMessage>();
    }
    
    public static IEnumerable<PlayerAchievementMessage> GetAchievementsByCondition(ResourceAchievement.Types.Condition condition)
    {
        return ResourceAchievement.GetAllByCondition(condition).Select(x => GetAchievementByDataID(x.Id));
        // return _achievementsByCondition.GetValueOrDefault(condition)?.Values ?? Enumerable.Empty<PlayerAchievementMessage>();
    }

    public static bool IsAchievementCompleted(int achievementDataId)
    {
        var achievement = GetAchievementByDataID(achievementDataId);
        return achievement?.IsAchievementCompleted() == true;
    }

    public static bool IsAchievementCompleted(ResourceAchievement resourceAchievement)
    {
        if (resourceAchievement == null)
            return false;
        
        var achievement = GetAchievementByDataID(resourceAchievement);
        return achievement?.IsAchievementCompleted() == true;
    }

    public static bool IsAchievementRewarded(int achievementDataId)
    {
        var achievement = GetAchievementByDataID(achievementDataId);
        return achievement?.IsAchievementRewarded() == true;
    }

    public static bool IsAchievementRewarded(ResourceAchievement resourceAchievement)
    {
        if (resourceAchievement == null)
            return false;
        
        var achievement = GetAchievementByDataID(resourceAchievement);
        return achievement?.IsAchievementRewarded() == true;
    }

    public static bool IsAchievementCompletedOrRewarded(int achievementDataId)
    {
        if (achievementDataId == 0)
            return true;
        
        var achievement = GetAchievementByDataID(achievementDataId);
        return achievement?.IsAchievementCompletedOrRewarded() == true;
    }

    public static bool IsAchievementCompletedOrRewarded(ResourceAchievement resourceAchievement)
    {
        if (resourceAchievement == null)
            return true;
        
        var achievement = GetAchievementByDataID(resourceAchievement);
        return achievement?.IsAchievementCompletedOrRewarded() == true;
    }

    public static ResourceMap GetCurrentMap()
    {
        using var maps = PooledList<ResourceMap>.Get();
        maps.AddRange(ResourceMap.GetAllByTag(Tag.Main));
        maps.Sort((x, y) => x.Id.CompareTo(y.Id));
        
        var currentMap = maps.FirstOrDefault(map =>
        {
            if (map.ContainsTag(Tag.Meta)) return false;

            foreach (var referenceAchievementDataId in map.ReferenceAchievementDataIds)
            {
                var resAch = ResourceAchievement.Get(referenceAchievementDataId);
                if (resAch is not { Condition: ResourceAchievement.Types.Condition.WinGame }) continue;
                var achievement = GetAchievementByDataID(resAch.Id);
                return !achievement.IsAchievementCompletedOrRewarded();
            }

            return true;
        }) ?? maps.Last();

        return currentMap;
    }
    
    public static ResourceMap GetCurrentLobbyMap()
    {
        return GetCurrentHomeMap();
    }

    public static ResourceMap GetCurrentHomeMap()
    {
        return ClientMapFlowResolver.ResolveHomeMap(GetCurrentMap());
    }

    public static bool TryEnterMap(ResourceMap resMap = null)
    {
        resMap ??= GetCurrentMap();
        if (resMap == null)
            return false;
        
        var materialItem = resMap.EntryMaterialItemGroups.FirstOrDefault()!.MaterialItems.FirstOrDefault()!;
        if (!HasEnoughMaterial(materialItem))
        {
            GetItemByDataID(materialItem.Id)?.GetData()?.ShowAcquisitionablePopup();
            return false;
        }
        
        GameBoardManager.Get().GoToMapLocalToNet(resMap.Id).Forget();
        return true;
    }
    
    public static int GetMaxWaveByMapId(int resMapId)
    {
        var resMap = ResourceMap.Get(resMapId);
        if (resMap == null)
            return 0;

        return resMap.GetWaveAchievements().Count(x => GetAchievementByDataID(x.Id)?.IsAchievementCompletedOrRewarded() == true);
    }
    
    public static float MineBoostEfficiency { get; private set; } = 1f;
    public static float MaxStaminaBoostRatio { get; private set; } = 1f;
    public static float StaminaRegenBoostRatio { get; private set; } = 1f;
    public static void RefreshTotalMineEfficiencyBoost()
    {
        var efficiencyBoost = 1f;
        foreach (var resItem in ResourceItem.GetAllByType(ResourceItem.Types.Type.MineBoost))
        {
            var item = GetItemByDataID(resItem.Id);
            if (item != null)
            {
                if (!item.CheckUntilAt())
                    continue;
                efficiencyBoost += resItem.EfficiencyPercent / 100f;
            }
        }
        
        MineBoostEfficiency = efficiencyBoost;
    }

    public static void RefreshTotalMaxStaminaBoost()
    {
        var staminaBoost = 1f;
        foreach (var resItem in ResourceItem.GetAllByType(ResourceItem.Types.Type.MaxStaminaBoost))
        {
            var item = GetItemByDataID(resItem.Id);
            if (item != null)
            {
                if (!item.CheckUntilAt())
                    continue;
                staminaBoost += resItem.BoostPercent / 100f;
            }
        }
        
        MaxStaminaBoostRatio = staminaBoost;
    }
    
    public static void RefreshTotalStaminaRegenBoost()
    {
        var regenBoost = 1f;
        foreach (var resItem in ResourceItem.GetAllByType(ResourceItem.Types.Type.StaminaRegenBoost))
        {
            var item = GetItemByDataID(resItem.Id);
            if (item != null)
            {
                if (!item.CheckUntilAt())
                    continue;
                regenBoost += resItem.BoostPercent / 100f;
            }
        }
        
        StaminaRegenBoostRatio = regenBoost;
    }

    public static int GetMaxQuickLevelUpCount(ResourceItem resItem, int level)
    {
        if (resItem == null)
            return 0;
        
        var count = 0;
        using var dict = PooledDictionary<int, long>.Get();
        for (; level < resItem.MaxLevel; level++)
        {
            var materialGroup = resItem.GetMaterialItemGroupByLevel(level);
            var (hasEnough, selectedMaterialCounts) = HasEnoughMaterial(dict, materialGroup);
            if (!hasEnough)
                break;
            
            foreach (var (materialId, cnt) in selectedMaterialCounts)
                dict[materialId] = dict.GetValueOrDefault(materialId) - cnt;
            selectedMaterialCounts.Dispose();
            
            count++;
        }

        return count;
    }

    public static int GetMaxQuickLevelUpCount(PlayerItemMessage item, ResourceItem resItem = null)
    {
        if (item == null)
            return 0;
        
        resItem ??= item.GetData()!;

        return GetMaxQuickLevelUpCount(resItem, item.Level);
    }
    
    public static long MaxSummonableUnitCount => GetItemByDataID(ResourceItem.Global.DataId.MaxUnitItemCount).GetCount() +
                                                 (GetItemsByCategory(ResourceItem.Types.Category.Boost).FirstOrDefault(x => x.IsValid() && x.GetData()!.Type == ResourceItem.Types.Type.MaxUnitBoost)?.GetData()!.BoostCount ?? 0);

    public static void AddResultRewardItem(ResourceItem resItem, long count, int level)
    {
        var itemAdded = false;
        foreach (var acquiredItem in ResultRewardItems)
        {
            if (acquiredItem.ItemDataId == resItem.Id && acquiredItem.Level == level)
            {
                acquiredItem.Count += count;
                itemAdded = true;
                break;
            }
        }

        if (!itemAdded)
        {
            ResultRewardItems.Add(new PlayerItemMessage
            {
                ItemDataId = resItem.Id,
                Count = count,
                Level = level,
                Grade = resItem.Grade,
            });
        }
    }

    public static bool IsGuestAccount()
    {
        var snsId = PlayerPrefs.GetString(Constants.Key.GUEST_SNS_ID);
        return snsId.StartsWith("Guest_");
    }
}
