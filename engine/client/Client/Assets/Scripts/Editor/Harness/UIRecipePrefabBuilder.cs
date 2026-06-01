using System.IO;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

public static class UIRecipePrefabBuilder
{
    private const string RecipePath = "harness/unity/recipes/ingame/hamster_growth_dock.yaml";
    private const string OutputFolder = "Assets/Resources/HarnessPreview";
    private const string SpriteFolder = OutputFolder + "/GeneratedSprites";
    private const string PrefabPath = OutputFolder + "/HamsterGrowthDock.prefab";
    private const float DesignWidth = 1080f;
    private const float DesignHeight = 1920f;
    private const float PortraitAspect = DesignWidth / DesignHeight;
    private const bool UseExternalIconSprites = false;

    private const string AttackIconPath = "Assets/Images/Icons/ICN_EQUIP_Battlepower.png";
    private const string CoinIconPath = "Assets/Images/Icons/ICN_COMMON_Gold.png";
    private const string HeartIconPath = "Assets/Images/Icons/ICN_INAGAME_Heart.png";
    private const string SpeedIconPath = "Assets/Resources/UI/Images_OLD/Common_Old/InAtlas/Icons/ToSpriteAssets/common_icn_time.png";
    private const string PetIconPath = "Assets/Images/Icons/ICN_CHARACTER_Pet.png";
    private const string GearIconPath = "Assets/Images/Icons/ICN_LOBBY_Equipment.png";
    private const string LockIconPath = "Assets/Images/Icons/ICN_COMMON_Lock_02.png";

    private static readonly Color32 Transparent = new(0, 0, 0, 0);
    private static readonly Color WoodBorder = HtmlColor("241007");
    private static readonly Color WoodDark = HtmlColor("3A1C0D");
    private static readonly Color WoodMid = HtmlColor("6F3513");
    private static readonly Color WoodLight = HtmlColor("A85D20");
    private static readonly Color ParchmentTop = HtmlColor("FFF4CF");
    private static readonly Color ParchmentBottom = HtmlColor("F5D79E");
    private static readonly Color Ink = HtmlColor("3B1D0C");
    private static readonly Color GreenTop = HtmlColor("9DDD53");
    private static readonly Color GreenBottom = HtmlColor("55A42D");
    private static readonly Color GoldTop = HtmlColor("FFC44E");
    private static readonly Color GoldBottom = HtmlColor("EF8D18");
    private static readonly Color LockedButtonTint = HtmlColor("8F877A");
    private static readonly Color LockedOverlay = new(0.08f, 0.04f, 0.02f, 0.48f);
    private static readonly Color LockedBadgeText = HtmlColor("FFE09B");

    private enum IconKind
    {
        Attack,
        Coin,
        Heart,
        Speed,
        Hamster,
        Mushroom,
        Gear,
        Pet,
        Adventure,
        Lock,
        Lamp,
        Shop,
    }

