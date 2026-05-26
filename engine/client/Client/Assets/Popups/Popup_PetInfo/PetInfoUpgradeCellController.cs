using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Coffee.UIEffects;
using DG.Tweening;
using UnityEngine.Serialization;

public class PetInfoUpgradeCellController : MonoBehaviour
{
    [SerializeField] private Image _vfxGlow;
    [SerializeField] private UIEffect _uiEffect;
    [SerializeField] private Animator _additiveSpriteAnimator;

    private Coroutine _unlockCoroutine;
    private Sequence _unlockSequence = null;

    private bool _isUnlocked = false;

    private void Start()
    {
        InitSequence();
        InitVFXObjects();
    }

    private void OnEnable()
    {
        //InitSequence();
        InitVFXObjects();
    }
    
    public void InitVFXObjects()
    {
        _vfxGlow.SetAlpha(0f);
        _uiEffect.transitionRate = 1f;
        _additiveSpriteAnimator.Play(_additiveSpriteAnimator.GetCurrentAnimatorClipInfo(0)[0].clip.name, -1, 1.0f);
    }

    private void InitSequence()
    {
        _unlockSequence ??= DOTween.Sequence();
        
        _unlockSequence.SetAutoKill(false);
        _unlockSequence.Pause();
        _unlockSequence.Join(
            DOTween.To(() => 0.5f, x => _uiEffect.transitionRate = x, 1f, 0.5f)
                .SetEase(Ease.OutExpo)
        );
        _unlockSequence.Join(
            DOTween.To(()=>1f, x=> _vfxGlow.SetAlpha(x), 0f, 0.5f)
                .SetEase(Ease.OutCubic)
        );
    }

    public void PlaySequence()
    {
        _unlockSequence.Restart();
        _additiveSpriteAnimator.Play(_additiveSpriteAnimator.GetCurrentAnimatorClipInfo(0)[0].clip.name, -1, 0f);
    }

    public bool IsUnlocked()
    {
        return _isUnlocked;
    }

    public void SetUnlocked(bool isUnlocked)
    {
        _isUnlocked = isUnlocked;
    }
}
