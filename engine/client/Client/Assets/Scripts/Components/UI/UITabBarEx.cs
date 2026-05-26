using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using DG.Tweening;
using JetBrains.Annotations;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Pool;
using UnityEngine.UI;
using Random = UnityEngine.Random;

[Serializable]
public class UITabElement : UIElement
{
#if UNITY_EDITOR
    public string comment;
#endif

    [DisallowNull] public ZButton button;
    [DisallowNull] public TextMeshProUGUI txtTabName;
    [CanBeNull, NonCopyable] public RectTransform page;
    [CanBeNull, NonCopyable] public Image bottomLine;
    [CanBeNull, NonCopyable] public GameObject badge;
    [DisallowNull] public GameObject[] pageObjects = new GameObject[0];
    [DisallowNull] public GameObject[] lockedObjects = new GameObject[0];
    
    public void SetActive(bool active)
    {
        if (button)
            button.interactable = !active;
        if (bottomLine)
            bottomLine.gameObject.SetActive(active);
        if (page)
            page.gameObject.SetActive(active);
        
        //foreach (var obj in pageObjects)
        //{
        //    if (obj)
        //    {
        //        obj.SetActive(active);
        //    }
        //}
    }
    
    public void SetBadgeActive(bool active)
    {
        if (badge)
            badge.SetActive(active);

        if (button)
            button.SetBadges(active);
    }

    public void SetLocked(bool bLocked)
    {
        //if (button)
        //    button.locked = bLocked;
    }
    
}

public class UITabBarEx : UIBehaviour
{
    public UIElementContainer<UITabElement> elements = new();
    [NonSerialized] public readonly List<UITabElement> validElements = new();

    //public UITabElement[] elements = new UITabElement[0];
    
    public int defaultTabIndex = 0;
    private int _selectedTabIndex;
    public int selectedTabIndex
    {
        get
        {
            return _selectedTabIndex;
        }
        set
        {
            if (_selectedTabIndex == value)
                return;
            
            OnSelectTab(value);
        }
    }
    
    [FoldoutGroup("Tab Handle")]
    public RectTransform rtTabHandle;
    [FoldoutGroup("Tab Handle"), ShowIf("@rtTabHandle != null")]
    public bool useTabHandle = false;
    [FoldoutGroup("Tab Handle"), ShowIf("@rtTabHandle != null")]
    public float tabHandleMoveDuration = .25f;
    [FoldoutGroup("Tab Handle"), ShowIf("@rtTabHandle != null")]
    public Ease tabHandleMoveEase = Ease.Linear;
    
    [FoldoutGroup("Save Selected Index")]
    public bool saveElementIndex = false;
    [FoldoutGroup("Save Selected Index")]
    public string saveKey = "";
    
    public UnityEvent<int> onTabSelected = new();
    
    private readonly Dictionary<GameObject, HashSet<int>> _tabPageObjectEnableIndexList = new();
    private readonly Dictionary<GameObject, List<int>> _tabLockObjectsIndexList = new();
    private readonly HashSet<int> lockedTabIndex = new();
    
    private bool _bisHandleMoving;

#if UNITY_EDITOR
    protected override void OnValidate()
    {
        if (saveElementIndex && string.IsNullOrEmpty(saveKey))
            saveKey = $"UI_TAB_{gameObject.name}_{Random.value.ToString(CultureInfo.InvariantCulture)[2..]}";
        
        defaultTabIndex = Mathf.Clamp(defaultTabIndex, 0, Math.Max(elements.Length - 1, 0));

        useTabHandle &= rtTabHandle != null;

        if (!Application.isPlaying)
        {
            selectedTabIndex = defaultTabIndex;
            OnChangedTabLayout();
            
            if (rtTabHandle)
                rtTabHandle.anchoredPosition = GetHandleTargetRectTransform().anchoredPosition;
        }
    }
#endif

    protected override void Awake()
    {
        ResetTab();
    }