    [MenuItem("Tools/IdleZ/Harness/Rebuild Hamster Growth Dock Preview")]
    public static void RebuildHamsterGrowthDockPreview()
    {
        EnsureAssetFolder("Assets/Resources");
        EnsureAssetFolder(OutputFolder);
        EnsureAssetFolder(SpriteFolder);
        GenerateSprites();

        var root = new GameObject("HamsterGrowthDock", typeof(RectTransform), typeof(CanvasGroup));
        try
        {
            var rootRect = root.GetComponent<RectTransform>();
            Stretch(rootRect);

            var canvasGroup = root.GetComponent<CanvasGroup>();
            canvasGroup.alpha = 1f;
            canvasGroup.blocksRaycasts = false;
            canvasGroup.interactable = false;

            var surface = CreateRect(rootRect, "Panel_DesignSurface", 0f, 0f, DesignWidth, DesignHeight);
            var fitter = surface.gameObject.AddComponent<AspectRatioFitter>();
            fitter.aspectMode = AspectRatioFitter.AspectMode.FitInParent;
            fitter.aspectRatio = PortraitAspect;

            BuildTopHud(surface);
            BuildCombatOverlay(surface);
            BuildGrowthDock(surface);
            BuildEquipmentSummonButton(surface);

            PrefabUtility.SaveAsPrefabAsset(root, PrefabPath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            Debug.Log($"Built uGUI element prefab {PrefabPath} from {RecipePath}.");
        }
        finally
        {
            Object.DestroyImmediate(root);
        }
    }

    private static void BuildTopHud(RectTransform surface)
    {
        var topHud = CreateSpritePanel(surface, "TopHudStrip", 34f, 36f, 1012f, 118f, "wood-frame");
        CreateCounter(topHud, "CombatPowerPill", 12f, 12f, 378f, 94f, "전투력", "125.8A", AttackIconPath, 1012f, 118f);
        CreateCounter(topHud, "CoinPill", 400f, 12f, 295f, 94f, "골드", "23.4A", CoinIconPath, 1012f, 118f);
        CreateCounter(topHud, "HeartPill", 705f, 12f, 295f, 94f, "하트", "1.23A", HeartIconPath, 1012f, 118f);

        var stage = CreateSpritePanel(surface, "StageProgressPill", 335f, 176f, 410f, 56f, "stage-pill");
        AddText(stage, "Text_StageProgress", "Stage 12-8 버섯 숲 전투 중", 25f, Color.white, 0f, 0f, 410f, 56f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 410f, refHeight: 56f);
    }

    private static void BuildCombatOverlay(RectTransform surface)
    {
        var arena = CreateRect(surface, "CombatArenaFrame", 0f, 288f, DesignWidth, 927f);

        var mission = CreateSpritePanel(arena, "MissionCard", 34f, 838f, 302f, 118f, "mission-card", refHeight: 927f);
        AddText(mission, "Text_Title", "오늘의 전투", 23f, Color.white, 18f, 13f, 264f, 28f,
            TextAlignmentOptions.Left, shadow: true, refWidth: 302f, refHeight: 118f);
        AddText(mission, "Text_Objective", "버섯 병정 42 / 100", 26f, Color.white, 18f, 42f, 264f, 32f,
            TextAlignmentOptions.Left, shadow: true, refWidth: 302f, refHeight: 118f);
        CreateProgressBar(mission, "FillBar", 18f, 89f, 266f, 16f, 0.42f);

        var damage = CreateSpritePanel(arena, "DamageBubble", 824f, 568f, 202f, 60f, "damage-pill", refHeight: 927f);
        AddText(damage, "Text_Damage", "CRIT  18.7A", 30f, Color.white, 0f, 0f, 202f, 60f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 202f, refHeight: 60f);
    }

    private static void BuildGrowthDock(RectTransform surface)
    {
        var dock = CreateSpritePanel(surface, "GrowthDockRoot", 0f, 1215f, DesignWidth, 705f, "dock-bg");
        CreateSpritePanel(dock, "Panel_Frame", 8f, 8f, 1064f, 689f, "dock-inner", refHeight: 705f);
        CreateSolidPanel(dock, "Panel_TopDivider", 0f, 0f, DesignWidth, 10f, WoodBorder, refHeight: 705f);

        var grid = CreateRect(dock, "StatCardGrid", 28f, 44f, 486f, 624f, refHeight: 705f);
        CreateCompactStatCard(grid, "StatCard_Attack", 0f, 0f, 237f, 306f, "Lv.245", "공격력", "24.5A", "3.21A", AttackIconPath);
        CreateCompactStatCard(grid, "StatCard_Health", 249f, 0f, 237f, 306f, "Lv.230", "체력", "18.7A", "2.14A", HeartIconPath);
        CreateCompactStatCard(grid, "StatCard_GoldGain", 0f, 318f, 237f, 306f, "Lv.210", "공격속도", "+24%", "1.89A", SpeedIconPath);
        CreateCompactStatCard(grid, "StatCard_GrowthSpeed", 249f, 318f, 237f, 306f, "Lv.205", "치명피해", "+80%", "1.77A", AttackIconPath);

        CreateEquipmentPanel(dock);
    }

    private static void BuildEquipmentSummonButton(RectTransform surface)
    {
        var button = CreateButton(surface, "Btn_EquipmentSummon", 342f, 1144f, 396f, 96f, "button-gold");
        AddGeneratedIcon(button.GetComponent<RectTransform>(), "Icon_Lamp", "icon-lamp", 24f, 18f, 60f, 60f,
            refWidth: 396f, refHeight: 96f);
        AddText(button.GetComponent<RectTransform>(), "Text_Label", "장비 소환", 31f, Color.white, 94f, 10f, 188f, 42f,
            TextAlignmentOptions.Left, shadow: true, refWidth: 396f, refHeight: 96f);
        AddText(button.GetComponent<RectTransform>(), "Text_Level", "Lv.1", 23f, Color.white, 282f, 13f, 90f, 34f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 396f, refHeight: 96f);
        AddText(button.GetComponent<RectTransform>(), "Text_Cost", "혼 10", 25f, Color.white, 94f, 50f, 278f, 34f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 396f, refHeight: 96f);
    }

    private static void CreateCounter(RectTransform parent, string name, float x, float y, float width, float height, string label, string value, string iconPath,
        float parentWidth, float parentHeight)
    {
        var pill = CreateSpritePanel(parent, name, x, y, width, height, "counter-pill", refWidth: parentWidth, refHeight: parentHeight);
        CreateSpritePanel(pill, "Panel_IconBadge", 18f, 14f, 66f, 66f, "medal-gold", refWidth: width, refHeight: height);
        AddIcon(pill, "Icon", iconPath, 29f, 25f, 44f, 44f, refWidth: width, refHeight: height);
        AddText(pill, "Text_Label", label, 22f, Color.white, 106f, 16f, width - 124f, 26f, TextAlignmentOptions.Left,
            shadow: true, refWidth: width, refHeight: height);
        AddText(pill, "Text_Value", value, 36f, Color.white, 106f, 45f, width - 124f, 42f, TextAlignmentOptions.Left,
            shadow: true, refWidth: width, refHeight: height);
    }

    private static void CreateStatCard(RectTransform parent, string name, float x, float y, float width, float height,
        string level, string statName, string value, string cost, string iconPath)
    {
        var card = CreateSpritePanel(parent, name, x, y, width, height, "stat-card", refWidth: 1024f, refHeight: 410f);
        AddText(card, "Text_Level", level, 25f, Ink, 18f, 15f, 98f, 30f, TextAlignmentOptions.Center, refWidth: width, refHeight: height);
        CreateSpritePanel(card, "Panel_IconBadge", 22f, 54f, 84f, 84f, "medal-gold", refWidth: width, refHeight: height);
        AddIcon(card, "Icon", iconPath, 36f, 68f, 56f, 56f, refWidth: width, refHeight: height);
        AddText(card, "Text_StatName", statName, 35f, Ink, 126f, 19f, width - 144f, 42f, TextAlignmentOptions.Left,
            refWidth: width, refHeight: height);
        AddText(card, "Text_Value", value, 39f, Ink, 126f, 62f, width - 144f, 48f, TextAlignmentOptions.Left,
            refWidth: width, refHeight: height);

        var button = CreateButton(card, "Btn_Upgrade", 126f, 128f, width - 144f, 54f, "button-green", refWidth: width, refHeight: height);
        AddIcon(button.GetComponent<RectTransform>(), "Icon_Coin", CoinIconPath, 14f, 11f, 32f, 32f, refWidth: width - 144f, refHeight: 54f);
        AddText(button.GetComponent<RectTransform>(), "Text_Cost", cost, 30f, Color.white, 54f, 0f, width - 198f, 54f,
            TextAlignmentOptions.Left, shadow: true, refWidth: width - 144f, refHeight: 54f);
    }

    private static void CreateCompactStatCard(RectTransform parent, string name, float x, float y, float width, float height,
        string level, string statName, string value, string cost, string iconPath)
    {
        var card = CreateSpritePanel(parent, name, x, y, width, height, "stat-card", refWidth: 486f, refHeight: 624f);
        AddText(card, "Text_Level", level, 20f, Ink, 14f, 12f, width - 28f, 28f, TextAlignmentOptions.Left,
            refWidth: width, refHeight: height);
        CreateSpritePanel(card, "Panel_IconBadge", 18f, 50f, 68f, 68f, "medal-gold", refWidth: width, refHeight: height);
        AddIcon(card, "Icon", iconPath, 30f, 62f, 44f, 44f, refWidth: width, refHeight: height);
        AddText(card, "Text_StatName", statName, 26f, Ink, 96f, 48f, width - 110f, 34f, TextAlignmentOptions.Left,
            refWidth: width, refHeight: height);
        AddText(card, "Text_Value", value, 30f, Ink, 96f, 82f, width - 110f, 38f, TextAlignmentOptions.Left,
            refWidth: width, refHeight: height);

        var button = CreateButton(card, "Btn_Upgrade", 18f, 232f, width - 36f, 56f, "button-green",
            refWidth: width, refHeight: height);
        AddIcon(button.GetComponent<RectTransform>(), "Icon_Coin", CoinIconPath, 14f, 12f, 32f, 32f,
            refWidth: width - 36f, refHeight: 56f);
        AddText(button.GetComponent<RectTransform>(), "Text_Cost", cost, 26f, Color.white, 52f, 0f, width - 92f, 56f,
            TextAlignmentOptions.Left, shadow: true, refWidth: width - 36f, refHeight: 56f);
    }

    private static void CreateEquipmentPanel(RectTransform dock)
    {
        var panel = CreateSpritePanel(dock, "EquipmentPanel", 532f, 44f, 520f, 624f, "equipment-panel", refHeight: 705f);
        AddText(panel, "Text_Title", "장비", 34f, Color.white, 24f, 18f, 170f, 42f,
            TextAlignmentOptions.Left, shadow: true, refWidth: 520f, refHeight: 624f);
        AddText(panel, "Text_Summary", "보유 장비 0", 24f, Color.white, 24f, 64f, 220f, 34f,
            TextAlignmentOptions.Left, shadow: true, refWidth: 520f, refHeight: 624f);
        AddText(panel, "Text_SoulValue", "혼 0", 24f, Color.white, 276f, 64f, 220f, 34f,
            TextAlignmentOptions.Right, shadow: true, refWidth: 520f, refHeight: 624f);

        var grid = CreateRect(panel, "EquipmentSlotGrid", 18f, 122f, 484f, 472f, refWidth: 520f, refHeight: 624f);
        var names = new[] { "Weapon", "Head", "Chest", "Gloves", "Boots", "Ring" };
        var labels = new[] { "무기", "머리", "갑옷", "장갑", "신발", "반지" };
        var icons = new[] { "icon-attack", "icon-hamster", "icon-gear", "icon-gear", "icon-adventure", "icon-coin" };
        const float slotWidth = 150f;
        const float slotHeight = 180f;
        const float gapX = 17f;
        const float gapY = 20f;

        for (var i = 0; i < names.Length; i++)
        {
            var col = i % 3;
            var row = i / 3;
            CreateEquipmentSlot(grid, $"EquipSlot_{names[i]}", labels[i], icons[i],
                col * (slotWidth + gapX), row * (slotHeight + gapY), slotWidth, slotHeight);
        }
    }

    private static void CreateEquipmentSlot(RectTransform parent, string name, string label, string iconName,
        float x, float y, float width, float height)
    {
        var slot = CreateSpritePanel(parent, name, x, y, width, height, "equipment-slot",
            refWidth: 484f, refHeight: 472f);
        CreateSpritePanel(slot, "Panel_IconBadge", 25f, 20f, 100f, 100f, "medal-gold", refWidth: width, refHeight: height);
        AddGeneratedIcon(slot, "Icon", iconName, 45f, 40f, 60f, 60f, refWidth: width, refHeight: height);
        AddText(slot, "Text_Label", label, 22f, Ink, 8f, 124f, width - 16f, 28f,
            TextAlignmentOptions.Center, refWidth: width, refHeight: height);
        AddText(slot, "Text_Level", "비어있음", 18f, Ink, 8f, 150f, width - 16f, 24f,
            TextAlignmentOptions.Center, refWidth: width, refHeight: height);
    }

    private static void CreateRewardButton(RectTransform dock)
    {
        var reward = CreateButton(dock, "Btn_GrowthReward", 28f, 450f, 698f, 126f, "button-gold", refHeight: 705f);
        CreateHamsterFace(reward.GetComponent<RectTransform>(), 28f, 29f, 82f, 68f, 698f, 126f);
        AddText(reward.GetComponent<RectTransform>(), "Text_Label", "성장 보상 받기", 42f, Color.white, 120f, 22f, 548f, 52f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 698f, refHeight: 126f);
        AddText(reward.GetComponent<RectTransform>(), "Text_RewardAmount", "89.32A", 33f, Color.white, 120f, 69f, 548f, 40f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 698f, refHeight: 126f);
        SetButtonLocked(reward, 698f, 126f, "준비 중", 24f, 500f, 10f, 168f, 30f);

        var auto = CreateButton(dock, "Btn_AutoEnhance", 742f, 450f, 310f, 126f, "button-green", refHeight: 705f);
        AddGeneratedIcon(auto.GetComponent<RectTransform>(), "Icon_Mushroom", "icon-mushroom", 28f, 34f, 58f, 58f,
            refWidth: 310f, refHeight: 126f);
        AddText(auto.GetComponent<RectTransform>(), "Text_Label", "자동 강화", 34f, Color.white, 92f, 0f, 196f, 126f,
            TextAlignmentOptions.Center, shadow: true, refWidth: 310f, refHeight: 126f);
        SetButtonLocked(auto, 310f, 126f, "잠김", 22f, 218f, 10f, 72f, 28f);
    }

    private static void CreateBottomTabs(RectTransform dock)
    {
        var tabs = CreateSpritePanel(dock, "BottomTabBar", 28f, 594f, 1024f, 96f, "tabs-bg", refHeight: 705f);
        var ids = new[] { "Growth", "Companion", "Equipment", "Pet", "Adventure", "Shop" };
        var labels = new[] { "성장", "동료", "장비", "펫", "모험", "상점" };
        var icons = new[] { "icon-hamster", "icon-mushroom", "icon-gear", "icon-pet", "icon-adventure", "icon-shop" };
        var tabWidth = (1024f - 16f - 40f) / 6f;

        for (var i = 0; i < labels.Length; i++)
        {
            var selected = i == 0;
            var tab = CreateButton(tabs, $"Tab_{ids[i]}", 8f + i * (tabWidth + 8f), 8f, tabWidth, 80f,
                selected ? "tab-active" : "tab-idle", refWidth: 1024f, refHeight: 96f);
            AddGeneratedIcon(tab.GetComponent<RectTransform>(), "Icon", icons[i], tabWidth * 0.5f - 17f, 10f, 34f, 34f,
                refWidth: tabWidth, refHeight: 80f);
            AddText(tab.GetComponent<RectTransform>(), "Text_Label", labels[i], 23f,
                selected ? HtmlColor("FFE9B2") : Color.white, 0f, 0f, tabWidth, 80f,
                TextAlignmentOptions.Bottom, shadow: true, refWidth: tabWidth, refHeight: 80f);

            var unlocked = selected || ids[i] == "Shop";
            if (!unlocked)
                SetButtonLocked(tab, tabWidth, 80f, "잠김", 14f, tabWidth - 54f, 5f, 48f, 20f);
        }
    }

    private static void SetButtonLocked(Button button, float width, float height, string badgeText, float badgeFontSize,
        float badgeX, float badgeY, float badgeWidth, float badgeHeight)
    {
        button.interactable = false;
        if (button.targetGraphic != null)
            button.targetGraphic.color = LockedButtonTint;

        var rect = button.GetComponent<RectTransform>();
        CreateSolidPanel(rect, "Panel_LockedVeil", 0f, 0f, width, height, LockedOverlay, refWidth: width, refHeight: height);
        AddText(rect, "Text_Lock", badgeText, badgeFontSize, LockedBadgeText, badgeX, badgeY, badgeWidth, badgeHeight,
            TextAlignmentOptions.Center, shadow: true, refWidth: width, refHeight: height);
    }

    private static void CreateProgressBar(RectTransform parent, string name, float x, float y, float width, float height, float fill)
    {
        var root = CreateSolidPanel(parent, name, x, y, width, height, HtmlColor("071006"), refWidth: 302f, refHeight: 118f);
        CreateSolidPanel(root, "FillBar", 0f, 0f, width * fill, height, HtmlColor("8CE05A"), refWidth: width, refHeight: height);
    }

    private static Button CreateButton(RectTransform parent, string name, float x, float y, float width, float height, string spriteName,
        float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var rectTransform = CreateSpritePanel(parent, name, x, y, width, height, spriteName, raycastTarget: true, refWidth: refWidth, refHeight: refHeight);
        var image = rectTransform.GetComponent<Image>();
        var button = rectTransform.gameObject.AddComponent<Button>();
        button.targetGraphic = image;
        button.transition = Selectable.Transition.ColorTint;
        return button;
    }

    private static void CreateHamsterFace(RectTransform parent, float x, float y, float width, float height, float refWidth, float refHeight)
    {
        var face = CreateSpritePanel(parent, "Icon_Hamster", x, y, width, height, "hamster-face", refWidth: refWidth, refHeight: refHeight);
        CreateSpritePanel(face, "Eye_L", 24f, 23f, 10f, 22f, "black-dot", refWidth: width, refHeight: height);
        CreateSpritePanel(face, "Eye_R", 48f, 23f, 10f, 22f, "black-dot", refWidth: width, refHeight: height);
    }

    private static void AddIcon(RectTransform parent, string name, string spritePath, float x, float y, float width, float height,
        float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        AddIcon(parent, name, spritePath, x, y, width, height, Ink, refWidth, refHeight);
    }

    private static void AddIcon(RectTransform parent, string name, string spritePath, float x, float y, float width, float height,
        Color fallbackColor, float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var icon = CreateRect(parent, name, x, y, width, height, refWidth, refHeight);
        var sprite = LoadGeneratedSprite(ResolveGeneratedIcon(spritePath));
        if (sprite == null && UseExternalIconSprites)
            sprite = LoadSprite(spritePath);

        if (sprite == null)
        {
            var label = AddText(icon, "Text_IconFallback", ResolveIconFallback(spritePath), Mathf.Min(width, height) * 0.4f,
                fallbackColor, 0f, 0f, width, height, TextAlignmentOptions.Center, shadow: true, refWidth: width, refHeight: height);
            label.enableAutoSizing = true;
            label.fontSizeMax = Mathf.Min(width, height) * 0.42f;
            label.fontSizeMin = 10f;
            return;
        }

        var image = icon.gameObject.AddComponent<Image>();
        image.sprite = sprite;
        image.color = Color.white;
        image.preserveAspect = true;
        image.raycastTarget = false;
    }

    private static void AddGeneratedIcon(RectTransform parent, string name, string spriteName, float x, float y, float width, float height,
        float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var icon = CreateRect(parent, name, x, y, width, height, refWidth, refHeight);
        var sprite = LoadGeneratedSprite(spriteName);
        if (sprite == null)
            return;

        var image = icon.gameObject.AddComponent<Image>();
        image.sprite = sprite;
        image.color = Color.white;
        image.preserveAspect = true;
        image.raycastTarget = false;
    }

    private static string ResolveIconFallback(string spritePath)
    {
        if (spritePath == AttackIconPath)
            return "ATK";
        if (spritePath == CoinIconPath)
            return "G";
        if (spritePath == HeartIconPath)
            return "HP";
        if (spritePath == SpeedIconPath)
            return "SPD";
        if (spritePath == PetIconPath)
            return "PET";
        if (spritePath == GearIconPath)
            return "EQ";
        if (spritePath == LockIconPath)
            return "LOCK";
        return "UI";
    }

    private static string ResolveGeneratedIcon(string spritePath)
    {
        if (spritePath == AttackIconPath)
            return "icon-attack";
        if (spritePath == CoinIconPath)
            return "icon-coin";
        if (spritePath == HeartIconPath)
            return "icon-heart";
        if (spritePath == SpeedIconPath)
            return "icon-speed";
        return null;
    }

    private static TextMeshProUGUI AddText(RectTransform parent, string name, string text, float fontSize, Color color,
        float x, float y, float width, float height, TextAlignmentOptions alignment, bool shadow = false,
        float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var rect = CreateRect(parent, name, x, y, width, height, refWidth, refHeight);
        var label = rect.gameObject.AddComponent<TextMeshProUGUI>();
        label.text = text;
        label.fontSize = fontSize;
        label.fontStyle = FontStyles.Bold;
        label.alignment = alignment;
        label.color = color;
        label.raycastTarget = false;
        label.textWrappingMode = TextWrappingModes.NoWrap;
        label.overflowMode = TextOverflowModes.Ellipsis;
        label.font = TMP_Settings.defaultFontAsset;
        label.enableAutoSizing = true;
        label.fontSizeMax = fontSize;
        label.fontSizeMin = Mathf.Max(10f, fontSize * 0.68f);

        if (shadow)
        {
            var shadowComponent = rect.gameObject.AddComponent<Shadow>();
            shadowComponent.effectColor = new Color(0f, 0f, 0f, 0.82f);
            shadowComponent.effectDistance = new Vector2(0f, -3.5f);
        }

        return label;
    }

    private static RectTransform CreateSpritePanel(RectTransform parent, string name, float x, float y, float width, float height,
        string spriteName, bool raycastTarget = false, float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var rectTransform = CreateRect(parent, name, x, y, width, height, refWidth, refHeight);
        var image = rectTransform.gameObject.AddComponent<Image>();
        image.sprite = LoadGeneratedSprite(spriteName);
        image.type = Image.Type.Sliced;
        image.color = Color.white;
        image.raycastTarget = raycastTarget;
        return rectTransform;
    }

    private static RectTransform CreateSolidPanel(RectTransform parent, string name, float x, float y, float width, float height, Color color,
        float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var rectTransform = CreateRect(parent, name, x, y, width, height, refWidth, refHeight);
        var image = rectTransform.gameObject.AddComponent<Image>();
        image.color = color;
        image.raycastTarget = false;
        return rectTransform;
    }

    private static RectTransform CreateRect(RectTransform parent, string name, float x, float y, float width, float height,
        float refWidth = DesignWidth, float refHeight = DesignHeight)
    {
        var go = new GameObject(name, typeof(RectTransform));
        var rectTransform = go.GetComponent<RectTransform>();
        rectTransform.SetParent(parent, false);
        rectTransform.localScale = Vector3.one;
        rectTransform.anchorMin = new Vector2(x / refWidth, 1f - (y + height) / refHeight);
        rectTransform.anchorMax = new Vector2((x + width) / refWidth, 1f - y / refHeight);
        rectTransform.offsetMin = Vector2.zero;
        rectTransform.offsetMax = Vector2.zero;
        return rectTransform;
    }

    private static void Stretch(RectTransform rectTransform)
    {
        rectTransform.anchorMin = Vector2.zero;
        rectTransform.anchorMax = Vector2.one;
        rectTransform.offsetMin = Vector2.zero;
        rectTransform.offsetMax = Vector2.zero;
        rectTransform.localScale = Vector3.one;
    }

    private static void GenerateSprites()
    {
        WriteRoundedSprite("wood-frame", 128, 128, 22, 7, WoodBorder, WoodLight, WoodMid, 32);
        WriteRoundedSprite("counter-pill", 128, 128, 16, 4, HtmlColor("1C0B05"), HtmlColor("4B220E"), HtmlColor("2A1207"), 28);
        WriteRoundedSprite("stage-pill", 128, 64, 16, 5, HtmlColor("140904"), HtmlColor("3B1B0B"), HtmlColor("2A1207"), 24);
        WriteRoundedSprite("mission-card", 128, 128, 14, 6, HtmlColor("13270F"), HtmlColor("154A22"), HtmlColor("0D3418"), 22);
        WriteRoundedSprite("damage-pill", 128, 64, 13, 0, Transparent, HtmlColor("B24D16"), HtmlColor("9A4617"), 22);
        WriteRoundedSprite("dock-bg", 128, 128, 0, 0, Transparent, HtmlColor("8B4518"), HtmlColor("4A220E"), 0);
        WriteRoundedSprite("dock-inner", 128, 128, 0, 0, Transparent, HtmlColor("522411"), HtmlColor("3A190C"), 0);
        WriteRoundedSprite("stat-card", 128, 128, 22, 6, WoodBorder, ParchmentTop, ParchmentBottom, 30);
        WriteRoundedSprite("equipment-panel", 128, 128, 20, 6, WoodBorder, HtmlColor("5A2B12"), HtmlColor("351608"), 28);
        WriteRoundedSprite("equipment-slot", 128, 128, 18, 5, HtmlColor("6B3517"), ParchmentTop, ParchmentBottom, 24);
        WriteRoundedSprite("medal-gold", 128, 128, 64, 7, HtmlColor("7D3D10"), HtmlColor("FFFBD0"), HtmlColor("D47715"), 48);
        WriteRoundedSprite("button-green", 128, 64, 18, 5, HtmlColor("315516"), GreenTop, GreenBottom, 24);
        WriteRoundedSprite("button-gold", 128, 64, 22, 5, WoodBorder, GoldTop, GoldBottom, 24);
        WriteRoundedSprite("tabs-bg", 128, 64, 18, 7, WoodBorder, HtmlColor("2D1509"), HtmlColor("2D1509"), 24);
        WriteRoundedSprite("tab-active", 96, 64, 14, 0, Transparent, HtmlColor("B8661E"), HtmlColor("7C3F13"), 18);
        WriteRoundedSprite("tab-idle", 96, 64, 14, 0, Transparent, HtmlColor("4F230D"), HtmlColor("3B1909"), 18);
        WriteRoundedSprite("hamster-face", 96, 80, 36, 5, WoodBorder, HtmlColor("FFC331"), HtmlColor("F4A622"), 24);
        WriteRoundedSprite("black-dot", 32, 48, 16, 0, Transparent, HtmlColor("331507"), HtmlColor("331507"), 12);
        WriteIconSprite("icon-attack", IconKind.Attack);
        WriteIconSprite("icon-coin", IconKind.Coin);
        WriteIconSprite("icon-heart", IconKind.Heart);
        WriteIconSprite("icon-speed", IconKind.Speed);
        WriteIconSprite("icon-hamster", IconKind.Hamster);
        WriteIconSprite("icon-mushroom", IconKind.Mushroom);
        WriteIconSprite("icon-gear", IconKind.Gear);
        WriteIconSprite("icon-pet", IconKind.Pet);
        WriteIconSprite("icon-adventure", IconKind.Adventure);
        WriteIconSprite("icon-lock", IconKind.Lock);
        WriteIconSprite("icon-lamp", IconKind.Lamp);
        WriteIconSprite("icon-shop", IconKind.Shop);

        AssetDatabase.Refresh();
    }

    private static void WriteIconSprite(string name, IconKind kind)
    {
        var texture = new Texture2D(96, 96, TextureFormat.RGBA32, false);
        for (var y = 0; y < texture.height; y++)
        {
            for (var x = 0; x < texture.width; x++)
                texture.SetPixel(x, y, Transparent);
        }

        switch (kind)
        {
            case IconKind.Attack:
                DrawAttackIcon(texture);
                break;
            case IconKind.Coin:
                DrawCoinIcon(texture);
                break;
            case IconKind.Heart:
                DrawHeartIcon(texture);
                break;
            case IconKind.Speed:
                DrawSpeedIcon(texture);
                break;
            case IconKind.Hamster:
                DrawHamsterIcon(texture);
                break;
            case IconKind.Mushroom:
                DrawMushroomIcon(texture);
                break;
            case IconKind.Gear:
                DrawGearIcon(texture);
                break;
            case IconKind.Pet:
                DrawPetIcon(texture);
                break;
            case IconKind.Adventure:
                DrawAdventureIcon(texture);
                break;
            case IconKind.Lock:
                DrawLockIcon(texture);
                break;
            case IconKind.Lamp:
                DrawLampIcon(texture);
                break;
            case IconKind.Shop:
                DrawShopIcon(texture);
                break;
        }

        texture.Apply();
        var path = $"{SpriteFolder}/{name}.png";
        File.WriteAllBytes(path, texture.EncodeToPNG());
        Object.DestroyImmediate(texture);

        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
        if (AssetImporter.GetAtPath(path) is TextureImporter importer)
        {
            importer.textureType = TextureImporterType.Sprite;
            importer.spriteImportMode = SpriteImportMode.Single;
            importer.alphaIsTransparency = true;
            importer.mipmapEnabled = false;
            importer.spritePixelsPerUnit = 100f;
            importer.spriteBorder = Vector4.zero;
            importer.SaveAndReimport();
        }
    }

    private static void DrawAttackIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B2A0E");
        var blade = HtmlColor("FFF8D5");
        var bladeShade = HtmlColor("B8C6D1");
        var handle = HtmlColor("9C4C14");
        DrawThickLine(texture, new Vector2(30f, 30f), new Vector2(72f, 72f), 16f, outline);
        DrawThickLine(texture, new Vector2(33f, 33f), new Vector2(72f, 72f), 10f, blade);
        DrawThickLine(texture, new Vector2(38f, 32f), new Vector2(76f, 70f), 4f, bladeShade);
        FillTriangle(texture, new Vector2(69f, 70f), new Vector2(88f, 84f), new Vector2(83f, 63f), outline);
        FillTriangle(texture, new Vector2(70f, 71f), new Vector2(83f, 80f), new Vector2(80f, 66f), blade);
        DrawThickLine(texture, new Vector2(22f, 39f), new Vector2(39f, 22f), 14f, outline);
        DrawThickLine(texture, new Vector2(24f, 39f), new Vector2(39f, 24f), 8f, handle);
        FillCircle(texture, 22f, 39f, 8f, outline);
        FillCircle(texture, 22f, 39f, 5f, HtmlColor("F2A32C"));
    }

