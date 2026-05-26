using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Popup_Pet : UIPopup, IGoodsViewer
{
    public UITabBar tabBar;
    public GoodsContainer goodsContainer = new();

    [Serializable]
    public class PetCell : UIElement
    {
        public CustomButton button;
        public Image imgFootBoard;
        public GameObject goPanel_Locked;
        public GameObject goPanel_Empty;
        public UnitUIRenderer unitUIRenderer;
        public LevelStars levelStars;
        public TextMeshProUGUI txtLevel;
        public TextMeshProUGUI txtName;

        public Animator animUnitUIRenderer;

        public void Refresh(PlayerItemMessage item, int index, Popup_Pet popup)
        {
            var lockAchievementDataId = ResourceAchievement.Global.DataId.PetSlotUnlocks.GetSafe(index);
            var resAchievement = ResourceAchievement.Get(lockAchievementDataId);
            var achievement = MyPlayer.GetAchievementByDataID(resAchievement);
            var isLocked = resAchievement != null && achievement?.IsAchievementCompletedOrRewarded() == false;
            var isEmpty = item == null || item.Id == 0;
            var resItem = item?.GetData();
            imgFootBoard.sprite = isLocked ? CRC.Get().gradeFootboardSprites.Last() : CRC.Get().gradeFootboardSprites.GetClamped(resItem?.Grade ?? 0);
            goPanel_Locked.SetActive(isLocked);
            goPanel_Empty.SetActive(!isLocked && isEmpty);
            unitUIRenderer.Initialize(resItem);
            levelStars.Refresh(item);
            txtLevel.text = isLocked ? resAchievement.ClientDesc : (isEmpty ? "" : "Level".L(item.Level.ToString()));
            txtName.text = isLocked ? "Locked".L() : resItem?.ClientName;

            if (isLocked)
            {
                button.SetOnClick(() =>
                {
                    Toast.Show<Popup_Toast>(resAchievement.ClientUnlockToast);
                });
            }
            else if (isEmpty)
            {
                button.SetOnClick(() =>
                {
                    popup.tabBar.selectedIndex = 1;
                    "Popup_Pet_TryDeployPet".ToToast();
                });
            }
            else
            {
                button.SetOnClick(() =>
                {
                    if (popup.selectedPet != null)
                    {
                        DeployPet(popup.selectedPet, item);
                    }
                    else
                    {
                        popup.tabBar.selectedIndex = 1;
                        GameManager.Get().ShowPopup<Popup_PetInfo>().Initialize(item);   
                    }
                });
            }
        }
    }
    
    [FoldoutGroup("Pet")] public PetCell petCell_1;
    [FoldoutGroup("Pet")] public PetCell petCell_2;
    [FoldoutGroup("Pet")] public PetCell petCell_3;

    [Serializable]
    public class PetSpawnMachine : UIElement
    {
        public Image imgIcn_Gacha_Machine;
        public Image imgGacha_Multiplier;
        public CustomButton btnGacha_Multiplier;
        public TextMeshProUGUI txtMultiply;
        public MinimalPurchaseProductCell cellPurchaseProduct;
        public TextMeshProUGUI txtSpawnCount;

        public void Refresh(ResourceItem resSpawnProduct)
        {
            imgIcn_Gacha_Machine.sprite = resSpawnProduct.ClientSpriteIcon;

            var canMultiply = resSpawnProduct.Multipliers.Count > 0;
            btnGacha_Multiplier.SetActive(canMultiply);
            if (canMultiply)
            {
                var key = $"PetSpawnMultiplier_{resSpawnProduct.Id}";
                var prefs = GameManager.Get().GetTransientPrefs<int>(key);
                
                var multiplier = resSpawnProduct.SetClientPurchaseMultiplier(resSpawnProduct.Multipliers.GetClamped(prefs));
                
                // Highlight the multiplier button if it's the last multiplier
                imgGacha_Multiplier.color = resSpawnProduct.Multipliers.Count - 1 == prefs ? Color.red : Color.white;

                txtMultiply.text = $"x{multiplier}";
                btnGacha_Multiplier.SetOnClick(() =>
                {
                    prefs.Set((prefs + 1) % resSpawnProduct.Multipliers.Count);
                    Refresh(resSpawnProduct);
                });
            }

            cellPurchaseProduct.Refresh(resSpawnProduct);
            txtSpawnCount.text = $"x{resSpawnProduct.GetPurchaseUnit()}";
        }
    }

    [FoldoutGroup("Summon")] public TextMeshProUGUI txtSummonLevel;
    [FoldoutGroup("Summon")] public TextMeshProUGUI txtSummonExp;
    [FoldoutGroup("Summon")] public Slider sliderSummonExpProgress;
    [FoldoutGroup("Summon")] public UIElementContainer<PetSpawnMachine> petSpawnMachines = new();
    
    
    [FoldoutGroup("Summon/Premium")] public PremiumLandingBanner premiumLandingBanner;
    
    [FoldoutGroup("RedDot")] public RedDot redDotSummonTab;
    [FoldoutGroup("RedDot")] public RedDot redDotManagementTab;
    
    [Serializable]
    public class PetTableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>> {}

    [FoldoutGroup("Management")] public PetTableElement petTableElement = new();
    [FoldoutGroup("Management")] public GameObject panelDeploySlotSelect;
    [FoldoutGroup("Management")] public UnitUIRenderer unitUIRendererDeploySlotSelect;
    [FoldoutGroup("Management")] public CanvasGroup cgTopBar;
    [FoldoutGroup("Management")] public CanvasGroup cgTabBar;

    private static IEnumerable<ResourceEntity> GetSummonTabNoticeRelevanceEntities()
    {
        return ResourceItem.GetAllByTag(Tag.SummonPet);
    }
    
    private static IEnumerable<ResourceEntity> GetManagementTabNoticeRelevanceEntities()
    {
        return Enumerable.Empty<ResourceEntity>();
        
        return ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Pet);
    }
    
    public static IEnumerable<ResourceEntity> GetNoticeRelevanceEntities()
    {
        return GetSummonTabNoticeRelevanceEntities()
            .Concat(GetManagementTabNoticeRelevanceEntities());
    }
    
    public static IEnumerable<int> GetNoticePrerequisiteAchievements()
    {
        yield return ResourceAchievement.Global.DataId.EquipmentPetUnlock;
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);
    }

    protected override void Start()
    {
        tabBar.onTabSelected.RemoveAllListeners();
        tabBar.onTabSelected.AddListener((_) => AddRefreshFlag(RefreshFlag.ALL));

        redDotSummonTab.Register(GetSummonTabNoticeRelevanceEntities());
        redDotManagementTab.Register(GetManagementTabNoticeRelevanceEntities());

        StopDeploySlotSelect();
        
        base.Start();
    }

    public override void Refresh()
    {
        base.Refresh();

        if (MyPlayer.PlayerAvatar?.GetDeployedPetSlot(selectedPet?.Id ?? long.MinValue) >= 0)
            StopDeploySlotSelect();
        
        RefreshPet();
        switch (tabBar.selectedIndex)
        {
            case 0:
                RefreshSummon();
                break;
            case 1:
                RefreshManagement();
                break;
        }
    }

    private void RefreshPet()
    {
        var pets = MyPlayer.PlayerAvatar?.Pets;
        petCell_1.Refresh(pets?.GetSafe(PlayerAvatar.PetSlot.Pet1), PlayerAvatar.PetSlot.Pet1, this);
        petCell_2.Refresh(pets?.GetSafe(PlayerAvatar.PetSlot.Pet2), PlayerAvatar.PetSlot.Pet2, this);
        petCell_3.Refresh(pets?.GetSafe(PlayerAvatar.PetSlot.Pet3), PlayerAvatar.PetSlot.Pet3, this);
    }

    private void RefreshSummon()
    {
        var summonLevelItem = MyPlayer.GetItemsByType(ResourceItem.Types.Type.SummonPetLevel).FirstOrDefault(x => x?.IsValid() == true);
        if (summonLevelItem == null)
            return;
        
        var resSummonLevel = summonLevelItem.GetData()!;

        var baseLevel = summonLevelItem.Level;
        var bonusLevel = summonLevelItem.GetBonusLevel();
        var summonLevel = baseLevel + bonusLevel;
        var color = bonusLevel > 0 ? Color.yellow : Color.white;
        var summonLevelText = $"<color=#{color.ToHex()}>{summonLevel}</color>";
        txtSummonLevel.text = "Popup_Pet_SummonLevel".L(summonLevelText);
        txtSummonLevel.color = bonusLevel > 0 ? Color.yellow : Color.white;
        var exp = summonLevelItem.Exp;
        var requiredExp = resSummonLevel.RequiredExps.GetClamped(baseLevel - 1);
        var ratio = (float)exp / requiredExp;
        txtSummonExp.text = resSummonLevel.MaxLevel > baseLevel ? $"{exp}/{requiredExp}" : "MAX".L();
        
        sliderSummonExpProgress.value = ratio;

        using var spawnMachines = PooledList<ResourceItem>.Get();
        foreach (var resourceItem in ResourceItem.GetAllByTag(Tag.SummonPet))
        {
            if (!resourceItem.IsValid)
                continue;
            
            spawnMachines.Add(resourceItem);
        }

        spawnMachines.Sort((x, y) => x.Order.CompareTo(y.Order));
        
        foreach (var (element, i, resProduct) in petSpawnMachines.GetElements(spawnMachines))
        {
            element.Refresh(resProduct);
        }

        premiumLandingBanner.Refresh(CRC.Get().premiumItemDataIdByKey.GetValueOrDefault("Popup_Pet_SummonPremium"));

    }

    private void RefreshManagement()
    {
        using var pets = PooledList<PlayerItemMessage>.Get();
        foreach (var itemMessage in MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Pet))
        {
            if (!itemMessage.IsValid(checkCount: false))
                continue;

            pets.Add(itemMessage);
        }
        
        pets.Sort((x, y) =>
        {
            var xData = x.GetData()!;
            var yData = y.GetData()!;

            if (xData.Grade == yData.Grade)
                return x.ItemDataId.CompareTo(y.ItemDataId);
            
            return yData.Grade.CompareTo(xData.Grade);
        });
        
        const int columnCount = 5;
        petTableElement.table.Initialize<PlayerItemMessage, UITableRow<ItemCellBehaviourWrapperElement>>(pets, (datas, rowIndex, row) =>
        {
            for (var i = 0; i < columnCount; i++)
            {
                var idx = i + rowIndex * columnCount;
                var cell = row.cells[i].Get<EquippablePetTableCell>();
                var pet = datas.GetSafe(idx);
                cell.Refresh(pet);

                if (pet != null)
                {
                    cell.btnCell.SetOnClick(() =>
                    {
                        GameManager.Get().ShowPopup<Popup_PetInfo>().Initialize(pet);
                    });
                }
            }
        }, Mathf.CeilToInt(pets.Count / (float)columnCount));
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED))
        {
            RefreshGoods();
        }

        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED | RefreshFlag.MY_AVATAR_UPDATED))
        {
            Refresh();
        }
    }

    public void RefreshGoods()
    {
        RefreshGoods(CRC.Get().GetGoodsItemDataIds(nameof(Popup_Pet)));
    }

    public void RefreshGoods(IList<int> goodsIds)
    {
        goodsContainer.RefreshGoods(goodsIds);
    }

    public void OnClickSummonLevelDetail()
    {
        var summonLevelItem = MyPlayer.GetItemsByType(ResourceItem.Types.Type.SummonPetLevel).FirstOrDefault(x => x?.IsValid() == true);
        GameManager.Get().ShowPopup<Popup_Info_Probability_Summon>().Initialize(summonLevelItem.GetData());
    }

    private PlayerItemMessage selectedPet = null;
    public void StartDeploySlotSelect(PlayerItemMessage pet)
    {
        panelDeploySlotSelect.SetActive(true);
        unitUIRendererDeploySlotSelect.Initialize(pet.GetData(), AnimNames.Select);

        petCell_1.animUnitUIRenderer.PlayForward(this, AnimatorHash.Anim);
        petCell_2.animUnitUIRenderer.PlayForward(this, AnimatorHash.Anim);
        petCell_3.animUnitUIRenderer.PlayForward(this, AnimatorHash.Anim);

        cgTopBar.interactable = cgTopBar.blocksRaycasts = cgTabBar.interactable = cgTabBar.blocksRaycasts = false;

        selectedPet = pet;
    }

    public void StopDeploySlotSelect()
    {
        selectedPet = null;
        
        panelDeploySlotSelect.SetActive(false);
        unitUIRendererDeploySlotSelect.Hide();
        
        petCell_1.animUnitUIRenderer.Rebind();
        petCell_2.animUnitUIRenderer.Rebind();
        petCell_3.animUnitUIRenderer.Rebind();
        
        cgTopBar.interactable = cgTopBar.blocksRaycasts = cgTabBar.interactable = cgTabBar.blocksRaycasts = true;
    }
    
    public static void DeployPet(PlayerItemMessage pet, int slot)
    {
        if (pet is not { Id: > 0 } || slot < 0)
            return;
        
        ZWorldClient.Get().SendPacket(Packet.Pop(0, new UseCashItemRequest()
        {
            ItemId = pet.Id,
            Slot = slot,
        })).Forget();
    }
    
    public static void DeployPet(PlayerItemMessage pet, PlayerItemMessage existingPet)
    {
        if (pet is not { Id: > 0 })
            return;

        var slot = MyPlayer.PlayerAvatar?.GetDeployedPetSlot(existingPet?.Id ?? long.MinValue) ?? -1;

        DeployPet(pet, slot);
    }

    public static bool QuickDeployPet(PlayerItemMessage pet)
    {
        if (pet is not { Id: > 0 })
            return false;
        
        var emptySlot = MyPlayer.PlayerAvatar?.GetEmptyPetSlot() ?? -1;
        if (emptySlot > -1)
        {
            ZWorldClient.Get().SendPacket(Packet.Pop(0, new UseCashItemRequest()
            {
                ItemId = pet.Id,
                Slot = emptySlot
            })).Forget();

            return true;
        }

        return false;
    }
    
}
