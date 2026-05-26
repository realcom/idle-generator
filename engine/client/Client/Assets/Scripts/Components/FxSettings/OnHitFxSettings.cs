using System;
using System.Collections;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(fileName = "OnHitSettings", menuName = "Scriptable Object/OnHitSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class OnHitFxSettings : FxSettings
{
    [TabGroup("피격자 세팅")]
    [LabelText("Effect Settings")]
    public AnimationFxSettingsProperties animationFxSettingsPropertiesAttacked = new();
    
    [TabGroup("피격자 세팅")]
    [LabelText("Audio Settings")]
    public AudioFxSettingsProperties audioFxSettingsPropertiesAttacked = new();
    
    [TabGroup("피격자 세팅")]
    [LabelText("Camera Shake Settings")]
    public CameraShakeFxSettingsProperties cameraShakeFxSettingsPropertiesAttacked = new(true);
    
    [TabGroup("피격자 세팅")]
    [LabelText("Camera Zoom Settings")]
    public CameraZoomFxSettingsProperties cameraZoomFxSettingsPropertiesAttacked = new(true);
    
    [TabGroup("피격자 세팅")]
    [LabelText("Camera Dim Settings")]
    public CameraDimFxSettingsProperties cameraDimFxSettingsPropertiesAttacked = new(true);
    
    [TabGroup("피격자 세팅")]
    [LabelText("Timescale FX Settings")]
    public TimeScaleFxSettingsProperties timeScaleFxSettingsPropertiesAttacked = new(true);


    // Attacker Settings
    [TabGroup("공격자 세팅")]
    [LabelText("Effect Settings")]
    public AnimationFxSettingsProperties animationFxSettingsPropertiesAttacker = new();
    
    [TabGroup("공격자 세팅")]
    [LabelText("Audio Settings")]
    public AudioFxSettingsProperties audioFxSettingsPropertiesAttacker = new();
    
    [TabGroup("공격자 세팅")]
    [LabelText("Camera Shake Settings")]
    public CameraShakeFxSettingsProperties cameraShakeFxSettingsPropertiesAttacker = new(true);
    
    [TabGroup("공격자 세팅")]
    [LabelText("Camera Zoom Settings")]
    public CameraZoomFxSettingsProperties cameraZoomFxSettingsPropertiesAttacker = new(true);
    
    [TabGroup("공격자 세팅")]
    [LabelText("Camera Dim Settings")]
    public CameraDimFxSettingsProperties cameraDimFxSettingsPropertiesAttacker = new(true);
    
    [TabGroup("공격자 세팅")]
    [LabelText("Timescale FX Settings")]
    public TimeScaleFxSettingsProperties timeScaleFxSettingsPropertiesAttacker = new(true);
    
    public override void Apply(FxContext fxContext)
    {
        animationFxSettingsPropertiesAttacked.TryApply(fxContext);
        audioFxSettingsPropertiesAttacked.TryApply(fxContext);
        cameraShakeFxSettingsPropertiesAttacked.TryApply(fxContext);
        cameraZoomFxSettingsPropertiesAttacked.TryApply(fxContext);
        cameraDimFxSettingsPropertiesAttacked.TryApply(fxContext);
        timeScaleFxSettingsPropertiesAttacked.TryApply(fxContext);

        var attackerUnitObject = GameBoardManager.Get().GetUnitByID(fxContext.fxGeneratingSkill?.Sender?.Id ?? 0);
        
        if (!attackerUnitObject || attackerUnitObject.syncId == 0)
            return;
        
        var attackerFxContext = new FxContext(fxContext.authorEvent, attackerUnitObject, fxContext.fxGeneratingSkill);
        
        animationFxSettingsPropertiesAttacker.TryApply(attackerFxContext);
        audioFxSettingsPropertiesAttacker.TryApply(attackerFxContext);
        cameraShakeFxSettingsPropertiesAttacker.TryApply(attackerFxContext);
        cameraZoomFxSettingsPropertiesAttacker.TryApply(attackerFxContext);
        cameraDimFxSettingsPropertiesAttacker.TryApply(attackerFxContext);
        timeScaleFxSettingsPropertiesAttacker.TryApply(attackerFxContext);
    }
}

[Serializable]
public class TimeScaleFxSettingsProperties : FxSettingsProperties
{
    private bool _showReadOnly;

    public TimeScaleFxSettingsProperties(bool showReadOnly = false)
    {
        _showReadOnly = showReadOnly;
        triggerType = EffectTriggerType.LOCAL;
        boardSpeed = 1f;
        editorSpeed = 1f;
        duration = 0f;
    }
    
    public TimeScaleFxSettingsProperties(float boardSpeed, float editorSpeed, float duration)
    {
        triggerType = EffectTriggerType.LOCAL;
        this.boardSpeed = boardSpeed;
        this.editorSpeed = editorSpeed;
        this.duration = duration;
    }
    
    [BoxGroup("Settings")]
    public float boardSpeed;
    
    [BoxGroup("Settings")]
    public float editorSpeed;
    
    [BoxGroup("Settings")]
    [ShowIf("_showReadOnly")]
    public float duration;


    protected override void Apply(FxSettings.FxContext fxContext)
    {
        FXSystem.RequestTimeScaleFx(this, fxContext);
    }

    protected override bool CanApply(FxSettings.FxContext fxContext)
    {
        return duration > 0f && base.CanApply(fxContext);
    }
}