    private static void DrawCoinIcon(Texture2D texture)
    {
        FillCircle(texture, 48f, 48f, 35f, HtmlColor("6B320C"));
        FillCircle(texture, 48f, 48f, 29f, HtmlColor("F9B925"));
        FillCircle(texture, 48f, 48f, 20f, HtmlColor("FFE77A"));
        FillCircle(texture, 48f, 48f, 12f, HtmlColor("D97512"));
        FillCircle(texture, 48f, 48f, 7f, HtmlColor("FFF2A0"));
    }

    private static void DrawHeartIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B1D16");
        var red = HtmlColor("EF4F55");
        var highlight = HtmlColor("FF8A85");
        FillCircle(texture, 34f, 59f, 23f, outline);
        FillCircle(texture, 62f, 59f, 23f, outline);
        FillTriangle(texture, new Vector2(15f, 54f), new Vector2(81f, 54f), new Vector2(48f, 15f), outline);
        FillCircle(texture, 36f, 58f, 17f, red);
        FillCircle(texture, 60f, 58f, 17f, red);
        FillTriangle(texture, new Vector2(24f, 53f), new Vector2(72f, 53f), new Vector2(48f, 22f), red);
        FillCircle(texture, 39f, 65f, 7f, highlight);
    }

    private static void DrawSpeedIcon(Texture2D texture)
    {
        var outline = HtmlColor("28501A");
        var green = HtmlColor("67C841");
        var light = HtmlColor("B9F26A");
        FillTriangle(texture, new Vector2(48f, 82f), new Vector2(20f, 48f), new Vector2(37f, 48f), outline);
        FillTriangle(texture, new Vector2(48f, 82f), new Vector2(76f, 48f), new Vector2(59f, 48f), outline);
        FillRect(texture, 36, 19, 25, 37, outline);
        FillTriangle(texture, new Vector2(48f, 74f), new Vector2(28f, 51f), new Vector2(40f, 51f), green);
        FillTriangle(texture, new Vector2(48f, 74f), new Vector2(68f, 51f), new Vector2(56f, 51f), green);
        FillRect(texture, 41, 23, 15, 32, green);
        FillRect(texture, 48, 51, 6, 17, light);
    }

    private static void DrawHamsterIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B2A0E");
        var fur = HtmlColor("FFC331");
        var cheek = HtmlColor("F89B24");
        FillCircle(texture, 27f, 70f, 13f, outline);
        FillCircle(texture, 69f, 70f, 13f, outline);
        FillCircle(texture, 27f, 70f, 8f, HtmlColor("FFE28A"));
        FillCircle(texture, 69f, 70f, 8f, HtmlColor("FFE28A"));
        FillCircle(texture, 48f, 48f, 36f, outline);
        FillCircle(texture, 48f, 48f, 30f, fur);
        FillCircle(texture, 31f, 42f, 10f, cheek);
        FillCircle(texture, 65f, 42f, 10f, cheek);
        FillCircle(texture, 39f, 55f, 4f, HtmlColor("331507"));
        FillCircle(texture, 57f, 55f, 4f, HtmlColor("331507"));
        FillCircle(texture, 48f, 46f, 5f, HtmlColor("6B2C12"));
        DrawThickLine(texture, new Vector2(43f, 39f), new Vector2(48f, 35f), 4f, HtmlColor("6B2C12"));
        DrawThickLine(texture, new Vector2(53f, 39f), new Vector2(48f, 35f), 4f, HtmlColor("6B2C12"));
    }

    private static void DrawMushroomIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B2A0E");
        var cap = HtmlColor("D94B31");
        var stem = HtmlColor("FFF1C1");
        FillCircle(texture, 48f, 56f, 34f, outline);
        FillRect(texture, 18, 22, 60, 35, Transparent);
        FillCircle(texture, 48f, 56f, 28f, cap);
        FillRect(texture, 24, 20, 48, 38, outline);
        FillRect(texture, 31, 23, 34, 34, stem);
        FillCircle(texture, 32f, 61f, 8f, HtmlColor("FFE68C"));
        FillCircle(texture, 57f, 68f, 10f, HtmlColor("FFE68C"));
        FillCircle(texture, 69f, 52f, 6f, HtmlColor("FFE68C"));
    }

    private static void DrawGearIcon(Texture2D texture)
    {
        var outline = HtmlColor("4A2510");
        var metal = HtmlColor("C9D1D8");
        var shade = HtmlColor("77828B");
        FillRect(texture, 43, 10, 10, 76, outline);
        FillRect(texture, 10, 43, 76, 10, outline);
        DrawThickLine(texture, new Vector2(22f, 22f), new Vector2(74f, 74f), 10f, outline);
        DrawThickLine(texture, new Vector2(74f, 22f), new Vector2(22f, 74f), 10f, outline);
        FillCircle(texture, 48f, 48f, 34f, outline);
        FillCircle(texture, 48f, 48f, 26f, metal);
        FillCircle(texture, 48f, 48f, 12f, outline);
        FillCircle(texture, 48f, 48f, 7f, shade);
    }

    private static void DrawPetIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B2A0E");
        var pad = HtmlColor("FFC331");
        FillCircle(texture, 32f, 64f, 10f, outline);
        FillCircle(texture, 48f, 70f, 10f, outline);
        FillCircle(texture, 64f, 64f, 10f, outline);
        FillCircle(texture, 36f, 39f, 16f, outline);
        FillCircle(texture, 60f, 39f, 16f, outline);
        FillCircle(texture, 48f, 47f, 18f, outline);
        FillCircle(texture, 32f, 64f, 6f, pad);
        FillCircle(texture, 48f, 70f, 6f, pad);
        FillCircle(texture, 64f, 64f, 6f, pad);
        FillCircle(texture, 36f, 39f, 11f, pad);
        FillCircle(texture, 60f, 39f, 11f, pad);
        FillCircle(texture, 48f, 47f, 13f, pad);
    }

    private static void DrawAdventureIcon(Texture2D texture)
    {
        var outline = HtmlColor("38551B");
        var leaf = HtmlColor("70B944");
        var trunk = HtmlColor("8A4718");
        FillCircle(texture, 34f, 58f, 18f, outline);
        FillCircle(texture, 53f, 67f, 22f, outline);
        FillCircle(texture, 66f, 51f, 18f, outline);
        FillCircle(texture, 34f, 58f, 13f, leaf);
        FillCircle(texture, 53f, 67f, 16f, HtmlColor("8CD356"));
        FillCircle(texture, 66f, 51f, 13f, leaf);
        FillRect(texture, 42, 22, 13, 34, HtmlColor("5B2A0E"));
        FillRect(texture, 45, 25, 8, 31, trunk);
        FillTriangle(texture, new Vector2(48f, 31f), new Vector2(27f, 16f), new Vector2(69f, 16f), HtmlColor("5B2A0E"));
        FillTriangle(texture, new Vector2(48f, 29f), new Vector2(34f, 19f), new Vector2(62f, 19f), trunk);
    }

    private static void DrawLockIcon(Texture2D texture)
    {
        var outline = HtmlColor("4A2510");
        var gold = HtmlColor("D89425");
        var light = HtmlColor("FFD56A");
        FillCircle(texture, 48f, 61f, 24f, outline);
        FillCircle(texture, 48f, 61f, 15f, Transparent);
        FillRect(texture, 18, 22, 60, 42, outline);
        FillRect(texture, 25, 28, 46, 31, gold);
        FillRect(texture, 34, 62, 28, 8, gold);
        FillCircle(texture, 48f, 45f, 5f, outline);
        FillRect(texture, 45, 32, 6, 13, outline);
        FillRect(texture, 31, 53, 18, 4, light);
    }

    private static void DrawLampIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B2A0E");
        var gold = HtmlColor("D89425");
        var light = HtmlColor("FFE28A");
        var jewel = HtmlColor("E84C8A");
        FillRect(texture, 24, 20, 48, 13, outline);
        FillRect(texture, 31, 24, 34, 7, gold);
        FillRect(texture, 43, 30, 10, 40, outline);
        FillRect(texture, 47, 32, 3, 36, light);
        FillCircle(texture, 48f, 65f, 23f, outline);
        FillCircle(texture, 48f, 65f, 16f, gold);
        FillCircle(texture, 48f, 65f, 8f, light);
        FillCircle(texture, 48f, 65f, 4f, jewel);
        DrawThickLine(texture, new Vector2(38f, 25f), new Vector2(22f, 49f), 9f, outline);
        DrawThickLine(texture, new Vector2(58f, 25f), new Vector2(74f, 49f), 9f, outline);
        DrawThickLine(texture, new Vector2(39f, 27f), new Vector2(25f, 49f), 5f, gold);
        DrawThickLine(texture, new Vector2(57f, 27f), new Vector2(71f, 49f), 5f, gold);
    }

    private static void DrawShopIcon(Texture2D texture)
    {
        var outline = HtmlColor("5B2A0E");
        var pouch = HtmlColor("A85A22");
        var pouchLight = HtmlColor("D89425");
        var ruby = HtmlColor("E63E45");
        var rubyLight = HtmlColor("FF9A92");
        var stringColor = HtmlColor("FFE28A");

        FillCircle(texture, 48f, 52f, 33f, outline);
        FillCircle(texture, 48f, 50f, 26f, pouch);
        FillRect(texture, 25, 23, 46, 18, outline);
        FillRect(texture, 31, 26, 34, 11, pouchLight);
        DrawThickLine(texture, new Vector2(31f, 37f), new Vector2(65f, 37f), 7f, stringColor);
        FillTriangle(texture, new Vector2(48f, 76f), new Vector2(25f, 47f), new Vector2(71f, 47f), pouch);

        FillTriangle(texture, new Vector2(48f, 29f), new Vector2(32f, 48f), new Vector2(64f, 48f), outline);
        FillTriangle(texture, new Vector2(48f, 32f), new Vector2(37f, 46f), new Vector2(59f, 46f), ruby);
        FillTriangle(texture, new Vector2(37f, 46f), new Vector2(59f, 46f), new Vector2(48f, 63f), outline);
        FillTriangle(texture, new Vector2(40f, 48f), new Vector2(56f, 48f), new Vector2(48f, 58f), ruby);
        FillTriangle(texture, new Vector2(48f, 32f), new Vector2(42f, 45f), new Vector2(54f, 45f), rubyLight);
    }

    private static void DrawThickLine(Texture2D texture, Vector2 start, Vector2 end, float thickness, Color color)
    {
        var radius = thickness * 0.5f;
        var minX = Mathf.FloorToInt(Mathf.Min(start.x, end.x) - radius - 1f);
        var maxX = Mathf.CeilToInt(Mathf.Max(start.x, end.x) + radius + 1f);
        var minY = Mathf.FloorToInt(Mathf.Min(start.y, end.y) - radius - 1f);
        var maxY = Mathf.CeilToInt(Mathf.Max(start.y, end.y) + radius + 1f);

        for (var y = minY; y <= maxY; y++)
        {
            for (var x = minX; x <= maxX; x++)
            {
                var distance = DistanceToSegment(new Vector2(x + 0.5f, y + 0.5f), start, end);
                if (distance <= radius)
                    SetPixelSafe(texture, x, y, color);
            }
        }
    }

    private static float DistanceToSegment(Vector2 point, Vector2 start, Vector2 end)
    {
        var segment = end - start;
        var lengthSquared = segment.sqrMagnitude;
        if (lengthSquared <= 0.0001f)
            return Vector2.Distance(point, start);

        var t = Mathf.Clamp01(Vector2.Dot(point - start, segment) / lengthSquared);
        var projection = start + t * segment;
        return Vector2.Distance(point, projection);
    }

    private static void FillCircle(Texture2D texture, float centerX, float centerY, float radius, Color color)
    {
        var radiusSquared = radius * radius;
        var minX = Mathf.FloorToInt(centerX - radius);
        var maxX = Mathf.CeilToInt(centerX + radius);
        var minY = Mathf.FloorToInt(centerY - radius);
        var maxY = Mathf.CeilToInt(centerY + radius);

        for (var y = minY; y <= maxY; y++)
        {
            for (var x = minX; x <= maxX; x++)
            {
                var dx = x + 0.5f - centerX;
                var dy = y + 0.5f - centerY;
                if (dx * dx + dy * dy <= radiusSquared)
                    SetPixelSafe(texture, x, y, color);
            }
        }
    }

    private static void FillRect(Texture2D texture, int x, int y, int width, int height, Color color)
    {
        for (var yy = y; yy < y + height; yy++)
        {
            for (var xx = x; xx < x + width; xx++)
                SetPixelSafe(texture, xx, yy, color);
        }
    }

    private static void FillTriangle(Texture2D texture, Vector2 a, Vector2 b, Vector2 c, Color color)
    {
        var minX = Mathf.FloorToInt(Mathf.Min(a.x, Mathf.Min(b.x, c.x)));
        var maxX = Mathf.CeilToInt(Mathf.Max(a.x, Mathf.Max(b.x, c.x)));
        var minY = Mathf.FloorToInt(Mathf.Min(a.y, Mathf.Min(b.y, c.y)));
        var maxY = Mathf.CeilToInt(Mathf.Max(a.y, Mathf.Max(b.y, c.y)));

        for (var y = minY; y <= maxY; y++)
        {
            for (var x = minX; x <= maxX; x++)
            {
                if (IsPointInTriangle(new Vector2(x + 0.5f, y + 0.5f), a, b, c))
                    SetPixelSafe(texture, x, y, color);
            }
        }
    }

    private static bool IsPointInTriangle(Vector2 point, Vector2 a, Vector2 b, Vector2 c)
    {
        var d1 = Sign(point, a, b);
        var d2 = Sign(point, b, c);
        var d3 = Sign(point, c, a);
        var hasNegative = d1 < 0f || d2 < 0f || d3 < 0f;
        var hasPositive = d1 > 0f || d2 > 0f || d3 > 0f;
        return !(hasNegative && hasPositive);
    }

    private static float Sign(Vector2 p1, Vector2 p2, Vector2 p3)
    {
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
    }

    private static void SetPixelSafe(Texture2D texture, int x, int y, Color color)
    {
        if (x < 0 || y < 0 || x >= texture.width || y >= texture.height)
            return;

        texture.SetPixel(x, y, color);
    }

    private static void WriteRoundedSprite(
        string name,
        int width,
        int height,
        int radius,
        int border,
        Color borderColor,
        Color topColor,
        Color bottomColor,
        int spriteBorder)
    {
        var texture = new Texture2D(width, height, TextureFormat.RGBA32, false);
        for (var y = 0; y < height; y++)
        {
            for (var x = 0; x < width; x++)
            {
                var distance = RoundedRectDistance(x + 0.5f, y + 0.5f, width, height, radius);
                if (distance > 0f)
                {
                    texture.SetPixel(x, y, Transparent);
                    continue;
                }

                var t = 1f - y / (height - 1f);
                var fill = Color.Lerp(bottomColor, topColor, t);
                texture.SetPixel(x, y, distance > -border ? borderColor : fill);
            }
        }

        texture.Apply();
        var path = $"{SpriteFolder}/{name}.png";
        File.WriteAllBytes(path, texture.EncodeToPNG());
        Object.DestroyImmediate(texture);

        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
        if (AssetImporter.GetAtPath(path) is TextureImporter importer)
        {
            importer.textureType = TextureImporterType.Sprite;
            importer.spriteImportMode = SpriteImportMode.Single;
            importer.alphaIsTransparency = true;
            importer.mipmapEnabled = false;
            importer.spritePixelsPerUnit = 100f;
            importer.spriteBorder = new Vector4(spriteBorder, spriteBorder, spriteBorder, spriteBorder);
            importer.SaveAndReimport();
        }
    }

    private static float RoundedRectDistance(float x, float y, float width, float height, float radius)
    {
        if (radius <= 0f)
            return x < 0f || y < 0f || x > width || y > height ? 1f : -1f;

        var px = Mathf.Abs(x - width * 0.5f) - (width * 0.5f - radius);
        var py = Mathf.Abs(y - height * 0.5f) - (height * 0.5f - radius);
        var outsideX = Mathf.Max(px, 0f);
        var outsideY = Mathf.Max(py, 0f);
        var outside = Mathf.Sqrt(outsideX * outsideX + outsideY * outsideY);
        var inside = Mathf.Min(Mathf.Max(px, py), 0f);
        return outside + inside - radius;
    }

    private static Sprite LoadGeneratedSprite(string name)
    {
        if (string.IsNullOrEmpty(name))
            return null;

        return AssetDatabase.LoadAssetAtPath<Sprite>($"{SpriteFolder}/{name}.png");
    }

    private static Sprite LoadSprite(string path)
    {
        return string.IsNullOrEmpty(path) ? null : AssetDatabase.LoadAssetAtPath<Sprite>(path);
    }

    private static Color HtmlColor(string hex)
    {
        ColorUtility.TryParseHtmlString("#" + hex, out var color);
        return color;
    }

    private static void EnsureAssetFolder(string folder)
    {
        if (AssetDatabase.IsValidFolder(folder))
            return;

        var slashIndex = folder.LastIndexOf('/');
        var parent = slashIndex > 0 ? folder.Substring(0, slashIndex) : "Assets";
        var name = slashIndex > 0 ? folder.Substring(slashIndex + 1) : folder;
        EnsureAssetFolder(parent);
        AssetDatabase.CreateFolder(parent, name);
    }
}
