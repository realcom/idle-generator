// Copyright (C) 2017-2019 gamevanilla. All rights reserved.
// This code can only be used under the standard Unity Asset Store End User License Agreement,
// a copy of which is available at http://unity3d.com/company/legal/as_terms.

using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using DG.Tweening;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine.Serialization;
using UnityEngine.UI;

//TODO: Legacy
public enum ButtonClickAnimationPivot
{
    NONE,
    CENTER,
    VERTICAL,
    HORIZONTAL,
    CUSTOM,
}

[Flags]
public enum ButtonInternalStateFlag
{
    NONE = 0,

    IS_DRAGGING = 1 << 1,
    IS_PLAYING_VISIBLE_EFFECT = 1 << 2,

    WAS_CLICK_INVOKED = 1 << 3,
    WAS_POINTER_EXIT = 1 << 4,
    WAS_HOLD_INVOKED = 1 << 5,
}

public enum ButtonClickType
{
    NORMAL,
    AUTO_CLICK,
}

public class ButtonInteractor_Old
{
    private bool interactable = true;
    private string notInteractableMessageKey = null;
    private Action notInteractableAction = null;

    private ZButton tempButton;
    private TextMeshProUGUI txtReference;
	
    public ButtonInteractor_Old Get(ZButton button, TextMeshProUGUI txtRef = null)
    {
        interactable = true;
        tempButton = button;
        txtReference = txtRef;
        return this;
    }

    public void Apply()
    {
        if (txtReference)
        {
            txtReference.text = !string.IsNullOrEmpty(notInteractableMessageKey) ? notInteractableMessageKey.L() : "";
            txtReference = null;
        }
        
        tempButton.interactable = interactable;
        tempButton = null;
    }

    public void HandleNotInteractable()
    {
        if (!string.IsNullOrEmpty(notInteractableMessageKey))
            notInteractableMessageKey.ToToast();

        notInteractableAction?.Invoke();
    }
	
    public ButtonInteractor_Old Update(bool condition, string messageKey = null)
    {
        interactable &= condition;
        if (!condition)
            notInteractableMessageKey = messageKey;
        return this;
    }

    public ButtonInteractor_Old Update(bool condition, Action action)
    {
        interactable &= condition;
        if (!condition && action != null)
            notInteractableAction = action;
        return this;
    }
	
}

