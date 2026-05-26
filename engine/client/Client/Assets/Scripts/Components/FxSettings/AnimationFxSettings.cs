using System;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "Animation Effect Settings", menuName = "Scriptable Object/Animation Effect Settings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class AnimationFxSettings : FxSettings
{

    public AnimationFxSettingsProperties animationFxSettingsProperties = new();

    public override void Apply(FxContext fxContext)
    {
        animationFxSettingsProperties.TryApply(fxContext);
    }
    
}

[Serializable]
public class AnimationFxSettingsProperties : FxSettingsProperties
{
    [BoxGroup("Settings")]
    public string effectName;
    [BoxGroup("Settings")]
    public GameObject effectPrefab;
    [BoxGroup("Settings")]
    public GameObject criticalEffectPrefab;
    [BoxGroup("Settings")]
    public Vector3 positionOffset;
    [BoxGroup("Settings")]
    public Quaternion rotationOffset;
    [BoxGroup("Settings")] 
    public Vector3 scaleOffset = Vector3.one;
    [BoxGroup("Settings")]
    public bool followUnitDirection;
    [BoxGroup("Settings")]
    [HideInInspector]
    public bool syncAnimationSpeed;
    [BoxGroup("Settings")]
    public bool parentAsWorld = true;
    [BoxGroup("Settings")]
    public bool independentOfTimeline = true;
    
    [BoxGroup("Settings")]
    [HideInInspector]
    public Vector3 adjustToFloorOffset;
    [BoxGroup("Settings")]
    [HideInInspector]
    public bool useCollisionContact;

    [BoxGroup("Settings")] 
    public bool useCustomDuration = true;
    [BoxGroup("Settings"), EnableIf(nameof(useCustomDuration))] [FormerlySerializedAs("destroyAfter")] 
    public float duration = 2f;

    protected override void Apply(FxSettings.FxContext fxContext)
    {
        FXSystem.RequestAnimationFx(this, fxContext);
    }
    
    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        // if (!effectPrefab)
        //     Debug.LogError($"AnimationFxSettingsProperties {fxContext.fxGeneratingSkill?.ResSkill?.Id}: effectPrefab is null");
        
        return GetPrefab(fxContext) && base.CanApply(fxContext);
    }

    public GameObject GetPrefab(FxSettings.FxContext fxContext)
    {
        return fxContext.authorEvent?.IsSpecial == true ? criticalEffectPrefab : effectPrefab; 
    }
    
}