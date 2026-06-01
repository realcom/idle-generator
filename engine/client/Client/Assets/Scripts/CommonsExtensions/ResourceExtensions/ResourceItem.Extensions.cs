using System;
using System.Buffers;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Interfaces;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;

namespace Commons.Resources
{
    public partial class ResourceItem
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Item;
        public override bool CanDisplay => IsValid && !ContainsTag(Tag.HideDisplay);

        public const int ShopLobbyUnitSummonProductTab = 1;
        public const int ShopLobbyNinjaPointTapProductTab = 2;
        
        public LazyLoad<GameObject> ClientPrefab { get; private set; }
        public Sprite ClientSpriteIcon => GetSpriteByKey("Icon");
        public string ClientSpriteIconString => GetSpriteStringByKey("Icon");
        public Sprite ClientSpriteContentsIcon => GetSpriteByKey("ContentsIcon");
        public Sprite ClientSpriteFrame => GetSpriteByKey("Frame");
        public Sprite ClientSpriteBackground => GetSpriteByKey("Background");
        public Sprite ClientSpriteBackgroundDetail => GetSpriteByKey("BackgroundDetail");
        
        private readonly Dictionary<string, LazyLoad<Sprite>> _clientSpriteGroups = new();
        
        
        public int MaxLevel  { get; private set; }
        public ResourceItem SlotRootItem { get; private set; }
        public List<int> StatChangedLevels { get; private set; } = new();
        
        private static readonly Dictionary<int, List<ResourceItem>> _itemsByProductAddItem = new();
        
        private static readonly Dictionary<Types.Type, ResourceItem> SlotRootItemsByType = new();
        
        private static readonly Dictionary<int, int> _productClientPurchaseMultiplierByDataId = new();

        public bool TryGetSlotRootItem(out ResourceItem slotRootItem)
        {
            slotRootItem = SlotRootItem;
            if (slotRootItem != null)
                return true;
            
            if (category_ != Types.Category.Equipment)
                return false;
            
            return SlotRootItemsByType.TryGetValue(type_, out slotRootItem);
        }

        public ResourceItem GetLevelUpSourceItem()
        {
            return TryGetSlotRootItem(out var slotRootItem) ? slotRootItem : this;
        }

        static partial void Reload()
        {
            PopupArgsContainer<ResourceItem>.Clear();
            SlotRootItemsByType.Clear();
        }
        
        partial void InitUnity()
        {
            InitEntity(ResourceString.Types.Category.Item, Id);
            if (!PrefabGroups.ContainsKey(-1))
                PrefabGroups[-1] = Prefab;
            ClientPrefab = new LazyLoad<GameObject>(string.IsNullOrEmpty(Prefab) ? PrefabGroups.GetValueOrDefault(-1) : Prefab);
            
            foreach (var (key, path) in spriteGroups_)
            {
                _clientSpriteGroups[key] = new LazyLoad<Sprite>(path);
            }

            if (!spriteGroups_.ContainsKey("Icon"))
                _clientSpriteGroups["Icon"] = new LazyLoad<Sprite>(sprite_);

            if (!spriteGroups_.ContainsKey("Background"))
                _clientSpriteGroups["Background"] = new LazyLoad<Sprite>($"Items/UI/FRAME_CELL_ItemCellBackground_{grade_:00}.png");

            if (!spriteGroups_.ContainsKey("BackgroundDetail"))
                _clientSpriteGroups["BackgroundDetail"] = new LazyLoad<Sprite>($"Items/UI/FRAME_CELL_ItemCellBackgroundDetail_{grade_:00}.png");

            switch (category_)
            {
                case Types.Category.Equipment:
                {
                    if (SlotRootItemsByType.TryGetValue(type_, out var slotRootItem))
                    {
                        SlotRootItem = slotRootItem;
                    
                        levelUpMaterialItemGroups_.Clear();
                        levelUpMaterialItemGroups_.AddRange(slotRootItem.LevelUpMaterialItemGroups);
                    }
                    
                    break;
                }
                case Types.Category.Product:
                {
                    foreach (var addItemGroup in addItemGroups_)
                    {
                        foreach (var addItem in addItemGroup.AddItems)
                        {
                            if (!_itemsByProductAddItem.TryGetValue(addItem.ItemDataId, out var list))
                                list = _itemsByProductAddItem[addItem.ItemDataId] = new ();
                        
                            list.Add(this);
                        }
                    }

                    const string buttonFrameKey = "ButtonFrame";
                    if (!spriteGroups_.ContainsKey(buttonFrameKey))
                    {
                        switch (type_)
                        {
                            case Types.Type.MaterialAd:
                                _clientSpriteGroups[buttonFrameKey] = new LazyLoad<Sprite>($"UIAssets/ButtonSprites/BTN_COMMON_Reward.png");
                                break;
                            case Types.Type.MaterialSingle when IsFreeProduct():
                                _clientSpriteGroups[buttonFrameKey] = new LazyLoad<Sprite>($"UIAssets/ButtonSprites/BTN_COMMON_Actionassist.png");
                                break;
                            default:
                                _clientSpriteGroups[buttonFrameKey] = new LazyLoad<Sprite>($"UIAssets/ButtonSprites/BTN_COMMON_Action_01.png");
                                break;
                        }
                    }

                    break;
                }
                case Types.Category.SlotRoot:
                    SlotRootItemsByType[type_] = this;
                    break;
            }

            MaxLevel = Math.Max(LevelUpMaterialItemGroups.Max(x => (int?)x.Level) + 1 ?? 1, requiredExps_.Count + 1);
            
            PopupArgsContainer<ResourceItem>.Register(this);

            InitStatChangedLevels();
        }
        
