using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public abstract class ZTrackAsset<MixerBehaviourType> : TrackAsset  
    where MixerBehaviourType : ZMixerBehaviour, IPlayableBehaviour, new()
{
    [NonSerialized]
    public MixerBehaviourType mixerBehaviour = null;
    [NonSerialized]
    public readonly List<ZPlayableBehaviour> behaviours = new();

    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        var mixerPlayable = ScriptPlayable<MixerBehaviourType>.Create(graph, inputCount);
        
        mixerBehaviour = mixerPlayable.GetBehaviour();
        mixerBehaviour.SetClips(GetClips());
        mixerBehaviour.InitBehaviourBinding(go);

        mixerBehaviour.parentTrack = this;
        
        mixerBehaviour.OnCreate(mixerPlayable);
        
        behaviours.Clear();
        
        return mixerPlayable;   
    }

    protected override Playable CreatePlayable(PlayableGraph graph, GameObject gameObject, TimelineClip clip)
    {
        var handle = base.CreatePlayable(graph, gameObject, clip);

        var inputPlayable = (ScriptPlayable<ZPlayableBehaviour>)handle;

        if (inputPlayable.GetBehaviour() is { } input)
        {
            input.SetClip(clip);
            input.parentTrack = this;
            behaviours.Add(input);    
        }
        
        return handle;
    }
}

public abstract class ZSkillTrackAsset<T> : ZTrackAsset<T>, IZPlayableAsset where T : ZMixerBehaviour, new()
{
    public abstract bool CanPlay(UnitSkin unit);
}

public interface IZPlayableAsset
{
    public bool CanPlay(UnitSkin unit);
}