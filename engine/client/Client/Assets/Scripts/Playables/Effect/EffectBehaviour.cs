using System;
using System.Collections.Generic;
using Sirenix.Utilities;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Serialization;
using UnityEngine.Timeline;

[Serializable]
public class EffectBehaviour : ZFxPlayableBehaviour<AnimationFxSettings>
{
    // [FormerlySerializedAs("fxSettings")] [FormerlySerializedAs("effectSettings")] public AnimationFxSettings animationFxSettings; 
    [HideInInspector]
    public bool isIndependent = false;

    private GameObject _effectInstance;
    private ParticleSystem[] _particleSystems = Array.Empty<ParticleSystem>();
    private ParticleSystem[] _randomSeedParticleSystems = Array.Empty<ParticleSystem>();
    private ParticleSystem _rootParticleSystem = null;
    
    private bool excludeFromLogic => isIndependent && Application.isPlaying;

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        base.ProcessFrame(playable, info, playerData);

        // if (!excludeFromLogic && _rootParticleSystem)
        // {
        //     var time = (float)playable.GetTime();
        //     _rootParticleSystem.Simulate(time);
        // }
    }

    private static readonly List<ParticleSystem> randomSeedParticleSystems = new();
    private bool TryInitParticle()
    {
        // if (_effectInstance)
        //     return true;
        //
        //
        // if (!unit || !fxSettings)
        //     return false;
        //
        // // var initParentTransform = unit.old_GetDummyTransform(fxSettings.animationFxSettingsProperties.dummyPositionType);
        // var initParentTransformData = unit.GetDummyTransformData(fxSettings.animationFxSettingsProperties.dummyPositionType);
        // var initParentTransform = initParentTransformData.baseTransform;
        // var initParentTransformOffset = initParentTransformData.positionOffset;
        // var initParentTransformRotationOffset = initParentTransformData.rotationOffset;
        //
        // if (fxSettings.animationFxSettingsProperties.effectPrefab == null)
        //     return false;
        // _effectInstance = (GameObject)GameObject.Instantiate(fxSettings.animationFxSettingsProperties.effectPrefab, initParentTransform.position + initParentTransformOffset , initParentTransform.rotation * initParentTransformRotationOffset, initParentTransform);
        // if (!_effectInstance)
        //     return false;
        //
        // _particleSystems = _effectInstance.GetComponentsInChildren<ParticleSystem>() ?? Array.Empty<ParticleSystem>();
        // if (_particleSystems.Length > 0)
        // {
        //     _rootParticleSystem = _particleSystems.GetSafe(0);
        //     _rootParticleSystem.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
        //     randomSeedParticleSystems.Clear();
        //     foreach (var ps in _particleSystems)
        //     {
        //         if (ps.useAutoRandomSeed)
        //         {
        //             ps.useAutoRandomSeed = false;
        //             randomSeedParticleSystems.Add(ps);
        //         }
        //     }
        //     _randomSeedParticleSystems = randomSeedParticleSystems.ToArray();            
        // }
        //
        // var transform = _effectInstance.transform;
        //     
        // transform.position = initParentTransform.TransformPoint(fxSettings.animationFxSettingsProperties.positionOffset);
        // transform.rotation = initParentTransform.rotation * fxSettings.animationFxSettingsProperties.rotationOffset;
        // transform.localScale = fxSettings.animationFxSettingsProperties.scaleOffset;
        //
        // // if (_effectInstance.GetComponent<PoolableObject>() == null)
        // //     Debug.LogWarning($"{fxSettings.animationFxSettingsProperties.effectPrefab.name}: Effect Prefab Instantiated without PoolableObject.");

        return true;
    }

    protected override void OnFirstFrame(Playable playable, FrameData info, object playerData)
    {
        base.OnFirstFrame(playable, info, playerData);
        
        // TryInitParticle();
    }

    public override void OnPlayableDestroy(Playable playable)
    {
        // if (_effectInstance && !excludeFromLogic)
        // {
        //     _effectInstance.SetActive(false);
        //
        //     if (_rootParticleSystem)
        //     {
        //         _rootParticleSystem.Stop();
        //         foreach (var ps in _randomSeedParticleSystems)
        //         {
        //             ps.useAutoRandomSeed = true;
        //         }
        //     }
        //
        //     GameObject.DestroyImmediate(_effectInstance);
        //     _effectInstance = null;            
        // }
        
        base.OnPlayableDestroy(playable);
    }

    protected override void OnBehaviourEnter(Playable playable, FrameData info, object playerData)
    {
        base.OnBehaviourEnter(playable, info, playerData);
        
        // if (!TryInitParticle())
        //     return;
        //
        // if (excludeFromLogic)
        //     GameContainer.Get()?.Run(() =>
        //     {
        //         ObjectPoolController.Destroy(_effectInstance);
        //         _effectInstance = null;
        //     }, fxSettings.animationFxSettingsProperties.duration);
        //
        // _effectInstance.SetActive(true);
        // if (_rootParticleSystem)
        // {
        //     _rootParticleSystem.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
        //     foreach (var ps in _randomSeedParticleSystems)
        //     {
        //         ps.randomSeed = (uint)UnityEngine.Random.Range(0, uint.MaxValue);
        //     }
        //     _rootParticleSystem.Play();   
        // }
    }

    protected override void OnBehaviourExit(Playable playable, FrameData info)
    {
        // if (_effectInstance && !excludeFromLogic)
        // {
        //     if (_rootParticleSystem)
        //         _rootParticleSystem.Stop();
        //     _effectInstance.SetActive(false);    
        // }
        
        base.OnBehaviourExit(playable, info);
    }

    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        base.OnBehaviourPlay(playable, info);

        // if (!TryInitParticle())
        //     return;
        //
        // if (fxSettings.animationFxSettingsProperties.parentAsWorld)
        // {
        //     RefreshTransformAsWorld();
        // }
    }

    private void RefreshTransformAsWorld()
    {
        // var rootTransform = unit.old_GetDummyTransform(fxSettings.animationFxSettingsProperties.dummyPositionType);
        
        // var rootTransformData = unit.GetDummyTransformData(fxSettings.animationFxSettingsProperties.dummyPositionType);
        // var rootTransform = rootTransformData.baseTransform;
        // var rootTransformOffset = rootTransformData.positionOffset;
        // var rootTransformRotationOffset = rootTransformData.rotationOffset;
        //     
        // var particleTransform = _effectInstance.transform;
        //     
        // particleTransform.position = rootTransform.TransformPoint(fxSettings.animationFxSettingsProperties.positionOffset + rootTransformOffset);
        // particleTransform.rotation = rootTransform.rotation * rootTransformRotationOffset * fxSettings.animationFxSettingsProperties.rotationOffset ;
        // particleTransform.localScale = fxSettings.animationFxSettingsProperties.scaleOffset;
        //
        // Transform worldParent = null;
        //
        // if (GameContainer.Get() is { } gameContainer)
        //     worldParent = gameContainer.transform;
        // particleTransform.SetParent(worldParent);
        //
        // if (fxSettings.animationFxSettingsProperties.followUnitDirection)
        //     particleTransform.rotation = unit.transform.rotation * fxSettings.animationFxSettingsProperties.rotationOffset;
    }
    
}

public static class ParticleBehaviourExtension
{
}