/// <summary>
/// All the buttons in the game play an animation when they are pressed. This class, modeled after Unity's Button,
/// enables that behavior.
/// </summary>
public class ZButton : ZUIBehaviour, IPointerDownHandler, IPointerUpHandler,
    IBeginDragHandler, IDragHandler, IEndDragHandler
{

    [SerializeField] private RectTransform _rectTransform;
    public RectTransform rectTransform => _rectTransform;
    public RectTransform[] includeRectTransforms = Array.Empty<RectTransform>();

    [SerializeField] private bool _enableEventLog = false;

    [FormerlySerializedAs("m_interactable")] [SerializeField]
    private bool m_Interactable = true;

    public bool interactable
    {
        set
        {
            if (m_Interactable != value)
            {
                m_Interactable = value;
                Refresh();
            }
        }
    }
    
    public bool IsInteractable() => m_Interactable && m_CanInteractionByCanvasGroup;

    private bool m_Locked = false;

    public bool locked
    {
        get => m_Locked;
        set
        {
            m_Locked = value;
            Refresh();
        }
    }

    public bool enableButtonAnimation = true;
    public ButtonClickType buttonClickType = ButtonClickType.NORMAL;

    [ShowIf("buttonClickType", ButtonClickType.NORMAL)]
    public float holdDelay = -1f;

    [ShowIf("buttonClickType", ButtonClickType.AUTO_CLICK)]
    public float autoClickAccelMinDelay = -1f;

    private bool enableAutoClickAccel => autoClickAccelMinDelay > 0f;

    public float clickDelay = 0.1f;
    private double _nextClickBlockedUntilAt = 0f;

    public int sendToParentDepth = -1;

    [Serializable]
    public class ImageStateSet
    {
        public Image image;

        public Sprite disabledSprite;
        public Sprite lockedSprite;
    }

    public ImageStateSet[] imageSet = new ImageStateSet[0];

    public GameObject enabledObject;
    public GameObject disabledObject;
    public GameObject lockedObject;

    public GameObject[] badges;
    private double _pointerDownAt;
    private string _customClickSoundString;

    private Vector3 _initialScale = Vector3.one;

    [SerializeField] private UnityEvent m_onButtonDown = new();
    [SerializeField] private UnityEvent m_onClick = new();
    [SerializeField] private UnityEvent m_onClickDisabled = new();
    [SerializeField] private UnityEvent m_onButtonHold = new();
    [SerializeField] private UnityEvent<bool> m_onButtonReleased = new();

    public UnityEvent onClick => m_onClick;
    public UnityEvent onClickDisabled => m_onClickDisabled;
    public UnityEvent onButtonDown => m_onButtonDown;
    public UnityEvent onButtonHold => m_onButtonHold;
    public UnityEvent<bool> onButtonReleased => m_onButtonReleased;

    public static UnityEvent<ZButton> globalOnButtonClick = new();

    private ButtonInternalStateFlag _buttonInternalStateFlag = ButtonInternalStateFlag.NONE;

    protected override void OnTransformParentChanged()
    {
        base.OnTransformParentChanged();

        OnCanvasGroupChanged();
    }

    private bool m_CanInteractionByCanvasGroup = true;
    protected override void OnCanvasGroupChanged()
    {
        base.OnCanvasGroupChanged();
        
        var canInteractionByCanvasGroup = CanInteractionByCanvasGroup();

        if (m_CanInteractionByCanvasGroup != canInteractionByCanvasGroup)
        {
            m_CanInteractionByCanvasGroup = canInteractionByCanvasGroup;
            Refresh();
        }
    }

    private readonly List<CanvasGroup> m_canvasGroups = new();
    private bool CanInteractionByCanvasGroup()
    {
        var t = transform;
        while (t != null)
        {
            t.GetComponents(m_canvasGroups);
            for (var i = 0; i < m_canvasGroups.Count; i++)
            {
                if (m_canvasGroups[i].enabled && !m_canvasGroups[i].interactable)
                    return false;

                if (m_canvasGroups[i].ignoreParentGroups)
                    return true;
            }

            t = t.parent;
        }

        return true;
    }

    protected override void Awake()
    {
        base.Awake();

        if (_rectTransform == null)
            _rectTransform = GetComponent<RectTransform>();

        _corners = new Vector3[1 + includeRectTransforms.Length][];
        for (var i = 0; i < _corners.GetLength(0); i++)
        {
            _corners[i] = new Vector3[4];
        }

        _initialScale = transform.localScale;
    }

    protected override void OnValidate()
    {
        base.OnValidate();

        _initialScale = transform.localScale;
    }

    protected override void OnEnable()
    {
        base.OnEnable();

        transform.localScale = _initialScale;
        
        m_CanInteractionByCanvasGroup = CanInteractionByCanvasGroup();
        Refresh();
    }

    protected override void OnDisable()
    {
        _tween?.Kill();
        _tween = null;
        _visibleEffect?.Kill();
        _visibleEffect = null;
        transform.localScale = _initialScale;

        base.OnDisable();
    }

    /// <summary>
    /// Do action for all parents
    /// </summary>
    private void DoForParents<T>(Action<T> action) where T : IEventSystemHandler
    {
        var parent = transform.parent;

        if (sendToParentDepth == 0)
            return;

        var cnt = 0;
        while (parent != null)
        {
            var isAction = false;

            foreach (var component in parent.GetComponents<T>())
            {
                action(component);
                isAction = true;
            }

            if (sendToParentDepth > -1 && cnt >= sendToParentDepth)
                return;

            parent = parent.parent;
            cnt++;
        }
    }

    private void Refresh()
    {
        var isInteractable = IsInteractable();
        
        if (lockedObject)
            lockedObject.SetActive(m_Locked);
        if (enabledObject)
            enabledObject.SetActive(!m_Locked && isInteractable);
        if (disabledObject)
            disabledObject.SetActive(!m_Locked && !isInteractable);

        foreach (var set in imageSet)
        {
            if (m_Locked)
            {
                if (set.lockedSprite)
                {
                    set.image.overrideSprite = set.lockedSprite;
                    continue;
                }
            }

            if (!isInteractable)
            {
                if (set.disabledSprite)
                {
                    set.image.overrideSprite = set.disabledSprite;
                    continue;
                }
            }

            set.image.overrideSprite = null;
        }
        
    }
    
    public virtual void OnPointerClick()
    {
        if (!IsActive())
            return;

        if (_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_POINTER_EXIT))
            return;

        if (_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_HOLD_INVOKED))
            return;

        if (!IsInteractable())
        {
            if (!_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_CLICK_INVOKED))
            {
                _buttonInternalStateFlag.AddFlag(ButtonInternalStateFlag.WAS_CLICK_INVOKED);

                if (_enableEventLog)
                    Debug.Log($"{name} is Invoked OnClickDisabled");
                m_onClickDisabled.Invoke();
                _interactor.HandleNotInteractable();
            }

            return;
        }

        _buttonInternalStateFlag.AddFlag(ButtonInternalStateFlag.WAS_CLICK_INVOKED);

        
        if (_enableEventLog)
            Debug.Log($"{name} is Invoked OnClick");

        // var isTutorialEnded = Tutorial.Get()?.IsEnd() == true;
        // var isLobby = GameBoardManager.Get()?.gameBoard?.ResMap?.Type == ResourceMap.Types.Type.Lobby;
        // if (!isLobby || isTutorialEnded)
        // {
            m_onClick.Invoke();
            globalOnButtonClick?.Invoke(this);   
        // }

        var currentTime = Utility.GetTime();
        if (_clickSoundBlockedUntilAt < currentTime)
        {
            if (string.IsNullOrEmpty(_customClickSoundString))
                GameManager.Get().PlayClick();
            else
                GameManager.Get().PlayFX(_customClickSoundString);

            var soundDelay = buttonClickType is ButtonClickType.AUTO_CLICK && enableAutoClickAccel ? Math.Max(autoClickAccelMinDelay, 0.1f) : Math.Max(clickDelay, 0.1f);
            _clickSoundBlockedUntilAt = currentTime + soundDelay;
        }
    }

    private Tween _tween;
    private Vector3[][] _corners = null;

    public virtual void OnPointerDown(PointerEventData eventData)
    {
        //reset flags
        _buttonInternalStateFlag &= ButtonInternalStateFlag.IS_PLAYING_VISIBLE_EFFECT;

        if (!IsActive())
            return;

        if (enableButtonAnimation)
        {
            //RefreshPivot();
            _tween = transform.DOScale(_initialScale * 0.9f, 0.1f).OnComplete(() => _tween = null);
        }

        _rectTransform.GetWorldCornersEx(_corners[0]);
        for (var i = 1; i < _corners.GetLength(0); i++)
        {
            includeRectTransforms[i - 1].GetWorldCornersEx(_corners[i]);
        }
        
        _pointerDownAt = Utility.GetTime();

        if (IsInteractable())
        {
            if (_enableEventLog)
                Debug.Log($"{name} is Invoked OnButtonDown");
            m_onButtonDown.Invoke();
        }

        DoForParents<IInitializePotentialDragHandler>(i => i.OnInitializePotentialDrag(eventData));
    }

    public virtual void OnPointerUp(PointerEventData eventData)
    {
        if (!IsActive())
            return;

        if (_pointerDownAt == 0)
            return;

        if (enableButtonAnimation)
        {
            //연출 강제
            transform.localScale = _initialScale * 0.9f;
            _tween = transform.DOScale(_initialScale, 0.1f).OnComplete(() => _tween = null);
        }

        if (!_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_CLICK_INVOKED))
        {
            var currentTime = Utility.GetTime();
            if (_nextClickBlockedUntilAt < currentTime)
            {
                _nextClickBlockedUntilAt = currentTime + clickDelay;
                OnPointerClick();
            }
        }
        
        if (IsInteractable())
        {
            if (_enableEventLog)
                Debug.Log($"{name} is Invoked OnButtonReleased");
            m_onButtonReleased.Invoke(!_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_POINTER_EXIT));
        }

        _pointerDownAt = 0;
    }

    private bool IsInRect()
    {
        var pos = GameManager.Get().GetMouseWorldPosition();

        for (var i = 0; i < _corners.GetLength(0); i++)
        {
            var corner = _corners[i];
            var xMin = Math.Min(corner[0].x, corner[3].x);
            var xMax = Math.Max(corner[0].x, corner[3].x);
            var yMin = Math.Min(corner[0].y, corner[1].y);
            var yMax = Math.Max(corner[0].y, corner[1].y);

            if (pos.x >= xMin && pos.x <= xMax && pos.y >= yMin && pos.y <= yMax)
                return true;
        }

        return false;
    }

    public void SetClickSound(string clickSoundString)
    {
        _customClickSoundString = clickSoundString;
    }

    private double _clickSoundBlockedUntilAt;

    protected override void Update()
    {
        base.Update();

        if (_pointerDownAt == 0 || !IsInteractable())
            return;

        if (_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_POINTER_EXIT))
            return;

        if (!IsInRect())
        {
            _buttonInternalStateFlag.AddFlag(ButtonInternalStateFlag.WAS_POINTER_EXIT);
            return;
        }

        var currentTime = Utility.GetTime();
        var timeHeld = (float)(currentTime - _pointerDownAt);

        switch (buttonClickType)
        {
            case ButtonClickType.NORMAL:
            {
                if (!_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.WAS_HOLD_INVOKED) &&
                    holdDelay > 0 && timeHeld > holdDelay)
                {
                    _buttonInternalStateFlag.AddFlag(ButtonInternalStateFlag.WAS_HOLD_INVOKED);
                    if (_enableEventLog)
                        Debug.Log($"{name} is Invoked OnButtonHold");
                    m_onButtonHold.Invoke();
                }
            }
                break;
            case ButtonClickType.AUTO_CLICK:
            {
                var autoClickDelay = clickDelay;
                if (enableAutoClickAccel)
                {
                    autoClickDelay = Math.Max(0.01f, Math.Max(clickDelay - timeHeld * 0.1f, autoClickAccelMinDelay));
                }

                if (_pointerDownAt + clickDelay < currentTime && _nextClickBlockedUntilAt < currentTime)
                {
                    if (_tween is null)
                    {
                        transform.localScale = _initialScale;
                        _tween = DOTween.To(x => transform.localScale = _initialScale * x, 1.0f, 0.9f, autoClickDelay).SetEase(Ease.OutCirc).OnComplete(() => _tween = null);
                    }
                    OnPointerClick();
                    _nextClickBlockedUntilAt = currentTime + autoClickDelay;
                }   
            }
                break;
            default:
                break;
        }
    }

    protected override void OnDestroy()
    {
        if (_tween != null)
        {
            _tween.Kill();
            _tween = null;
        }

        if (_visibleEffect != null)
        {
            _tween.Kill();
            _tween = null;
        }

        base.OnDestroy();
    }

    public virtual void OnBeginDrag(PointerEventData eventData)
    {
        _buttonInternalStateFlag.AddFlag(ButtonInternalStateFlag.IS_DRAGGING);
        DoForParents<IBeginDragHandler>(parent => { parent.OnBeginDrag(eventData); });
    }

    public virtual void OnDrag(PointerEventData eventData)
    {
        DoForParents<IDragHandler>(parent => { parent.OnDrag(eventData); });
    }

    public virtual void OnEndDrag(PointerEventData eventData)
    {
        _buttonInternalStateFlag.RemoveFlag(ButtonInternalStateFlag.IS_DRAGGING);
        DoForParents<IEndDragHandler>(parent => { parent.OnEndDrag(eventData); });
    }

    private readonly ButtonInteractor_Old _interactor = new();
    public ButtonInteractor_Old GetInteractor(TextMeshProUGUI textRef = null)
    {
        return _interactor.Get(this, textRef);
    }

    public void SetBadges(bool isActive)
    {
        foreach (var badge in badges)
        {
            if (badge)
                badge.SetActive(isActive);
        }
    }

    private Tweener _visibleEffect = null;

    public void SetActiveWithEffect(bool bActive)
    {
        if (gameObject.activeSelf == bActive)
            return;

        if (_visibleEffect != null)
            DOTween.Kill(_visibleEffect);

        _buttonInternalStateFlag.AddFlag(ButtonInternalStateFlag.IS_PLAYING_VISIBLE_EFFECT);

        if (bActive)
        {
            gameObject.SetActive(true);

            transform.localScale = _initialScale * .7f;
            _visibleEffect = transform.DOScale(_initialScale, .1f)
                .SetEase(Ease.OutBack).OnKill(() =>
                {
                    _visibleEffect = null;
                    _buttonInternalStateFlag.RemoveFlag(ButtonInternalStateFlag.IS_PLAYING_VISIBLE_EFFECT);
                });
        }
        else
        {
            _visibleEffect = transform.DOScale(0f, .1f)
                .SetEase(Ease.InBack).OnKill(() =>
                {
                    _visibleEffect = null;
                    _buttonInternalStateFlag.RemoveFlag(ButtonInternalStateFlag.IS_PLAYING_VISIBLE_EFFECT);

                    gameObject.SetActive(false);
                });
        }
    }

    public override bool IsActive()
    {
        return base.IsActive() && !_buttonInternalStateFlag.HasFlag(ButtonInternalStateFlag.IS_PLAYING_VISIBLE_EFFECT);
    }

    public void RefreshNotice(bool bActive)
    {
        SetBadges(bActive);
    }
}

