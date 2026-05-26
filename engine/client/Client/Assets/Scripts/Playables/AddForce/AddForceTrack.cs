using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using System.ComponentModel;

[TrackColor(0.5545073f, 1f, 0.1745283f)]
[TrackClipType(typeof(AddForceClip))]
[DisplayName("Idlez/AddForce Track")]
public class AddForceTrack : ZSkillTrackAsset<AddForceMixerBehaviour>
{
#if UNITY_EDITOR
    public Vector3 editorFixingPosition = Vector3.zero;
    
    [ContextMenu("시작 지점 갱신")]
    public void Func()
    {
        //editorFixingPosition = 
    }
#endif


    public override bool CanPlay(UnitSkin unit)
    {
        return true;
    }
}
