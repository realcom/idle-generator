using System;
using System.Collections;
using System.Collections.Generic;
using Commons;
using Commons.Game;
using Commons.Game.Events;
using Commons.Utility;
using Commons.Types.Units;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

public class ModeManagerMushroom : ZModeManagerBattle
{
    public const string AbilityPageAddressKey = nameof(Page_Ability);
    public const string ShopPageAddressKey = "Page_Shop_New";

    private const string HamsterGrowthDockPreviewName = "HamsterGrowthDockPreview";
    private const string HamsterGrowthDockPreviewResource = "HarnessPreview/HamsterGrowthDock";
    private const string PauseRequestKey = "ModeManagerMushroomOverlay";
    private const float MushroomCameraFov = 9.25f;
    private const float BottomUiHeightRatio = 0.38f;
    private const float DockMinY = 0.016f;
    private const float DockMaxY = 0.088f;
    private const float QuickGrowthMinY = 0.274f;
    private const float QuickGrowthMaxY = 0.362f;
    private const float OverlayPanelMinY = 0.102f;
    private const float OverlayPanelMaxY = 0.364f;
    private const float HudTopMargin = 20f;
    private const float HudSideMargin = 28f;
    private const float HudHeight = 126f;
    private const float DockHeight = 112f;
    private const float DockBottomMargin = 26f;
    private const float QuickGrowthHeight = 154f;
    private const float QuickGrowthGap = 14f;
    private const float BottomSideMargin = 28f;
    private const string GrowthPanelId = AbilityPageAddressKey;
    private const string ShopPanelId = ShopPageAddressKey;
    private static readonly Rect MushroomCameraRect = new(0f, BottomUiHeightRatio, 1f, 1f);
    private static readonly Vector2 MushroomCameraPivot = new(0.5f, 0.58f);

    private readonly struct PageSpec
    {
        public PageSpec(string addressKey, string label)
        {
            AddressKey = addressKey;
            Label = label;
        }

        public string AddressKey { get; }
        public string Label { get; }
    }

    private readonly struct UpgradeSpec
    {
        public UpgradeSpec(string id, string label, UnitStatType statType, float statGain, long baseCost, long costStep, string gainText)
        {
            Id = id;
            Label = label;
            StatType = statType;
            StatGain = statGain;
            BaseCost = baseCost;
            CostStep = costStep;
            GainText = gainText;
        }

        public string Id { get; }
        public string Label { get; }
        public UnitStatType StatType { get; }
        public float StatGain { get; }
        public long BaseCost { get; }
        public long CostStep { get; }
        public string GainText { get; }
    }

    private static readonly PageSpec[] PageSpecs =
    {
        new(AbilityPageAddressKey, "성장"),
        new(ShopPageAddressKey, "상점"),
    };

    private static readonly UpgradeSpec[] UpgradeSpecs =
    {
        new("Attack", "공격 강화", UnitStatType.Attack, 5f, 40, 25, "공격 +5"),
        new("Hp", "체력 강화", UnitStatType.Hp, 45f, 35, 20, "체력 +45"),
        new("Skill", "스킬 강화", UnitStatType.GameplaySkillScalePercent, 8f, 60, 35, "스킬 피해 +8%"),
    };

    private readonly Dictionary<string, Button> _dockButtons = new();
    private readonly Dictionary<string, int> _upgradeLevels = new();
    private readonly Dictionary<string, List<Button>> _upgradeButtons = new();

    private RectTransform _hudRoot;
    private TextMeshProUGUI _hudTitle;
    private TextMeshProUGUI _hudWave;
    private TextMeshProUGUI _hudLevel;
    private TextMeshProUGUI _hudAttack;
    private TextMeshProUGUI _hudGold;
    private Image _hudHpFill;
    private TextMeshProUGUI _hudHpText;
    private Image _hudExpFill;
    private TextMeshProUGUI _hudExpText;
    private GameObject _legacyBattleUiRoot;
    private RectTransform _bottomUiRoot;
    private RectTransform _quickGrowthRoot;
    private RectTransform _dockRoot;
    private RectTransform _overlayRoot;
    private RectTransform _overlayPageRoot;
    private RectTransform _growthPanelRoot;
    private RectTransform _shopPanelRoot;
    private TextMeshProUGUI _overlayTitle;
    private TextMeshProUGUI _feedbackText;
    private Button _battleButton;
    private Button _overlayCloseButton;
    private GameObject _hamsterGrowthDockPreview;
    private bool _hasLoggedHamsterGrowthDockPreviewMissing;
    private bool _isOverlayOpen;
    private bool _isCameraLayoutQueued;
    private string _currentPanelId;

    public override IEnumerator Initialize(Commons.Resources.ResourceMap resMap)
    {
        yield return base.Initialize(resMap);
        HideLegacyBattleUi();
        EnsureMushroomHud();
        EnsureOverlayUI();
        EnsureMushroomControls();
        EnsureHamsterGrowthDockPreview();
        ApplyMushroomSceneLayout(queueCameraAfterFrame: true);
        RefreshMushroomHud();
        EnsureLocalMushroomRuntimeReady();
    }

    public override IEnumerator Release()
    {
        CleanupHamsterGrowthDockPreview();
        CleanupMushroomHud();
        CleanupOverlay();
        yield return base.Release();
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);
        HideLegacyBattleUi();
        EnsureHamsterGrowthDockPreview();
        ApplyMushroomSceneLayout(e.type == GameEventType.MAP_LOADED);
        UpdateMushroomControlLabels();
        RefreshMushroomHud();

