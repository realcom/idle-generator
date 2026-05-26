using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Random = System.Random;

public class FloatingTextCanvasCell : WorldUICanvasCell
{
    public RectTransform rtText;
    public TextMeshProUGUI text;
    public Image imgMapArrow;
    public ZButton btnMapArrow;
    
    public bool expired { get; private set; }

    public override void Initialize(GameUnitObject unit)
    {
        rtText.gameObject.SetActive(false);
    }

    private Coroutine coroutine;

    public double initTime;
    public bool doFloat = false;
    public float randomX = 0;
    public Coroutine Show(string inText, float duration = float.PositiveInfinity, Color? color = null, bool doFloat = false)
    {
        expired = false;
        gameObject.SetActive(true);
        
        text.text = inText;
        text.color = color ?? Color.white;
        text.alpha = 1f;
        
        rtText.gameObject.SetActive(true);
        rtText.DOKill();
        rtText.localScale = Vector3.zero;
        rtText.transform.DOScale(doFloat ? 1.5f: 1f, 0.15f);
        
        this.doFloat = doFloat;
        if (doFloat)
        {
            initTime = TimeSystem.time;
            // randomX = (float)(new Random().NextDouble() - 0.5f) * 3f;
            text.DOKill();
            text.DOFade(0f, 3);
        }

        if (coroutine != null)
            StopCoroutine(coroutine);
        if (float.IsPositiveInfinity(duration))
            return null;
        return coroutine = StartCoroutine(HideTextCoroutine(duration));
    }
    
    private IEnumerator HideTextCoroutine(float duration)
    {
        yield return Utility.GetWaitForSeconds(duration);
        Hide();
    }
    
    public void Hide()
    {
        
        rtText.transform.DOKill();
        rtText.localScale = Vector3.one;
        rtText.transform.DOScale(0f, 0.15f)
            .SetEase(Ease.InBack)
            .OnComplete(() =>
            {
                rtText.gameObject.SetActive(false);
                expired = true;
            });
    }
}
