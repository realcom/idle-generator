using System;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "AudioFxSettings", menuName = "Scriptable Object/AudioFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class AudioFxSettings : FxSettings
{
    [LabelText("Audio Settings")]
    public AudioFxSettingsProperties audioFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        audioFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class AudioFxSettingsProperties : FxSettingsProperties
{
    [BoxGroup("Settings")]
    [LabelText("AudioClip")]
    public AudioClip audioClip;
    [BoxGroup("Settings")]
    [LabelText("Volume")]
    public float volume = 1.0f;
    
    protected override void Apply(FxSettings.FxContext fxContext)
    {
        if (audioClip == null)
            return;
        
        // var fxApplyTransform = fxContext.fxApplyTransform ? fxContext.fxApplyTransform :
        //     fxContext.fxApplyingUnit ? fxContext.fxApplyingUnit.transform : GameBoardManager.Get().transform;
        var fxApplyTransform = fxContext.fxApplyingUnitObject ? fxContext.fxApplyingUnitObject.transform : GameBoardManager.Get().transform;
        var fxApplyTransformPos = fxApplyTransform.position;

        AudioManager.Get().PlayFX(audioClip, audioClip.name, 0, fxApplyTransform, fxApplyTransformPos, volume: volume);
    }
}
