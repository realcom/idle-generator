using System;
using System.Collections;
using System.Collections.Generic;
using Commons;
using Sirenix.OdinInspector;
using UnityEngine;

public class RuntimeDebugCanvas : MonoBehaviour
{
    public CanvasGroup canvasGroup;

    private bool isOn = false;

    private void Start()
    {
        gameObject.SetActive(Config.IsDebug);
        enabled = Config.IsDebug;
        ToggleOn(isOn = false);
    }

    [Button]
    public void On()
    {
        isOn = true;
        ToggleOn(isOn);
    }

    [Button]
    public void Off()
    {
        isOn = false;
        ToggleOn(isOn);
    }

    private void ToggleOn(bool bIsOn)
    {
        canvasGroup.alpha = bIsOn ? 1 : 0;
        canvasGroup.interactable = bIsOn;
        canvasGroup.blocksRaycasts = bIsOn;
    }

    private void Update()
    {
        if (Input.touchCount == 3 || Input.GetKeyUp(KeyCode.F12))
        {
            var allBegan = true;

            for (var i = 0; i < Input.touchCount; i++)
            {
                if (Input.GetTouch(i).phase != TouchPhase.Began)
                {
                    allBegan = false;
                    break;
                }
            }

            if (allBegan)
            {
                ToggleOn(isOn = !isOn);
            }
        }
    }
}
