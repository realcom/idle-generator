using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public abstract class IgnoreColliderBehaviour : ZSkillPlayableBehaviour
{

    protected override void OnBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        base.OnBehaviourEnter(playable, info, playerData);
        
        IgnoreCollider();
    }

    protected override void OnBehaviourExit(Playable playable, FrameData info)
    {
        UndoIgnoreCollider();
        
        base.OnBehaviourExit(playable, info);
    }

    protected abstract void IgnoreCollider();
    protected abstract void UndoIgnoreCollider();
    
}
