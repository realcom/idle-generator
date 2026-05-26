using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Types.Players;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class LevelStarsWithVFX : LevelStars
{
    [SerializeField] private HorizontalLayoutGroup _hlGroup;
    [SerializeField] private Animator[] _animators;

    private void Start()
    {
        InitAnimatorsComponent();
    }
    private void OnEnable()
    {
        InitAnimatorsComponent();
    }

    private void InitAnimatorsComponent()
    {
        _animators = new Animator[stars.Length];
        
        for (int i = 0; i < stars.Length; i++)
        {
            _animators[i] = stars[i].elementRoot.GetComponent<Animator>();
        }
    }

    private void InitAnimatorsTime()
    {
        foreach (var animator in _animators)
        {
            if (!animator.isActiveAndEnabled)
            {
                continue;
            }
            animator.Play(animator.GetCurrentAnimatorClipInfo(0)[0].clip.name, -1, 1.0f);
        }
    }
    
    public void FreezeRefresh()
    {
        _blockRefresh = true;
    }
    
    public void UnfreezeRefresh()
    {
        _blockRefresh = false;
    }
    
    private bool _blockRefresh = false;
    public override void Refresh(int level)
    {
        if (_blockRefresh)
            return;
        
        base.Refresh(level);
        
        var starCount = GetStarCount(level);
        _hlGroup.spacing = _starSize * (Constants.STAR_GRADE_UNIT - starCount) * -1;

        InitAnimatorsTime();
    }
    
    Tween _starAddTween;
    Tween _starCompositeTween;
    private int _starSize = 32;

    public void UpdateStar(PlayerItemMessage oldItem, PlayerItemMessage newItem)
    {
        var level = newItem?.Level ?? 0;
        if (level < Constants.STAR_GRADE_UNIT)
        {
            stars.elementParent.SetActive(false);
            return;
        }

        if (level % 5 != 0)
        {
            return;
        }

        var starCount = GetStarCount(level);
        var starIndex = GetStarIndex(level);
        if (starCount <= 1)
        {
            _starCompositeTween.Kill();
            _starCompositeTween = DOTween.To(
                    () => 0f,
                    x => _hlGroup.spacing = x,
                    _starSize * Constants.STAR_GRADE_UNIT * -1,
                    0.1f
                )
                .SetEase(Ease.InOutQuart);

            _starCompositeTween.Pause();
            
            _starCompositeTween.OnStart(FreezeRefresh);
            _starCompositeTween.OnComplete(() =>
            {
                UnfreezeRefresh();
                Refresh(level);
                _animators[starIndex].Play(_animators[starIndex].GetCurrentAnimatorClipInfo(0)[0].clip.name, -1, 0.0f);
            });
            _starCompositeTween.OnKill(() =>
            {
                UnfreezeRefresh();
                Refresh(level);
                _animators[starIndex].Play(_animators[starIndex].GetCurrentAnimatorClipInfo(0)[0].clip.name, -1, 0.0f);
            });
            
            _starCompositeTween.Restart();
        }
        else
        {
            _starAddTween.Kill();
            _starAddTween = DOTween.To(
                    () => _starSize * (Constants.STAR_GRADE_UNIT - (starCount - 1)) * -1,
                    x => _hlGroup.spacing = x,
                    _starSize * (Constants.STAR_GRADE_UNIT - starCount) * -1,
                    0.15f)
                .SetEase(Ease.OutExpo);

            _starAddTween.Pause();
            
            _starAddTween.OnStart(() =>
            {
                FreezeRefresh();
                base.Refresh(level);
                _animators[starIndex].Play(_animators[starIndex].GetCurrentAnimatorClipInfo(0)[0].clip.name, -1, 0.0f);
            });
            _starAddTween.OnComplete(() =>
            {
                UnfreezeRefresh();
                Refresh(level);
            });
            _starAddTween.OnKill(() =>
            {
                UnfreezeRefresh();
                Refresh(level);
            });
            
            _starAddTween.Restart();
            
        }
    }
}
