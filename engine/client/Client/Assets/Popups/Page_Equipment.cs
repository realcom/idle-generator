using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;
using ZLinq;

public class Page_Equipment : ZModePage
{
    [Serializable]
    public class EquipmentPartCell : PlacedItemCell
    {
        public RedDot redDot;
    }
    
    [FoldoutGroup("RedDots")] public RedDot redDotPet;
    [FoldoutGroup("RedDots")] public RedDot redDotCombineEquipment;
    
    [Title("Equipped")]
    public Dictionary<ResourceItem.Types.Type, ItemCellBehaviourWrapperElement> cellsByPartType;
    
    [Title("Info")]
    public UnitUIRenderer unitUIRenderer;
    public TextMeshProUGUI txtStatHp;
    public TextMeshProUGUI txtStatAtk;
    public TextMeshProUGUI txtStatDefense;
    public CustomButton btnPet;
    public CustomButton btnCostume;
    public CustomButton btnArtifact;
    
    [Serializable]
    public class TableElement : UITableElement<UITableRow<ItemCellBehaviourWrapperElement>> { }
    [Title("Table")]
    public TableElement equipmentTableElement = new();
    public UITableViewEx equipmentTable;
    
    public CustomButton btnCombine;
    public CustomButton btnOrder;
    public TextMeshProUGUI txtOrder;
    
    private OrderType currentOrderType = OrderType.Grade;
    
    public static IEnumerable<ResourceEntity> GetNoticeRelevanceEntities()
    {
        return Popup_Pet.GetNoticeRelevanceEntities()
            .Concat(Popup_CombineEquipment.GetMergeableEquipmentNoticeRelevanceEntities())
            .Concat(GetEquipmentLevelUpNoticeEntities());
    }

    private static IEnumerable<ResourceEntity> GetEquipmentLevelUpNoticeEntities(ResourceItem.Types.Type? partType = null)
    {
        foreach (var slotRoot in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.SlotRoot))
        {
            if (!slotRoot.IsValid)
                continue;
            if (partType.HasValue && slotRoot.Type != partType.Value)
                continue;
            
            yield return slotRoot;
        }
        
