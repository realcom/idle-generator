using System.ComponentModel;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0f, 0.8360357f, 1f)]
[TrackClipType(typeof(EffectClip))]
// [TrackClipType(typeof(FullScreenEffectClip))]
[DisplayName("Idlez/Effect Track")]
public class EffectTrack : ZSkillTrackAsset<EffectMixerBehaviour>
{
    public override bool CanPlay(UnitSkin unit)
    {
        return true;
    }
}
