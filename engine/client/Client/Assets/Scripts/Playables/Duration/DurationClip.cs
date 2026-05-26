using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class DurationClip : ZSerializedClip<DurationBehaviour>
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
