using System;
using System.Collections;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "ShaderPropertyFxSettings", menuName = "Scriptable Object/ShaderPropertyFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class ShaderPropertyFxSettings : FxSettings
{
    [LabelText("Shader Property Fx Settings")]
    public ShaderPropertyFxSettingsProperties shaderPropertyFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        shaderPropertyFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class ShaderPropertyFxSettingsProperties : FxSettingsProperties
{
    [BoxGroup("Settings")]
    public bool useCutOff = false;
    [BoxGroup("Settings"), ShowIf("useCutOff")]
    public AnimationCurve cutOff = AnimationCurve.Linear(0, 0, 1, 1);
    [BoxGroup("Settings"), ShowIf("useCutOff")]
    [ColorUsage(false, true)]
    public Color dissolveColor = Color.white;

    [BoxGroup("Settings")]
    public bool useEmission = false;
    [BoxGroup("Settings"), ShowIf("useEmission")]
    [ColorUsage(false, true)]
    public Color emissionColor = Color.white;
    [BoxGroup("Settings"), ShowIf("useEmission")]
    public AnimationCurve emissionFactor = AnimationCurve.Linear(0, 0, 1, 1);
    
    [BoxGroup("Settings")] 
    public bool useRim = false;
    [BoxGroup("Settings"), ShowIf("useRim")]
    [ColorUsage(false, true)]
    public Color rimColor = Color.white;
    [BoxGroup("Settings"), ShowIf("useRim")] 
    public AnimationCurve rimPower = AnimationCurve.Linear(0, 0, 1, 1);
    [BoxGroup("Settings"), ShowIf("useRim")]
    public AnimationCurve rimFactor = AnimationCurve.Linear(0, 0, 1, 1);
    
    [BoxGroup("Settings")]
    [ReadOnly]
    public float duration = 0f;

    protected override void Apply(FxSettings.FxContext fxContext)
    {
        //FXSystem.RequestShaderPropertyFx(this, fxContext);
    }

    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        return base.CanApply(fxContext);
    }
    
}