        private void InitStatChangedLevels()
        {
            using var hashSet = PooledHashSet<int>.Get();
            StatChangedLevels.Clear();

            var oldEquipSkillDataId = equipSkillDataIds_.FirstOrDefault();
            var oldAddStat = 0f;

            var array = ArrayPool<float>.Shared.Rent(MaxLevel);
            addStats_.Flatten(array);
            
            for (var level = 1; level <= MaxLevel; level++)
            {
                if (Math.Abs(oldAddStat - array.GetClamped(level - 1)) > float.Epsilon)
                {
                    hashSet.Add(level);
                    oldAddStat = array.GetClamped(level - 1);
                }

                var equipSkillDataId = equipSkillDataIds_.GetClamped(level - 1);
                if (level > 1 && oldEquipSkillDataId != 0 && equipSkillDataId != oldEquipSkillDataId)
                {
                    hashSet.Add(level);
                    oldEquipSkillDataId = equipSkillDataId;
                }
            }

            StatChangedLevels.AddRange(hashSet);
            
            ArrayPool<float>.Shared.Return(array);
        }

        protected override void InitEntity(ResourceString.Types.Category stringCategory, int id)
        {
            base.InitEntity(stringCategory, id);
        }
        
        partial void CheckValidPartial(ref bool result)
        {
            //result &= IsValidByRequiredAndExclusive();
        }
        
        public static IReadOnlyList<ResourceItem> GetProductsByAddItem(int itemDataId)
        {
            return _itemsByProductAddItem.TryGetValue(itemDataId, out var itemList) ? itemList : EmptyList;
        }
        
        public Sprite GetSpriteByKey(string key, Sprite defaultValue = null)
        {
            var sprite = _clientSpriteGroups.GetValueOrDefault(key) ?? defaultValue;
            
#if UNITY_EDITOR
            if (sprite == null)
            {
                var spriteName = $"item_{Id}_{key}";
                sprite = global::Utility.GenerateTextSprite(spriteName);
                sprite.name = spriteName;
            }
#endif
            
            return sprite;
        }
        
        public string GetSpriteStringByKey(string key, string path = null)
        {
            var sprite = _clientSpriteGroups.GetValueOrDefault(key)?.name ?? path;
            return sprite.ToIconSpriteString();
        }

        public double GetRankSeasonStartAt()
        {
            if (StartAt == null)
                return 0f;

            return GetRankStartDateTime().ToSeconds();
        }

        public DateTime GetRankStartDateTime()
        {
            if (StartAt == null)
                return DateTime.UnixEpoch;

            return StartAt.ToDateTime().AddDays((GetRankingDate() - 1) * RankingPeriodDays);
        }

        public double GetRankSeasonUntilAt()
        {
            if (StartAt == null)
                return double.PositiveInfinity;

            return GetRankStartDateTime().AddDays(RankingPeriodDays).ToSeconds();
        }

        public int GetPurchaseUnit()
        {
            switch (type_)
            {
                case Types.Type.MaterialAmap:
                {
                    var productMaterial = GetProductMaterial();
                    if (productMaterial != null)
                    {
                        return (int)Math.Max(productMaterial.Count, MyPlayer.GetItemByDataID(productMaterial.Id)?.GetCount() ?? 1);
                    }
                
                    break;
                }
            }
            
            return purchaseUnit_ * GetClientPurchaseMultiplier();
        }
        
        public int SetClientPurchaseMultiplier(int purchaseMultiplier)
        {
            if (purchaseMultiplier < 1)
                return 1;

            return _productClientPurchaseMultiplierByDataId[Id] = purchaseMultiplier;
        }
        
        public int GetClientPurchaseMultiplier()
        {
            return _productClientPurchaseMultiplierByDataId.GetValueOrDefault(Id, 1);
        }

        public bool IsProductBuyable()
        {
            if (category_ != Types.Category.Product)
                return false;

            if (type_ == Types.Type.Unspecified)
                return false;
            
            if (!IsValidByRequiredAndExclusive())
                return false;

            if (!MyPlayer.HasEnoughMaterial(productMaterialItemGroups_.FirstOrDefault(), GetPurchaseUnit(),
                    GetProductMaterialPriceMultiplier(GetPurchaseUnit())).hasEnoughMaterial)
                return false;

            return true;
        }

