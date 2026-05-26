using System;
using UnityEngine;
using UnityEngine.Playables;

[Serializable]
public class ZAudioBehaviour : ZFxPlayableBehaviour<AudioFxSettings>
{
    // public AudioFxSettings audioFxSettings;

    protected override void OnBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        base.OnBehaviourEnter(playable, info, playerData);
        
#if UNITY_EDITOR
        if (!Application.isPlaying)
            EditorFXAudioSystem.PlayClip(fxSettings.audioFxSettingsProperties.audioClip);
#endif
    }

    protected override void OnBehaviourExit(Playable playable, FrameData info)
    {
        base.OnBehaviourExit(playable, info);
        
#if UNITY_EDITOR
        if (!Application.isPlaying)
            EditorFXAudioSystem.StopAllClips();
#endif
    }
}
