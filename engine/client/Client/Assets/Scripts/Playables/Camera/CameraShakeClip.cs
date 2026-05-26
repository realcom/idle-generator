using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class CameraShakeClip : CameraBaseClip<CameraShakeBehaviour, CameraShakeFxSettings>
{
    public override PostRefreshCallback postRefreshCallback =>
        (clip) =>
        {
            template.fxSettings.cameraShakeFxSettingsProperties.cameraShakeDuration = (float)Math.Round(clip.duration, 3);
        };
}