        foreach (var equipment in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Equipment))
        {
            if (!equipment.IsValid)
                continue;
            if (partType.HasValue && equipment.Type != partType.Value)
                continue;
            if (equipment.GetLevelUpSourceItem().Id != equipment.Id)
                continue;
            
            yield return equipment;
        }
    }
    
    public static IEnumerable<int> GetNoticePrerequisites()
    {
        return Popup_Pet.GetNoticePrerequisiteAchievements();
    }
    
    public enum OrderType
    {
        Grade,
        Type,
    }
    
    public override void Awake()
    {
        base.Awake();
        
        GameManager.Get().AddListener(this);
    }

    public override void Start()
    {
        base.Start();

        InitButtons();

        var resItem = MyPlayer.PlayerAvatar.Character.GetData();
        unitUIRenderer.Initialize(resItem);

        foreach (var (partType, element) in cellsByPartType)
        {
            element.Get<EquipmentPartCell>().redDot.Register(GetEquipmentLevelUpNoticeEntities(partType));
        }
    }

    public override void InitializeUsingToken(string[] tokens)
    {
        
    }

    public override void OnVisible()
    {
        Refresh();
    }

    public override void OnHide()
    {
    }
    
    public override void Refresh()
    {
        RefreshOrderText();
        RefreshStats();
        RefreshEquippedEquipments();
        RefreshEquipmentTable();
        RefreshButtons();
    }

    private void RefreshButtons()
    {
        using (var interactor = new ButtonInteractor(btnPet))
        {
            var lockAchievementDataId = ResourceAchievement.Global.DataId.EquipmentPetUnlock;
            interactor.Update(MyPlayer.IsAchievementCompletedOrRewarded(lockAchievementDataId), ResourceAchievement.Get(lockAchievementDataId)!.ClientUnlockToast);
        }
    }

    private void InitButtons()
    {
        // TODO: set onclick
        //btnOrder.SetOnClick(() => Toast.Show<Popup_Toast>("Coming Soon".L()));
        btnCombine.SetOnClick(() => GameManager.Get().ShowPopup<Popup_CombineEquipment>());
        
        btnOrder.SetOnClick(OnClickOrderButton);
        
        btnPet.SetOnClick(() => GameManager.Get().ShowPopup<Popup_Pet>());

        using (var register = new NoticeSystem.RegisterScope(redDotPet))
        {
            register.AddNoticeRelevanceEntities(Popup_Pet.GetNoticeRelevanceEntities());
            register.AddPrerequisitesCondition(ResourceAchievement.Global.DataId.EquipmentPetUnlock);
        }
        
        redDotCombineEquipment.Register(Popup_CombineEquipment.GetMergeableEquipmentNoticeRelevanceEntities());
        btnCostume.SetOnClick(() => Toast.Show<Popup_Toast>("Coming Soon".L()));
        btnArtifact.SetOnClick(() => Toast.Show<Popup_Toast>("Coming Soon".L()));
    }

    public void OnClickOrderButton()
    {
        currentOrderType = (OrderType)(((int)currentOrderType + 1) % Enum.GetValues(typeof(OrderType)).Length);
        RefreshOrderText();
        RefreshEquipmentTable();
    }

    private void RefreshOrderText()
    {
        txtOrder.text = currentOrderType switch
        {
            OrderType.Grade => StringKeys.Client.Page_Equipment_Order_Rank.L(),
            OrderType.Type => StringKeys.Client.Page_Equipment_Order_Type.L(),
            _ => StringKeys.Client.Page_Equipment_Order_Rank.L()
        };
    }

    private void RefreshStats()
    {
        txtStatHp.text = CRC.Get().statInfo[UnitStatType.Hp].Format((double)MyPlayer.PlayerUnitStat.MaxHp);
        txtStatAtk.text = CRC.Get().statInfo[UnitStatType.Attack].Format((double)MyPlayer.PlayerUnitStat.Attack);
        txtStatDefense.text = CRC.Get().statInfo[UnitStatType.Defense].Format((double)MyPlayer.PlayerUnitStat.Defense);
    }
    
    private void RefreshEquippedEquipments()
    {
        foreach (var (partType, element) in cellsByPartType)
        {
            var slot = PlayerAvatar.ToEquipmentSlot(partType);
            if (partType == ResourceItem.Types.Type.Ring)
                slot = PlayerAvatar.EquipmentSlot.Ring1;

            var item = MyPlayer.PlayerAvatar.Equipments.GetSafe(slot);
            var cell = element.Get<PlacedItemCell>();
            cell.Refresh(item);
            cell.btnCell.interactable = item != null;
            cell.btnCell.SetOnClick(() =>
            {
                GameManager.Get().ShowPopup<Popup_EquipInfo>().Initialize(item);
            });
        }
    }
    
        
    private void RefreshEquipmentTable()
    {
        var myPlayerAvatar = MyPlayer.PlayerAvatar;
        if (myPlayerAvatar == null)
            return;
        
        using var equipmentList = PooledList<PlayerItemMessage>.Get();

        foreach (var playerItem in MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Equipment))
        {
            if (playerItem == null || !playerItem.IsValid())
                continue;
            if (playerItem.IsEquipped())
                continue;
            equipmentList.Add(playerItem);
        }
        
        equipmentList.Sort((a, b) =>
        {
            var resItemA = a.GetData();
            var resItemB = b.GetData();

            if (resItemA == null || resItemB == null)
                return 0;

            switch (currentOrderType)
            {
                case OrderType.Grade:
                    if (resItemA.Grade != resItemB.Grade)
                        return resItemB.Grade.CompareTo(resItemA.Grade);
                    if (resItemA.Tier != resItemB.Tier)
                        return resItemB.Tier.CompareTo(resItemA.Tier);
                    if (resItemA.Type != resItemB.Type)
                        return resItemA.Type.CompareTo(resItemB.Type);
                    return b.ItemDataId.CompareTo(a.ItemDataId);
                case OrderType.Type:
                    if (resItemA.Type != resItemB.Type)
                        return resItemA.Type.CompareTo(resItemB.Type);
                    if (resItemA.Grade != resItemB.Grade)
                        return resItemB.Grade.CompareTo(resItemA.Grade);
                    if (resItemA.Tier != resItemB.Tier)
                        return resItemB.Tier.CompareTo(resItemA.Tier);
                    return b.ItemDataId.CompareTo(a.ItemDataId);
            }

            return 0;
        });
        
        const int columnCount = 5;
        var count = Mathf.CeilToInt(equipmentList.Count / (float)columnCount);
        equipmentTable.Initialize<PlayerItemMessage, UITableRow<ItemCellBehaviourWrapperElement>>(equipmentList, (equipments, rowIndex, row) =>
        {
            for (var i = 0; i < columnCount; i++)
            {
                var idx = rowIndex * 5 + i;
                var element = row.cells[i];
                var item = equipments.GetSafe(idx);
                var cell = element.Get<ItemCellBase>();
                cell.Refresh(item);
                cell.btnCell.SetOnClick(() =>
                {
                    GameManager.Get().ShowPopup<Popup_EquipInfo>().Initialize(item);
                });
            }
        }, count);
    }
    
    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);
        
        if (!gameObject.activeInHierarchy)
            return;

        switch (e.type)
        {
            case GameEventType.MyPlayerAchievementUpdated:
            case GameEventType.MyPlayerItemUpdated:
            case GameEventType.MY_PLAYER_AVATAR_UPDATED:
            {
                Refresh();
                break;
            }
            case GameEventType.MY_STATS_UPDATED:
            {
                RefreshStats();
                break;
            }
        }
    }
    
    public PlayerItemMessage GetFirstEquipment()
    {
        return MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Equipment).First(x => x.IsValid() && !x.IsEquipped());
    }
    
}
