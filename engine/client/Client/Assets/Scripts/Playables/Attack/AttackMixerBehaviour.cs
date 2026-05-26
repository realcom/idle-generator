using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class AttackMixerBehaviour : ZSkillMixerBehaviour
{
    // protected override void OnProcessFrame(Playable playable, FrameData info, object playerData)
    // {
    //     base.OnProcessFrame(playable, info, playerData);
    //     
    //     var inputCount = playable.GetInputCount ();
    //
    //     for (var i = 0; i < inputCount; i++)
    //     {
    //         var inputWeight = playable.GetInputWeight(i);
    //         var inputPlayable = (ScriptPlayable<AttackBehaviour>)playable.GetInput(i);
    //         var input = inputPlayable.GetBehaviour ();
    //         
    //         // Use the above variables to process each frame of this playable.
    //         
    //     }
    // }

    protected override void OnProcessFrame(Playable playable, FrameData info, object playerData)
    {
        base.OnProcessFrame(playable, info, playerData);
    }
}
