using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.3942415f, 0.4921847f, 0.8098266f)]
[TrackClipType(typeof(PlayTriggerClip))]
[DisplayName("Idlez/PlayTrigger Track")]
public class PlayTriggerTrack : ZSkillTrackAsset<PlayTriggerMixerBehaviour>
{
public override bool CanPlay(UnitSkin unit)
	{
		return true;
	}
}
