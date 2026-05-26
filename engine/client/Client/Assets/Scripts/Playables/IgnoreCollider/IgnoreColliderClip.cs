using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public abstract class IgnoreColliderClip<IgnoreColliderBehaviourType> : ZSerializedClip<IgnoreColliderBehaviourType> where IgnoreColliderBehaviourType : ZPlayableBehaviour, new()
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
