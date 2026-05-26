using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]
public class AnimationNormalizedTimeViewer : NormalizedTimeViewer
{
    [SerializeField] private Animator _animator;
    [SerializeField] private string _stateName = "Anim";
    private int _stateHash;

#if UNITY_EDITOR
    private void Reset()
    {
        _animator = GetComponent<Animator>();
    }
#endif

    private void Start()
    {
        if(_animator == null || string.IsNullOrEmpty(_stateName))
        {
            enabled = false;
            return;
        }
        
        _stateHash = Animator.StringToHash(_stateName);
        
        if(!_animator.HasState(0, _stateHash))
        {
            enabled = false;
            return;
        }

        _animator.speed = 0f;
    }

    protected override void UpdateNormalizedTime(float normalizedTime)
    {
        _animator.Play(_stateHash, -1, normalizedTime);
    }
}
