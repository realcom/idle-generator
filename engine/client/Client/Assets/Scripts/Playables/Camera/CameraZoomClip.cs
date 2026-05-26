using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class CameraZoomClip : CameraBaseClip<CameraZoomBehaviour, CameraZoomFxSettings>
{
    public override PostRefreshCallback postRefreshCallback =>
        (clip) =>
        {
            template.fxSettings.cameraZoomFxSettingsProperties.cameraZoomDuration = (float)Math.Round(clip.duration, 3);
        };
}
