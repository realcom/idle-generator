using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

using KeyType = System.ValueTuple<int, System.Type, int>;

public class ZMixerBehaviour : PlayableBehaviour
{
    protected class PlayableClip
    {
        public int index;
        public float weight;
        public TimelineClip clip;
        public ScriptPlayable<ZPlayableBehaviour> playable;
    }

    private class ProcessFrameArgs
    {
        public Playable playable;
        public FrameData info;
        public object playerData;
    }
    
    private static readonly Dictionary<KeyType, List<ZMixerBehaviour>> Mixers = new();
    
    [NonSerialized]
    public TrackAsset parentTrack;
        
    protected IReadOnlyList<ZMixerBehaviour> mixers => Mixers[_key];
    
    protected readonly List<PlayableClip> playableClips = new();
    protected readonly List<PlayableClip> playableClipsInGroups = new();
    
    protected readonly List<PlayableClip> processedClips = new();

    private readonly ProcessFrameArgs processFrameArgs = new();

    private KeyType _key;
    private bool _isCoordinator;
    private bool _frameProceed;
    private bool _frameHappened;
    protected TimelineClip[] clips;
    
    protected virtual bool useGrouping => false;

    protected PlayableClip currentPlayableClip => playableClips.GetSafe(processedClips.Count, processedClips.GetSafe(processedClips.Count - 1));

    protected virtual void OnCreate()
    {
        
    }

    protected virtual void OnDestroy()
    {
        
    }
    
    protected virtual void OnFirstFrame(Playable playable, FrameData info, object playerData)
    {
        
    }
    
    protected virtual void OnProcessFrame(Playable playable, FrameData info, object playerData)
    {
        
    }
    
    public void SetClips(IEnumerable<TimelineClip> _clips)
    {
        this.clips = _clips?.ToArray() ?? Array.Empty<TimelineClip>();
    }
    
    public void OnCreate(Playable playable)
    {
        var director = (PlayableDirector)playable.GetGraph().GetResolver();
        var zPlayableDirector = director.gameObject.Get<ZPlayableDirector>();
        var type = GetType();
        _key = (director.GetInstanceID(), type, zPlayableDirector.강영찬);

        if (!Mixers.TryGetValue(_key, out var mixers))
            Mixers[_key] = mixers = new List<ZMixerBehaviour>();
        mixers.Add(this);

        processedClips.Clear();
        playableClips.Clear();
        
        for (var i = 0; i < clips.Length; i++)
        {
            playableClips.Add(new ()
            {
                index = i,
                clip = clips[i]
            });
        }

        if (useGrouping)
        {
            ZMixerBehaviour coordinatorMixer = null;
            for (var i = 0; i < mixers.Count; i++)
            {
                var mixer = mixers[i];
                mixer._isCoordinator = i == 0;
                if (mixer._isCoordinator)
                {
                    coordinatorMixer = mixer;
                    coordinatorMixer.playableClipsInGroups.Clear();
                }
                coordinatorMixer?.playableClipsInGroups.AddRange(mixer.playableClips);
            }
            coordinatorMixer?.playableClipsInGroups.Sort((a, b) => a.clip.start.CompareTo(b.clip.start));
        }
        else
        {
            _isCoordinator = true;
        }
        
        if (_isCoordinator)
            OnCreate();
    }
    
    public sealed override void OnPlayableCreate(Playable playable)
    {
        base.OnPlayableCreate(playable);
    }
    
    public sealed override void OnPlayableDestroy(Playable playable)
    {
        base.OnPlayableDestroy(playable);
        
        if (!Mixers.TryGetValue(_key, out var mixers))
            Mixers[_key] = mixers = new List<ZMixerBehaviour>();
        mixers.Remove(this);
        if (mixers.Count == 0)
            Mixers.Remove(_key);

        var isCoordinator = _isCoordinator;
        for (var i = 0; i < mixers.Count; i++)
        {
            var mixer = mixers[i];
            mixer._isCoordinator = i == 0;
        }
        playableClips.Clear();

        if (isCoordinator)
            OnDestroy();
    }

    private readonly Dictionary<int, float> preFrameWeightByIndexes = new();  
    public sealed override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        base.ProcessFrame(playable, info, playerData);

        foreach (var clip in playableClips)
        {
            var preWeight = preFrameWeightByIndexes.GetValueOrDefault(clip.index);
            preFrameWeightByIndexes[clip.index] = clip.weight = playable.GetInputWeight(clip.index);
            var input = playable.GetInput(clip.index);
            clip.playable = (ScriptPlayable<ZPlayableBehaviour>)input;
            var behaviour = clip.playable.GetBehaviour();
            
            switch (preWeight)
            {
                case > 0f when clip.weight <= 0f:
                    behaviour.OnPreBehaviourExit(input, info);
                    OnPlayableBehaviourExit(playable, info, behaviour);
                    break;
                case <= 0f when clip.weight > 0f:
                    behaviour.OnPreBehaviourEnter(input, info, playerData);
                    OnPlayableBehaviourEnter(playable, info, behaviour);
                    break;
            }
        }

        processFrameArgs.playable = playable;
        processFrameArgs.info = info;
        processFrameArgs.playerData = playerData;
        
        _frameProceed = true;
        
        if (useGrouping)
        {
            if (_isCoordinator)
            {
                processedClips.Clear();
                for (var i = 0; i < playableClipsInGroups.Count; i++)
                {
                    var playableClip = playableClipsInGroups[i];
                    if (playableClip.clip.end < playable.GetTime())
                        processedClips.Add(playableClip);
                }
            }
        }
        else
        {
            processedClips.Clear();
            for (var i = 0; i < playableClips.Count; i++)
            {
                var playableClip = playableClips[i];
                if (playableClip.clip.end < playable.GetTime())
                    processedClips.Add(playableClip);
            }
        }

        if (useGrouping)
        {
            if (!mixers.All(x => x._frameProceed))
                return;
            
            foreach (var mixer in mixers)
            {
                if (mixer._isCoordinator)
                {
                    if (!mixer._frameHappened)
                    {
                        mixer.OnFirstFrame(playable, info, playerData);
                        mixer._frameHappened = true;
                    }
                    mixer.OnProcessFrame(mixer.processFrameArgs.playable, mixer.processFrameArgs.info, mixer.processFrameArgs.playerData);
                }
                mixer._frameProceed = false;
            }
        }
        else
        {
            if (!_frameHappened)
            {
                OnFirstFrame(playable, info, playerData);
                _frameHappened = true;
            }
            OnProcessFrame(playable, info, playerData);
            _frameProceed = false;
        }
        
    }
    
    protected virtual void OnPlayableBehaviourEnter(Playable playable, FrameData info, ZPlayableBehaviour behaviour)
    {
        
    }
    
    protected virtual void OnPlayableBehaviourExit(Playable playable, FrameData info, ZPlayableBehaviour behaviour)
    {
        
    }

    public virtual void InitBehaviourBinding(GameObject go)
    {
        
    }
}
