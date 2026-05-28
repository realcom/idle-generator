using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

public static class UIRecipePrefabBuilder
{
    private const string RecipePath = "harness/unity/recipes/ingame/hamster_growth_dock.yaml";
    private const string OutputFolder = "Assets/Resources/HarnessPreview";
    private const string PrefabPath = OutputFolder + "/HamsterGrowthDock.prefab";

    [MenuItem("Tools/IdleZ/Harness/Rebuild Hamster Growth Dock Preview")]
    public static void RebuildHamsterGrowthDockPreview()
    {
        EnsureAssetFolder("Assets/Resources");
        EnsureAssetFolder(OutputFolder);

        var root = new GameObject("HamsterGrowthDock", typeof(RectTransform), typeof(CanvasGroup));
        try
        {
            var rectTransform = root.GetComponent<RectTransform>();
            Stretch(rectTransform);

            var canvasGroup = root.GetComponent<CanvasGroup>();
            canvasGroup.alpha = 1f;
            canvasGroup.blocksRaycasts = false;
            canvasGroup.interactable = false;

            BuildTopHud(rectTransform);
            BuildCombatFrame(rectTransform);
            BuildGrowthDock(rectTransform);

            PrefabUtility.SaveAsPrefabAsset(root, PrefabPath);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            Debug.Log($"Built {PrefabPath} from {RecipePath}.");
        }
        finally
        {
            Object.DestroyImmediate(root);
        }
    }

    private static void BuildTopHud(RectTransform parent)
    {
        var topHud = CreateRect("TopHudStrip", parent, new Vector2(0f, 1f), new Vector2(1f, 1f),
            new Vector2(28f, -142f), new Vector2(-28f, -24f));
        AddImage(topHud, new Color(0.28f, 0.16f, 0.08f, 0.93f), false);

        var layout = topHud.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.padding = new RectOffset(16, 16, 14, 14);
        layout.spacing = 12f;
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        CreateCounterPill(topHud, "CombatPowerPill", "전투력", "125.8A", "ATK", new Color(0.86f, 0.67f, 0.28f, 1f), 1.3f);
        CreateCounterPill(topHud, "CoinPill", "골드", "23.4A", "G", new Color(1f, 0.78f, 0.22f, 1f), 1f);
        CreateCounterPill(topHud, "HeartPill", "하트", "1.23A", "HP", new Color(0.96f, 0.28f, 0.31f, 1f), 1f);

        var stage = CreateRect("StageProgressPill", parent, new Vector2(0.5f, 1f), new Vector2(0.5f, 1f),
            new Vector2(-236f, -212f), new Vector2(236f, -158f));
        AddImage(stage, new Color(0.19f, 0.13f, 0.08f, 0.76f), false);
        AddText(stage, "StageProgressText", "Stage 12-8  버섯 숲 전투 중", 24f, FontStyles.Bold, TextAlignmentOptions.Center);
    }

    private static void BuildCombatFrame(RectTransform parent)
    {
        var arena = CreateRect("CombatArenaFrame", parent, new Vector2(0f, 0.38f), new Vector2(1f, 0.86f),
            new Vector2(28f, 18f), new Vector2(-28f, -18f));
        arena.SetAsFirstSibling();

        var mission = CreateRect("MissionCard", arena, new Vector2(0f, 0f), new Vector2(0f, 0f),
            new Vector2(0f, 42f), new Vector2(360f, 154f));
        AddImage(mission, new Color(0.12f, 0.25f, 0.17f, 0.82f), false);

        var missionLayout = mission.gameObject.AddComponent<VerticalLayoutGroup>();
        missionLayout.padding = new RectOffset(18, 18, 12, 12);
        missionLayout.spacing = 2f;
        missionLayout.childControlWidth = true;
        missionLayout.childControlHeight = true;
        missionLayout.childForceExpandHeight = false;

        AddText(mission, "MissionTitle", "오늘의 전투", 22f, FontStyles.Bold, TextAlignmentOptions.Left);
        AddText(mission, "MissionValue", "버섯 병정 42 / 100", 26f, FontStyles.Bold, TextAlignmentOptions.Left);
        CreateProgressBar(mission, "MissionProgress", 0.42f, new Color(0.52f, 0.82f, 0.35f, 1f), 20f);

        var damage = CreateRect("DamageBubble", arena, new Vector2(1f, 0.5f), new Vector2(1f, 0.5f),
            new Vector2(-274f, -56f), new Vector2(-20f, 16f));
        AddImage(damage, new Color(0.55f, 0.14f, 0.08f, 0.72f), false);
        AddText(damage, "DamageText", "CRIT  18.7A", 28f, FontStyles.Bold, TextAlignmentOptions.Center);
    }

