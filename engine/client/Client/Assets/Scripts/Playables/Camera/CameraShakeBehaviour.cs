using System;
using Cinemachine;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using Random = System.Random;

[Serializable]
public class CameraShakeBehaviour : CameraBaseBehaviour<CameraShakeFxSettings>
{
    // public CameraShakeFxSettings cameraShakeFxSettings;
    
    public override void OnBeforeCreate(PlayableGraph graph, GameObject owner)
    {
        base.OnBeforeCreate(graph, owner);
    }
}
