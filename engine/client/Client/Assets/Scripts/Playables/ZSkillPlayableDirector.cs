using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Timeline;

public class ZSkillPlayableDirector : ZPlayableDirector
{
    [NonSerialized]
    public AnimationTrack RootAnimationTrack = null;

    protected override void OnCachedTrackData()
    {
        base.OnCachedTrackData();

        foreach (var (_, tracksByType) in tracks)
        {
            foreach (var track in tracksByType)
            {
                if (track is IZPlayableAsset asset)
                {
                    if (!asset.CanPlay(this.Get<UnitSkin>()))
                    {
                        track.muted = true;
                    }
                }
            }
        }
    }
}
