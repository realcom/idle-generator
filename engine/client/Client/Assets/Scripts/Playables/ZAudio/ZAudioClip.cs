using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class ZAudioClip : ZFxSerializedClip<ZAudioBehaviour, AudioFxSettings>
{
    public override double duration
    {
        get
        {
            if (template != null && template.fxSettings != null && template.fxSettings.audioFxSettingsProperties.audioClip != null)
                return template.fxSettings.audioFxSettingsProperties.audioClip.length;

            return base.duration;
        }
    }

}
