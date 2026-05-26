using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class EffectClip : ZFxSerializedClip<EffectBehaviour, AnimationFxSettings>
{
    public override PostRefreshCallback postRefreshCallback =>
        (clip) =>
        {
            if (!template.fxSettings.animationFxSettingsProperties.useCustomDuration)
                template.fxSettings.animationFxSettingsProperties.duration = (float)Math.Round(clip.duration, 3);
        };
}
