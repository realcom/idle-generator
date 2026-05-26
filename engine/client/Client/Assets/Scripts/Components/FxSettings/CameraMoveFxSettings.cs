using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;
using Object = UnityEngine.Object;

[CreateAssetMenu(fileName = "CameraMoveFxSettings", menuName = "Scriptable Object/CameraMoveFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class CameraMoveFxSettings : FxSettings
{
    [LabelText("Camera Move Settings")]
    public CameraMoveFxSettingsProperties cameraMoveFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        cameraMoveFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class CameraMoveFxSettingsProperties : FxSettingsProperties
{
    private bool _showReadOnly;
    
    public CameraMoveFxSettingsProperties(bool showReadOnly = false)
    {
        _showReadOnly = showReadOnly;
        cameraMoveDuration = 0f;
        cameraMoveEase = AnimationCurve.Linear(0, 0, 1, 1);
    }
    
    [BoxGroup("Settings")]
    public bool rotate;
    [BoxGroup("Settings")]
    [EnableIf("_showReadOnly")]
    public float cameraMoveDuration;
    [BoxGroup("Settings")]
    [LabelText("Ease")]
    public AnimationCurve cameraMoveEase;
    
    protected override void Apply(FxSettings.FxContext fxContext)
    {
        //FXSystem.RequestCameraMoveFx(this, fxContext);
    }
    
    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        return cameraMoveDuration > 0f && base.CanApply(fxContext);
    }
}
