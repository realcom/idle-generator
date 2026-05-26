using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Slider))]
public class ZSlider : ZUIBehaviour
{
    public override bool enabled
    {
        get => base.enabled;
        set => base.enabled = _slider.enabled = value;
    }

    [SerializeField] private Slider _slider;

    public bool useFillMinActivatedObject;
    
    [ShowIf("useFillMinActivatedObject")]
    public GameObject fillMinActivatedObject;
    public GameObject fillMaxActivatedObject;
    public GameObject fillBetweenActivatedObject;

    public float value
    {
        get => _slider.value;
        set
        {
            _slider.value = value;
            
            if (_slider.fillRect)
                _slider.fillRect.gameObject.SetActive(value > _slider.minValue);

            if (_slider.handleRect)
                _slider.handleRect.gameObject.SetActive(value > _slider.minValue);

            if (fillMinActivatedObject)
                fillMinActivatedObject.SetActive(value <= _slider.minValue);

            if (fillMaxActivatedObject)
                fillMaxActivatedObject.SetActive(value >= _slider.maxValue);

            if (fillBetweenActivatedObject)
                fillBetweenActivatedObject.SetActive((!useFillMinActivatedObject || value > _slider.minValue) && value < _slider.maxValue);
        } 
    }
    
}
