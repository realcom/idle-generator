using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.01227164f, 0.2130584f, 0.8761264f)]
[TrackClipType(typeof(UseBuffClip))]
[DisplayName("Idlez/UseBuff Track")]
public class UseBuffTrack : ZSkillTrackAsset<UseBuffMixerBehaviour>
{
public override bool CanPlay(UnitSkin unit)
	{
		return true;
	}
}
