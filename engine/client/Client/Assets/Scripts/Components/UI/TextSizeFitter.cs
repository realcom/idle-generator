using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class TextSizeFitter : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI target;
    
    [SerializeField] private Vector2 additionalSize;
    [SerializeField] private float minWidth = -1f;
    [SerializeField] private float minHeight = -1f;
    [SerializeField] private float maxWidth = -1f;
    [SerializeField] private float maxHeight = -1f;
    [SerializeField] private bool fitWidth = true;
    [SerializeField] private bool fitHeight = true;

    public void SetMaxHeight(float height)
    {
        maxHeight = height;
        target.SetAllDirty();
    }

    private RectTransform rt;

    private void Awake()
    {
        rt = GetComponent<RectTransform>();
    }

    private void OnValidate()
    {
        if (target)
        {
            target.UnregisterDirtyVerticesCallback(Fit);
            target.RegisterDirtyVerticesCallback(Fit);   
        }
        
        Fit();
    }

    private void Reset()
    {
        if (target)
            target.UnregisterDirtyVerticesCallback(Fit);
    }

    private void Start()
    {
        if (target)
        {
            target.UnregisterDirtyVerticesCallback(Fit);
            target.RegisterDirtyVerticesCallback(Fit);   
        }
        
        Fit();
    }

    private void OnDestroy()
    {
        if (target)
            target.UnregisterDirtyLayoutCallback(Fit);
    }

    [Button]
    private void Fit()
    {
        if (rt == null)
            rt = GetComponent<RectTransform>();

        if (target == null)
            return;

        if (!enabled)
            return;
        
        var sizeX = target.preferredWidth + additionalSize.x;
        var sizeY = target.preferredHeight + additionalSize.y;

        if (sizeX < minWidth)
            sizeX = minWidth;
        if (sizeY < minHeight)
            sizeY = minHeight;

        if (maxWidth > 0f && sizeX > maxWidth)
            sizeX = maxWidth;
        if (maxHeight > 0f && sizeY > maxHeight)
            sizeY = maxHeight;

        var drivenLayoutGroup = (rt.drivenByObject as HorizontalOrVerticalLayoutGroup);
        var isNull = drivenLayoutGroup == null;
        var sizeDelta = rt.sizeDelta;
        if (fitWidth && (isNull || !drivenLayoutGroup.childControlWidth))
            sizeDelta.x = sizeX;
        if (fitHeight && (isNull || !drivenLayoutGroup.childControlHeight))
            sizeDelta.y = sizeY;
        rt.sizeDelta = sizeDelta;
    }

}
