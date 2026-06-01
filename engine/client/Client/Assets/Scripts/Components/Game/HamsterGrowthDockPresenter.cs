using System;
using System.Collections.Generic;
using System.Linq;
using Commons;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class HamsterGrowthDockPresenter : MonoBehaviour
{
    private const int EquipmentSummonProductId = 200503;
    private const int MonsterSoulItemId = 200108;
    private const float RefreshInterval = 0.2f;
    private static readonly Color LockedPreviewTint = new(0.58f, 0.56f, 0.52f, 0.88f);
    private static readonly string[] PreviewOnlyButtonNames =
    {
        "Btn_GrowthReward",
        "Btn_AutoEnhance",
        "Tab_Companion",
        "Tab_Equipment",
        "Tab_Pet",
        "Tab_Adventure",
    };

    private readonly struct GrowthCardSpec
    {
        public GrowthCardSpec(string id, string rootName, string label, int itemDataId, UnitStatType statType, float statGain,
            long baseCost, long costStep, Func<GameUnit, string> valueGetter, string gainText)
        {
            Id = id;
            RootName = rootName;
            Label = label;
            ItemDataId = itemDataId;
            StatType = statType;
            StatGain = statGain;
            BaseCost = baseCost;
            CostStep = costStep;
            ValueGetter = valueGetter;
            GainText = gainText;
        }

        public string Id { get; }
        public string RootName { get; }
        public string Label { get; }
        public int ItemDataId { get; }
        public UnitStatType StatType { get; }
        public float StatGain { get; }
        public long BaseCost { get; }
        public long CostStep { get; }
        public Func<GameUnit, string> ValueGetter { get; }
        public string GainText { get; }
    }

    private sealed class StatCardView
    {
        public RectTransform Root;
        public TextMeshProUGUI Level;
        public TextMeshProUGUI StatName;
        public TextMeshProUGUI Value;
        public TextMeshProUGUI Cost;
        public Button UpgradeButton;
        public Image UpgradeImage;
    }

    private sealed class EquipmentSlotView
    {
        public RectTransform Root;
        public TextMeshProUGUI Label;
        public TextMeshProUGUI Level;
        public Image Icon;
        public Sprite PlaceholderSprite;
    }

    private readonly struct EquipmentSlotSpec
    {
        public EquipmentSlotSpec(string rootName, string emptyLabel)
        {
            RootName = rootName;
            EmptyLabel = emptyLabel;
        }

        public string RootName { get; }
        public string EmptyLabel { get; }
    }

    private static readonly GrowthCardSpec[] CardSpecs =
    {
        new("Attack", "StatCard_Attack", "공격력", 1000, UnitStatType.Attack, 5f, 40, 25,
            unit => unit != null ? FormatCompact(LongFixedFloatMath.ToLongSaturated(unit.Attack)) : "0", "+5"),
        new("Hp", "StatCard_Health", "체력", 1001, UnitStatType.Hp, 45f, 35, 20,
            unit => unit != null ? FormatCompact(unit.MaxHp) : "0", "+45"),
        new("AttackSpeed", "StatCard_GoldGain", "공격속도", 1002, UnitStatType.AttackSpeedPercent, 4f, 55, 30,
            _ => $"+{Mathf.RoundToInt(GetRuntimeStat(UnitStatType.AttackSpeedPercent))}%", "+4%"),
        new("CriticalDamage", "StatCard_GrowthSpeed", "크리티컬 데미지", 1003, UnitStatType.CriticalDamagePercent, 10f, 60, 35,
            _ => $"+{Mathf.RoundToInt(GetRuntimeStat(UnitStatType.CriticalDamagePercent))}%", "+10%"),
    };

    private readonly Dictionary<string, StatCardView> _cardViews = new();
    private static readonly EquipmentSlotSpec[] EquipmentSlotSpecs =
    {
        new("EquipSlot_Weapon", "무기"),
        new("EquipSlot_Head", "머리"),
        new("EquipSlot_Chest", "갑옷"),
        new("EquipSlot_Gloves", "장갑"),
        new("EquipSlot_Boots", "신발"),
        new("EquipSlot_Ring", "반지"),
    };

    private TextMeshProUGUI _combatPowerValue;
    private TextMeshProUGUI _coinValue;
    private TextMeshProUGUI _heartValue;
    private TextMeshProUGUI _stageProgress;
    private TextMeshProUGUI _equipmentSummary;
    private TextMeshProUGUI _soulValue;
    private TextMeshProUGUI _summonLevel;
    private TextMeshProUGUI _summonCost;
    private Button _summonButton;
    private Image _summonButtonImage;
    private readonly List<EquipmentSlotView> _equipmentSlots = new();
    private float _nextRefreshAt;

    private void OnEnable()
    {
        BindReferences();
        BindButtons();
        RefreshFromRuntime();
    }

    private void Update()
    {
        if (Time.unscaledTime >= _nextRefreshAt)
        {
            _nextRefreshAt = Time.unscaledTime + RefreshInterval;
            RefreshFromRuntime();
        }
    }

    public void RefreshFromRuntime()
    {
        var gameBoard = GameBoardManager.Get()?.gameBoard;
        var boardPlayer = GetMyBoardPlayer(gameBoard);
        var unit = GetMyUnit(gameBoard);

        RefreshTopHud(gameBoard, boardPlayer, unit);
        RefreshGrowthCards(boardPlayer, unit);
        RefreshEquipmentPanel();
    }

    public bool TryUpgradeById(string upgradeId, out string feedback)
    {
        feedback = "성장 데이터 없음";
        if (!TryGetSpec(upgradeId, out var spec))
            return false;

        var upgraded = TryUpgrade(spec, out feedback);
        RefreshFromRuntime();
        return upgraded;
    }

    private void BindReferences()
    {
        _combatPowerValue = FindText("CombatPowerPill", "Text_Value");
        _coinValue = FindText("CoinPill", "Text_Value");
        _heartValue = FindText("HeartPill", "Text_Value");
        _stageProgress = FindText("StageProgressPill", "Text_StageProgress");
        _equipmentSummary = FindText("EquipmentPanel", "Text_Summary");
        _soulValue = FindText("EquipmentPanel", "Text_SoulValue");
        _summonButton = FindButton(transform, "Btn_EquipmentSummon");
        _summonLevel = FindText("Btn_EquipmentSummon", "Text_Level");
        _summonCost = FindText("Btn_EquipmentSummon", "Text_Cost");
        _summonButtonImage = _summonButton != null ? _summonButton.GetComponent<Image>() : null;

        _cardViews.Clear();
        foreach (var spec in CardSpecs)
        {
            var root = FindChild(transform, spec.RootName) as RectTransform;
            if (root == null)
                continue;

            var upgradeButton = FindButton(root, "Btn_Upgrade");
            _cardViews[spec.Id] = new StatCardView
            {
                Root = root,
                Level = FindText(root, "Text_Level"),
                StatName = FindText(root, "Text_StatName"),
                Value = FindText(root, "Text_Value"),
                Cost = FindText(root, "Text_Cost"),
                UpgradeButton = upgradeButton,
                UpgradeImage = upgradeButton != null ? upgradeButton.GetComponent<Image>() : null,
            };
        }

        _equipmentSlots.Clear();
        foreach (var spec in EquipmentSlotSpecs)
        {
            var root = FindChild(transform, spec.RootName) as RectTransform;
            if (root == null)
                continue;

            var icon = FindChild(root, "Icon")?.GetComponent<Image>();
            _equipmentSlots.Add(new EquipmentSlotView
            {
                Root = root,
                Label = FindText(root, "Text_Label"),
                Level = FindText(root, "Text_Level"),
                Icon = icon,
                PlaceholderSprite = icon != null ? icon.sprite : null,
            });
        }
    }

    private void BindButtons()
    {
        foreach (var spec in CardSpecs)
        {
            if (!_cardViews.TryGetValue(spec.Id, out var view) || view.UpgradeButton == null)
                continue;

            var capturedSpec = spec;
            view.UpgradeButton.onClick.RemoveAllListeners();
            view.UpgradeButton.onClick.AddListener(() =>
            {
                TryUpgrade(capturedSpec, out _);
                RefreshFromRuntime();
            });
        }

        if (_summonButton != null)
        {
            _summonButton.onClick.RemoveAllListeners();
            _summonButton.onClick.AddListener(() => TrySummonEquipment().Forget());
        }

        var shopTabButton = FindButton(transform, "Tab_Shop");
        if (shopTabButton != null)
        {
            shopTabButton.onClick.RemoveAllListeners();
            shopTabButton.onClick.AddListener(OpenShopTab);
        }

        LockPreviewOnlyButtons();
    }

    private void OpenShopTab()
    {
        if (GameBoardManager.Get()?.modeManager is ModeManagerMushroom modeManager &&
            modeManager.TryOpenPredefinedPage(ModeManagerMushroom.ShopPageAddressKey, Array.Empty<string>()))
            return;

        GameManager.Get()?.ShowPopupAsync(ModeManagerMushroom.ShopPageAddressKey).Forget();
    }

    private void LockPreviewOnlyButtons()
    {
        foreach (var buttonName in PreviewOnlyButtonNames)
        {
            var button = FindButton(transform, buttonName);
            if (button == null)
                continue;

            button.onClick.RemoveAllListeners();
            button.interactable = false;

            var colors = button.colors;
            colors.disabledColor = LockedPreviewTint;
            button.colors = colors;

            foreach (var graphic in button.GetComponentsInChildren<Graphic>(true))
            {
                graphic.color = LockedPreviewTint;
            }
        }
    }

    private void RefreshTopHud(GameBoard gameBoard, BoardPlayerMessage boardPlayer, GameUnit unit)
    {
        if (_combatPowerValue != null)
            _combatPowerValue.text = FormatCompact(GetCombatPower(unit));

        if (_coinValue != null)
            _coinValue.text = FormatCompact(boardPlayer?.Gold ?? 0L);

        if (_heartValue != null)
            _heartValue.text = unit != null && unit.MaxHp > 0
                ? $"{FormatCompact(unit.Hp)}/{FormatCompact(unit.MaxHp)}"
                : "0";

        if (_stageProgress == null)
            return;

        if (gameBoard == null)
        {
            _stageProgress.text = "전투 준비";
            return;
        }

        var wave = (int)gameBoard.Variables.Get(BoardVariableId.Map.wave);
        var enemyCount = gameBoard.GetUnitCountByTeam(GameBoard.Team.Enemy);
        var mapName = !string.IsNullOrEmpty(gameBoard.ResMap?.Name) ? gameBoard.ResMap.Name : "햄스터 전투";
        _stageProgress.text = wave > 0
            ? $"Wave {wave} · 적 {enemyCount}"
            : mapName;
    }

    private void RefreshGrowthCards(BoardPlayerMessage boardPlayer, GameUnit unit)
    {
        foreach (var spec in CardSpecs)
        {
            if (!_cardViews.TryGetValue(spec.Id, out var view))
                continue;

            var level = GetUpgradeLevel(spec);
            var isMaxLevel = IsMaxLevel(spec);
            var cost = GetUpgradeCost(spec);
            var canUpgrade = boardPlayer != null && !isMaxLevel && boardPlayer.Gold >= cost;

            if (view.Level != null)
                view.Level.text = isMaxLevel ? "MAX" : $"Lv.{level}";
            if (view.StatName != null)
                view.StatName.text = spec.Label;
            if (view.Value != null)
                view.Value.text = spec.ValueGetter(unit);
            if (view.Cost != null)
                view.Cost.text = isMaxLevel ? "MAX" : FormatCompact(cost);
            if (view.UpgradeButton != null)
                view.UpgradeButton.interactable = boardPlayer != null && !isMaxLevel;
            if (view.UpgradeImage != null)
                view.UpgradeImage.color = canUpgrade
                    ? Color.white
                    : new Color(0.62f, 0.62f, 0.62f, 1f);
        }
    }

    private void RefreshEquipmentPanel()
    {
        var previewItems = GetEquipmentPreviewItems().ToList();
        var allGearCount = GetValidGearItems().Count();
        var soulCount = MyPlayer.GetItemByDataID(MonsterSoulItemId, checkCount: false)?.GetCount() ?? 0L;

        if (_equipmentSummary != null)
            _equipmentSummary.text = $"보유 장비 {allGearCount}";
        if (_soulValue != null)
            _soulValue.text = $"혼 {FormatCompact(soulCount)}";

        for (var i = 0; i < _equipmentSlots.Count; i++)
        {
            var view = _equipmentSlots[i];
            var item = previewItems.GetSafe(i);
            var resItem = item?.GetData();

            if (resItem == null)
            {
                if (view.Label != null)
                    view.Label.text = EquipmentSlotSpecs.GetSafe(i).EmptyLabel;
                if (view.Level != null)
                    view.Level.text = "비어있음";
                if (view.Icon != null)
                {
                    view.Icon.sprite = view.PlaceholderSprite;
                    view.Icon.color = new Color(1f, 1f, 1f, 0.45f);
                }
                continue;
            }

            if (view.Label != null)
                view.Label.text = resItem.ClientName;
            if (view.Level != null)
                view.Level.text = IsEquippedGear(item) ? $"장착 Lv.{item.Level}" : $"Lv.{item.Level}";
            if (view.Icon != null)
            {
                view.Icon.sprite = resItem.ClientSpriteIcon != null ? resItem.ClientSpriteIcon : view.PlaceholderSprite;
                view.Icon.color = Color.white;
            }
        }

        RefreshSummonButton();
    }

    private void RefreshSummonButton()
    {
        var product = ResourceItem.Get(EquipmentSummonProductId);
        var material = product?.GetProductMaterial();
        var canBuy = product?.IsProductBuyable() == true;

        if (_summonLevel != null)
            _summonLevel.text = product != null ? $"Lv.{product.GetProgressiveProductLevel()}" : "Lv.1";

        if (_summonCost != null)
        {
            _summonCost.text = material != null
                ? $"혼 {FormatCompact(product.GetProductMaterialRequiredCount(material, product.GetPurchaseUnit()))}"
                : "무료";
        }

        if (_summonButton != null)
            _summonButton.interactable = canBuy;
        if (_summonButtonImage != null)
            _summonButtonImage.color = canBuy ? Color.white : new Color(0.62f, 0.62f, 0.62f, 1f);
    }

    private async UniTaskVoid TrySummonEquipment()
    {
        var product = ResourceItem.Get(EquipmentSummonProductId);
        if (product == null || !product.IsProductBuyable())
        {
            RefreshEquipmentPanel();
            return;
        }

        var client = ZWorldClient.Get();
        if (!client.logined)
        {
            Debug.LogWarning("Equipment summon requires a logged-in world client.");
            return;
        }

        if (_summonButton != null)
            _summonButton.interactable = false;

        try
        {
            var response = await client.SendPacket<BuyItemRequest.Types.Response>(
                Packet.Pop(0, new BuyItemRequest
                {
                    ProductItemDataId = EquipmentSummonProductId,
                    Count = product.GetPurchaseUnit(),
                }),
                this.GetCancellationTokenOnDestroy());

            if (response.Status.IsSuccess())
            {
                MyPlayer.UpdateItems(response.Items);
                GameManager.Get()?.PlayFX("click");
            }
            else
            {
                Debug.LogWarning($"Equipment summon failed: {response.Status} {response.Message}");
            }
        }
        catch (Exception ex)
        {
            Debug.LogWarning($"Equipment summon request failed: {ex.Message}");
        }

        RefreshFromRuntime();
    }

    private static IEnumerable<PlayerItemMessage> GetEquipmentPreviewItems()
    {
        return GetValidGearItems()
            .OrderByDescending(IsEquippedGear)
            .ThenByDescending(item => item.GetData()?.Grade ?? 0)
            .ThenByDescending(item => item.Level)
            .ThenByDescending(item => item.Id)
            .Take(EquipmentSlotSpecs.Length);
    }

    private static IEnumerable<PlayerItemMessage> GetValidGearItems()
    {
        return MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Weapon)
            .Concat(MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Equipment))
            .Where(item => item?.IsValid() == true);
    }

    private static bool IsEquippedGear(PlayerItemMessage item)
    {
        var avatar = MyPlayer.PlayerAvatar;
        if (avatar == null || item == null)
            return false;

        return avatar.Weapons.Any(weapon => weapon?.Id == item.Id)
               || avatar.Equipments.Any(equipment => equipment?.Id == item.Id);
    }

    private bool TryUpgrade(GrowthCardSpec spec, out string feedback)
    {
        feedback = "전투 입장 후 가능";
        var gameBoard = GameBoardManager.Get()?.gameBoard;
        var boardPlayer = GetMyBoardPlayer(gameBoard);
        var unit = GetMyUnit(gameBoard);
        if (boardPlayer == null || unit == null)
            return false;

        if (IsMaxLevel(spec))
        {
            feedback = $"{spec.Label} MAX";
            return false;
        }

        var nextItem = CreateNextGrowthItem(spec);
        if (nextItem == null)
        {
            feedback = "성장 데이터 없음";
            return false;
        }

        var cost = GetUpgradeCost(spec);
        if (boardPlayer.Gold < cost)
        {
            feedback = $"골드 부족: {FormatCompact(cost)}G";
            return false;
        }

        boardPlayer.Gold -= cost;
        boardPlayer.HandleGoldChange(-cost);
        ApplyGrowthItem(nextItem, boardPlayer, unit);
        TryPersistGrowthItem(nextItem.Id).Forget();
        MyPlayer.HandleBoardPlayer(boardPlayer);
        GameManager.Get()?.PlayFX("click");
        feedback = $"{spec.Label} +1  {spec.GainText}";
        return true;
    }

    private static bool TryGetSpec(string upgradeId, out GrowthCardSpec spec)
    {
        foreach (var candidate in CardSpecs)
        {
            if (candidate.Id != upgradeId)
                continue;

            spec = candidate;
            return true;
        }

        spec = default;
        return false;
    }

    private static long GetCombatPower(GameUnit unit)
    {
        var playerPower = MyPlayer.Player?.Power ?? 0L;
        if (playerPower > 0 || unit == null)
            return playerPower;

        var attack = LongFixedFloatMath.ToLongSaturated(unit.Attack);
        var hpPower = Math.Max(0L, unit.MaxHp / 10L);
        return Math.Max(0L, attack + hpPower);
    }

    private static GrowthCardSpec? GetCheapestSpec(BoardPlayerMessage boardPlayer, bool requireAffordable)
    {
        if (boardPlayer == null)
            return null;

        GrowthCardSpec? result = null;
        var resultCost = long.MaxValue;
        foreach (var spec in CardSpecs)
        {
            if (IsMaxLevel(spec))
                continue;

            var cost = GetUpgradeCost(spec);
            if (requireAffordable && boardPlayer.Gold < cost)
                continue;
            if (cost >= resultCost)
                continue;

            result = spec;
            resultCost = cost;
        }

        return result;
    }

    private static int GetUpgradeLevel(GrowthCardSpec spec)
    {
        var item = GetGrowthItem(spec);
        return Mathf.Max(1, item?.Level ?? 1);
    }

    private static long GetUpgradeCost(GrowthCardSpec spec)
    {
        return spec.BaseCost + spec.CostStep * Mathf.Max(0, GetUpgradeLevel(spec) - 1);
    }

    private static float GetRuntimeStat(UnitStatType statType)
    {
        var gameBoard = GameBoardManager.Get()?.gameBoard;
        var boardPlayer = GetMyBoardPlayer(gameBoard);
        if (boardPlayer == null)
            return 0f;

        return GetStatValue(boardPlayer, statType);
    }

    private static float GetStatValue(BoardPlayerMessage boardPlayer, UnitStatType statType)
    {
        var statIndex = (int)statType;
        return boardPlayer.ItemStat.Count > statIndex ? boardPlayer.ItemStat[statIndex] : 0f;
    }

    private static bool IsMaxLevel(GrowthCardSpec spec)
    {
        var resItem = ResourceItem.Get(spec.ItemDataId);
        var item = GetGrowthItem(spec);
        return resItem != null && item != null && resItem.MaxLevel > 0 && item.Level >= resItem.MaxLevel;
    }

    private static PlayerItemMessage GetGrowthItem(GrowthCardSpec spec)
    {
        return MyPlayer.GetItemByDataID(spec.ItemDataId, checkCount: false, checkTimeValid: false, checkDeprecated: false);
    }

    private static PlayerItemMessage CreateNextGrowthItem(GrowthCardSpec spec)
    {
        var resItem = ResourceItem.Get(spec.ItemDataId);
        if (resItem == null)
            return null;

        var item = GetGrowthItem(spec)?.Clone() ?? new PlayerItemMessage
        {
            Id = spec.ItemDataId,
            ItemDataId = spec.ItemDataId,
            Count = 1,
            Grade = resItem.Grade,
            Level = Math.Max(1, resItem.InitialCreateLevel),
        };

        if (item.Id == 0)
            item.Id = spec.ItemDataId;
        if (item.Count <= 0)
            item.Count = 1;
        if (item.Level <= 0)
            item.Level = 1;
        if (resItem.MaxLevel > 0 && item.Level >= resItem.MaxLevel)
            return null;

        item.Level += 1;
        return item;
    }

    private static void ApplyGrowthItem(PlayerItemMessage item, BoardPlayerMessage boardPlayer, GameUnit unit)
    {
        MyPlayer.UpdateItemsArgs(item);
        MyPlayer.ShouldUpdateMyPlayerGameUnit = true;
        SyncRuntimeStatsFromPlayerItems(boardPlayer, unit);
    }

    private static void SyncRuntimeStatsFromPlayerItems(BoardPlayerMessage boardPlayer, GameUnit unit)
    {
        if (boardPlayer == null)
            return;

        boardPlayer.ItemStat.Clear();
        MyPlayer.PlayerItemStat.CopyTo(boardPlayer.ItemStat);

        if (unit == null)
            return;

        unit.BaseStat.Clear();
        unit.BaseStat.AddRange(boardPlayer.ItemStat);
        unit.SetStatDirty();
    }

    private async UniTaskVoid TryPersistGrowthItem(long itemId)
    {
        var client = ZWorldClient.Get();
        if (!client.logined)
            return;

        try
        {
            var response = await client.SendPacket<LevelUpItemRequest.Types.Response>(
                Packet.Pop(0, new LevelUpItemRequest
                {
                    ItemId = itemId,
                    Count = 1,
                }),
                this.GetCancellationTokenOnDestroy());

            if (response.Status.IsSuccess() && response.Items.Count > 0)
            {
                MyPlayer.UpdateItems(response.Items);
                MyPlayer.ShouldUpdateMyPlayerGameUnit = true;
                RefreshFromRuntime();
            }
            else if (!response.Status.IsSuccess())
            {
                Debug.LogWarning($"Hamster growth stat item level-up failed: {response.Status} {response.Message}");
            }
        }
        catch (Exception ex)
        {
            Debug.LogWarning($"Hamster growth stat item level-up request failed: {ex.Message}");
        }
    }

    private static BoardPlayerMessage GetMyBoardPlayer(GameBoard gameBoard)
    {
        var player = MyPlayer.Player;
        return player == null ? null : gameBoard?.GetPlayerById(player.Id);
    }

    private static GameUnit GetMyUnit(GameBoard gameBoard)
    {
        var player = MyPlayer.Player;
        return player == null ? null : gameBoard?.GetUnitByPlayerId(player.Id) ?? MyPlayer.GameUnit;
    }

    private TextMeshProUGUI FindText(string rootName, string childName)
    {
        var root = FindChild(transform, rootName);
        return root != null ? FindText(root, childName) : null;
    }

    private static TextMeshProUGUI FindText(Transform root, string childName)
    {
        var child = FindChild(root, childName);
        return child != null ? child.GetComponent<TextMeshProUGUI>() : null;
    }

    private static Button FindButton(Transform root, string childName)
    {
        var child = FindChild(root, childName);
        return child != null ? child.GetComponent<Button>() : null;
    }

    private static Transform FindChild(Transform root, string childName)
    {
        if (root == null)
            return null;

        foreach (Transform child in root)
        {
            if (child.name == childName)
                return child;

            var result = FindChild(child, childName);
            if (result != null)
                return result;
        }

        return null;
    }

    private static string FormatCompact(long value)
    {
        return value.ToUnitString(decimalPlace: 2);
    }
}
