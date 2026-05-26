using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class UseBuffClip : ZSerializedClip<UseBuffBehaviour>
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
