using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Serialization;
using UnityEngine.Timeline;

[Serializable]
public class UseBuffBehaviour : ZSkillPlayableBehaviour
{
    public int buffDataId;
    
    [Flags]
    public enum EditorBuffFlag : uint
    {
        NONE = 0,
        HIDE_UNIT = 1 << 0,
        INCREASE_UNIT = 2 << 0,
    }
    
    public EditorBuffFlag editorBuffFlag;
    
    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        base.ProcessFrame(playable, info, playerData);
        
    }
    
    protected override void OnBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        base.OnBehaviourEnter(playable, info, playerData);

        if (editorBuffFlag.HasFlag(EditorBuffFlag.HIDE_UNIT))
        {
            if (unit != null)
                unit.SetRendererActive(false);
        }
    }

    protected override void OnBehaviourExit(Playable playable, FrameData info)
    {
        base.OnBehaviourExit(playable, info);
        
        if (editorBuffFlag.HasFlag(EditorBuffFlag.HIDE_UNIT))
        {
            if (unit != null)
                unit.SetRendererActive(true);
        }
    }
}
