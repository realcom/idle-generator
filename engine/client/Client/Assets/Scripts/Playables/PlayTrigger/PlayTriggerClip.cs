using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class PlayTriggerClip : ZSerializedClip<PlayTriggerBehaviour>
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