    private void Update()
    {
        if (useTabHandle && !_bisHandleMoving)
        {
            var element = GetCurrentTabElement();
            if (element != null)
            {
                var targetRectTransform = (RectTransform)element.button.transform;
                rtTabHandle.position = targetRectTransform.position;
            }
        }
    }

    protected override void OnRectTransformDimensionsChange()
    {
        //OnChangedTabLayout();
    }

    private readonly Dictionary<int, (Func<bool>, UnityEvent)> tabEnableValidator = new();

    public void RemoveTabEnableValidator(int index)
    {
        tabEnableValidator.Remove(index);
    }
    
    public void SetTabEnableValidator(int index, Func<bool> validator, UnityAction disabledCallback = null)
    {
        if (!tabEnableValidator.TryGetValue(index, out (Func<bool> validator, UnityEvent callbacks) p))
            tabEnableValidator[index] = p = (validator, new());
        
        if (disabledCallback != null)
            p.callbacks.AddListener(disabledCallback);
    }
    
    public void SetTabEnableGeneralValidator(Func<bool> validator, UnityAction disabledCallback = null)
    {
        SetTabEnableValidator(-1, validator, disabledCallback);
    }
    
    public void AddTabDisableCallback(int index, UnityAction callback)
    {
        if (!tabEnableValidator.TryGetValue(index, out (Func<bool> validator, UnityEvent callbacks) p))
            tabEnableValidator[index] = p = (null, new());

        p.callbacks.AddListener(callback);
    }
    
    public void AddTabDisableGeneralCallback(UnityAction callback)
    {
        AddTabDisableCallback(-1, callback);
    }

    public void SetTabLock(int index, bool locked, UnityAction callback = null)
    {
        if (locked)
        {
            lockedTabIndex.Add(index);
            SetTabEnableValidator(index, () => false, callback);
        }
        else
        {
            lockedTabIndex.Remove(index);
            RemoveTabEnableValidator(index);
        }
        
        Refresh();
    }

    public void RefreshBadge(int index, bool bActive)
    {
        GetTabElement(index)?.SetBadgeActive(bActive);
    }

    public void RefreshTab()
    {
        OnSelectTab(selectedTabIndex, false);
    }

    public void OnSelectTab(int index, bool bMoveWithTween = true, bool silently = false)
    {
        if (index < 0 || index >= validElements.Count)
            return;
        
        if (tabEnableValidator.TryGetValue(-1, out (Func<bool> validator, UnityEvent callbacks) generalValidator))
        {
            if ((generalValidator.validator?.Invoke() ?? true) == false)
            {
                generalValidator.callbacks?.Invoke();
                return;
            }
        }
        
        if (tabEnableValidator.TryGetValue(index, out (Func<bool> validator, UnityEvent callbacks) validator))
        {
            if ((validator.validator?.Invoke() ?? true) == false)
            {
                validator.callbacks?.Invoke();
                return;
            }
        }
        
        _selectedTabIndex = index;

        Refresh();

        if (!silently)
            onTabSelected?.Invoke(index);
        
        if (saveElementIndex && !string.IsNullOrEmpty(saveKey))
        {
            PlayerPrefs.SetInt(saveKey, index);
            PlayerPrefs.Save();
        }

        if (bMoveWithTween && useTabHandle)
        {
            _bisHandleMoving = true;
            //팝업 크기가 변경되면 이상하게 움직일 수 있어 레이아웃 변경 이후 핸들 이동
            this.RunAfterFrame(() =>
            {
                rtTabHandle.DOKill();
                rtTabHandle.DOMove(GetHandleTargetRectTransform().position, tabHandleMoveDuration).SetEase(tabHandleMoveEase).OnComplete(() =>
                {
                    _bisHandleMoving = false;
                });
            });
        }
    }

