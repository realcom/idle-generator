using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.6854839f, 0.4481132f, 1f)]
[TrackClipType(typeof(ZAudioClip))]
[DisplayName("Idlez/ZAudio Track")]
public class ZAudioTrack : ZSkillTrackAsset<ZAudioMixerBehaviour>
{
public override bool CanPlay(UnitSkin unit)
	{
		return true;
	}
}
