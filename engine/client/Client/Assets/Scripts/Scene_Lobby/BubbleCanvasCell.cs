using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.Rendering;

public class BubbleCanvasCell : WorldUICanvasCell
{
    public RectTransform rtBubble;
    public TextMeshProUGUI txtBubble;

    public bool expired { get; private set; }

    public override void Initialize(GameUnitObject unit)
    {
        rtBubble.gameObject.SetActive(false);
    }
    
    private Coroutine bubbleCoroutine;

    public Coroutine ShowBubble(string text, float duration = float.PositiveInfinity)
    {
        expired = false;
        gameObject.SetActive(true);
        
        rtBubble.gameObject.SetActive(true);
        rtBubble.DOKill();
        rtBubble.localScale = Vector3.zero;
        rtBubble.transform.DOScale(1f, 0.15f);
        txtBubble.text = text;

        if (bubbleCoroutine != null)
            StopCoroutine(bubbleCoroutine);
        if (float.IsPositiveInfinity(duration))
            return null;
        return bubbleCoroutine = StartCoroutine(HideTextBubbleCoroutine(duration));
    }
    
    private IEnumerator HideTextBubbleCoroutine(float duration)
    {
        yield return Utility.GetWaitForSeconds(duration);
        HideBubble();
    }

    public void HideBubble()
    {
        rtBubble.DOKill();
        rtBubble.localScale = Vector3.one;
        rtBubble.transform.DOScale(0f, 0.15f)
            .SetEase(Ease.InBack)
            .OnComplete(() =>
            {
                rtBubble.gameObject.SetActive(false);
                expired = true;
            });
    }
    
}