    public void ResetTab()
    {
        _tabPageObjectEnableIndexList.Clear();
        _tabLockObjectsIndexList.Clear();
        validElements.Clear();
        for (var i = 0; i < elements.Length; i++)
        {
            if (elements[i].elementRoot.activeSelf)
                validElements.Add(elements[i]);
        }
        
        for (var i = 0; i < validElements.Count; i++)
        {
            var capturedIdx = i;
            var element = validElements[i];
            element.button.onClick.AddListener(() => OnSelectTab(capturedIdx));

            if (element.button.imageSet is not { Length: 1 })
            {
                element.button.imageSet = new ZButton.ImageStateSet[1];
            }
            
            //element.button.imageSet[0].image.sprite = CRC.Get().tabBarSpriteSet.normalCenter;
            //element.button.imageSet[0].disabledSprite = CRC.Get().tabBarSpriteSet.selectedCenter;

            foreach (var pageObject in element.pageObjects)
            {
                if (!_tabPageObjectEnableIndexList.TryGetValue(pageObject, out var collection))
                    _tabPageObjectEnableIndexList[pageObject] = collection = new ();
                
                collection.Add(i);
            }
            
            foreach (var lockedObject in element.lockedObjects)
            {
                if (!_tabLockObjectsIndexList.TryGetValue(lockedObject, out var collection))
                    _tabLockObjectsIndexList[lockedObject] = collection = new ();
                
                collection.Add(i);
            }
        }
        
        var firstElement = validElements.First();
        //firstElement.button.imageSet[0].image.sprite = CRC.Get().tabBarSpriteSet.normalLeft;
        //firstElement.button.imageSet[0].disabledSprite = CRC.Get().tabBarSpriteSet.selectedLeft;

        if (validElements.Count > 1)
        {
            var lastElement = validElements.Last();
            //lastElement.button.imageSet[0].image.sprite = CRC.Get().tabBarSpriteSet.normalRight;
            //lastElement.button.imageSet[0].disabledSprite = CRC.Get().tabBarSpriteSet.selectedRight;
        }
        
        lockedTabIndex.Clear();
        
        if (saveElementIndex && !string.IsNullOrEmpty(saveKey))
        {
            defaultTabIndex = PlayerPrefs.GetInt(saveKey, defaultTabIndex);
        }

        OnSelectTab(defaultTabIndex, false);

        if (useTabHandle)
        {
            LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
            rtTabHandle.anchoredPosition = GetHandleTargetRectTransform().anchoredPosition;
        }

        transform.SetActive(validElements.Count > 1);
        
    }
    
    public void Refresh()
    {
        for (var i = 0; i < validElements.Count; i++)
        {
            var element = validElements[i];
            element.SetActive(i == selectedTabIndex);
            element.SetLocked(lockedTabIndex.Contains(i));
        }

        foreach (var (go, enableIndexCollection) in _tabPageObjectEnableIndexList)
        {
            go.SetActive(enableIndexCollection.Contains(selectedTabIndex));
        }
        
        foreach (var (go, lockIndexCollection) in _tabLockObjectsIndexList)
        {
            go.SetActive(lockIndexCollection.Any(i => lockedTabIndex.Contains(i)));
        }
    }
    
    public void AllocateTabs(int count)
    {
        foreach (var _ in GetRecycleTabs(count)) { }
    }

    public IEnumerable<(UITabElement element, int index)> GetRecycleTabs(int count, bool forceReset = false)
    {
        var wasChangedCount = validElements.Count != count;
        foreach (var tuple in elements.GetElements(count))
        {
            yield return tuple;
        }

        if (wasChangedCount || forceReset)
        {
            ResetTab();
        }
    }

    private void OnChangedTabLayout()
    {
        if (rtTabHandle)
            rtTabHandle.sizeDelta = GetHandleTargetRectTransform().rect.size;
    }

    private RectTransform GetHandleTargetRectTransform() => ((RectTransform)GetCurrentTabElement()?.button?.transform ?? rtTabHandle);
    
    public UITabElement GetCurrentTabElement()
    {
        return validElements.GetSafe(selectedTabIndex);
    }
    
    public UITabElement GetTabElement(int index)
    {
        return validElements.GetSafe(index);
    }
    
}