        if (e.type == GameEventType.MAP_LOADED)
            EnsureLocalMushroomRuntimeReady();
    }

    private void ApplyMushroomSceneLayout(bool queueCameraAfterFrame = false)
    {
        ApplyMushroomCameraLayout();
        ApplyMushroomUILayout();

        if (queueCameraAfterFrame)
            ApplyMushroomCameraLayoutDeferred().Forget();
    }

    private async UniTaskVoid ApplyMushroomCameraLayoutDeferred()
    {
        if (_isCameraLayoutQueued)
            return;

        _isCameraLayoutQueued = true;
        await UniTask.Yield(PlayerLoopTiming.LastPostLateUpdate);
        _isCameraLayoutQueued = false;
        ApplyMushroomCameraLayout();
    }

    private static void ApplyMushroomCameraLayout()
    {
        var gameScene = GameScene.Get();
        var followCamera = gameScene != null ? gameScene.followTargetCamera : null;
        if (followCamera == null)
            return;

        followCamera.viewRect = MushroomCameraRect;
        followCamera.FOV = MushroomCameraFov;
        followCamera.targetTransformPivot = MushroomCameraPivot;
    }

    private void ApplyMushroomUILayout()
    {
        if (transform is not RectTransform)
            return;

        StretchToParent(_hudRoot);
        StretchToParent(_overlayRoot);

        var topStatus = FindChildComponent<RectTransform>(_hudRoot, "TopStatus");
        SetTopBand(topStatus, HudSideMargin, HudTopMargin, HudHeight);
        if (topStatus != null)
        {
            var layout = topStatus.GetComponent<HorizontalLayoutGroup>();
            if (layout != null)
            {
                layout.spacing = 10f;
                layout.padding = new RectOffset(12, 12, 12, 12);
            }

            SetPreferredWidth(FindChildComponent<RectTransform>(topStatus, "IdentityPanel"), 300f);
            SetPreferredWidth(FindChildComponent<RectTransform>(topStatus, "StatsPanel"), 220f);
        }

        SetScreenRatioBand(_bottomUiRoot, 0f, 0f, BottomUiHeightRatio);
        SetScreenRatioBand(_dockRoot, BottomSideMargin, DockMinY, DockMaxY);
        SetScreenRatioBand(_quickGrowthRoot, BottomSideMargin, QuickGrowthMinY, QuickGrowthMaxY);

        var safeArea = FindChildComponent<RectTransform>(_overlayRoot, "SafeArea");
        StretchToParent(safeArea);
        var overlayHeader = FindChildComponent<RectTransform>(_overlayRoot, "Header");
        if (overlayHeader != null)
            overlayHeader.gameObject.SetActive(false);
        StretchToParent(_overlayPageRoot);

        SetOverlaySheet(_growthPanelRoot);
        SetOverlaySheet(_shopPanelRoot);
        OrderMushroomUiLayers();
    }

    private void HideLegacyBattleUi()
    {
        for (var i = 0; i < transform.childCount; i++)
        {
            var child = transform.GetChild(i);
            if (child == _hudRoot || child == _overlayRoot || child == _dockRoot)
                continue;
            if (child.name == "CanvasHitEffect")
                continue;
            if (child.GetComponentInChildren<MergeBoard>(true) != null)
                child.gameObject.SetActive(false);
        }

        if (_legacyBattleUiRoot == null && mergeBoard != null)
        {
            var root = mergeBoard.transform;
            while (root != null && root.parent != transform)
                root = root.parent;

            if (root != null && root != transform)
                _legacyBattleUiRoot = root.gameObject;
        }

        if (_legacyBattleUiRoot != null)
            _legacyBattleUiRoot.SetActive(false);

        if (mergeBoard == null)
            return;

        mergeBoard.gameObject.SetActive(false);
    }

    private void EnsureLocalMushroomRuntimeReady()
    {
        var boardManager = GameBoardManager.Get();
        if (boardManager?.gameBoard?.isLocalBoard == true)
            boardManager.ClearBoardPauseRequests();

        GameManager.Get().HideLoading().Forget();
        SceneLoader.Get().SetActive(false, true);
    }

    private void EnsureHamsterGrowthDockPreview()
    {
        if (_hamsterGrowthDockPreview != null)
        {
            ConfigureHamsterGrowthDockPreview();
            return;
        }

        var existing = transform.Find(HamsterGrowthDockPreviewName);
        if (existing != null)
        {
            _hamsterGrowthDockPreview = existing.gameObject;
            ConfigureHamsterGrowthDockPreview();
            return;
        }

        var prefab = Resources.Load<GameObject>(HamsterGrowthDockPreviewResource);
        if (prefab == null)
        {
            if (!_hasLoggedHamsterGrowthDockPreviewMissing)
            {
                Debug.LogWarning($"Missing UI harness preview prefab at Resources/{HamsterGrowthDockPreviewResource}.");
                _hasLoggedHamsterGrowthDockPreviewMissing = true;
            }

            return;
        }

        _hasLoggedHamsterGrowthDockPreviewMissing = false;
        _hamsterGrowthDockPreview = Instantiate(prefab, transform, false);
        _hamsterGrowthDockPreview.name = HamsterGrowthDockPreviewName;
        ConfigureHamsterGrowthDockPreview();
    }

    private void ConfigureHamsterGrowthDockPreview()
    {
        if (_hamsterGrowthDockPreview == null)
            return;

        if (_hamsterGrowthDockPreview.transform is RectTransform rectTransform)
            StretchToParent(rectTransform);

        var canvasGroup = _hamsterGrowthDockPreview.GetComponent<CanvasGroup>();
        if (canvasGroup != null)
        {
            canvasGroup.alpha = 1f;
            canvasGroup.blocksRaycasts = false;
            canvasGroup.interactable = false;
        }

        if (!_isOverlayOpen)
            _hamsterGrowthDockPreview.transform.SetAsLastSibling();
    }

    private void CleanupHamsterGrowthDockPreview()
    {
        if (_hamsterGrowthDockPreview != null)
            Object.Destroy(_hamsterGrowthDockPreview);

        _hamsterGrowthDockPreview = null;
    }

    private void EnsureMushroomHud()
    {
        if (_hudRoot != null)
            return;

        if (TryBindMushroomHud())
            return;

        _hudRoot = CreateRect("MushroomHudRoot", (RectTransform)transform, stretch: true);
        _hudRoot.SetAsLastSibling();

        var topBar = CreateRect("TopStatus", _hudRoot, stretchHorizontally: true);
        topBar.anchorMin = new Vector2(0f, 1f);
        topBar.anchorMax = new Vector2(1f, 1f);
        topBar.pivot = new Vector2(0.5f, 1f);
        topBar.offsetMin = new Vector2(44f, -170f);
        topBar.offsetMax = new Vector2(-44f, -28f);

        var topLayout = topBar.gameObject.AddComponent<HorizontalLayoutGroup>();
        topLayout.spacing = 16f;
        topLayout.padding = new RectOffset(0, 0, 0, 0);
        topLayout.childControlWidth = true;
        topLayout.childControlHeight = true;
        topLayout.childForceExpandWidth = false;
        topLayout.childForceExpandHeight = true;

        var identityPanel = CreateHudPanel("IdentityPanel", topBar);
        var identityLayout = identityPanel.gameObject.AddComponent<VerticalLayoutGroup>();
        identityLayout.spacing = 8f;
        identityLayout.padding = new RectOffset(24, 24, 18, 18);
        identityLayout.childControlWidth = true;
        identityLayout.childControlHeight = true;
        identityLayout.childForceExpandWidth = true;
        identityLayout.childForceExpandHeight = false;

        var identityElement = identityPanel.gameObject.AddComponent<LayoutElement>();
        identityElement.preferredWidth = 420f;
        identityElement.flexibleWidth = 0f;

        _hudTitle = CreateText("Title", identityPanel, "Mushroomer", 34, FontStyles.Bold);
        _hudTitle.alignment = TextAlignmentOptions.Left;
        _hudTitle.rectTransform.sizeDelta = new Vector2(0f, 46f);

        _hudWave = CreateText("Wave", identityPanel, "전투 준비", 24, FontStyles.Normal);
        _hudWave.alignment = TextAlignmentOptions.Left;
        _hudWave.rectTransform.sizeDelta = new Vector2(0f, 34f);

        var barPanel = CreateHudPanel("GrowthPanel", topBar);
        var barLayout = barPanel.gameObject.AddComponent<VerticalLayoutGroup>();
        barLayout.spacing = 10f;
        barLayout.padding = new RectOffset(22, 22, 18, 18);
        barLayout.childControlWidth = true;
        barLayout.childControlHeight = true;
        barLayout.childForceExpandWidth = true;
        barLayout.childForceExpandHeight = true;

        var barElement = barPanel.gameObject.AddComponent<LayoutElement>();
        barElement.flexibleWidth = 1f;

        (_hudHpFill, _hudHpText) = CreateHudBar("HpBar", barPanel, new Color(0.87f, 0.24f, 0.20f, 1f));
        (_hudExpFill, _hudExpText) = CreateHudBar("ExpBar", barPanel, new Color(0.24f, 0.63f, 0.92f, 1f));

        var statPanel = CreateHudPanel("StatPanel", topBar);
        var statLayout = statPanel.gameObject.AddComponent<VerticalLayoutGroup>();
        statLayout.spacing = 6f;
        statLayout.padding = new RectOffset(22, 22, 16, 16);
        statLayout.childControlWidth = true;
        statLayout.childControlHeight = true;
        statLayout.childForceExpandWidth = true;
        statLayout.childForceExpandHeight = false;

        var statElement = statPanel.gameObject.AddComponent<LayoutElement>();
        statElement.preferredWidth = 310f;
        statElement.flexibleWidth = 0f;

        _hudLevel = CreateText("Level", statPanel, "Lv.1", 25, FontStyles.Bold);
        _hudLevel.alignment = TextAlignmentOptions.Left;
        _hudLevel.rectTransform.sizeDelta = new Vector2(0f, 32f);

        _hudAttack = CreateText("Attack", statPanel, "공격 0", 22, FontStyles.Normal);
        _hudAttack.alignment = TextAlignmentOptions.Left;
        _hudAttack.rectTransform.sizeDelta = new Vector2(0f, 30f);

        _hudGold = CreateText("Gold", statPanel, "골드 0", 22, FontStyles.Normal);
        _hudGold.alignment = TextAlignmentOptions.Left;
        _hudGold.rectTransform.sizeDelta = new Vector2(0f, 30f);
    }

    private void EnsureOverlayUI()
    {
        if (_overlayRoot != null)
            return;

        if (TryBindOverlayUI())
            return;

        _overlayRoot = CreateRect("MushroomOverlayRoot", (RectTransform)transform, stretch: true);
        _overlayRoot.SetAsLastSibling();
        _overlayRoot.gameObject.SetActive(false);

        var dim = _overlayRoot.gameObject.AddComponent<Image>();
        dim.color = new Color(0.05f, 0.04f, 0.03f, 0f);
        dim.raycastTarget = false;

        var safeArea = CreateRect("SafeArea", _overlayRoot, stretch: true);

        var header = CreateRect("Header", safeArea, stretchHorizontally: true);
        header.anchorMin = new Vector2(0f, 1f);
        header.anchorMax = new Vector2(1f, 1f);
        header.pivot = new Vector2(0.5f, 1f);
        header.sizeDelta = new Vector2(0f, 88f);

        _overlayTitle = CreateText("Title", header, "성장", 40, FontStyles.Bold);
        _overlayTitle.alignment = TextAlignmentOptions.Left;
        _overlayTitle.rectTransform.offsetMin = new Vector2(0f, 0f);
        _overlayTitle.rectTransform.offsetMax = new Vector2(-180f, 0f);

        _overlayCloseButton = CreateDockButton("CloseButton", header, "전투");
        var closeRt = (RectTransform)_overlayCloseButton.transform;
        closeRt.anchorMin = new Vector2(1f, 0.5f);
        closeRt.anchorMax = new Vector2(1f, 0.5f);
        closeRt.pivot = new Vector2(1f, 0.5f);
        closeRt.anchoredPosition = Vector2.zero;
        closeRt.sizeDelta = new Vector2(150f, 72f);
        _overlayCloseButton.onClick.AddListener(CloseOverlay);

        _overlayPageRoot = CreateRect("PageRoot", safeArea, stretch: true);
        _overlayPageRoot.offsetMin = new Vector2(0f, 0f);
        _overlayPageRoot.offsetMax = new Vector2(0f, -120f);

        _dockRoot = CreateRect("MushroomDock", (RectTransform)transform, stretchHorizontally: true);
        _dockRoot.anchorMin = new Vector2(0f, 0f);
        _dockRoot.anchorMax = new Vector2(1f, 0f);
        _dockRoot.pivot = new Vector2(0.5f, 0f);
        _dockRoot.offsetMin = new Vector2(72f, DockBottomMargin);
        _dockRoot.offsetMax = new Vector2(-72f, DockBottomMargin + DockHeight);

        var dockBackground = _dockRoot.gameObject.AddComponent<Image>();
        dockBackground.color = new Color(0.11f, 0.09f, 0.07f, 0.88f);

        var layout = _dockRoot.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 18f;
        layout.padding = new RectOffset(24, 24, 18, 18);
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        _battleButton = CreateDockButton("BattleButton", _dockRoot, "전투");
        _battleButton.onClick.AddListener(CloseOverlay);
        var battleLayoutElement = _battleButton.gameObject.AddComponent<LayoutElement>();
        battleLayoutElement.minHeight = 78f;
        battleLayoutElement.flexibleWidth = 1f;

        for (var index = 0; index < PageSpecs.Length; index++)
        {
            var pageSpec = PageSpecs[index];
            var button = CreateDockButton($"{pageSpec.AddressKey}Button", _dockRoot, pageSpec.Label);
            button.onClick.AddListener(() => OpenMushroomPanel(pageSpec.AddressKey));

            var layoutElement = button.gameObject.AddComponent<LayoutElement>();
            layoutElement.minHeight = 78f;
            layoutElement.flexibleWidth = 1f;

            _dockButtons[pageSpec.AddressKey] = button;
        }
    }

    private void EnsureMushroomControls()
    {
        EnsureBottomFrameUI();
        EnsureQuickGrowthUI();
        EnsureFeedbackText();
        EnsureMushroomPanels();
        BindQuickGrowthButtons();
        UpdateMushroomControlLabels();
        RefreshDockState();
    }

    private void EnsureBottomFrameUI()
    {
        _bottomUiRoot ??= FindDirectChild<RectTransform>("MushroomBottomUiRoot");
        if (_bottomUiRoot != null)
        {
            _bottomUiRoot.SetAsLastSibling();
            return;
        }

        _bottomUiRoot = CreateRect("MushroomBottomUiRoot", (RectTransform)transform, stretchHorizontally: true);
        _bottomUiRoot.SetAsLastSibling();

        var background = _bottomUiRoot.gameObject.AddComponent<Image>();
        background.color = new Color(0.13f, 0.10f, 0.075f, 0.98f);
        background.raycastTarget = true;

        var topLine = CreateRect("TopLine", _bottomUiRoot, stretchHorizontally: true);
        topLine.anchorMin = new Vector2(0f, 1f);
        topLine.anchorMax = new Vector2(1f, 1f);
        topLine.pivot = new Vector2(0.5f, 1f);
        topLine.offsetMin = new Vector2(0f, -4f);
        topLine.offsetMax = Vector2.zero;

        var topLineImage = topLine.gameObject.AddComponent<Image>();
        topLineImage.color = new Color(0.72f, 0.60f, 0.36f, 1f);
        topLineImage.raycastTarget = false;
    }

    private void EnsureQuickGrowthUI()
    {
        _quickGrowthRoot ??= FindDirectChild<RectTransform>("MushroomQuickGrowthRoot");
        if (_quickGrowthRoot != null)
        {
            _quickGrowthRoot.SetAsLastSibling();
            return;
        }

        _quickGrowthRoot = CreateRect("MushroomQuickGrowthRoot", (RectTransform)transform, stretchHorizontally: true);
        _quickGrowthRoot.SetAsLastSibling();

        var background = _quickGrowthRoot.gameObject.AddComponent<Image>();
        background.color = new Color(0.08f, 0.07f, 0.06f, 0.88f);
        background.raycastTarget = true;

        var layout = _quickGrowthRoot.gameObject.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 14f;
        layout.padding = new RectOffset(18, 18, 14, 14);
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = true;

        CreateDockButton("QuickAttackButton", _quickGrowthRoot, string.Empty);
        CreateDockButton("QuickHpButton", _quickGrowthRoot, string.Empty);
        CreateDockButton("QuickSkillButton", _quickGrowthRoot, string.Empty);
    }

    private void EnsureFeedbackText()
    {
        if (_hudRoot == null)
            return;

        _feedbackText = FindChildComponent<TextMeshProUGUI>(_hudRoot, "MushroomFeedbackText");
        if (_feedbackText == null)
            _feedbackText = CreateText("MushroomFeedbackText", _hudRoot, string.Empty, 30f, FontStyles.Bold);

        _feedbackText.alignment = TextAlignmentOptions.Center;
        _feedbackText.color = new Color(1f, 0.87f, 0.42f, 1f);
        _feedbackText.rectTransform.anchorMin = new Vector2(0.5f, BottomUiHeightRatio);
        _feedbackText.rectTransform.anchorMax = new Vector2(0.5f, BottomUiHeightRatio);
        _feedbackText.rectTransform.pivot = new Vector2(0.5f, 0f);
        _feedbackText.rectTransform.anchoredPosition = new Vector2(0f, 16f);
        _feedbackText.rectTransform.sizeDelta = new Vector2(520f, 54f);
        _feedbackText.gameObject.SetActive(false);
    }

    private void EnsureMushroomPanels()
    {
        if (_overlayPageRoot == null)
            return;

        _growthPanelRoot = FindChildComponent<RectTransform>(_overlayPageRoot, "GrowthPanelRoot");
        _shopPanelRoot = FindChildComponent<RectTransform>(_overlayPageRoot, "ShopPanelRoot");

        if (_growthPanelRoot == null)
        {
            _growthPanelRoot = CreateSheetPanel("GrowthPanelRoot", "성장");
            foreach (var spec in UpgradeSpecs)
                CreateUpgradePanelButton(_growthPanelRoot, spec);
        }

        if (_shopPanelRoot == null)
        {
            _shopPanelRoot = CreateSheetPanel("ShopPanelRoot", "상점");
            CreateShopButton(_shopPanelRoot, "ShopSupplyButton", "포자 보급\n+120G", () => AddGoldReward(120, "포자 보급 +120G"));
            CreateShopButton(_shopPanelRoot, "ShopAdButton", "광고 보상\n+300G", () => AddGoldReward(300, "광고 보상 +300G"));
            CreateShopButton(_shopPanelRoot, "ShopPackageButton", "패키지\n준비중", () => ShowFeedback("패키지는 아직 준비중", false));
        }

        _growthPanelRoot.gameObject.SetActive(false);
        _shopPanelRoot.gameObject.SetActive(false);
    }

    private RectTransform CreateSheetPanel(string name, string title)
    {
        var panel = CreateRect(name, _overlayPageRoot, stretchHorizontally: true);
        SetOverlaySheet(panel);

        var background = panel.gameObject.AddComponent<Image>();
        background.color = new Color(0.10f, 0.085f, 0.065f, 0.96f);
        background.raycastTarget = true;

        var layout = panel.gameObject.AddComponent<VerticalLayoutGroup>();
        layout.spacing = 12f;
        layout.padding = new RectOffset(18, 18, 18, 18);
        layout.childControlWidth = true;
        layout.childControlHeight = true;
        layout.childForceExpandWidth = true;
        layout.childForceExpandHeight = false;

        var titleText = CreateText("PanelTitle", panel, title, 30f, FontStyles.Bold);
        titleText.alignment = TextAlignmentOptions.Left;
        var titleElement = titleText.gameObject.AddComponent<LayoutElement>();
        titleElement.minHeight = 42f;

        return panel;
    }

    private void CreateUpgradePanelButton(RectTransform parent, UpgradeSpec spec)
    {
        var button = CreateDockButton($"{spec.Id}UpgradeButton", parent, string.Empty);
        var layoutElement = button.gameObject.AddComponent<LayoutElement>();
        layoutElement.minHeight = 82f;
        layoutElement.flexibleWidth = 1f;
        button.onClick.AddListener(() => TryUpgrade(spec.Id));
        RegisterUpgradeButton(spec.Id, button);
    }

    private void CreateShopButton(RectTransform parent, string name, string label, UnityEngine.Events.UnityAction onClick)
    {
        var button = CreateDockButton(name, parent, label);
        var layoutElement = button.gameObject.AddComponent<LayoutElement>();
        layoutElement.minHeight = 82f;
        layoutElement.flexibleWidth = 1f;
        button.onClick.AddListener(onClick);
    }

    private void BindQuickGrowthButtons()
    {
        RegisterQuickButton("Attack", "QuickAttackButton");
        RegisterQuickButton("Hp", "QuickHpButton");
        RegisterQuickButton("Skill", "QuickSkillButton");
    }

    private void RegisterQuickButton(string upgradeId, string buttonName)
    {
        var button = FindChildComponent<Button>(_quickGrowthRoot, buttonName);
        if (button == null)
            return;

        button.onClick.RemoveAllListeners();
        button.onClick.AddListener(() => TryUpgrade(upgradeId));
        RegisterUpgradeButton(upgradeId, button);
    }

    private void RegisterUpgradeButton(string upgradeId, Button button)
    {
        if (!_upgradeButtons.TryGetValue(upgradeId, out var buttons))
        {
            buttons = new List<Button>();
            _upgradeButtons[upgradeId] = buttons;
        }

        if (!buttons.Contains(button))
            buttons.Add(button);
    }

    public bool TryOpenPredefinedPage(string pageId, string[] tokens)
    {
        var addressKey = ResolveAddressKey(pageId);
        if (string.IsNullOrEmpty(addressKey))
            return false;

        OpenMushroomPanel(addressKey);
        return true;
    }

    private void OpenMushroomPanel(string panelId)
    {
        if (_overlayRoot == null)
            return;

        if (_isOverlayOpen && _currentPanelId == panelId)
        {
            CloseOverlay();
            return;
        }

        _currentPanelId = panelId;
        _isOverlayOpen = true;

        if (_overlayTitle != null)
            _overlayTitle.text = GetPageLabel(panelId);

        if (_growthPanelRoot != null)
            _growthPanelRoot.gameObject.SetActive(panelId == GrowthPanelId);

        if (_shopPanelRoot != null)
            _shopPanelRoot.gameObject.SetActive(panelId == ShopPanelId);

        _overlayRoot.gameObject.SetActive(true);
        UpdateMushroomControlLabels();
        RefreshDockState();
        OrderMushroomUiLayers();
    }

    private void CloseOverlay()
    {
        _isOverlayOpen = false;
        _currentPanelId = null;
        if (_growthPanelRoot != null)
            _growthPanelRoot.gameObject.SetActive(false);
        if (_shopPanelRoot != null)
            _shopPanelRoot.gameObject.SetActive(false);

        if (_overlayRoot != null)
            _overlayRoot.gameObject.SetActive(false);

        GameBoardManager.Get()?.ResumeBoard(PauseRequestKey);
        RefreshDockState();
        OrderMushroomUiLayers();
    }

    private void RefreshDockState()
    {
        SetDockButtonState(_battleButton, !_isOverlayOpen);

        foreach (var (addressKey, button) in _dockButtons)
        {
            if (button == null)
                continue;

            var isActive = _isOverlayOpen && _currentPanelId == addressKey;
            SetDockButtonState(button, isActive);
        }
    }

    private void TryUpgrade(string upgradeId)
    {
        var spec = GetUpgradeSpec(upgradeId);
        if (spec == null)
            return;

        var cost = GetUpgradeCost(spec.Value);
        if (!TrySpendGold(cost))
        {
            ShowFeedback($"골드 부족: {cost}G", false);
            return;
        }

        _upgradeLevels[upgradeId] = GetUpgradeLevel(upgradeId) + 1;
        ApplyUpgradeStat(spec.Value);
        ShowFeedback($"{spec.Value.Label} +1  {spec.Value.GainText}", true);
        UpdateMushroomControlLabels();
        RefreshMushroomHud();
        RefreshMushroomHudAfterStatUpdate().Forget();
        GameManager.Get()?.PlayFX("click");
    }

    private void ApplyUpgradeStat(UpgradeSpec spec)
    {
        var boardPlayer = GetMyBoardPlayer();
        var myUnit = GetMyBoardUnit();
        if (boardPlayer == null || myUnit == null)
            return;

        EnsurePlayerStatBuffer(boardPlayer.ItemStat, myUnit);

        var statIndex = (int)spec.StatType;
        boardPlayer.ItemStat[statIndex] += spec.StatGain;

        myUnit.BaseStat.Clear();
        myUnit.BaseStat.AddRange(boardPlayer.ItemStat);
        myUnit.SetStatDirty();
    }

    private static void EnsurePlayerStatBuffer(IList<float> stats, Commons.Game.GameUnit sourceUnit)
    {
        if (stats.Count == (int)UnitStatType.Count)
            return;

        stats.Clear();
        if (sourceUnit != null)
        {
            for (var i = 0; i < sourceUnit.BaseStat.Count && stats.Count < (int)UnitStatType.Count; i++)
                stats.Add(sourceUnit.BaseStat[i]);
        }

        while (stats.Count < (int)UnitStatType.Count)
            stats.Add(0f);
    }

    private async UniTaskVoid RefreshMushroomHudAfterStatUpdate()
    {
        await UniTask.Yield(PlayerLoopTiming.LastPostLateUpdate);
        RefreshMushroomHud();
    }

    private void AddGoldReward(long amount, string message)
    {
        var boardPlayer = GetMyBoardPlayer();
        if (boardPlayer == null)
        {
            ShowFeedback("전투 입장 후 받을 수 있음", false);
            return;
        }

        boardPlayer.Gold += amount;
        boardPlayer.HandleGoldChange(amount);
        MyPlayer.HandleBoardPlayer(boardPlayer);
        ShowFeedback(message, true);
        UpdateMushroomControlLabels();
        RefreshMushroomHud();
        GameManager.Get()?.PlayFX("click");
    }

    private bool TrySpendGold(long cost)
    {
        var boardPlayer = GetMyBoardPlayer();
        if (boardPlayer == null || boardPlayer.Gold < cost)
            return false;

        boardPlayer.Gold -= cost;
        boardPlayer.HandleGoldChange(-cost);
        MyPlayer.HandleBoardPlayer(boardPlayer);
        return true;
    }

    private Commons.Types.Players.BoardPlayerMessage GetMyBoardPlayer()
    {
        var gameBoard = GameBoardManager.Get()?.gameBoard;
        var player = MyPlayer.Player;
        return player == null ? null : gameBoard?.GetPlayerById(player.Id);
    }

    private Commons.Game.GameUnit GetMyBoardUnit()
    {
        var gameBoard = GameBoardManager.Get()?.gameBoard;
        var player = MyPlayer.Player;
        return player == null ? null : gameBoard?.GetUnitByPlayerId(player.Id);
    }

    private void UpdateMushroomControlLabels()
    {
        foreach (var spec in UpgradeSpecs)
        {
            var level = GetUpgradeLevel(spec.Id);
            var cost = GetUpgradeCost(spec);
            var label = $"{spec.Label} Lv.{level}\n{spec.GainText} / {cost}G";
            var hasEnoughGold = GetCurrentGold() >= cost;

            if (!_upgradeButtons.TryGetValue(spec.Id, out var buttons))
                continue;

            foreach (var button in buttons)
            {
                if (button == null)
                    continue;

                var text = button.GetComponentInChildren<TextMeshProUGUI>();
                if (text != null)
                    text.text = label;

                var image = button.GetComponent<Image>();
                if (image != null)
                {
                    image.color = hasEnoughGold
                        ? new Color(0.24f, 0.20f, 0.16f, 0.96f)
                        : new Color(0.16f, 0.14f, 0.12f, 0.86f);
                }
            }
        }
    }

    private long GetCurrentGold()
    {
        return GetMyBoardPlayer()?.Gold ?? 0L;
    }

    private int GetUpgradeLevel(string upgradeId)
    {
        return _upgradeLevels.GetValueOrDefault(upgradeId);
    }

    private long GetUpgradeCost(UpgradeSpec spec)
    {
        return spec.BaseCost + spec.CostStep * GetUpgradeLevel(spec.Id);
    }

    private static UpgradeSpec? GetUpgradeSpec(string upgradeId)
    {
        foreach (var spec in UpgradeSpecs)
        {
            if (spec.Id == upgradeId)
                return spec;
        }

        return null;
    }

    private void ShowFeedback(string message, bool positive)
    {
        if (_feedbackText == null)
            return;

        _feedbackText.text = message;
        _feedbackText.color = positive
            ? new Color(1f, 0.86f, 0.36f, 1f)
            : new Color(1f, 0.35f, 0.30f, 1f);
        _feedbackText.gameObject.SetActive(true);
        HideFeedbackLater(message).Forget();
    }

    private async UniTaskVoid HideFeedbackLater(string message)
    {
        await UniTask.Delay(900, ignoreTimeScale: true);
        if (_feedbackText != null && _feedbackText.text == message)
            _feedbackText.gameObject.SetActive(false);
    }

    private void CleanupOverlay()
    {
        GameBoardManager.Get()?.ResumeBoard(PauseRequestKey);

        _dockButtons.Clear();
        _upgradeButtons.Clear();
        _currentPanelId = null;
        _isOverlayOpen = false;

        if (_overlayRoot != null)
            Object.Destroy(_overlayRoot.gameObject);

        if (_dockRoot != null)
            Object.Destroy(_dockRoot.gameObject);

        if (_bottomUiRoot != null)
            Object.Destroy(_bottomUiRoot.gameObject);

        _overlayRoot = null;
        _overlayPageRoot = null;
        _growthPanelRoot = null;
        _shopPanelRoot = null;
        _overlayTitle = null;
        _dockRoot = null;
        _battleButton = null;
        _overlayCloseButton = null;
        _bottomUiRoot = null;
        _quickGrowthRoot = null;
    }

    private void CleanupMushroomHud()
    {
        if (_hudRoot != null)
            Object.Destroy(_hudRoot.gameObject);

        _hudRoot = null;
        _hudTitle = null;
        _hudWave = null;
        _hudLevel = null;
        _hudAttack = null;
        _hudGold = null;
        _hudHpFill = null;
        _hudHpText = null;
        _hudExpFill = null;
        _hudExpText = null;
        _feedbackText = null;
    }

    private bool TryBindMushroomHud()
    {
        _hudRoot = FindDirectChild<RectTransform>("MushroomHudRoot");
        if (_hudRoot == null)
            return false;

        _hudRoot.SetAsLastSibling();
        _quickGrowthRoot = FindDirectChild<RectTransform>("MushroomQuickGrowthRoot");
        if (_quickGrowthRoot != null)
            _quickGrowthRoot.SetAsLastSibling();

        _hudTitle = FindChildComponent<TextMeshProUGUI>(_hudRoot, "HudTitle");
        _hudWave = FindChildComponent<TextMeshProUGUI>(_hudRoot, "HudWave");
        _hudLevel = FindChildComponent<TextMeshProUGUI>(_hudRoot, "HudLevel");
        _hudAttack = FindChildComponent<TextMeshProUGUI>(_hudRoot, "HudAttack");
        _hudGold = FindChildComponent<TextMeshProUGUI>(_hudRoot, "HudGold");
        _hudHpFill = FindChildComponent<Image>(_hudRoot, "HpFill");
        _hudHpText = FindChildComponent<TextMeshProUGUI>(_hudRoot, "HpText");
        _hudExpFill = FindChildComponent<Image>(_hudRoot, "ExpFill");
        _hudExpText = FindChildComponent<TextMeshProUGUI>(_hudRoot, "ExpText");
        return true;
    }

    private bool TryBindOverlayUI()
    {
        _overlayRoot = FindDirectChild<RectTransform>("MushroomOverlayRoot");
        _dockRoot = FindDirectChild<RectTransform>("MushroomDock");
        if (_overlayRoot == null || _dockRoot == null)
        {
            _overlayRoot = null;
            _dockRoot = null;
            return false;
        }

        _overlayRoot.SetAsLastSibling();
        _dockRoot.SetAsLastSibling();
        _overlayRoot.gameObject.SetActive(false);

        var overlayImage = _overlayRoot.GetComponent<Image>();
        if (overlayImage != null)
        {
            overlayImage.color = new Color(0.05f, 0.04f, 0.03f, 0f);
            overlayImage.raycastTarget = false;
        }

        _overlayPageRoot = FindChildComponent<RectTransform>(_overlayRoot, "PageRoot");
        _overlayTitle = FindChildComponent<TextMeshProUGUI>(_overlayRoot, "OverlayTitle");

        _overlayCloseButton = FindChildComponent<Button>(_overlayRoot, "OverlayCloseButton");
        if (_overlayCloseButton != null)
        {
            _overlayCloseButton.onClick.RemoveAllListeners();
            _overlayCloseButton.onClick.AddListener(CloseOverlay);
        }

        _battleButton = FindChildComponent<Button>(_dockRoot, "BattleButton");
        if (_battleButton != null)
        {
            _battleButton.onClick.RemoveAllListeners();
            _battleButton.onClick.AddListener(CloseOverlay);
        }

        _dockButtons.Clear();
        foreach (var pageSpec in PageSpecs)
        {
            var button = FindChildComponent<Button>(_dockRoot, $"{pageSpec.AddressKey}Button");
            if (button == null)
                continue;

            var addressKey = pageSpec.AddressKey;
            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(() => OpenMushroomPanel(addressKey));
            _dockButtons[addressKey] = button;
        }

        RefreshDockState();
        return _overlayPageRoot != null;
    }

    private void RefreshMushroomHud()
    {
        if (_hudRoot == null)
            return;

        var gameBoard = GameBoardManager.Get()?.gameBoard;
        var resMap = gameBoard?.ResMap;
        var player = MyPlayer.Player;
        var myUnit = player == null ? null : gameBoard?.GetUnitByPlayerId(player.Id);
        myUnit ??= MyPlayer.GameUnit;
        var myBoardPlayer = player == null ? null : gameBoard?.GetPlayerById(player.Id);

        if (_hudTitle != null)
            _hudTitle.text = !string.IsNullOrEmpty(resMap?.Name) ? resMap.Name : "Mushroomer";

        if (_hudWave != null)
        {
            var wave = gameBoard != null ? (int)gameBoard.Variables.Get(BoardVariableId.Map.wave) : 0;
            _hudWave.text = wave > 0 ? $"Wave {wave}" : "전투 준비";
        }

        if (myUnit != null)
        {
            if (_hudLevel != null)
                _hudLevel.text = $"Lv.{myUnit.Level}";

            if (_hudAttack != null)
                _hudAttack.text = $"공격 {(int)myUnit.Attack}";

            if (_hudHpFill != null)
                _hudHpFill.fillAmount = myUnit.MaxHp > 0 ? Mathf.Clamp01((float)myUnit.Hp / myUnit.MaxHp) : 0f;

            if (_hudHpText != null)
                _hudHpText.text = $"HP {myUnit.Hp}/{myUnit.MaxHp}";

            if (_hudExpFill != null && gameBoard?.ResMap != null)
            {
                var requiredExp = gameBoard.ResMap.RequiredExps.GetClamped(myUnit.Level - 1);
                _hudExpFill.fillAmount = requiredExp > 0 ? Mathf.Clamp01(myUnit.Exp / (float)requiredExp) : 0f;
            }

            if (_hudExpText != null)
                _hudExpText.text = $"EXP {myUnit.Exp}";
        }

        if (_hudGold != null)
            _hudGold.text = $"골드 {myBoardPlayer?.Gold ?? 0}";
    }

    private static string ResolveAddressKey(string pageId)
    {
        return pageId switch
        {
            nameof(Page_Ability) => AbilityPageAddressKey,
            nameof(Page_Shop) => ShopPageAddressKey,
            ShopPageAddressKey => ShopPageAddressKey,
            _ => null
        };
    }

    private static string GetPageLabel(string addressKey)
    {
        foreach (var pageSpec in PageSpecs)
        {
            if (pageSpec.AddressKey == addressKey)
                return pageSpec.Label;
        }

        return "메뉴";
    }

    private T FindDirectChild<T>(string childName) where T : Component
    {
        var child = transform.Find(childName);
        return child != null ? child.GetComponent<T>() : null;
    }

    private static T FindChildComponent<T>(Transform root, string childName) where T : Component
    {
        var child = FindChildRecursive(root, childName);
        return child != null ? child.GetComponent<T>() : null;
    }

    private static Transform FindChildRecursive(Transform root, string childName)
    {
        if (root == null)
            return null;

        foreach (Transform child in root)
        {
            if (child.name == childName)
                return child;

            var result = FindChildRecursive(child, childName);
            if (result != null)
                return result;
        }

        return null;
    }

    private static void SetDockButtonState(Button button, bool isActive)
    {
        if (button == null)
            return;

        var image = button.GetComponent<Image>();
        if (image != null)
        {
            image.color = isActive
                ? new Color(0.93f, 0.77f, 0.43f, 1f)
                : new Color(0.24f, 0.20f, 0.16f, 0.96f);
        }

        var text = button.GetComponentInChildren<TextMeshProUGUI>();
        if (text != null)
            text.color = isActive ? new Color(0.15f, 0.10f, 0.05f, 1f) : Color.white;
    }

    private static void StretchToParent(RectTransform rt)
    {
        if (rt == null)
            return;

        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.pivot = new Vector2(0.5f, 0.5f);
        rt.offsetMin = Vector2.zero;
        rt.offsetMax = Vector2.zero;
        rt.localScale = Vector3.one;
    }

    private static void SetTopBand(RectTransform rt, float sideMargin, float topMargin, float height)
    {
        if (rt == null)
            return;

        rt.anchorMin = new Vector2(0f, 1f);
        rt.anchorMax = new Vector2(1f, 1f);
        rt.pivot = new Vector2(0.5f, 1f);
        rt.offsetMin = new Vector2(sideMargin, -(topMargin + height));
        rt.offsetMax = new Vector2(-sideMargin, -topMargin);
        rt.localScale = Vector3.one;
    }

    private static void SetBottomBand(RectTransform rt, float sideMargin, float bottomMargin, float height)
    {
        if (rt == null)
            return;

        rt.anchorMin = new Vector2(0f, 0f);
        rt.anchorMax = new Vector2(1f, 0f);
        rt.pivot = new Vector2(0.5f, 0f);
        rt.offsetMin = new Vector2(sideMargin, bottomMargin);
        rt.offsetMax = new Vector2(-sideMargin, bottomMargin + height);
        rt.localScale = Vector3.one;
    }

    private static void SetScreenRatioBand(RectTransform rt, float sideMargin, float minY, float maxY)
    {
        if (rt == null)
            return;

        rt.anchorMin = new Vector2(0f, minY);
        rt.anchorMax = new Vector2(1f, maxY);
        rt.pivot = new Vector2(0.5f, 0.5f);
        rt.offsetMin = new Vector2(sideMargin, 0f);
        rt.offsetMax = new Vector2(-sideMargin, 0f);
        rt.localScale = Vector3.one;
    }

    private static void SetOverlaySheet(RectTransform rt)
    {
        if (rt == null)
            return;

        rt.anchorMin = new Vector2(0f, OverlayPanelMinY);
        rt.anchorMax = new Vector2(1f, OverlayPanelMaxY);
        rt.pivot = new Vector2(0.5f, 0.5f);
        rt.offsetMin = new Vector2(BottomSideMargin, 0f);
        rt.offsetMax = new Vector2(-BottomSideMargin, 0f);
        rt.localScale = Vector3.one;
    }

    private void OrderMushroomUiLayers()
    {
        if (_bottomUiRoot != null)
            _bottomUiRoot.SetAsLastSibling();
        if (_quickGrowthRoot != null)
            _quickGrowthRoot.SetAsLastSibling();
        if (_dockRoot != null)
            _dockRoot.SetAsLastSibling();
        if (_hudRoot != null)
            _hudRoot.SetAsLastSibling();
        if (_overlayRoot != null && _overlayRoot.gameObject.activeSelf)
            _overlayRoot.SetAsLastSibling();
        if (_hamsterGrowthDockPreview != null && !_isOverlayOpen)
            _hamsterGrowthDockPreview.transform.SetAsLastSibling();
    }

    private static void SetPreferredWidth(RectTransform rt, float preferredWidth)
    {
        if (rt == null)
            return;

        var layoutElement = rt.GetComponent<LayoutElement>();
        if (layoutElement == null)
            return;

        layoutElement.preferredWidth = preferredWidth;
    }

    private static RectTransform CreateHudPanel(string name, RectTransform parent)
    {
        var panel = CreateRect(name, parent);
        var image = panel.gameObject.AddComponent<Image>();
        image.color = new Color(0.10f, 0.10f, 0.08f, 0.78f);
        image.raycastTarget = false;
        return panel;
    }

    private static (Image fill, TextMeshProUGUI label) CreateHudBar(string name, RectTransform parent, Color fillColor)
    {
        var bar = CreateRect(name, parent, stretchHorizontally: true);
        bar.sizeDelta = new Vector2(0f, 38f);

        var layoutElement = bar.gameObject.AddComponent<LayoutElement>();
        layoutElement.minHeight = 38f;
        layoutElement.flexibleHeight = 1f;

        var background = bar.gameObject.AddComponent<Image>();
        background.color = new Color(0.02f, 0.02f, 0.02f, 0.62f);
        background.raycastTarget = false;

        var fillRoot = CreateRect("Fill", bar, stretch: true);
        fillRoot.offsetMin = new Vector2(3f, 3f);
        fillRoot.offsetMax = new Vector2(-3f, -3f);

        var fill = fillRoot.gameObject.AddComponent<Image>();
        fill.color = fillColor;
        fill.type = Image.Type.Filled;
        fill.fillMethod = Image.FillMethod.Horizontal;
        fill.fillOrigin = 0;
        fill.fillAmount = 0f;
        fill.raycastTarget = false;

        var label = CreateText("Label", bar, string.Empty, 19, FontStyles.Bold);
        label.alignment = TextAlignmentOptions.Center;
        label.rectTransform.offsetMin = Vector2.zero;
        label.rectTransform.offsetMax = Vector2.zero;

        return (fill, label);
    }

    private static RectTransform CreateRect(string name, RectTransform parent, bool stretch = false, bool stretchHorizontally = false)
    {
        var go = new GameObject(name, typeof(RectTransform));
        var rt = go.GetComponent<RectTransform>();
        rt.SetParent(parent, false);
        rt.localScale = Vector3.one;

        if (stretch)
        {
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.offsetMin = Vector2.zero;
            rt.offsetMax = Vector2.zero;
        }
        else if (stretchHorizontally)
        {
            rt.anchorMin = new Vector2(0f, 0.5f);
            rt.anchorMax = new Vector2(1f, 0.5f);
            rt.offsetMin = Vector2.zero;
            rt.offsetMax = Vector2.zero;
        }

        return rt;
    }

    private static Button CreateDockButton(string name, RectTransform parent, string label)
    {
        var buttonRoot = CreateRect(name, parent);
        var image = buttonRoot.gameObject.AddComponent<Image>();
        image.color = new Color(0.24f, 0.20f, 0.16f, 0.96f);

        var button = buttonRoot.gameObject.AddComponent<Button>();
        button.targetGraphic = image;
        button.transition = Selectable.Transition.None;

        var text = CreateText("Label", buttonRoot, label, 28, FontStyles.Bold);
        text.alignment = TextAlignmentOptions.Center;
        text.rectTransform.offsetMin = Vector2.zero;
        text.rectTransform.offsetMax = Vector2.zero;

        return button;
    }

    private static TextMeshProUGUI CreateText(string name, RectTransform parent, string text, float fontSize, FontStyles fontStyle)
    {
        var go = new GameObject(name, typeof(RectTransform));
        var rt = go.GetComponent<RectTransform>();
        rt.SetParent(parent, false);
        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.offsetMin = Vector2.zero;
        rt.offsetMax = Vector2.zero;

        var label = go.AddComponent<TextMeshProUGUI>();
        label.text = text;
        label.fontSize = fontSize;
        label.fontStyle = fontStyle;
        label.color = Color.white;
        label.textWrappingMode = TextWrappingModes.NoWrap;
        label.font = TMP_Settings.defaultFontAsset;
        label.raycastTarget = false;
        return label;
    }
}
