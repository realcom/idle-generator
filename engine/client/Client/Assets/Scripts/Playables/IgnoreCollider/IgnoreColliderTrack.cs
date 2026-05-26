using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.1948725f, 0.4279643f, 0.5051109f)]
[TrackClipType(typeof(IgnoreUnitColliderClip))]
[DisplayName("Idlez/IgnoreCollider Track")]
public class IgnoreColliderTrack : ZSkillTrackAsset<IgnoreColliderMixerBehaviour>
{
    public override bool CanPlay(UnitSkin unit)
    {
        return true;
    }
}
