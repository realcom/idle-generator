using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using DG.Tweening;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using ZLinq;

public class UITabBar : CustomToggleGroup
{
    [Serializable]
    public class BasicTabElement : UIElement
    {
        public TextMeshProUGUI txtName;
        public RedDot redDot;
    }
    
    [Serializable]
    public class IconTabElement : BasicTabElement
    {
        public Image imgIcon;
    }
    
    [SerializeField]
    private int m_DefaultIndex = 0;
    private int m_SelectedIndex = -1;

    public int selectedIndex
    {
        get => m_SelectedIndex;
        set
        {
            if (m_SelectedIndex == value)
                return;

            m_SelectedIndex = value;
            currentToggle?.Set(true);
        }
    }

    public UnityEvent<int> onTabSelected = new();
    
    public CustomToggle currentToggle
    {
        get
        {
            var toggle = m_Toggles.GetClamped(m_SelectedIndex);
            return toggle == null ? null : toggle;
        }
    }

    private bool m_IsHandleMove;
    private string UI_TAB_INDEX_PREFS_KEY => GetGamePrefsKey("UI_Tab_Index");
    
#if UNITY_EDITOR
    protected override void OnValidate()
    {
        m_DefaultIndex = Mathf.Clamp(m_DefaultIndex, 0, Math.Max(m_Toggles.Count - 1, 0));

        if (!Application.isPlaying)
        {
            selectedIndex = m_DefaultIndex;
        }
    }
#endif
    
    protected override void Start()
    {
        base.Start();

        if (selectedIndex == -1)
            ResetTab();
    }
    
    public void RefreshBadge(int index, bool bActive)
    {
        
    }
    
    public void RefreshTab()
    {
        OnSelectTab(selectedIndex, false);
    }
    
    public void OnSelectTab(int index, bool silently = false)
    {
        if (index < 0 || index >= m_Toggles.Count)
            return;
        
        m_SelectedIndex = index;

        Refresh();

        if (!silently)
            onTabSelected?.Invoke(index);
        
        if (isStorable && !string.IsNullOrEmpty(saveKey))
        {
            PlayerPrefs.SetInt(UI_TAB_INDEX_PREFS_KEY, index);
            PlayerPrefs.Save();
        }
    }
    
    public void ResetTab()
    {
        for (var i = 0; i < m_Toggles.Count; i++)
        {
            var capturedIdx = i;
            var toggle = m_Toggles[i];
            toggle.onValueChanged.RemoveAllListeners();
            toggle.onValueChanged.AddListener(isOn =>
            {
                if (isOn)
                {
                    OnSelectTab(capturedIdx);
                }
            });
        }
        
        if (isStorable && !string.IsNullOrEmpty(saveKey))
        {
            m_DefaultIndex = PlayerPrefs.GetInt(UI_TAB_INDEX_PREFS_KEY, m_DefaultIndex);
        }

        var defaultToggle = m_Toggles.GetSafe(m_DefaultIndex);
        if (defaultToggle)
            defaultToggle.isOn = true;
        OnSelectTab(m_DefaultIndex);

        transform.SetActive(m_Toggles.Count > 1);
        
    }
    
    public void Refresh()
    {

    }

    public IEnumerable<(TUIElement element, int index, TData data)> AllocateTabs<TUIElement, TData>(UIElementContainer<TUIElement> elementContainer, IList<TData> datas, UnityAction<int> onTabSelected, bool forceReset = true) where TUIElement : UIElement, new()
    {
        this.onTabSelected.RemoveAllListeners();
        this.onTabSelected.AddListener(onTabSelected);

        using var list = PooledList<TData>.Get();
        list.AddRange(datas);
        
        foreach (var valueTuple in elementContainer.GetElements(datas))
        {
            yield return valueTuple;
        }
        
        var count = datas.Count;
        if (m_Toggles.Count == count)
        {
            if (forceReset)
                ResetTab();
            yield break;
        }

        foreach (var _ in GetRecycleTabs(count, forceReset))
        {
        }
    }

    public IEnumerable<(TUIElement element, int index, TData data)> AllocateTabs<TUIElement, TData>(UIElementContainer<TUIElement> elementContainer, IEnumerable<TData> datas, UnityAction<int> onTabSelected, bool forceReset = true) where TUIElement : UIElement, new()
    {
        return AllocateTabs(elementContainer, datas.AsValueEnumerable().ToList(), onTabSelected, forceReset);
    }
    
    public IEnumerable<(CustomToggle toggle, int index)> GetRecycleTabs(int count, bool forceReset = false)
    {
        var wasChangedCount = m_Toggles.Count != count;
        while (m_Toggles.Count < count)
        {
            var newToggle = Utility.DuplicateGameObject(m_Toggles.First().gameObject).GetOrAdd<CustomToggle>();
            newToggle.group = this;
        }

        for (var i = m_Toggles.Count - 1; i > count; i--)
        {
            m_Toggles[i].gameObject.SetActive(false);
        }
        
        for (var i = 0; i < m_Toggles.Count; i++)
        {
            yield return (m_Toggles[i], i);
        }
        
        if (wasChangedCount || forceReset)
        {
            ResetTab();
        }
    }
    
    public void SetTabLock(int index, bool locked, UnityAction callback = null)
    {
        m_Toggles[index].interactable = !locked;

        if (locked)
        {
            m_Toggles[index].SetOnClickDisabled(callback);
        }
        else
        {
            m_Toggles[index].onClickDisabled.RemoveAllListeners();
        }
        
        Refresh();
    }

    
}
