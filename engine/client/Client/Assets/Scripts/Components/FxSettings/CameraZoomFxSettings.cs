using System;
using System.Collections;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;

[CreateAssetMenu(fileName = "CameraZoomFxSettings", menuName = "Scriptable Object/CameraZoomFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class CameraZoomFxSettings : FxSettings
{
    [LabelText("Camera Zoom Settings")]
    public CameraZoomFxSettingsProperties cameraZoomFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        cameraZoomFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class CameraZoomFxSettingsProperties : FxSettingsProperties
{
    private bool _showReadOnly;
    
    public CameraZoomFxSettingsProperties(bool showReadOnly = false)
    {
        _showReadOnly = showReadOnly;
        cameraZoomRatio = 0f;
        cameraZoomDelay = 0f;
        cameraZoomDuration = 0f;
        cameraZoomOffset = Vector2.zero;
        cameraZoomEase = AnimationCurve.Linear(0, 0, 1, 1);
    }
    
    [BoxGroup("Settings")]
    [LabelText("Ratio Value (0.5일 때 현재 fov의 절반)")]
    public float cameraZoomRatio;
    [HideInInspector]
    public float cameraZoomDelay;
    // [HideInInspector]
    [BoxGroup("Settings")]
    [EnableIf("_showReadOnly")]
    public float cameraZoomDuration;
    [BoxGroup("Settings")]
    [LabelText("Local Offset (화면 상 +x = 오른쪽, +y = 위쪽)")]
    public Vector2 cameraZoomOffset;
    [BoxGroup("Settings")]
    [LabelText("Ease")]
    public AnimationCurve cameraZoomEase;
    
    protected override void Apply(FxSettings.FxContext fxContext)
    {
        //FXSystem.RequestCameraZoomFx(this, fxContext);
    }
    
    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        return cameraZoomDuration > 0f && base.CanApply(fxContext);
    }
}