public static class ZButtonExtension
{
    public static ButtonInternalStateFlag AddFlag(this ref ButtonInternalStateFlag a, ButtonInternalStateFlag b)
    {
        return a |= b;
    }

    public static ButtonInternalStateFlag RemoveFlag(this ref ButtonInternalStateFlag a, ButtonInternalStateFlag b)
    {
        return a &= ~b;
    }

    public static ZButton SetOnClick(this ZButton button, UnityAction action)
    {
        button.onClick.RemoveAllListeners();
        button.onClick.AddListener(action);
        return button;
    }

    public static ZButton SetOnClickDisabled(this ZButton button, UnityAction action)
    {
        button.onClickDisabled.RemoveAllListeners();
        button.onClickDisabled.AddListener(action);
        return button;
    }

    public static ZButton SetOnButtonDown(this ZButton button, UnityAction action)
    {
        button.onButtonDown.RemoveAllListeners();
        button.onButtonDown.AddListener(action);
        return button;
    }

    public static ZButton SetOnButtonHold(this ZButton button, UnityAction action)
    {
        button.onButtonHold.RemoveAllListeners();
        button.onButtonHold.AddListener(action);
        return button;
    }

    public static ZButton SetOnButtonReleased(this ZButton button, UnityAction<bool> action)
    {
        button.onButtonReleased.RemoveAllListeners();
        button.onButtonReleased.AddListener(action);
        return button;
    }

    public static ZButton SetOnButtonReleased(this ZButton button, UnityAction action)
    {
        button.onButtonReleased.RemoveAllListeners();
        button.onButtonReleased.AddListener((_) => action?.Invoke());
        return button;
    }
    
}