        public float GetProductMaterialPriceMultiplier(int count = 1)
        {
            var productMaterial = GetProductMaterial();
            if (productMaterial == null)
                return 1.0f;

            var baseCount = productMaterial.Count * Math.Max(count, 1);
            if (baseCount <= 0)
                return 1.0f;

            return GetProductMaterialRequiredCount(productMaterial, count) / (float)baseCount;
        }

        public int GetProductMaterialRequiredCount(MaterialItem materialItem, int count = 1)
        {
            count = Math.Max(count, 1);
            if (!UsesProgressiveProductPrice())
                return materialItem.Count * count;

            if (UsesAchievementProgressiveProductPrice())
                return (materialItem.Count + GetProgressiveProductCompletedAchievementCount() * regenCount_) * count;

            var productItem = MyPlayer.GetItemByDataID(Id, checkCount: false, checkTimeValid: false, checkDeprecated: false);
            var purchasedBefore = productItem?.Option?.ProductOption?.MultiplyBonusCount ?? 0;
            var totalCount = 0;
            for (var i = 0; i < count; i++)
                totalCount += materialItem.Count + ((purchasedBefore + i) / regenPeriod_) * regenCount_;
            return totalCount;
        }

        public int GetProgressiveProductLevel()
        {
            if (!UsesProgressiveProductPrice())
                return 1;

            if (UsesAchievementProgressiveProductPrice())
                return GetProgressiveProductCompletedAchievementCount() + 1;

            if (regenPeriod_ <= 0)
                return 1;

            var productItem = MyPlayer.GetItemByDataID(Id, checkCount: false, checkTimeValid: false, checkDeprecated: false);
            var purchasedBefore = productItem?.Option?.ProductOption?.MultiplyBonusCount ?? 0;
            return purchasedBefore / regenPeriod_ + 1;
        }

        private bool UsesProgressiveProductPrice()
        {
            return category_ == Types.Category.Product
                   && regenCount_ > 0
                   && (regenPeriod_ > 0 || targetAchievementDataIds_.Count > 0)
                   && productMaterialItemGroups_.Count > 0;
        }

        private bool UsesAchievementProgressiveProductPrice()
        {
            return targetAchievementDataIds_.Count > 0;
        }

        private int GetProgressiveProductCompletedAchievementCount()
        {
            return targetAchievementDataIds_.Count(achievementDataId =>
                MyPlayer.GetAchievementByDataID(achievementDataId)?.IsAchievementCompletedOrRewarded() == true);
        }

        public bool IsMaterialInRecipeRange(List<int> materialIds)
        {
            if (Category != Types.Category.Recipe)
                return false;

            var recipeMaterials = DictionaryPool<int, int>.Get();

            foreach (var materialItemGroup in MaterialItemGroups)
            {
                foreach (var materialItem in materialItemGroup.MaterialItems)
                {
                    recipeMaterials[materialItem.Id] = recipeMaterials.GetValueOrDefault(materialItem.Id) + materialItem.Count;
                }
            }

            var operandMaterials = DictionaryPool<int, int>.Get();
            foreach (var id in materialIds)
            {
                operandMaterials[id] = operandMaterials.GetValueOrDefault(id) + 1;
            }

            var hasEnough = true;
            foreach (var (key, value) in operandMaterials)
            {
                if (recipeMaterials.GetValueOrDefault(key) < value)
                {
                    hasEnough = false;
                    break;
                }
            }

            DictionaryPool<int, int>.Release(recipeMaterials);
            DictionaryPool<int, int>.Release(operandMaterials);

            return hasEnough;
        }

        //materialIds: 보유하고 있는 재료 아이템 아이디 리스트 (중복 가능)
        public bool HasEnoughMaterial(List<int> materialIds)
        {
            using var _ = DictionaryPool<int, int>.Get(out var handHoldMaterials);
            foreach (var materialId in materialIds)
            {
                handHoldMaterials[materialId] = handHoldMaterials.GetValueOrDefault(materialId) + 1;
            }
            
            foreach (var materialItemGroup in MaterialItemGroups)
            {
                if (materialItemGroup.ShouldAllValid)
                {
                    foreach (var materialItem in materialItemGroup.MaterialItems)
                    {
                        var handHoldCount = handHoldMaterials.GetValueOrDefault(materialItem.Id);
                        if (handHoldCount <= 0)
                            return false;

                        handHoldMaterials[materialItem.Id] = Math.Max(0, handHoldCount - materialItem.Count);
                    }
                }
                else
                {
                    var groupValid = false;
                    foreach (var materialItem in materialItemGroup.MaterialItems)
                    {
                        var handHoldCount = handHoldMaterials.GetValueOrDefault(materialItem.Id);
                        if (handHoldCount <= 0)
                            continue;
                        
                        handHoldMaterials[materialItem.Id] = Math.Max(0, handHoldCount - materialItem.Count);
                        groupValid = true;
                        break;
                    }
                    
                    if (!groupValid)
                        return false;
                }
            }

            return true;
        }

        public IEnumerable<ResourceItem> GetPaymentThisProductItems()
        {
            foreach (var product in GetAllByCategory(Types.Category.Product))
            {
                if (!product.CanDisplay)
                    continue;

                if (product.addItemGroups_.Any(x => x.AddItems.Any(y => y.ItemDataId == Id)))
                {
                    yield return product;
                }
            }
        }
        