    private static void BuildGrowthDock(RectTransform parent)
    {
        var dock = CreateRect("GrowthDockRoot", parent, new Vector2(0f, 0f), new Vector2(1f, 0.38f),
            Vector2.zero, Vector2.zero);
        AddImage(dock, new Color(0.31f, 0.18f, 0.09f, 0.98f), false);

        var dockLayout = dock.gameObject.AddComponent<VerticalLayoutGroup>();
        dockLayout.padding = new RectOffset(22, 22, 18, 18);
        dockLayout.spacing = 14f;
        dockLayout.childControlWidth = true;
        dockLayout.childControlHeight = true;
        dockLayout.childForceExpandWidth = true;
        dockLayout.childForceExpandHeight = false;

        var grid = CreateRect("StatCardGrid", dock, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var gridElement = grid.gameObject.AddComponent<LayoutElement>();
        gridElement.minHeight = 394f;
        gridElement.flexibleHeight = 1f;

        var gridLayout = grid.gameObject.AddComponent<VerticalLayoutGroup>();
        gridLayout.spacing = 12f;
        gridLayout.childControlWidth = true;
        gridLayout.childControlHeight = true;
        gridLayout.childForceExpandWidth = true;
        gridLayout.childForceExpandHeight = true;

        var rowA = CreateStatRow(grid, "StatCardRowA");
        CreateStatCard(rowA, "StatCard_Attack", "공격력", "24.5A", "Lv. 245", "3.21A", "ATK", new Color(0.93f, 0.62f, 0.16f, 1f));
        CreateStatCard(rowA, "StatCard_Health", "체력", "18.7A", "Lv. 230", "2.14A", "HP", new Color(0.95f, 0.32f, 0.36f, 1f));

        var rowB = CreateStatRow(grid, "StatCardRowB");
        CreateStatCard(rowB, "StatCard_GoldGain", "골드 획득", "6.45A", "Lv. 210", "1.89A", "G", new Color(1f, 0.78f, 0.22f, 1f));
        CreateStatCard(rowB, "StatCard_GrowthSpeed", "버섯 성장속도", "5.32A", "Lv. 205", "1.77A", "SPD", new Color(0.74f, 0.26f, 0.18f, 1f));

        BuildRewardRow(dock);
        BuildTabBar(dock);
    }

    private static RectTransform CreateStatRow(RectTransform parent, string name)
    {
        var row = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var layoutElement = row.gameObject.AddComponent<LayoutElement>();
        layoutElement.flexibleHeight = 1f;

        var layout = row.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 12f;
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;
        return row;
    }

    private static void CreateStatCard(
        RectTransform parent,
        string name,
        string label,
        string value,
        string level,
        string cost,
        string icon,
        Color iconColor)
    {
        var card = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(card, new Color(0.93f, 0.78f, 0.55f, 1f), false);

        var layoutElement = card.gameObject.AddComponent<LayoutElement>();
        layoutElement.flexibleWidth = 1f;
        layoutElement.flexibleHeight = 1f;

        var layout = card.gameObject.AddComponent<VerticalLayoutGroup>();
        layout.padding = new RectOffset(14, 14, 12, 12);
        layout.spacing = 4f;
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = false;

        var levelText = AddText(card, "LevelText", level, 22f, FontStyles.Bold, TextAlignmentOptions.Center);
        levelText.color = new Color(0.24f, 0.13f, 0.06f, 1f);
        levelText.gameObject.AddComponent<LayoutElement>().minHeight = 28f;

        var iconBadge = CreateRect("IconBadge", card, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(iconBadge, iconColor, false);
        iconBadge.gameObject.AddComponent<LayoutElement>().minHeight = 58f;
        var iconText = AddText(iconBadge, "IconText", icon, 24f, FontStyles.Bold, TextAlignmentOptions.Center);
        iconText.color = Color.white;

        var labelText = AddText(card, "LabelText", label, 22f, FontStyles.Bold, TextAlignmentOptions.Center);
        labelText.color = new Color(0.21f, 0.11f, 0.05f, 1f);
        labelText.textWrappingMode = TextWrappingModes.Normal;
        labelText.gameObject.AddComponent<LayoutElement>().minHeight = 32f;

        var valueText = AddText(card, "ValueText", value, 22f, FontStyles.Bold, TextAlignmentOptions.Center);
        valueText.color = new Color(0.21f, 0.11f, 0.05f, 1f);
        valueText.gameObject.AddComponent<LayoutElement>().minHeight = 30f;

        var button = CreateButton(card, "Btn_Upgrade", cost, 24f, new Color(0.42f, 0.68f, 0.18f, 1f), Color.white);
        button.gameObject.AddComponent<LayoutElement>().minHeight = 46f;
    }

    private static void BuildRewardRow(RectTransform parent)
    {
        var row = CreateRect("GrowthRewardRow", parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var rowElement = row.gameObject.AddComponent<LayoutElement>();
        rowElement.minHeight = 104f;

        var layout = row.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 12f;
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        var reward = CreateButton(row, "Btn_ClaimGrowthReward", "성장 보상 받기\n89.32A", 30f,
            new Color(0.96f, 0.57f, 0.10f, 1f), Color.white);
        var rewardElement = reward.gameObject.AddComponent<LayoutElement>();
        rewardElement.flexibleWidth = 2.2f;

        var auto = CreateButton(row, "Btn_AutoEnhance", "자동 강화", 26f,
            new Color(0.31f, 0.67f, 0.26f, 1f), Color.white);
        var autoElement = auto.gameObject.AddComponent<LayoutElement>();
        autoElement.flexibleWidth = 1f;
    }

    private static void BuildTabBar(RectTransform parent)
    {
        var tabs = CreateRect("BottomTabBar", parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var tabsElement = tabs.gameObject.AddComponent<LayoutElement>();
        tabsElement.minHeight = 102f;

        AddImage(tabs, new Color(0.22f, 0.13f, 0.08f, 1f), false);

        var layout = tabs.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.padding = new RectOffset(10, 10, 10, 10);
        layout.spacing = 8f;
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        CreateTabButton(tabs, "Tab_Growth", "성장", true);
        CreateTabButton(tabs, "Tab_Companion", "동료", false);
        CreateTabButton(tabs, "Tab_Equipment", "장비", false);
        CreateTabButton(tabs, "Tab_Pet", "펫", false);
        CreateTabButton(tabs, "Tab_Adventure", "모험", false);
        CreateTabButton(tabs, "Tab_LockedGuild", "길드", false);
    }

    private static void CreateCounterPill(RectTransform parent, string name, string label, string value, string icon, Color iconColor, float flexibleWidth)
    {
        var pill = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(pill, new Color(0.18f, 0.10f, 0.05f, 0.82f), false);

        var layoutElement = pill.gameObject.AddComponent<LayoutElement>();
        layoutElement.flexibleWidth = flexibleWidth;

        var layout = pill.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.padding = new RectOffset(12, 14, 10, 10);
        layout.spacing = 10f;
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandHeight = true;

        var iconBadge = CreateRect("IconBadge", pill, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(iconBadge, iconColor, false);
        var iconElement = iconBadge.gameObject.AddComponent<LayoutElement>();
        iconElement.preferredWidth = 70f;
        AddText(iconBadge, "IconText", icon, 20f, FontStyles.Bold, TextAlignmentOptions.Center);

        var stack = CreateRect("TextStack", pill, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        stack.gameObject.AddComponent<LayoutElement>().flexibleWidth = 1f;

        var stackLayout = stack.gameObject.AddComponent<VerticalLayoutGroup>();
        stackLayout.spacing = 0f;
        stackLayout.childControlWidth = true;
        stackLayout.childControlHeight = true;
        stackLayout.childForceExpandWidth = true;
        stackLayout.childForceExpandHeight = false;

        AddText(stack, "LabelText", label, 18f, FontStyles.Bold, TextAlignmentOptions.Left);
        AddText(stack, "ValueText", value, 30f, FontStyles.Bold, TextAlignmentOptions.Left);
    }

    private static void CreateTabButton(RectTransform parent, string name, string label, bool selected)
    {
        var button = CreateButton(parent, name, label, 22f,
            selected ? new Color(0.95f, 0.62f, 0.14f, 1f) : new Color(0.34f, 0.22f, 0.13f, 1f),
            selected ? new Color(0.18f, 0.10f, 0.04f, 1f) : Color.white);
        button.gameObject.AddComponent<LayoutElement>().flexibleWidth = 1f;
    }

    private static void CreateProgressBar(RectTransform parent, string name, float fillAmount, Color fillColor, float minHeight)
    {
        var bar = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(bar, new Color(0.04f, 0.04f, 0.03f, 0.72f), false);
        bar.gameObject.AddComponent<LayoutElement>().minHeight = minHeight;

        var fill = CreateRect("Fill", bar, new Vector2(0f, 0f), new Vector2(fillAmount, 1f),
            new Vector2(3f, 3f), new Vector2(-3f, -3f));
        AddImage(fill, fillColor, false);
    }

    private static Button CreateButton(RectTransform parent, string name, string label, float fontSize, Color backgroundColor, Color textColor)
    {
        var buttonRoot = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var image = AddImage(buttonRoot, backgroundColor, true);
        var button = buttonRoot.gameObject.AddComponent<Button>();
        button.targetGraphic = image;
        button.transition = Selectable.Transition.ColorTint;

        var text = AddText(buttonRoot, "Label", label, fontSize, FontStyles.Bold, TextAlignmentOptions.Center);
        text.color = textColor;
        text.textWrappingMode = TextWrappingModes.Normal;
        text.overflowMode = TextOverflowModes.Ellipsis;
        return button;
    }

    private static TextMeshProUGUI AddText(RectTransform parent, string name, string text, float fontSize, FontStyles style, TextAlignmentOptions alignment)
    {
        var rect = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var label = rect.gameObject.AddComponent<TextMeshProUGUI>();
        label.text = text;
        label.fontSize = fontSize;
        label.fontStyle = style;
        label.alignment = alignment;
        label.color = Color.white;
        label.raycastTarget = false;
        label.textWrappingMode = TextWrappingModes.NoWrap;
        label.overflowMode = TextOverflowModes.Ellipsis;
        label.font = TMP_Settings.defaultFontAsset;
        return label;
    }

    private static Image AddImage(RectTransform rectTransform, Color color, bool raycastTarget)
    {
        var image = rectTransform.gameObject.AddComponent<Image>();
        image.color = color;
        image.raycastTarget = raycastTarget;
        return image;
    }

    private static RectTransform CreateRect(string name, RectTransform parent, Vector2 anchorMin, Vector2 anchorMax, Vector2 offsetMin, Vector2 offsetMax)
    {
        var go = new GameObject(name, typeof(RectTransform));
        var rectTransform = go.GetComponent<RectTransform>();
        rectTransform.SetParent(parent, false);
        rectTransform.localScale = Vector3.one;
        rectTransform.anchorMin = anchorMin;
        rectTransform.anchorMax = anchorMax;
        rectTransform.offsetMin = offsetMin;
        rectTransform.offsetMax = offsetMax;
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
