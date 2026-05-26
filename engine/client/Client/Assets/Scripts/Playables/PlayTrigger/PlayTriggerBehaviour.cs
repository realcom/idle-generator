using System;
using UnityEngine;

[Serializable]
public class PlayTriggerBehaviour : ZSkillPlayableBehaviour
{
    #if UNITY_EDITOR
    [SerializeField]
    public TriggerSelector trigger = new();
    #endif
}
