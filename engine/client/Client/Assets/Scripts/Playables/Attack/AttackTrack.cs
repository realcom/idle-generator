using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(1f, 0f, 0.2505919f)]
[TrackClipType(typeof(AttackClip))]
[DisplayName("Idlez/Attack Track")]
public class AttackTrack : ZSkillTrackAsset<AttackMixerBehaviour>
{
    public override bool CanPlay(UnitSkin unit)
    {
        return true;
    }
}
