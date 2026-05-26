using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class PlayAnimationBehaviour : ZSkillPlayableBehaviour
{
    public enum AnimationName
    {
        Attack,
        Attack1,
        Attack2,
        Attack3,
        Attack4,
        Dead,
        Dead1,
        Dead2,
        Dead3,
        Dead4,
        Idle,
        Run,
        
        Landing,
        Fly,
        Charge,


        Interaction1,
        Interaction2,
        Interaction3,
    }

    public AnimationName animationName = AnimationName.Attack;
}
