using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class ZSkillMixerBehaviour : ZMixerBehaviour
{
    [NonSerialized]
    protected UnitSkin unit = null;
    
    private void SetUnit(UnitSkin unitSkin)
    {
        unit = unitSkin;
    }
    
    public override void InitBehaviourBinding(GameObject go)
    {
        base.InitBehaviourBinding(go);
        
        SetUnit(go.Get<UnitSkin>());
    }
}
