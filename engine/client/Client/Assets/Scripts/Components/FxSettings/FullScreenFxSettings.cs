using System;
using System.Collections;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "FullScreenFxSettings", menuName = "Scriptable Object/FullScreenFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class FullScreenFxSettings : FxSettings
{
    [LabelText("Full Screen Fx Settings")]
    public FullScreenFxSettingsProperties fullScreenFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        fullScreenFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class FullScreenFxSettingsProperties : FxSettingsProperties
{
    [BoxGroup("Settings")]
    public Material fxMaterial;

    [BoxGroup("Settings")]
    public AnimationCurve factorCurve = AnimationCurve.Linear(0, 0, 1, 1);
    
    [BoxGroup("Settings")]
    [ReadOnly]
    public float duration = 0f;


    protected override void Apply(FxSettings.FxContext fxContext)
    {
        //FXSystem.RequestFullScreenFx(this, fxContext);
    }

    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        if (!fxMaterial)
            Debug.LogError($"FullScreenFxSettings {fxContext.fxGeneratingSkill?.ResSkill?.Id}: fxMaterial is null");
        
        return fxMaterial && base.CanApply(fxContext);
    }
    
}
