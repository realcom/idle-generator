using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(1f, 1f, 1f)]
[TrackClipType(typeof(DurationClip))]
[DisplayName("Idlez/Duration Track")]
public class DurationTrack : ZTrackAsset<DurationMixerBehaviour>
{
}
