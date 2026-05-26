using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.7294792f, 0.7946248f, 0.8722478f)]
[TrackClipType(typeof(PlayAnimationClip))]
[DisplayName("Idlez/PlayAnimation Track")]
public class PlayAnimationTrack : ZSkillTrackAsset<PlayAnimationMixerBehaviour>
{
public override bool CanPlay(UnitSkin unit)
	{
		return true;
	}
}