        public MaterialItemGroup GetMaterialItemGroupByLevel(int level)
        {
            var matGroup = LevelUpMaterialItemGroups.FirstOrDefault(x => x.Level == level);
#if UNITY_EDITOR
            if (matGroup == null)
                Debug.LogError($"MaterialItemGroup not found for level {level} in {Name}");
#endif
            return matGroup;
        }

        public bool IsValidByRequiredAndExclusive()
        {
            if (AchievementDataId != 0 && MyPlayer.GetAchievementByDataID(AchievementDataId)?.IsAchievementCompletedOrRewarded() == false)
                return false;

            if (!CheckRequiredAchievements(out _))
                return false;

            foreach (var requiredItemDataId in RequiredItemDataIds)
            {
                if (MyPlayer.GetItem(requiredItemDataId)?.IsValid() == false)
                    return false;
            }

            if (!CheckExclusiveAchievements(out _))
                return false;
            
            foreach (var requiredItemDataId in ExclusiveItemDataIds)
            {
                if (MyPlayer.GetItem(requiredItemDataId)?.IsValid() == true)
                    return false;
            }

            if (!CheckItemTags())
                return false;

            return true;
        }

        public bool CheckItemTags()
        {
            foreach (var tag in requiredItemTags_)
            {
                if (!MyPlayer.GetItemsByTag(tag).Any(x => x.IsValid()))
                    return false;
            }
            
            foreach (var tag in exclusiveItemTags_)
            {
                if (MyPlayer.GetItemsByTag(tag).Any(x => x.IsValid()))
                    return false;
            }

            return true;
        }
        
        public bool CheckRequiredAchievements(out string message)
        {
            message = string.Empty;
            foreach (var requiredAchievementDataId in RequiredAchievementDataIds)
            {
                if (MyPlayer.GetAchievementByDataID(requiredAchievementDataId)?.IsAchievementCompletedOrRewarded() == false)
                {
                    message = ResourceAchievement.Get(requiredAchievementDataId)?.GetLocalizedString("RequiredAchievementMessageKey") ?? string.Empty;
                    return false;
                }
            }

            return true;
        }

        public bool CheckExclusiveAchievements(out string message)
        {
            message = string.Empty;
            foreach (var exclusiveAchievementDataId in ExclusiveAchievementDataIds)
            {
                if (MyPlayer.GetAchievementByDataID(exclusiveAchievementDataId)?.IsAchievementCompletedOrRewarded() == true)
                {
                    message = ResourceAchievement.Get(exclusiveAchievementDataId)?.GetLocalizedString("ExclusiveAchievementMessageKey") ?? string.Empty;
                    return false;
                }
            }

            return true;
        }
        
        public bool GetExclusiveAchievement(out ResourceAchievement exclusiveAchievement, Func<ResourceAchievement, bool> predicate = null)
        {
            exclusiveAchievement = null;
            foreach (var exclusiveAchievementDataId in ExclusiveAchievementDataIds)
            {
                var resAchievement = ResourceAchievement.Get(exclusiveAchievementDataId);
                if (predicate?.Invoke(resAchievement) == false)
                    continue;
                
                exclusiveAchievement = resAchievement;
                return true;
            }

            return false;
        }

        public ResourceAchievement GetProductBuyLimitAchievement()
        {
            GetExclusiveAchievement(out var exclusiveAchievement, x => x.IsValid &&  x.ContainsTag(Tag.ProductBuyLimit));
            return exclusiveAchievement;
        }
        
        public string GetAddItemString(string format = null, Func<AddItem, bool> predicate = null, Func<AddItemGroup, bool> groupPredicate = null)
        {
            var addItems = addItemGroups_.GetAddItems(predicate, groupPredicate);
            return addItems.FirstOrDefault()?.GetStringWithIcon();
        }

        public bool IsFreeProduct()
        {
            return GetProductMaterial() == null;
        }

        public MaterialItem GetProductMaterial(Func<MaterialItem, bool> predicate = null, Func<MaterialItemGroup, bool> groupPredicate = null)
        {
            foreach (var materialItemGroup in ProductMaterialItemGroups)
            {
                if (groupPredicate?.Invoke(materialItemGroup) == false)
                    continue;

                foreach (var materialItem in materialItemGroup.MaterialItems)
                {
                    if (predicate is null || predicate(materialItem))
                        return materialItem;
                }
            }

            return null;
        }
        
        public IEnumerable<MaterialItem> GetProductMaterials(Func<MaterialItem, bool> predicate = null, Func<MaterialItemGroup, bool> groupPredicate = null)
        {
            foreach (var materialItemGroup in ProductMaterialItemGroups)
            {
                if (groupPredicate?.Invoke(materialItemGroup) == false)
                    continue;

                foreach (var materialItem in materialItemGroup.MaterialItems)
                {
                    if (predicate is null || predicate(materialItem))
                        yield return materialItem;
                }
            }
        }
        
