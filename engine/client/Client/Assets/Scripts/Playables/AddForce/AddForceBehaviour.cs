using System;

using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Serialization;
using UnityEngine.Timeline;

[Serializable]
public class AddForceBehaviour : ZSkillPlayableBehaviour
{
    public float distance = 0f;
    public Vector2 direction = Vector2.up;
    // [HideInInspector]
    public bool adjustDistanceToTarget = false;
    
    public Vector3? derivedPosition { get; set; } = null;

    [HideInInspector]
    public AddForceRotateParameter duringRotateParameter = new(AddForceRotateParameter.RotationTargetTiming.CLIP_CURRENT, Quaternion.identity);
    [HideInInspector]
    public AddForceRotateParameter endRotateParameter = new(AddForceRotateParameter.RotationTargetTiming.SEQUENCE_START, Quaternion.identity);
} 

[Serializable]
public struct AddForceRotateParameter
{
    public enum RotationTargetTiming
    {
        SEQUENCE_START,
        CLIP_CURRENT,
    }

    public RotationTargetTiming timing;
    public Quaternion deltaRotation;

    public AddForceRotateParameter(RotationTargetTiming timing, Quaternion deltaRotation)
    {
        this.timing = timing;
        this.deltaRotation = deltaRotation;
    }
}