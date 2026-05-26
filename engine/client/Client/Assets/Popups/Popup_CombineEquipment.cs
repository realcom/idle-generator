using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Interfaces;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;
using ZLinq;


public class Popup_CombineEquipment : UIPopup
{
    
    [Serializable]
    public class CombinableItemCell : EquippableItemTableCell
    {
        public RedDot redDot;
    }
    
    [Title("Cells")] 
    public ItemCellBehaviourWrapperElement resultElement = new();
    public ItemCellBehaviourWrapperElement mainMaterialElement = new();
    public GameObject goSubMaterials;
    public UIElementContainer<ItemCellBehaviourWrapperElement> subMaterialElements = new();

    public GameObject goEmptyResult;
    public GameObject goResult;
    public TextMeshProUGUI txtResultItemName;
    public TextMeshProUGUI txtResultItemMainStat;
    public TextMeshProUGUI txtResultIemAddedBuff;
    public TextMeshProUGUI txtCombineEquation;

    // [Serializable]
    // public class UpgradeDetail : UIElement
    // {
    //     public TextMeshProUGUI txtName;
    //     public TextMeshProUGUI txtValue;
    //     public TextMeshProUGUI txtDesc;
    // }
    //
    // public UIElementContainer<UpgradeDetail> upgradeDetailCells;
        
    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>> { }
    [Title("Table")]
    public TableElement equipmentTableElement = new();
    
    [Title("Button")]
    public CustomButton btnCombine;
    public CustomButton btnCombineAll;
    
    private PlayerItemMessage _mainMaterialItem;
    private List<PlayerItemMessage> _subMaterialItems = new();
    
    private ResourceItem _recipe;
    private ResourceItem _resultResItem;
    
    private Dictionary<int, List<ResourceItem>> mergeRecipesByMaterialId = new();
    
    public static IEnumerable<ResourceEntity> GetMergeableEquipmentNoticeRelevanceEntities()
    {
        return ResourceItem.GetAllByTag(Tag.EquipmentCombineRecipe);
    }
    
    private static PooledHashSet<int> GetMergeableMaterialIds()
    {
        var set = PooledHashSet<int>.Get();
        foreach (var recipe in ResourceItem.GetAllByTag(Tag.EquipmentCombineRecipe))
        {
            if (MyPlayer.HasEnoughMaterial(recipe.MaterialItemGroups))
            {
                foreach (var materialItem in recipe.MaterialItemGroups.Flatten())
                {
                    set.Add(materialItem.Id);
                }
            }
        }
        return set;
    }

    protected override void Start()
    {
        mergeRecipesByMaterialId.Clear();
        foreach (var recipe in ResourceItem.GetAllByTag(Tag.EquipmentCombineRecipe))
        {
            foreach (var recipeMaterialItemGroup in recipe.MaterialItemGroups)
            {
                //TODO: 여기 목록은 or이라 바꿔야 한다.
                foreach (var materialItem in recipeMaterialItemGroup.MaterialItems)
                {
                    if (!mergeRecipesByMaterialId.TryGetValue(materialItem.Id, out var list))
                        list = mergeRecipesByMaterialId[materialItem.Id] = new();

                    list.Add(recipe);
                }
            }
        }
        
        base.Start();
        
        InitButtons();
    }

    private PooledHashSet<int> _mergeableMaterialIds;
    public override void Refresh()
    {
        _mergeableMaterialIds?.Dispose();
        _mergeableMaterialIds = GetMergeableMaterialIds();
        
        RefreshMaterialEquipments();
        RefreshUpgradeDetails();
        RefreshEquipmentTable();
        
        var combineAvailable = false;
        if (_mainMaterialItem != null)
        {
            using var totalMaterialItems = PooledList<int>.Get();
            totalMaterialItems.Add(_mainMaterialItem.GetData()!.MaterialId);
            foreach (var subMaterialItem in _subMaterialItems)
            {
                if (subMaterialItem == null || !subMaterialItem.IsValid())
                    continue;
                totalMaterialItems.Add(subMaterialItem.GetData()!.MaterialId);
            }

            if (_recipe.HasEnoughMaterial(totalMaterialItems)) 
                combineAvailable = true;
            
        }


        using (var interactor = new ButtonInteractor(btnCombine))
        {
            interactor.Update(combineAvailable,  "CannotCombineEquipment".L());
        }
        
        using (var interactor = new ButtonInteractor(btnCombineAll))
        {
            using var autoCombinableRecipeIds = GetAutoCombinableRecipeIds();
            interactor.Update(autoCombinableRecipeIds.Count > 0, "CannotAutoCombineEquipment".L());
        }
    }

