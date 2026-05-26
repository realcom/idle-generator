using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(1f, 0.8066038f, 0.8484183f)]
[TrackClipType(typeof(UseSkillClip))]
[DisplayName("Idlez/UseSkill Track")]
public class UseSkillTrack : ZTrackAsset<UseSkillMixerBehaviour>
{
}
