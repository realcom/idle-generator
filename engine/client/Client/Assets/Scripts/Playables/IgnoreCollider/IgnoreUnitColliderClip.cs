using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class IgnoreUnitColliderClip : IgnoreColliderClip<IgnoreUnitColliderBehaviour>
{

}

public class IgnoreUnitColliderBehaviour : IgnoreColliderBehaviour
{
    protected override void IgnoreCollider()
    {
        //if (unit)
        //    unit.old_unit?.ExcludeUnitCollider();
    }
    
    protected override void UndoIgnoreCollider()
    {
        //if (unit)
        //    unit.old_unit?.IncludeUnitCollider();
    }
}