        public string GetProductMaterialString(string format = null, Func<MaterialItem, bool> predicate = null, Func<MaterialItemGroup, bool> groupPredicate = null)
        {
            var productMaterial = GetProductMaterial(predicate, groupPredicate);
            return productMaterial.ToStringWithIconFormat(format ?? "{0} {2}",
                priceMultiplier: GetProductMaterialPriceMultiplier(GetPurchaseUnit()));
        }
        
        public Sprite GetDamageTypeIcon(out int damageType)
        {
            Sprite damageTypeIcon = null;
            if (ContainsTag(Tag.Consumable))
            {
                damageTypeIcon = CRC.Get().consumableTypeIcon;
                damageType = 4;
            }
            else
            {
                var skillId = MyPlayer.GameUnit.GetReplaceSkillDataId(SkillDataId);
                var resSkill = ResourceSkill.Get(skillId)!;
                damageTypeIcon = CRC.Get().GetDamageTypeSprite(resSkill.DamageType);
                damageType = (int)resSkill.DamageType;
            }
            
            return damageTypeIcon;
        }
        
        public string GetIAPPriceString()
        {
            return PurchaseManager.Get().GetLocalizedPriceString(this);
        }

        public string GetPriceString()
        {
            if (category_ != Types.Category.Product)
                return string.Empty;

            if (!CheckExclusiveAchievements(out _))
            {
                if (!GetLocalizedString(out var inText, "PurchaseCompleted"))
                    inText = "PurchaseCompleted".L();
                return inText;
            }

            if (priceUsd_ > 0)
                return GetLocalizedString("IAPFormat", "{0}").GetParsedString(GetIAPPriceString());

            var material = GetProductMaterial();
            if (material != null)
            {
                //AMAP는 보유량에 미보유 시에만 색깔 덮기
                if (type_ == Types.Type.MaterialAmap)
                    return material.ToStringWithIconFormat(GetLocalizedString("MaterialFormat", "{0} {7}")); 
                
                //기본적으로는 필요량에 미보유 시에만 색깔 덮기
                return material.ToStringWithIconFormat(GetLocalizedString("MaterialFormat", "{0} {8}"),
                    GetPurchaseUnit(), GetProductMaterialPriceMultiplier(GetPurchaseUnit()));
            }

            if (type_ == Types.Type.MaterialAd)
                return "WatchAd".L();

            return "Free".L();
        }

        public string GetMaterialIconString()
        {
            var material = GetProductMaterial();
            if (material != null)
                return material.GetData()?.ClientSpriteIconString;

            if (type_ == Types.Type.MaterialAd)
                return "AdIcon".L();

            return string.Empty;
        }
        
        public override bool HasRelevanceNotice()
        {
            return HasRelevanceNoticeWithRecursiveCheck();
        }

