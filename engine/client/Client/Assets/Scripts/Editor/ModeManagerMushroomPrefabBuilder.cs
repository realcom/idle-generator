using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

public static class ModeManagerMushroomPrefabBuilder
{
    private const string PrefabPath = "Assets/ModeManagers/ModeManagerMushroom.prefab";
    private const string RunOnceMarkerPath = "Assets/Scripts/Editor/ModeManagerMushroomPrefabBuilder.runonce";
    private const float BottomUiHeightRatio = 0.38f;
    private const float DockMinY = 0.016f;
    private const float DockMaxY = 0.088f;
    private const float QuickGrowthMinY = 0.274f;
    private const float QuickGrowthMaxY = 0.362f;
    private const float HudTopMargin = 20f;
    private const float HudSideMargin = 28f;
    private const float HudHeight = 126f;
    private const float BottomSideMargin = 28f;

    [InitializeOnLoadMethod]
    private static void RunOnceIfRequested()
    {
        EditorApplication.delayCall += () =>
        {
            if (AssetDatabase.LoadAssetAtPath<Object>(RunOnceMarkerPath) == null)
                return;

            try
            {
                RebuildPrefab();
            }
            finally
            {
                AssetDatabase.DeleteAsset(RunOnceMarkerPath);
                AssetDatabase.Refresh();
            }
        };
    }

    [MenuItem("Tools/IdleZ/Mushroomer/Rebuild ModeManager Prefab")]
    public static void RebuildPrefab()
    {
        var root = PrefabUtility.LoadPrefabContents(PrefabPath);
        try
        {
            var rectTransform = root.GetComponent<RectTransform>();
            if (rectTransform == null)
            {
                Debug.LogError($"{PrefabPath} root does not have RectTransform.");
                return;
            }

            HideLegacyBattleUi(root);
            DestroyDirectChild(rectTransform, "MushroomHudRoot");
            DestroyDirectChild(rectTransform, "MushroomBottomUiRoot");
            DestroyDirectChild(rectTransform, "MushroomQuickGrowthRoot");
            DestroyDirectChild(rectTransform, "MushroomDock");
            DestroyDirectChild(rectTransform, "MushroomOverlayRoot");

            BuildHud(rectTransform);
            BuildBottomPanel(rectTransform);
            BuildQuickGrowth(rectTransform);
            BuildDock(rectTransform);
            BuildOverlay(rectTransform);

            PrefabUtility.SaveAsPrefabAsset(root, PrefabPath);
            AssetDatabase.SaveAssets();
            Debug.Log($"Rebuilt {PrefabPath} for Mushroomer.");
        }
        finally
        {
            PrefabUtility.UnloadPrefabContents(root);
        }
    }

    private static void HideLegacyBattleUi(GameObject root)
    {
        var modeManager = root.GetComponent<ModeManagerMushroom>();
        if (modeManager?.mergeBoard != null)
        {
            var legacyRoot = modeManager.mergeBoard.transform;
            while (legacyRoot != null && legacyRoot.parent != root.transform)
                legacyRoot = legacyRoot.parent;

            if (legacyRoot != null && legacyRoot != root.transform)
                legacyRoot.gameObject.SetActive(false);
        }

        var legacyRect = root.transform.Find("Rect");
        if (legacyRect != null)
            legacyRect.gameObject.SetActive(false);
    }

