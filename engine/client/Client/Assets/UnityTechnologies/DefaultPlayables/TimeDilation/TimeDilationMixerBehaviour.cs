using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class TimeDilationMixerBehaviour : PlayableBehaviour
{
    readonly float defaultTimeScale = 1f;

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        int inputCount = playable.GetInputCount ();

        float mixedTimeScale = 0f;
        float totalWeight = 0f;
        int currentInputCount = 0;

        for (int i = 0; i < inputCount; i++)
        {
            float inputWeight = playable.GetInputWeight(i);

            if (inputWeight > 0f)
                currentInputCount++;
            
            totalWeight += inputWeight;

            ScriptPlayable<TimeDilationBehaviour> playableInput = (ScriptPlayable<TimeDilationBehaviour>)playable.GetInput (i);
            TimeDilationBehaviour input = playableInput.GetBehaviour ();

            mixedTimeScale += inputWeight * input.timeScale;
        }

        TimeSystem.timeScale = mixedTimeScale + defaultTimeScale * (1f - totalWeight);

        if (currentInputCount == 0)
            TimeSystem.timeScale = defaultTimeScale;
    }

    public override void OnBehaviourPause (Playable playable, FrameData info)
    {
        TimeSystem.timeScale = defaultTimeScale;
    }

    public override void OnGraphStop (Playable playable)
    {
        TimeSystem.timeScale = defaultTimeScale;
    }

    public override void OnPlayableDestroy (Playable playable)
    {
        TimeSystem.timeScale = defaultTimeScale;
    }
}
