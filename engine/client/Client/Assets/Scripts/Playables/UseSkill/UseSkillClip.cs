using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class UseSkillClip : ZSerializedClip<UseSkillBehaviour>
{

    public override ClipCaps clipCaps => ClipCaps.None;

}
