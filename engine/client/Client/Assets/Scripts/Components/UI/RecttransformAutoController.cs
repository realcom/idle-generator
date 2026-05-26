using System;
using System.Collections;
using System.Collections.Generic;
using Components.UI;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class RecttransformAutoController : UIBehaviour, ILayoutSelfController
{
    [SerializeField] private RectTransform _rectTarget;
    [SerializeField] private RectOffset _padding = new();

    [SerializeField] private Vector2 _anchorMin = new(0.5f, 0.5f);
    [SerializeField] private Vector2 _anchorMax = new(0.5f, 0.5f);
    [SerializeField] private Vector2 _pivot = new(0.5f, 0.5f);
    [SerializeField] private Vector2 _anchoredPosition = Vector2.zero;
    
    private DrivenRectTransformTracker _tracker;

    protected override void OnDisable()
    {
        _tracker.Clear();
        base.OnDisable();
    }
    
    protected override void OnEnable()
    {
        base.OnEnable();
        var self = transform as RectTransform;
        if (self && !CanvasUpdateRegistry.IsRebuildingLayout())
            LayoutRebuilder.MarkLayoutForRebuild(self);
    }

#if UNITY_EDITOR
    protected override void OnValidate()
    {
        base.OnValidate();
        if (isActiveAndEnabled && !CanvasUpdateRegistry.IsRebuildingLayout())
            LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
    }
    
    protected override void Reset()
    {
        _padding = new RectOffset(4, 4, 4, 4);
    }
#endif
    
    protected override void OnRectTransformDimensionsChange()
    {
        base.OnRectTransformDimensionsChange();
        if (isActiveAndEnabled && !CanvasUpdateRegistry.IsRebuildingLayout())
            LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
    }
    
    public virtual void SetLayoutHorizontal() => FitSize();
    public virtual void SetLayoutVertical() => FitSize();

    private void FitSize()
    {
        var self = transform as RectTransform;
        if (!self) 
            return;

        var rect = _rectTarget ? _rectTarget : (transform.parent as RectTransform);
        if (!rect) 
            return;

        var r = rect.rect;
        if (r.width <= 0f || r.height <= 0f)
        {
            if (isActiveAndEnabled && !CanvasUpdateRegistry.IsRebuildingLayout())
                LayoutRebuilder.MarkLayoutForRebuild((RectTransform)transform);
        };

        _tracker.Clear();
        _tracker.Add(this, self, DrivenTransformProperties.All);

        if (!self.anchorMin.Approximately(_anchorMin))
            self.anchorMin = _anchorMin;
        if (!self.anchorMax.Approximately(_anchorMax))
            self.anchorMax = _anchorMax;
        if (!self.pivot.Approximately(_pivot))
            self.pivot = _pivot;
        
        var desiredW = Mathf.Max(0, r.width  - _padding.horizontal);
        var desiredH = Mathf.Max(0, r.height - _padding.vertical);
        var desiredSize = new Vector2(desiredW, desiredH);
        if (!self.sizeDelta.Approximately(desiredSize))
            self.sizeDelta = desiredSize;

        if (!self.localScale.Approximately(Vector3.one))
            self.localScale = Vector3.one;
        if (!self.anchoredPosition.Approximately(_anchoredPosition))
            self.anchoredPosition = _anchoredPosition;
        if (self.localRotation != Quaternion.identity)
            self.localRotation = Quaternion.identity;
    }
    
}