        private bool HasRelevanceNoticeWithRecursiveCheck(int recursiveCount = 0)
        {
            if (++recursiveCount > 5)
                return false;

            if (!IsValid)
                return false;

            var item = MyPlayer.GetItemByDataID(Id, checkCount: false, checkTimeValid: false, checkDeprecated: false);
            var itemCount = item?.GetCount() ?? 0;
            
            //아이템 있을 경우 기간 만료 체크
            if (item?.CheckUntilAt() == false)
                return false;

            if (itemCount > 0)
            {
                //상단 기간 체크 및 아이템 있을 경우 업적 알림 체크
                foreach (var achievementDataId in targetAchievementDataIds_)
                {
                    if (ResourceAchievement.Get(achievementDataId)?.HasRelevanceNotice() == true)
                        return true;
                }   
            }

            if (id_ == Global.DataId.MailNoticeCache)
            {
                //Has Unread Mail
                return item?.Param1 > 0;
            }
            
            switch (category_)
            {
                case Types.Category.Product:
                {
                    foreach (var subProduct in GetAllByParentId(id_))
                    {
                        if (subProduct.id_ == id_)
                            continue;
                        
                        if (subProduct.HasRelevanceNoticeWithRecursiveCheck(recursiveCount))
                            return true;
                    }
                    
                    var purchasableAt = item?.Option?.ProductOption.ReprocessableAt?.ToSeconds() ?? 0;
                    if (purchasableAt > TimeSystem.offsetTime)
                        return false;
                    
                    if (GetProductMaterial()?.Id == Global.DataId.Ruby)
                        return false;

                    if (type_ != Types.Type.MaterialRealPrice && IsProductBuyable())
                        return true;

                    break;
                }
                case Types.Category.SlotRoot:
                {
                    var slot = PlayerAvatar.ToEquipmentSlot(type_);
                    if (type_ == Types.Type.Ring)
                        slot = PlayerAvatar.EquipmentSlot.Ring1;
                    
                    var hasEquipment = MyPlayer.PlayerAvatar?.Equipments.GetSafe(slot)?.Id != 0;
                    if (!hasEquipment)
                        return false;
                    
                    return MyPlayer.GetMaxQuickLevelUpCount(item) > 0;
                }
                case Types.Category.Equipment:
                case Types.Category.Pet:
                case Types.Category.Unit:
                case Types.Category.Stat:
                {
                    return MyPlayer.GetMaxQuickLevelUpCount(item) > 0;
                }
                case Types.Category.SelectableBox:
                {
                    return itemCount > 0;
                }
                case Types.Category.Recipe:
                {
                    return MyPlayer.HasEnoughMaterial(materialItemGroups_);
                }
                default:
                {
                    switch (type_)
                    {
                        case Types.Type.GamePassGroup:
                        {
                            return itemCount > 0 && GetAllByGroup(group_).Any(x => x.type_ == Types.Type.GamePassMain && x.HasRelevanceNoticeWithRecursiveCheck(recursiveCount));
                        }
                        case Types.Type.GamePassMain:
                        {
                            return itemCount > 0 && targetItemDataIds_.Any(x => Get(x)?.HasRelevanceNoticeWithRecursiveCheck(recursiveCount) == true);
                        }
                        case Types.Type.Scout:
                        {
                            if (ContainsTag(Tag.ScoutNormal))
                            {
                                if (item == null || item.Param1 == 0)
                                    return false;

                                var targetResMap = ResourceMap.Get(item.Param1)!;
                                var minMinutes = targetResMap.ScoutAddItemGroups.Min(x => x.Minutes);
                                var pendingMinutes = (TimeSystem.offsetTime - item.Param2) / 60;

                                return pendingMinutes >= minMinutes;
                            }

                            if (ContainsTag(Tag.ScoutQuick))
                            {
                                foreach (var productQuickScout in GetAllByTag(Tag.ProductQuickScout))
                                {
                                    if (productQuickScout.HasRelevanceNoticeWithRecursiveCheck(recursiveCount))
                                        return true;
                                }
                            }

                            break;
                        }
                        case Types.Type.TimeLimitedMission:
                        {
                            if (Get(TimeLimitedMissionPointItemDataId)!.HasRelevanceNoticeWithRecursiveCheck(recursiveCount))
                                return true;
                            
                            foreach (var resDayCheckAch in ResourceAchievement.GetAllByTag(Tag.ForDayCheck))
                            {
                                if (!resDayCheckAch.CompareTargetPopupName(nameof(Popup_TimeLimitedMission), id_))
                                    continue;

                                if (!MyPlayer.IsAchievementCompletedOrRewarded(resDayCheckAch))
                                    continue;

                                var day = resDayCheckAch.GetTargetPopupArgument(1);
                                foreach (var resAch in ResourceAchievement.GetAllByTargetPopupNameWithArgs(nameof(Popup_TimeLimitedMission), id_, day))
                                {
                                    if (!resAch.IsValid || resAch.ContainsTag(Tag.ForDayCheck))
                                        continue;

                                    if (resAch.HasRelevanceNotice())
                                        return true;
                                }

                                foreach (var resItem in GetAllByTargetPopupNameWithArgs(nameof(Popup_TimeLimitedMission), id_, day))
                                {
                                    if (!resItem.IsValid || resItem.Category != Types.Category.Product)
                                        continue;

                                    if (resItem.HasRelevanceNoticeWithRecursiveCheck(recursiveCount))
                                        return true;
                                }
                            }
                            
                            break;
                        }
                    }
                    
                    break;
                }
            }

            if (item?.CanClaimDailyReward() == true)
                return true;

            var acquisitionablePopupName = GetPopupArgument("AcquisitionablePopup"); 
            if (!string.IsNullOrEmpty(acquisitionablePopupName))
            {
                foreach (var itemToAcquisition in GetAllByTargetPopupNameWithArgs(acquisitionablePopupName, id_))
                {
                    if (itemToAcquisition.HasRelevanceNoticeWithRecursiveCheck(recursiveCount))
                        return true;
                }
            }

            return false;
        }
    }
}

public static class GlobalResourceItem
{
    public static ResourceItem TrainingRankItem => ResourceItem.GetAllByType(ResourceItem.Types.Type.TrainingRank).FirstOrDefault(x => x.CanDisplay);
    public static ResourceItem ChapterPassItem => ResourceItem.GetAllByTag(Tag.ChapterPass).LastOrDefault(x => 
        x.Type == ResourceItem.Types.Type.GamePassMain && 
        x.CanDisplay &&
        MyPlayer.GetItemByDataID(x.Id) != null);
    public static ResourceItem ScoutNormalItem => ResourceItem.GetAllByTag(Tag.ScoutNormal).FirstOrDefault(x => x.CanDisplay);
}

public static class ResourceItemExtensions
{
    public static ResourceItem PickAdWatchProduct(this IReadOnlyList<ResourceItem> products)
    {
        foreach (var product in products)
        {
            if (product is not { Category: ResourceItem.Types.Category.Product })
                continue;

            if (product.Type == ResourceItem.Types.Type.MaterialAd)
                return product;
        }

        return null;
    }
    
    public static ResourceItem PickMaterialProduct(this IReadOnlyList<ResourceItem> products)
    {
        foreach (var product in products)
        {
            if (product is not { Category: ResourceItem.Types.Category.Product })
                continue;

            var material = product.GetProductMaterial();
            if (material != null && material.Id != 0)
                return product;
        }

        return null;
    }

