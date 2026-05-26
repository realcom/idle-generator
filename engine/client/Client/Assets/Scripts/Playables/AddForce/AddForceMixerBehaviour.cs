using System;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class AddForceMixerBehaviour : ZSkillMixerBehaviour
{
    private Quaternion _initialRotation;
    private Vector3 _initialPosition;

    private float _targetDistance;

    protected override void OnCreate()
    {
        base.OnCreate();

        var transform = unit.transform;
        _initialRotation = transform.rotation;
        _initialPosition = transform.position;

#if UNITY_EDITOR
        if (!Application.isPlaying)
        {
            _initialRotation = Quaternion.identity;
            _initialPosition = Vector3.zero;
        }
#endif
        
    }

    protected override void OnFirstFrame(Playable playable, FrameData info, object playerData)
    {
        base.OnFirstFrame(playable, info, playerData);
        
        foreach (var playableClip in playableClips)
        {
            var scriptPlayable = playableClip.playable;

            var behaviour = scriptPlayable.GetBehaviour();
            switch (behaviour)
            {
                case AddForceBehaviour addForceBehaviour:
                {
                    var forceToTarget = addForceBehaviour.adjustDistanceToTarget && addForceBehaviour.derivedPosition.HasValue;
                    _targetDistance = forceToTarget
                        ? Mathf.Min((addForceBehaviour.derivedPosition.Value.ProjectToXZPlane() - unit.transform.position.ProjectToXZPlane()).magnitude, addForceBehaviour.distance)
                        : addForceBehaviour.distance;

                    (addForceBehaviour.clip.asset as AddForceClip)!.template.derivedPosition = null;
                    break;
                }
            }

        }
    }

    protected override void OnProcessFrame(Playable playable, FrameData info, object playerData)
    {
        base.OnProcessFrame(playable, info, playerData);

        var time = playable.GetTime();
        var vec = _initialPosition;
        var rot = _initialRotation;

        var currentPosition = unit.transform.position;

        foreach (var playableClip in playableClips)
        {
            var clip = playableClip.clip;

            if (clip.start > time)
                continue;
            
            var scriptPlayable = playableClip.playable;
            var normalizedTime = (float)(scriptPlayable.GetTime() / scriptPlayable.GetDuration());
            
            var behaviour = scriptPlayable.GetBehaviour();
            switch (behaviour)
            {
                case AddForceBehaviour addForceBehaviour:
                {
                    if (clip.end < time)
                    {
                        normalizedTime = 1f;
                    }

                    vec = Vector3.Lerp(vec, vec + _initialRotation * addForceBehaviour.direction.X0Z() * _targetDistance, normalizedTime);
                    
                    rot = addForceBehaviour.duringRotateParameter.timing switch
                    {
                        AddForceRotateParameter.RotationTargetTiming.SEQUENCE_START => _initialRotation,
                        AddForceRotateParameter.RotationTargetTiming.CLIP_CURRENT => Quaternion.LookRotation(_initialRotation * addForceBehaviour.direction.X0Z()),
                        _ => rot
                    };
                    rot *= addForceBehaviour.duringRotateParameter.deltaRotation;
                    
                    if (normalizedTime >= 1f)
                    {
                        rot = addForceBehaviour.endRotateParameter.timing switch
                        {
                            AddForceRotateParameter.RotationTargetTiming.SEQUENCE_START => _initialRotation,
                            AddForceRotateParameter.RotationTargetTiming.CLIP_CURRENT => rot,
                            _ => rot
                        };
                        rot *= addForceBehaviour.endRotateParameter.deltaRotation;
                    }
                    
                    break;
                }
            }
        }

        if (playableClips.Count == processedClips.Count)
        {
            if (processedClips[^1].clip.end + info.deltaTime < time)
                return;
        }
        
        var moveVec = vec - currentPosition;
        rot.x = 0f;
        rot.z = 0f;
        //unit.unit.Look(rot * Vector3.forward);
        // unit.characterController.clientAddForce = new(moveVec, rot);

    }

    protected override void OnPlayableBehaviourEnter(Playable playable, FrameData info, ZPlayableBehaviour behaviour)
    {
        base.OnPlayableBehaviourEnter(playable, info, behaviour);
        
    }

    protected override void OnPlayableBehaviourExit(Playable playable, FrameData info, ZPlayableBehaviour behaviour)
    {
        base.OnPlayableBehaviourExit(playable, info, behaviour);
    }
}
