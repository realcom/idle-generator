using System;
using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Playables;

[Serializable]
public class ForceDisableSkillClip : DisableActionClip<DisableSkillBehaviour>
{
    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        var behaviour = template;
        return base.CreatePlayable(graph, owner);
    }
}