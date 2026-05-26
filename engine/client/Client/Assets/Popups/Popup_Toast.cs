using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class Popup_Toast : Toast
{
    private Tween _tweenMoveY;
    private Tween _tweenFade;
	
    protected override void Start () {
        base.Start();

        if (this.Get<CanvasGroup>() is { } canvasGroup)
        {
            canvasGroup.interactable = false;
            canvasGroup.blocksRaycasts = false;
        }
    }

    protected override void RefreshByFlag()
    {
        
    }

    protected override void OnDestroy()
    {
        if (_tweenMoveY != null) {
            _tweenMoveY.Kill();
            _tweenMoveY = null;
        }
		
        if (_tweenFade != null) {
            _tweenFade.Kill();
            _tweenFade = null;
        }
		
        base.OnDestroy();
    }

    protected override void Initialize_Internal(ToastMessageData messageData)
    {
        _tweenMoveY = contents.transform.DOLocalMoveY(contents.transform.localPosition.y + 100f, messageData.Duration + 0.2f);

        var canvasGroup = this.GetOrAdd<CanvasGroup>();
        if (canvasGroup != null)
        {
            canvasGroup.alpha = 0f;
            _tweenFade = canvasGroup.DOFade(1f, 0.2f);	
        }
    }

    protected override void Release_Internal(ToastData data)
    {
        var canvasGroup = this.GetOrAdd<CanvasGroup>();
        if (canvasGroup == null)
        {
            Hide();
            return;
        }
		
        canvasGroup.DOKill();
        _tweenFade = canvasGroup.DOFade(0f, 0.2f).OnComplete(Hide);
    }
}
