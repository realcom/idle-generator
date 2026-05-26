using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Timeline;

public abstract class CameraBaseClip<T, TFxSettings> : ZFxSerializedClip<T, TFxSettings> where T : ZFxPlayableBehaviour<TFxSettings>, new() where TFxSettings : FxSettings
{
    public sealed override ClipCaps clipCaps => ClipCaps.Blending;
}
