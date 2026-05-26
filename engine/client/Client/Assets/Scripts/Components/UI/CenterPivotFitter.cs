using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;

[ExecuteAlways, DefaultExecutionOrder(101)]
public class CenterPivotFitter : SerializedMonoBehaviour
{
    public RectTransform target;
    public RectTransform rectTransform { get; private set; } = null;
    
    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
    }
    
    private void Start()
    {
        if (target == null)
        {
            enabled = false;
        }
    }
#if UNITY_EDITOR
    private void OnValidate()
    {
        Fit();
    }
#endif

    private void OnRectTransformDimensionsChange()
    {
        Fit();
    }

    private void Fit()
    {
        if (!enabled)
            return;
#if UNITY_EDITOR
        if (target == null)
            return;
        if (rectTransform == null)
            rectTransform = GetComponent<RectTransform>();
#endif

        var bounds = RectTransformUtility.CalculateRelativeRectTransformBounds(target);
        rectTransform.anchoredPosition = -bounds.center;   
    }

}
