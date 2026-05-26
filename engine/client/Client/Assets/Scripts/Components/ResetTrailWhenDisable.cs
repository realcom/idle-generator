using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetTrailWhenDisable : MonoBehaviour
{
    public TrailRenderer renderer;

    private void OnDisable()
    {
        renderer.Clear();
    }
}
