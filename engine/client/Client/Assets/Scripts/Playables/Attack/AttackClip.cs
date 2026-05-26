using System;
using UnityEngine.Timeline;

[Serializable]
public class AttackClip : ZSerializedClip<AttackBehaviour>
{
    public override ClipCaps clipCaps => ClipCaps.None;
}

