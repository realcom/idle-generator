using System;
using System.Collections;
using Cinemachine;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "CameraShakeFxSettings", menuName = "Scriptable Object/CameraShakeFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class AreaDisplayFxSettings : FxSettings
{
    [LabelText("Area Display Fx Settings")]
    public AreaDisplayFxSettingsProperties areaDisplayFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        areaDisplayFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class AreaDisplayFxSettingsProperties : FxSettingsProperties
{
    [BoxGroup("Settings")]
    public AnimationCurve fillCurve = AnimationCurve.Linear(0, 0, 1, 1);
    [BoxGroup("Settings")]
    public Mesh mesh;
    [BoxGroup("Settings")]
    public Vector2 size;
    [BoxGroup("Settings")]
    public Material material;
    [BoxGroup("Settings")]
    public Vector2 offset;
    [BoxGroup("Settings")]
    public bool followUnitRotation;
    [BoxGroup("Settings")]
    public Quaternion deltaRotation = Quaternion.identity;
    
    [BoxGroup("Settings")]
    [ReadOnly]
    public float duration;
    
    protected override void Apply(FxSettings.FxContext fxContext)
    {
        FXSystem.RequestAreaDisplayFx(this, fxContext);
    }
}
