using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public abstract class DisableActionClip<T> : ZSerializedClip<T> where T : DisableActionBehaviour, new()
{
    public override ClipCaps clipCaps => ClipCaps.Blending;
}