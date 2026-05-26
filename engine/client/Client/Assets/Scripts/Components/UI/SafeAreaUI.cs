using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
[ExecuteAlways]
public class SafeAreaUI : UIBehaviour, ILayoutSelfController
{
    private RectTransform _rt;
#if !UNITY_EDITOR
    private Rect _oldSafeArea;
#endif
    
    [SerializeField] private bool m_SafeLeft = true;
    [SerializeField] private bool m_SafeRight = true;
    [SerializeField] private bool m_SafeTop = true;
    [SerializeField] private bool m_SafeBottom = true;

    protected override void Awake()
    {
        _rt = GetComponent<RectTransform>();
    }

    protected override void Start()
    {
        base.Start();
        ApplySafeArea();
    }

    protected override void OnEnable()
    {
        base.OnEnable();
        if (isActiveAndEnabled && !CanvasUpdateRegistry.IsRebuildingLayout())
            LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
    }

    protected override void OnRectTransformDimensionsChange()
    {
        base.OnRectTransformDimensionsChange();
        if (isActiveAndEnabled && !CanvasUpdateRegistry.IsRebuildingLayout())
            LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
    }

    protected override void OnCanvasHierarchyChanged()
    {
        base.OnCanvasHierarchyChanged();
        if (isActiveAndEnabled && !CanvasUpdateRegistry.IsRebuildingLayout())
            LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
    }

    private void ApplySafeArea()
    {
        if (!enabled)
            return;

        if (_rt == null)
            _rt = GetComponent<RectTransform>();

        if (_rt == null)
            return;
        
        var safeArea = Screen.safeArea;
        
#if !UNITY_EDITOR
         if(_oldSafeArea == safeArea)
            return;
#endif
        
        var screen = new Vector2(Screen.width, Screen.height);

        _rt.anchorMin = new Vector2(Mathf.Clamp01(safeArea.x / screen.x), Mathf.Clamp01(safeArea.y / screen.y));
        _rt.anchorMax = new Vector2(Mathf.Clamp01((safeArea.x + safeArea.width) / screen.x), Mathf.Clamp01((safeArea.y + safeArea.height) / screen.y));
        
        _rt.anchorMin = new Vector2(m_SafeLeft ? _rt.anchorMin.x : 0, m_SafeBottom ? _rt.anchorMin.y : 0);
        _rt.anchorMax = new Vector2(m_SafeRight ? _rt.anchorMax.x : 1, m_SafeTop ? _rt.anchorMax.y : 1);

#if !UNITY_EDITOR
        Debug.Log($"Fit SafeAreaUI: {safeArea}, anchorMin: {_rt.anchorMin}, anchorMax: {_rt.anchorMax}");
        _oldSafeArea = safeArea;
#endif
    }

    public void SetLayoutHorizontal() => ApplySafeArea();

    public void SetLayoutVertical() => ApplySafeArea();
}
