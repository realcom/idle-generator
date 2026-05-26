using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.4950605f, 0.5654292f, 0.8396226f)]
[TrackClipType(typeof(TimeScaleFxClip))]
[DisplayName("Idlez/TimeScaleFx Track")]
public class TimeScaleFxTrack : ZTrackAsset<TimeScaleFxMixerBehaviour>
{
}

public class TimeScaleFxMixerBehaviour : ZMixerBehaviour
{
}