    private void InitButtons()
    {
        btnCombineAll.SetOnClick(OnClickCombineAllButton);
        btnCombine.SetOnClick(OnClickCombineButton);
    }

    public void OnClickCombineButton()
    {
        RequestCombine().Forget();
    }

    private async UniTask RequestCombine()
    {
        using var itemIds = PooledList<long>.Get();
        itemIds.Add(_mainMaterialItem.Id);
        itemIds.AddRange(_subMaterialItems.Select(subItem => subItem.Id));
        
        var response = await SendPacket<CreateItemRequest.Types.Response>(Packet.Pop(0, new CreateItemRequest
        {
            RecipeItemDataId = _recipe.Id,
            Count = 1,
            SelectedMaterialItemIds = { itemIds }
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
            ResetMaterialEquipments();
        }
    }
    
    private PooledList<int> GetAutoCombinableRecipeIds()
    {
        using var materialCounts = PooledDictionary<int, long>.Get(); 
        var selectedRecipeDataIds = PooledList<int>.Get();
        foreach (var recipe in ResourceItem.GetAllByTag(Tag.EquipmentCombineRecipe))
        {
            if (!recipe.ContainsTag(Tag.AutoCombineAvailable))
                continue;
            
            while (true)
            {
                var (hasEnough, selectedMaterialCounts) = MyPlayer.HasEnoughMaterial(materialCounts, recipe.MaterialItemGroups);
                if (!hasEnough)
                    break;

                foreach (var (materialId, count) in selectedMaterialCounts)
                    materialCounts[materialId] = materialCounts.GetValueOrDefault(materialId) - count;
                selectedMaterialCounts.Dispose();
                
                selectedRecipeDataIds.Add(recipe.Id);
            }
        }

        return selectedRecipeDataIds;
    }

    private void OnClickCombineAllButton()
    {
        RequestCombineAll().Forget();
    }

    private async UniTask RequestCombineAll()
    {
        using var selectedRecipeDataIds = GetAutoCombinableRecipeIds();

        var response = await SendPacket<CreateItemRequest.Types.Response>(Packet.Pop(0, new CreateItemRequest()
        {
            RecipeItemDataIds = { selectedRecipeDataIds },
            Count = 1
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
            ResetMaterialEquipments();
        }
    }
    
    private void RefreshMaterialEquipments()
    {
        var mainMaterialCell = mainMaterialElement.Get<PlacedItemCell>();
        mainMaterialCell.Refresh(_mainMaterialItem);
        
        var isMainMaterialSelected = _mainMaterialItem != null;
        goSubMaterials.SetActive(isMainMaterialSelected); // todo: add animation
        _recipe = null;

        if (isMainMaterialSelected)
        {
            mainMaterialCell.btnCell.SetOnClick(ResetMaterialEquipments);
            var recipes = mergeRecipesByMaterialId[_mainMaterialItem.GetData()!.MaterialId];
            
            foreach (var recipe in recipes)
            {
                var targetItem = recipe.AddItemGroups.GetAddItem();
                if (targetItem.GetData().ParentId != _mainMaterialItem.ItemDataId) 
                    continue;
                _recipe = recipe;
                break;
            }
            if (_recipe == null)
            {
                Debug.LogError($"No recipe found for {_mainMaterialItem.GetData()!.Id}");
                return;
            }
            
            using var _ = ListPool<PlayerItemMessage>.Get(out var subMaterialItems);
            
            var subMaterialCount = _recipe.MaterialItemGroups.Count - 1;
            _subMaterialItems.ResizeAndFillNew(subMaterialCount);
            subMaterialItems.AddRange(_subMaterialItems);
            foreach (var (element, index, item) in subMaterialElements.GetElements(subMaterialItems))
            {
                var cell = element.Get<PlacedItemCell>();
                cell.Refresh(item);
                cell.btnCell.SetOnClick(() =>
                {
                    if (item == null)
                        return;

                    _subMaterialItems[index] = new PlayerItemMessage();
                    AddRefreshFlag(RefreshFlag.ALL);
                });
            }

            var firstAddItem = _recipe.AddItemGroups.GetAddItem();
            if (firstAddItem == null)
            {
                Debug.LogError($"No add item found for Recipe {_recipe.Id}");
                return;
            }

            resultElement.Get<PlacedItemCell>().Refresh(new PlayerItemMessage
            {
                ItemDataId = firstAddItem.ItemDataId,
                Level = _mainMaterialItem.Level
            });
            _resultResItem = ResourceItem.Get(firstAddItem.ItemDataId);
            if (_resultResItem == null)
                Debug.LogError($"No result item found for Recipe {_recipe.Id}");
        }
        else
        {
            resultElement.Get<PlacedItemCell>().SetActive(false);
            _resultResItem = null;
        }

        txtCombineEquation.text = _recipe?.ClientDesc;
    }
    
    private void RefreshUpgradeDetails()
    {
        goEmptyResult.SetActive(_mainMaterialItem == null);
        goResult.SetActive(_mainMaterialItem != null);
        
        if (_mainMaterialItem == null)
            return;

        txtResultItemName.text = _resultResItem.ClientName;
        
        
        var mainResItem = _mainMaterialItem.GetData()!;
        var prevInfo = mainResItem.EquipAddStats.AsSorted().FirstOrDefault();
        var curInfo = _resultResItem.EquipAddStats.AsSorted().FirstOrDefault();
        
        var formattedOriginalValue = prevInfo.GetFormatString(_mainMaterialItem.Level);
        var formattedNewValue = curInfo.GetFormatString(_mainMaterialItem.Level);
        txtResultItemMainStat.text = $"{nameof(Popup_CombineEquipment)}_StatUpgradeFormat".L(curInfo.info.GetName(), formattedOriginalValue, formattedNewValue);

        var newBuffAdded = _resultResItem.EquipAddBuffs.Count > 0 &&
                           _resultResItem.EquipAddBuffs.Count > mainResItem.EquipAddBuffs.Count;
        txtResultIemAddedBuff.SetActive(newBuffAdded);
        if (newBuffAdded)
        {
            var addBuff = _resultResItem.EquipAddBuffs.Last();
            var resBuff = ResourceBuff.Get(addBuff.BuffDataId)!;
            txtResultIemAddedBuff.text = $"{nameof(Popup_CombineEquipment)}_NewEffectFormat".L(resBuff.ClientDesc);
        }
    }
    
    private void RefreshEquipmentTable()
    {
        var myPlayerAvatar = MyPlayer.PlayerAvatar;
        if (myPlayerAvatar == null)
            return;
                
        // using var _ = ListPool<PlayerItemMessage>.Get(out var equipmentList);
        using var equipmentSet = PooledHashSet<PlayerItemMessage>.Get(); 
        foreach (var playerItem in MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Equipment))
        {
            if (!playerItem.IsValid())
                continue;
            equipmentSet.Add(playerItem);
        }

        if (_recipe != null)
        {
            foreach (var materialItem in _recipe.MaterialItemGroups.AsValueEnumerable().SelectMany(x => x.MaterialItems))
            {
                foreach (var item in MyPlayer.GetItemsByMaterialId(materialItem.Id).AsValueEnumerable().Where(x => x.IsValidAsMaterial()))
                {
                    if (item.GetData()!.Category != ResourceItem.Types.Category.Material)
                        continue;
                    
                    for (var i = 0; i < item.GetCount(); i++)
                    {
                        equipmentSet.Add(new PlayerItemMessage()
                        {
                            Id = item.Id,
                            ItemDataId = item.ItemDataId,
                            Count = 1,
                            Param4 = i
                        });
                    }
                }
            }
        }
        
        using var equipmentList = PooledList<PlayerItemMessage>.Get();
        equipmentList.AddRange(equipmentSet);
        equipmentList.Sort((a, b) =>
        {
            // 0) 메인 아이템/합성 가능 여부 계산
            if (_mainMaterialItem != null)
            {
                var aIsMain = a.Id == _mainMaterialItem.Id;
                var bIsMain = b.Id == _mainMaterialItem.Id;

                // 메인 아이템이 양쪽 모두면 동일 취급
                if (aIsMain && bIsMain) return 0;
                if (aIsMain) return -1;   // a가 메인 -> a 먼저
                if (bIsMain) return 1;    // b가 메인 -> b 먼저

                var aInRecipe = CanCombine(_mainMaterialItem, a);
                var bInRecipe = CanCombine(_mainMaterialItem, b);

                // true가 먼저 오도록: true > false 이므로 b.CompareTo(a)
                if (aInRecipe != bInRecipe)
                    return bInRecipe.CompareTo(aInRecipe);
            }

            // 1) 데이터 가져오기
            var resItemA = a.GetData();
            var resItemB = b.GetData();

            // 2) null 처리: null을 뒤로 보냄
            if (resItemA == null && resItemB == null) return 0;
            if (resItemA == null) return 1;
            if (resItemB == null) return -1;

            // 등급 내림차순
            if (resItemB.Grade != resItemA.Grade)
                return resItemB.Grade.CompareTo(resItemA.Grade);
            // 티어 내림차순
            if (resItemA.Tier != resItemB.Tier)
                return resItemB.Tier.CompareTo(resItemA.Tier);
            // 타입 오름차순
            if (resItemA.Type != resItemB.Type)
                return resItemA.Type.CompareTo(resItemB.Type);
            // 아이디 오름차순
            return resItemB.Id.CompareTo(resItemA.Id);
        });
        
        var count = Mathf.CeilToInt(equipmentList.Count / 5f);
        
        equipmentTableElement.table.Initialize<PlayerItemMessage, UITableRow<ItemCellBehaviourWrapperElement>>(equipmentList, (equipments, rowIndex, row) =>
        {
            for (var i = 0; i < 5; i++)
            {
                var idx = rowIndex * 5 + i;
                var cell = row.cells[i].Get<CombinableItemCell>();
                var item = equipments.GetSafe(idx);
                var resItem = cell.Refresh(item);
                if (resItem == null)
                    continue;

                var isDimmed = item.IsEquipped()
                               || !mergeRecipesByMaterialId.ContainsKey(resItem.MaterialId)
                               || (_mainMaterialItem != null && !CanCombine(_mainMaterialItem, item));
                var isSelected = _mainMaterialItem?.Id == item.Id ||
                                 _subMaterialItems?.Any(subItem => MatchSubMaterial(subItem, item)) == true;

                cell.redDot.SetActive(_mainMaterialItem == null && _mergeableMaterialIds.Contains(resItem.MaterialId));
                cell.ShowDim(isDimmed);
                cell.ShowSelected(isSelected);
                
                cell.btnCell.SetOnClick(() =>
                {
                    if (item.IsEquipped())
                    {
                        "CannotCombineEquippedItem".ToToast();
                        return;
                    }

                    if (isDimmed)
                    {
                        "CannotCombineItem".ToToast();
                        return;
                    }

                    if (_mainMaterialItem == null)
                    {
                        _mainMaterialItem = item;
                        equipmentTableElement.table.ScrollToRatio(0f);
                    }
                    else if (_mainMaterialItem.Id == item.Id)
                    {
                        // 메인 재료가 선택되어 있다면 리셋
                        ResetMaterialEquipments();
                    }
                    else if (_subMaterialItems.FindIndex(subItem => MatchSubMaterial(subItem, item)) is var subMaterialIndex and >= 0)
                    {
                        // 이미 서브 재료로 선택되어 있다면 해제
                        _subMaterialItems[subMaterialIndex] = new PlayerItemMessage();
                    }
                    else
                    {
                        var blankIndex = _subMaterialItems.FindIndex(subItem => subItem.Id == 0);
                        if (blankIndex == -1)
                            return;
                        _subMaterialItems[blankIndex] = item;
                    }
                    AddRefreshFlag(RefreshFlag.ALL);
                });
            }
        }, count);
        
        return;
        
        bool MatchSubMaterial(PlayerItemMessage subMaterialItem, PlayerItemMessage item)
        {
            return subMaterialItem.Id == item.Id && subMaterialItem.Param4 == item.Param4;
        }
        
    }
    
    private bool CanCombine(PlayerItemMessage mainMaterialItem, PlayerItemMessage subMaterialItem)
    {
        if (mainMaterialItem == null || subMaterialItem == null)
            return false;
        
        if (_recipe == null)
            return false;

        if (mainMaterialItem.Id == subMaterialItem.Id)
            return true;
        
        if (mainMaterialItem.GetData() == null || subMaterialItem.GetData() == null)
            return false;
        
        return _recipe.MaterialItemGroups.Any(materialItemGroup =>
        {
            //메인 재료 그룹은 shouldAllValid이 true이므로 패스
            return !materialItemGroup.ShouldAllValid && materialItemGroup.MaterialItems.Any(materialItem => materialItem.Id == subMaterialItem.GetData()!.MaterialId);
        });
    }
    
    private void ResetMaterialEquipments()
    {
        _mainMaterialItem = null;
        _subMaterialItems.Clear();
        _recipe = null;
        AddRefreshFlag(RefreshFlag.ALL);
    }
    
    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED
                                     | RefreshFlag.MY_ACHIEVEMENT_UPDATED
                                     | RefreshFlag.MY_AVATAR_UPDATED))
        {
            Refresh();
        }
    }
}
