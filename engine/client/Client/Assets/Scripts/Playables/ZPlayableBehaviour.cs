using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class ZPlayableBehaviour : PlayableBehaviour
{
    private bool wasFirstFrameInvoke;
    private bool wasBehaviourEnterInvoke = false;

    [NonSerialized]
    public TrackAsset parentTrack;
    [NonSerialized]
    public TimelineClip clip;

    public void SetClip(TimelineClip clip)
    {
        this.clip = clip;
    }
    
    public virtual void OnBeforeCreate(PlayableGraph graph, GameObject owner)
    {
        
    }

    public sealed override void OnPlayableCreate(Playable playable)
    {
        base.OnPlayableCreate(playable);
    }

    public override void OnPlayableDestroy(Playable playable)
    {
        wasFirstFrameInvoke = false;

        OnPreBehaviourExit(playable, new FrameData());
        
        base.OnPlayableDestroy(playable);
    }

    protected virtual void OnFirstFrame(Playable playable, FrameData info, object playerData)
    {
    }
    
    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        if (!wasFirstFrameInvoke)
        {
            OnFirstFrame(playable, info, playerData);
            wasFirstFrameInvoke = true;
        }
        
        base.ProcessFrame(playable, info, playerData);
    }
    
    public void OnPreBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        if (wasBehaviourEnterInvoke)
            return;
        
        wasBehaviourEnterInvoke = true;
        OnBehaviourEnter(playable, info, playerData);
    }
    
    protected virtual void OnBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        
    }
    
    public void OnPreBehaviourExit(Playable playable, FrameData info)
    {
        if (!wasBehaviourEnterInvoke)
            return;
        
        wasBehaviourEnterInvoke = false;
        OnBehaviourExit(playable, info);
    }
    
    protected virtual void OnBehaviourExit(Playable playable, FrameData info)
    {
        
    }
    
}

public class ZFxPlayableBehaviour<TFxSettings> : ZPlayableBehaviour where TFxSettings : FxSettings
{
    [BoxGroup("Settings")]
    public TFxSettings fxSettings;
    
    [NonSerialized]
    public UnitSkin unit = null;
    
    private void SetUnit(UnitSkin unitSkin)
    {
        unit = unitSkin;
    }

    public override void OnBeforeCreate(PlayableGraph graph, GameObject owner)
    {
        base.OnBeforeCreate(graph, owner);
        SetUnit(owner.Get<UnitSkin>());
    }
}
public static class PlayerBehaviourExtension
{
    public static float GetNormalizedTime(this Playable playable)
    {
        return Mathf.Clamp01((float)(playable.GetTime() / playable.GetDuration()));
    }
} 