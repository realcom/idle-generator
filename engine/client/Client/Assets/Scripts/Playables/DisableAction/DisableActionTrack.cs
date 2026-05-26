using UnityEngine;
using System.ComponentModel;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(1f, 0.454696f, 0.4009434f)]
[TrackClipType(typeof(DisableMoveClip))]
[TrackClipType(typeof(DisableSkillClip))]
[TrackClipType(typeof(ForceDisableSkillClip))]
[DisplayName("Idlez/DisableAction Track")]
public class DisableActionTrack : ZSkillTrackAsset<DisableActionMixerBehaviour>
{
    public override bool CanPlay(UnitSkin unit)
    {
        return true;
    }
}
