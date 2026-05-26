using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public abstract class DisableActionBehaviour : ZSkillPlayableBehaviour
{
    protected override void OnBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        base.OnBehaviourEnter(playable, info, playerData);
        
        DisableAction();
    }

    protected override void OnBehaviourExit(Playable playable, FrameData info)
    {
        EnableAction();
        
        base.OnBehaviourExit(playable, info);
    }
    
    protected abstract void DisableAction();
    protected abstract void EnableAction();
    
}

[Serializable]
public class DisableMoveBehaviour : DisableActionBehaviour
{
    protected override void DisableAction()
    {
    }

    protected override void EnableAction()
    {
    }
}

[Serializable]
public class DisableSkillBehaviour : DisableActionBehaviour
{
    public int priority;
    
    protected override void DisableAction()
    {
    }

    protected override void EnableAction()
    {
    }
}