    private static void BuildHud(RectTransform parent)
    {
        var hudRoot = CreateRect("MushroomHudRoot", parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        hudRoot.SetAsLastSibling();

        var topBar = CreateRect("TopStatus", hudRoot, new Vector2(0f, 1f), new Vector2(1f, 1f),
            new Vector2(HudSideMargin, -(HudTopMargin + HudHeight)), new Vector2(-HudSideMargin, -HudTopMargin));
        topBar.pivot = new Vector2(0.5f, 1f);
        AddImage(topBar, new Color(0.07f, 0.08f, 0.06f, 0.82f), raycastTarget: false);

        var layout = topBar.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 10f;
        layout.padding = new RectOffset(12, 12, 12, 12);
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = false;
        layout.childForceExpandHeight = true;

        var identity = CreatePanel("IdentityPanel", topBar, 300f);
        var identityLayout = identity.gameObject.AddComponent<VerticalLayoutGroup>();
        identityLayout.spacing = 4f;
        identityLayout.padding = new RectOffset(16, 16, 8, 8);
        identityLayout.childControlWidth = true;
        identityLayout.childControlHeight = true;
        identityLayout.childForceExpandHeight = false;

        AddText(identity, "HudTitle", "Mushroomer", 28f, FontStyles.Bold, TextAlignmentOptions.Left);
        AddText(identity, "HudWave", "Wave 1", 20f, FontStyles.Normal, TextAlignmentOptions.Left);

        var bars = CreatePanel("BarsPanel", topBar, 0f, flexibleWidth: 1f);
        var barsLayout = bars.gameObject.AddComponent<VerticalLayoutGroup>();
        barsLayout.spacing = 7f;
        barsLayout.padding = new RectOffset(14, 14, 10, 10);
        barsLayout.childControlWidth = true;
        barsLayout.childControlHeight = true;
        barsLayout.childForceExpandHeight = true;
        CreateBar(bars, "Hp", "HP 0/0", new Color(0.86f, 0.20f, 0.17f, 1f));
        CreateBar(bars, "Exp", "EXP 0", new Color(0.20f, 0.57f, 0.88f, 1f));

        var stats = CreatePanel("StatsPanel", topBar, 220f);
        var statsLayout = stats.gameObject.AddComponent<VerticalLayoutGroup>();
        statsLayout.spacing = 2f;
        statsLayout.padding = new RectOffset(16, 16, 7, 7);
        statsLayout.childControlWidth = true;
        statsLayout.childControlHeight = true;
        statsLayout.childForceExpandHeight = false;
        AddText(stats, "HudLevel", "Lv.1", 21f, FontStyles.Bold, TextAlignmentOptions.Left);
        AddText(stats, "HudAttack", "Attack 0", 19f, FontStyles.Normal, TextAlignmentOptions.Left);
        AddText(stats, "HudGold", "Gold 0", 19f, FontStyles.Normal, TextAlignmentOptions.Left);
    }

    private static void BuildBottomPanel(RectTransform parent)
    {
        var root = CreateRect("MushroomBottomUiRoot", parent, new Vector2(0f, 0f), new Vector2(1f, BottomUiHeightRatio),
            Vector2.zero, Vector2.zero);
        root.SetAsLastSibling();
        AddImage(root, new Color(0.13f, 0.10f, 0.075f, 0.98f), raycastTarget: true);

        var topLine = CreateRect("TopLine", root, new Vector2(0f, 1f), Vector2.one,
            new Vector2(0f, -4f), Vector2.zero);
        topLine.pivot = new Vector2(0.5f, 1f);
        AddImage(topLine, new Color(0.72f, 0.60f, 0.36f, 1f), raycastTarget: false);
    }

    private static void BuildQuickGrowth(RectTransform parent)
    {
        var root = CreateRect("MushroomQuickGrowthRoot", parent, new Vector2(0f, QuickGrowthMinY), new Vector2(1f, QuickGrowthMaxY),
            new Vector2(BottomSideMargin, 0f), new Vector2(-BottomSideMargin, 0f));
        root.SetAsLastSibling();
        AddImage(root, new Color(0.08f, 0.07f, 0.06f, 0.88f), raycastTarget: true);

        var layout = root.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 14f;
        layout.padding = new RectOffset(18, 18, 14, 14);
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        CreateButton(root, "QuickAttackButton", "공격 강화\n50G", 24f);
        CreateButton(root, "QuickHpButton", "체력 강화\n40G", 24f);
        CreateButton(root, "QuickSkillButton", "스킬 강화\n80G", 24f);
    }

    private static void BuildDock(RectTransform parent)
    {
        var dock = CreateRect("MushroomDock", parent, new Vector2(0f, DockMinY), new Vector2(1f, DockMaxY),
            new Vector2(BottomSideMargin, 0f), new Vector2(-BottomSideMargin, 0f));
        dock.SetAsLastSibling();
        AddImage(dock, new Color(0.10f, 0.09f, 0.08f, 0.94f), raycastTarget: true);

        var layout = dock.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 12f;
        layout.padding = new RectOffset(14, 14, 12, 12);
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        CreateButton(dock, "BattleButton", "전투", 26f);
        CreateButton(dock, "Page_AbilityButton", "성장", 26f);
        CreateButton(dock, "Page_Shop_NewButton", "상점", 26f);
    }

    private static void BuildOverlay(RectTransform parent)
    {
        var overlay = CreateRect("MushroomOverlayRoot", parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        overlay.SetAsLastSibling();
        AddImage(overlay, new Color(0.05f, 0.04f, 0.03f, 0f), raycastTarget: false);

        var safeArea = CreateRect("SafeArea", overlay, Vector2.zero, Vector2.one,
            Vector2.zero, Vector2.zero);

        var header = CreateRect("Header", safeArea, new Vector2(0f, 1f), new Vector2(1f, 1f),
            new Vector2(0f, -88f), Vector2.zero);
        header.pivot = new Vector2(0.5f, 1f);

        var title = AddText(header, "OverlayTitle", "성장", 40f, FontStyles.Bold, TextAlignmentOptions.Left);
        title.rectTransform.offsetMax = new Vector2(-180f, 0f);

        var close = CreateButton(header, "OverlayCloseButton", "전투", 25f);
        var closeRect = (RectTransform)close.transform;
        closeRect.anchorMin = new Vector2(1f, 0.5f);
        closeRect.anchorMax = new Vector2(1f, 0.5f);
        closeRect.pivot = new Vector2(1f, 0.5f);
        closeRect.anchoredPosition = Vector2.zero;
        closeRect.sizeDelta = new Vector2(150f, 72f);
        header.gameObject.SetActive(false);

        var pageRoot = CreateRect("PageRoot", safeArea, Vector2.zero, Vector2.one,
            Vector2.zero, Vector2.zero);
        pageRoot.SetAsFirstSibling();

        overlay.gameObject.SetActive(false);
    }

    private static RectTransform CreatePanel(string name, RectTransform parent, float preferredWidth, float flexibleWidth = 0f)
    {
        var panel = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(panel, new Color(0.14f, 0.13f, 0.10f, 0.72f), raycastTarget: false);

        var layoutElement = panel.gameObject.AddComponent<LayoutElement>();
        layoutElement.preferredWidth = preferredWidth;
        layoutElement.flexibleWidth = flexibleWidth;
        return panel;
    }

    private static void CreateBar(RectTransform parent, string prefix, string label, Color fillColor)
    {
        var root = CreateRect($"{prefix}Bar", parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        AddImage(root, new Color(0.02f, 0.02f, 0.02f, 0.62f), raycastTarget: false);
        var layoutElement = root.gameObject.AddComponent<LayoutElement>();
        layoutElement.minHeight = 36f;
        layoutElement.flexibleHeight = 1f;

        var fillRoot = CreateRect($"{prefix}FillRoot", root, Vector2.zero, Vector2.one,
            new Vector2(3f, 3f), new Vector2(-3f, -3f));
        var fill = AddImage(fillRoot, fillColor, raycastTarget: false);
        fill.name = $"{prefix}Fill";
        fill.type = Image.Type.Filled;
        fill.fillMethod = Image.FillMethod.Horizontal;
        fill.fillOrigin = 0;
        fill.fillAmount = 1f;

        AddText(root, $"{prefix}Text", label, 18f, FontStyles.Bold, TextAlignmentOptions.Center);
    }

    private static Button CreateButton(RectTransform parent, string name, string label, float fontSize)
    {
        var root = CreateRect(name, parent, Vector2.zero, Vector2.one, Vector2.zero, Vector2.zero);
        var image = AddImage(root, new Color(0.24f, 0.20f, 0.16f, 0.98f), raycastTarget: true);
        var button = root.gameObject.AddComponent<Button>();
        button.targetGraphic = image;
        button.transition = Selectable.Transition.None;

        var text = AddText(root, "Label", label, fontSize, FontStyles.Bold, TextAlignmentOptions.Center);
        text.textWrappingMode = TextWrappingModes.Normal;

        var layoutElement = root.gameObject.AddComponent<LayoutElement>();
        layoutElement.minHeight = 60f;
        layoutElement.flexibleWidth = 1f;
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
        var rect = go.GetComponent<RectTransform>();
        rect.SetParent(parent, false);
        rect.localScale = Vector3.one;
        rect.anchorMin = anchorMin;
        rect.anchorMax = anchorMax;
        rect.offsetMin = offsetMin;
        rect.offsetMax = offsetMax;
        return rect;
    }

    private static void DestroyDirectChild(Transform parent, string childName)
    {
        var child = parent.Find(childName);
        if (child != null)
            Object.DestroyImmediate(child.gameObject);
    }
}
