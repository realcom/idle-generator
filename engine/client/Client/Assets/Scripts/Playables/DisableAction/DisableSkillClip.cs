using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Serialization;

[Serializable]
public class DisableSkillClip : DisableActionClip<DisableSkillBehaviour>
{
    [HideInInspector]
    [FormerlySerializedAs("disableOrder")] 
    public int priority = 1;
    
    // public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    // {
    //     var behaviour = template;
    //     behaviour.priority = priority;        
    //     return base.CreatePlayable(graph, owner);
    // }
}