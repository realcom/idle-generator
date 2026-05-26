using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class AddForceClip : ZSerializedClip<AddForceBehaviour>
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