    public static ResourceItem GetSelectableBoxPool(this ResourceItem resItem)
    {
        if (resItem.Category == ResourceItem.Types.Category.SelectableBox && resItem.Type != ResourceItem.Types.Type.SeasonalSelectableBox)
            return resItem;
        
        foreach (var resPool in ResourceItem.GetAllByType(ResourceItem.Types.Type.SeasonalSelectableBox))
        {
            if (resPool.Category == ResourceItem.Types.Category.SelectableBox)
                continue;

            if (!resPool.IsValid)
                continue;

            if (resPool.TargetItemDataIds.Contains(resItem.Id))
            {
                return resPool;
            }
        }

        return null;
    }
    
    private static readonly StringBuilder itemCountStringBuilder = new();
    public static string GetCountString(int itemId, long count, bool toShortString = false)
    {
        if (toShortString && count < 2)
            return string.Empty;
        
        var countString = count.ToUnitString();
        itemCountStringBuilder.Clear();

        itemCountStringBuilder.Append(countString);
        
        return itemCountStringBuilder.ToString();
    }

    public static long GetCombinedItemCount(this IReadOnlyList<PlayerItemMessage> items, Func<PlayerItemMessage, bool> predicate = null)
    {
        long count = 0;
        foreach (var item in items)
        {
            if (predicate != null && !predicate(item))
                continue;
            
            count += item.GetCount();
        }

        return count;
    }
    
    public static int GetMaxStamina(this ResourceItem unitItem)
    {
        return (int)(unitItem.MaxStamina * MyPlayer.MaxStaminaBoostRatio);
    }
    
    public static int GetStaminaRegenPerSecond(this ResourceItem unitItem)
    {
        return (int)(unitItem.StaminaRegenPerSecond * MyPlayer.StaminaRegenBoostRatio);
    }
    
}

[Serializable]
public class UITableRow<TElement> : UIElement where TElement : UIElement, new()
{
    public UIElementContainer<TElement> cells = new();
}

[Serializable]
public class TraitCell : UIElement
{
    public CustomButton btnTraitCell;
    
    public Image imgIcon;
    public Image imgRarity;

    public virtual void Refresh(ResourceItem resTraitItem)
    {
        imgIcon.sprite = resTraitItem.ClientSpriteIcon;
        imgRarity.sprite = resTraitItem.ClientSpriteBackground;

        btnTraitCell.SetOnClick(() => resTraitItem.ShowInfoPopup());
    }
}

[Serializable]
public class PurchaseProductCell : UIElement
{
    public PurchaseProductButton btnPurchaseProduct;
    
    [FormerlySerializedAs("imgProductIcon")] public Image imgIcon;

    public TextMeshProUGUI txtFlexiblePurchaseInfo;
    
    [FormerlySerializedAs("txtProductName")] public TextMeshProUGUI txtName;
    public TextMeshProUGUI txtRewardCount;
    [FormerlySerializedAs("txtProductPrice")] public TextMeshProUGUI txtPrice;
    public TextMeshProUGUI txtPurchaseLimit;
    
    [FormerlySerializedAs("rtProductPromotion")] public RectTransform rtPromotion;
    [FormerlySerializedAs("txtProductPromotion")] public TextMeshProUGUI txtPromotion;

    public TextMeshProUGUI txtPityDesc;

    public RectTransform rtReprocessableAt;
    public TextTimer timerReprocessableAt;

    public bool Refresh(int productItemDataId)
    {
        return Refresh(ResourceItem.Get(productItemDataId));
    }

