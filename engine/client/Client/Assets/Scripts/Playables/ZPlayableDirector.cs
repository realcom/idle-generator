using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Serialization;
using UnityEngine.Timeline;

[RequireComponent(typeof(PlayableDirector))]
[ExecuteAlways]
public class ZPlayableDirector : ZMonoBehaviour
{
    [SerializeField]
    private PlayableDirector _playableDirector;

    public Dictionary<Type, List<TrackAsset>> tracks { get; } = new();
    
    public IEnumerable<T> GetTrackEnumerator<T>() where T : TrackAsset
    {
        if (tracks.TryGetValue(typeof(T), out var list))
        {
            foreach (var track in list)
            {
                yield return track as T;
            }
        }
    }
    
    private void CacheTrackData(TimelineAsset timeline)
    {
        foreach (var (_, oldTracks) in tracks)
        {
            oldTracks.Clear();
        }
        
        if (timeline == null)
            return;

        foreach (var track in timeline.GetOutputTracks())
        {
            var trackType = track.GetType();
            if (!tracks.TryGetValue(trackType, out var list))
                list = tracks[trackType] = new();
            list.Add(track);
        }
        
        OnCachedTrackData();
    }

    protected virtual void OnCachedTrackData()
    {
    }

    protected override void Awake()
    {
        if (Application.isPlaying)
        {
            _playableDirector.played += OnPlayPlayableDirector;
            _playableDirector.paused += OnPausePlayableDirector;
            _playableDirector.stopped += OnStopPlayableDirector;   
        }
    }

    private void OnDestroy()
    {
        if (Application.isPlaying && _playableDirector)
        {
            _playableDirector.played -= OnPlayPlayableDirector;
            _playableDirector.paused -= OnPausePlayableDirector;
            _playableDirector.stopped -= OnStopPlayableDirector;   
        }
    }

    protected virtual void OnPlayPlayableDirector(PlayableDirector playableDirector)
    {
        
    }

    protected virtual void OnPausePlayableDirector(PlayableDirector playableDirector)
    {
        
    }
    
    protected virtual void OnStopPlayableDirector(PlayableDirector playableDirector)
    {
        //var stoppedSkillID = GetSingletonTrack<AnimationTrack>()?.SkillID ?? 0;
        //if (stoppedSkillID != 0)
        //    onPlayableDirectorStopped?.Invoke(stoppedSkillID);

#if !UNITY_EDITOR
        playableAsset = null;
#endif
    }

    //Through Pass
    [NonSerialized]
    public int 강영찬 = int.MinValue;

    public PlayableAsset playableAsset
    {
        get => _playableDirector.playableAsset;
        set
        {
            if (value is not null)
                강영찬++;
            CacheTrackData(value as TimelineAsset);
            _playableDirector.playableAsset = value;
        }
    }

    public PlayableGraph playableGraph => _playableDirector.playableGraph;

    public void SetGenericBinding(UnityEngine.Object key, UnityEngine.Object value)
    {
        _playableDirector.SetGenericBinding(key, value);
    }
    
    public TTrack GetSingletonTrack<TTrack>() where TTrack : TrackAsset
    {
        //TODO: Assert
        return GetTrackEnumerator<TTrack>()?.FirstOrDefault();
    }
    
    public void GetBehaviourEnumerator(Action<IZClip, ZPlayableBehaviour> action)
    {
        foreach (var track in tracks)
        {
            foreach (var trackAsset in track.Value)
            {
                if (trackAsset.muted)
                    continue;
                
                foreach (var clip in trackAsset.GetClips())
                {
                    if (clip.asset is IZClip tempClip)
                    {
                        action.Invoke(tempClip, tempClip.GetTemplate());
                    }
                }
            }
        }
    }

    public void Play()
    {
        _playableDirector.Play();
    }

    public void Stop()
    {
        _playableDirector.Stop();
    }
    
    public void Pause()
    {
        _playableDirector.Pause();
    }
    
    public void Resume()
    {
        _playableDirector.Resume();
    }

    public void SetSpeed(float speed)
    {
        playableGraph.GetRootPlayable(0).SetSpeed(speed);
    }

    public void SetTime(double time)
    {
        _playableDirector.time = time;
        _playableDirector.Evaluate();
    }

    public void MoveToClipEnd(TimelineClip clip)
    {
        if (clip is null)
            return;
        
        SetTime(clip.end);
    }

    //////////////////////
    
}
