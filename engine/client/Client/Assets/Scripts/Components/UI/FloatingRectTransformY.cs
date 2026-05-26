using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class FloatingRectTransformY : MonoBehaviour
{
    [ShowInInspector] RectTransform _rectTransform;
    [SerializeField] private float floatingValue = 5f;
    [SerializeField] private float floatingSpeed = 1f;
    private float _randomOffset = 0f;
    private Vector2 _defaultPos;
    
#if UNITY_EDITOR
    private void Reset()
    {
        _rectTransform = _rectTransform ?? GetComponent<RectTransform>();
    }
#endif
    
    void Start()
    {
        _rectTransform = _rectTransform ?? GetComponent<RectTransform>();
        _randomOffset = UnityEngine.Random.Range(0f, Mathf.PI);
        _defaultPos = _rectTransform.anchoredPosition;
    }
    
    void Update()
    {
        _rectTransform.anchoredPosition = new Vector2(_defaultPos.x, _defaultPos.y + Mathf.Sin(_randomOffset + (Time.time * floatingSpeed)) * floatingValue);
    }
}
