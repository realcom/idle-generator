using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class ZSkillPlayableBehaviour : ZPlayableBehaviour
{
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
