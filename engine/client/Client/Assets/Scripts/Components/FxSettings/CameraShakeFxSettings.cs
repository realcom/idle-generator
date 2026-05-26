using System;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "CameraShakeFxSettings", menuName = "Scriptable Object/CameraShakeFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class CameraShakeFxSettings : FxSettings
{
    // [FormerlySerializedAs("cameraShakeSelf")]
    // [BoxGroup("Camera Shake Settings")]
    // [LabelText("Magnitude")]
    // public float cameraShakeMagnitude;
    // [BoxGroup("Camera Shake Settings")]
    // [LabelText("Delay")]
    // public float cameraShakeDelay;
    
    [LabelText("Camera Shake Settings")]
    public CameraShakeFxSettingsProperties cameraShakeFxSettingsProperties  = new();
    
    public override void Apply(FxContext fxContext)
    {
        cameraShakeFxSettingsProperties.TryApply(fxContext);
    }
    
//     public override void MigrateValuesToProperties()
//     {
//         cameraShakeFxSettingsProperties.cameraShakeMagnitude = this.cameraShakeMagnitude;
//         cameraShakeFxSettingsProperties.cameraShakeDelay = this.cameraShakeDelay;
//         
// #if UNITY_EDITOR
//         UnityEditor.EditorUtility.SetDirty(this);
// #endif
//     }
}

[Serializable]
public class CameraShakeFxSettingsProperties : FxSettingsProperties
{
    private bool _showReadOnly;

    public CameraShakeFxSettingsProperties(bool showReadOnly = false)
    {
        _showReadOnly = showReadOnly;
        cameraShakeMagnitude = 0f;
        cameraShakeDuration = 0f;
    }
    
    [FormerlySerializedAs("cameraShakeSelf")]
    [BoxGroup("Settings")]
    [LabelText("Magnitude")]
    public float cameraShakeMagnitude;
    [BoxGroup("Settings")]
    [EnableIf("_showReadOnly")]
    public float cameraShakeDuration;
    
    protected override void Apply(FxSettings.FxContext fxContext)
    {
        //
        // void CameraShake()
        // {
        //     if (cameraShakeMagnitude > 0f)
        //         // GameBoardManager.Get().StartCoroutine(PlayerCamera.Get().Shake(cameraShakeSelf, direction: dir));
        //         GameBoardManager.Get().StartCoroutine(PlayerCamera.Get().Shake(cameraShakeMagnitude, cameraShakeDuration));
        // }

        // if (cameraShakeDelay > 0)
        //     GameBoardManager.Get().Run(CameraShake, cameraShakeDelay);
        // else
        //     CameraShake();
        //if (cameraShakeMagnitude > 0f)
        //    FXSystem.RequestCameraShakeFx(this, fxContext);
    }
    
    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        // if (cameraShakeMagnitude <= 0f)
        //     Debug.LogError($"CameraShakeFxSettings {fxContext.fxGeneratingSkill?.ResSkill?.Id}: cameraShakeMagnitude is less than or equal to 0");
        
        return cameraShakeMagnitude > 0f && base.CanApply(fxContext);
    }
}