    private static object[] flexiblePurchaseInfoArgs = new object[30];
    public virtual bool Refresh(ResourceItem resProduct)
    {
        if (resProduct is not { Category: ResourceItem.Types.Category.Product })
            return false;
        
        var productItem = MyPlayer.GetItemByDataID(resProduct.Id, checkCount: false);
        if (productItem == null)
            return false;

        var isBuyable = resProduct.IsProductBuyable();

        for (var i = 0; i < flexiblePurchaseInfoArgs.Length; i++)
            flexiblePurchaseInfoArgs[i] = string.Empty;

        if (btnPurchaseProduct)
        {
            btnPurchaseProduct.SetProduct(resProduct);
            btnPurchaseProduct.SetActive(isBuyable || !resProduct.ContainsTag(Tag.PurchaseButtonHideWhenNotBuyable));
        }

        if (imgIcon)
            imgIcon.SetActive(imgIcon.sprite = resProduct.ClientSpriteIcon);

        var inNameText = resProduct.ClientName;
        flexiblePurchaseInfoArgs[0] = inNameText;
        var inShortNameText = resProduct.ClientShortName;
        flexiblePurchaseInfoArgs[1] = inShortNameText;
        flexiblePurchaseInfoArgs[2] = resProduct.GetMaterialIconString();
        
        var inRewardCountText = resProduct.GetLocalizedString("RewardCount", resProduct.AddItemGroups.GetAddItem()?.GetClientCountString());
        flexiblePurchaseInfoArgs[5] = inRewardCountText;
        var inPriceText = resProduct.GetPriceString();
        var resAddItem = resProduct.AddItemGroups.GetAddItem()?.GetData()!;

        //기한이 있는 아이템이면서, 연장 구매 가능 태그 보유시 가격에 연장 구매 포맷 적용
        if (resAddItem != null && MyPlayer.GetItemByDataID(resAddItem.Id, checkCount: true) is { } addItem &&
            addItem.UntilAt != null && resAddItem.ContainsTag(Tag.ExtensionPurchaseAvailable))
        {
            inPriceText = resProduct.GetLocalizedString("ExtensionPriceFormat", "{0}").GetParsedString(inPriceText);
        }
        flexiblePurchaseInfoArgs[6] = inPriceText;
        
        var inPurchaseLimitText = string.Empty;
        var buyLimitAchievement = resProduct.GetProductBuyLimitAchievement();
        if (buyLimitAchievement != null)
        {
            var achievement = MyPlayer.GetAchievementByDataID(buyLimitAchievement.Id)!;
            if (!resProduct.GetLocalizedString(out var inText, "PurchaseLimitFormat"))
                inText = $"AchLimitType_{buyLimitAchievement.Type}".L();
            inPurchaseLimitText = inText.GetParsedString(buyLimitAchievement.TargetProgress - achievement.Progress, buyLimitAchievement.TargetProgress, achievement.Progress);
        }
        flexiblePurchaseInfoArgs[7] = inPurchaseLimitText;
        
        var hasPromotionText = resProduct.GetLocalizedString(out var inPromotionText, "Promotion");
        flexiblePurchaseInfoArgs[8] = inPromotionText;
        
        var pityRemainCounts = ArrayPool<object>.Shared.Rent(resProduct.BonusCounts.Count);
        for (var i = 0; i < resProduct.BonusCounts.Count; i++)
        {
            var remainCount = resProduct.BonusCounts[i] - (productItem.Option?.ProductOption?.PityCounts.GetSafe(i) ?? 0);
            pityRemainCounts[i] = remainCount.ToString();
        }
        var inPityDescText = resProduct.GetLocalizedString("PityDesc").GetParsedString(pityRemainCounts);
        flexiblePurchaseInfoArgs[9] = inPityDescText;

        if (txtName)
            txtName.text = inNameText;
        if (txtRewardCount)
            txtRewardCount.text = inRewardCountText;
        if (txtPrice)
            txtPrice.text = inPriceText;
        if (txtPurchaseLimit)
        {
            txtPurchaseLimit.SetActive(!string.IsNullOrEmpty(inPurchaseLimitText));
            txtPurchaseLimit.text = inPurchaseLimitText;
        }
        
        if (rtPromotion)
            rtPromotion.SetActive(hasPromotionText);
        if (txtPromotion)
            txtPromotion.text = inPromotionText;

        var purchasableAt = productItem.Option?.ProductOption?.ReprocessableAt?.ToOffsetSeconds() ?? 0;
        var purchasable = purchasableAt <= TimeSystem.offsetTime;
        if (rtReprocessableAt)
        {
            rtReprocessableAt.SetActive(!purchasable);

            if (txtPurchaseLimit)
                txtPurchaseLimit.SetActive(purchasable);
        }

        if (timerReprocessableAt)
        {
            timerReprocessableAt.Stop();

            if (purchasableAt > TimeSystem.offsetTime)
            {
                timerReprocessableAt.targetTimeAt = Utility.OffsetSecondsToSeconds(purchasableAt);
                timerReprocessableAt.SetExpiredCallback(()=>
                {
                    Refresh(resProduct);
                });
            }
        }

        if (txtPityDesc)
        {
            txtPityDesc.text = inPityDescText;
            txtPityDesc.SetActive(resProduct.BonusCounts.Count > 0);
        }

        if (txtFlexiblePurchaseInfo)
            txtFlexiblePurchaseInfo.text = resProduct.GetLocalizedString("FlexiblePurchaseInfo").GetParsedString(flexiblePurchaseInfoArgs);
        
        if (!isBuyable && resProduct.ContainsTag(Tag.ProductHideWhenNotBuyable))
        {
            elementRoot.SetActive(false);
            return false;
        }

        //태그 보유 여부로 검사 실패 할 경우 무조건 비활성화
        if (!resProduct.CheckItemTags())
        {
            elementRoot.SetActive(false);
            return false;
        }
        
        return true;
    }
    
}

[Serializable]
public class MinimalPurchaseProductCell : PurchaseProductCell
{
    public override bool Refresh(ResourceItem resProduct)
    {
        if (!base.Refresh(resProduct))
            return false;

        var isMaterialAdProduct = resProduct.Type == ResourceItem.Types.Type.MaterialAd;
        
        if (txtPrice)
            txtPrice.SetActive(!isMaterialAdProduct);

        if (txtPurchaseLimit)
            txtPurchaseLimit.SetActive(isMaterialAdProduct);

        return true;
    }
}
