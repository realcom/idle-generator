using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoroutineRunner : MonoBehaviour
{
    private Action action = null;
    
    private void OnDisable()
    {
        StopAllCoroutines();
        action?.Invoke();
        action = null;
    }

    public void RunWithDelay(Action action, float delay)
    {
        if (!gameObject.activeSelf)
        {
            action?.Invoke();
            return;
        }
        
        StartCoroutine(RunWithDelayInternal(action, delay));
    }

    private IEnumerator RunWithDelayInternal(Action action, float delay)
    {
        this.action = action;
        yield return Utility.GetWaitForSeconds(delay);
        this.action?.Invoke();
        this.action = null;
    }
}
