using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class TimeScaleFxClip : ZSerializedClip<TimeScaleFxBehaviour>
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
