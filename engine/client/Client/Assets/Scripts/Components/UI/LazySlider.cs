using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;
using Sirenix.OdinInspector;

public class LazySlider : MonoBehaviour
{
    [SerializeField] private Slider m_Slider;
    [SerializeField] private Slider m_LazySlider;

    private Tweener lazyTweener = null;
    public void Set(float value)
    {
        value = float.IsNaN(value) ? 0 : value;

        m_Slider.value = value;

        lazyTweener ??= DOTween.To(v =>
        {
            m_LazySlider.value = Mathf.Lerp(m_LazySlider.value, m_Slider.value, v);
        }, 0f, 1f, 0.3f).SetDelay(0.3f).OnComplete(() => lazyTweener = null);
    }

#if UNITY_EDITOR
    [Button]
    public void FitFillRect()
    {
        if (m_Slider != null && m_Slider.fillRect != null)
        {
            Fit(m_Slider.fillRect);
        }
        
        if (m_LazySlider != null && m_LazySlider.fillRect != null)
        {
            Fit(m_LazySlider.fillRect);
        }
        
        void Fit(RectTransform rectTransform)
        {
            var child = (RectTransform)rectTransform.GetChild(0);
            var xPadding = child.anchoredPosition.x;
            var width = rectTransform.rect.width - xPadding * 2;
            child.sizeDelta = new Vector2(width, child.sizeDelta.y);
        }
            
    }
#endif
    
}
