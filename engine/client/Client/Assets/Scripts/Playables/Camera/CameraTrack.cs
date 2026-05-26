using System.ComponentModel;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(1f, 0.8919904f, 0f)]
[TrackClipType(typeof(CameraZoomClip))]
[TrackClipType(typeof(CameraShakeClip))]
[DisplayName("Idlez/CameraTrack")]
public class CameraTrack : ZSkillTrackAsset<CameraMixerBehaviour>
{
    public override bool CanPlay(UnitSkin unit)
    {
        return true;
    }
}
