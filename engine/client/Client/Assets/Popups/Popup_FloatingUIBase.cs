using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Popup_FloatingUIBase<T> : UIPopup where T : Popup_FloatingUIBase<T>
{
    [SerializeField] private CanvasGroup m_CanvasGroup;
    
    protected static T ShowInternal(Vector2? screenPoint = null)
    {
        var popup = GameManager.Get().ShowPopup<T>();
        popup.Clear();
        popup.RebuildLayout(screenPoint);
        return popup;
    }

    protected abstract void Clear();
    
    private void RebuildLayout(Vector2? screenPoint = null)
    {
        screenPoint ??= Input.mousePosition;

        var canvas = transform.root.GetComponent<Canvas>();
        var rtRootCanvas = (RectTransform)canvas.transform;
        var localPoint = screenPoint.Value;
        switch (canvas.renderMode)
        {
            case RenderMode.ScreenSpaceOverlay:
            {
                // Overlay 모드에서는 직접 변환
                RectTransformUtility.ScreenPointToLocalPointInRectangle(
                    rtRootCanvas,
                    screenPoint.Value,
                    null, // camera가 null이어야 overlay 모드에서 제대로 작동
                    out localPoint);
                break;
            }
            case RenderMode.ScreenSpaceCamera:
            {
                // Camera 모드에서는 기존 방식
                var worldPoint = GameManager.Get().ScreenToWorldPoint(screenPoint.Value);
                localPoint = rtRootCanvas.InverseTransformPoint(worldPoint);
                break;
            }
        }

        if (isActiveAndEnabled)
            StartCoroutine(IDelayedRebuildLayout(localPoint));
    }
    
    private IEnumerator IDelayedRebuildLayout(Vector2 localPoint)
    {
        m_CanvasGroup.alpha = 0;
        yield return null;
        m_CanvasGroup.alpha = 1;
        
        var rt = contents.Get<RectTransform>();
        var canvasRT = transform.root as RectTransform;
        var canvasBounds = canvasRT.rect;
        
        //바운드 최대 90%까지만 사용
        canvasBounds.min += canvasBounds.size * 0.05f;
        canvasBounds.max -= canvasBounds.size * 0.05f;
        
        var tooltipSize = rt.sizeDelta;

        //피봇에 따라 min, max 바운드 범위 재조정
        canvasBounds.min += tooltipSize * rt.pivot;
        canvasBounds.max -= (tooltipSize - tooltipSize * rt.pivot);

        localPoint.x = Mathf.Clamp(localPoint.x, canvasBounds.min.x, canvasBounds.max.x);
        localPoint.y = Mathf.Clamp(localPoint.y, canvasBounds.min.y, canvasBounds.max.y);

        rt.anchoredPosition = localPoint;
    }

}
