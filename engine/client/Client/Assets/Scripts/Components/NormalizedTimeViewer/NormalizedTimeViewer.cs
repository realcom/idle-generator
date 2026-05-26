using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class NormalizedTimeViewer : MonoBehaviour
{
    [SerializeField] private float _cyclesPerSecond = 1f;
    [SerializeField, Range(0f, 1f)] private float _offset01 = 0f;
    [SerializeField] private bool _useUnscaledTime = false;
    
    public static float GlobalSpeed { get; set; }= 1f;

    public void Update()
    {
        var t = _useUnscaledTime ? Time.unscaledTimeAsDouble : Time.timeAsDouble;
        var cycles = t * _cyclesPerSecond * GlobalSpeed + _offset01;

        // repeat 0~1
        var normalizedTime = (float)(cycles - Math.Floor(cycles));

        UpdateNormalizedTime(normalizedTime);
    }
    
    protected abstract void UpdateNormalizedTime(float normalizedTime);
}
