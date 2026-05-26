using System;
using Sirenix.OdinInspector;
using UnityEngine;

[CreateAssetMenu(fileName = "CameraDimFxSettings", menuName = "Scriptable Object/CameraDimFxSettings", order = int.MaxValue)]
[InlineEditor(InlineEditorObjectFieldModes.Hidden)]
public class CameraDimFxSettings : FxSettings
{
    [LabelText("Camera Dim Settings")]
    public CameraDimFxSettingsProperties cameraDimFxSettingsProperties = new();
    
    public override void Apply(FxContext fxContext)
    {
        cameraDimFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable]
public class CameraDimFxSettingsProperties : FxSettingsProperties
{
    private bool _showReadOnly;

    public CameraDimFxSettingsProperties(bool showReadOnly = false)
    {
        _showReadOnly = showReadOnly;
        dimDuration = 0f;
        dimDelay = 0f;
    }
    
    [BoxGroup("Settings")]
    [EnableIf("_showReadOnly")]
    public float dimDuration;
    [BoxGroup("Settings")]
    public AnimationCurve ease = new(
        new Keyframe(0, 0),
        new Keyframe(0.3f, 1f),
        new Keyframe(0.7f, 1f),
        new Keyframe(1f, 0f)
    );
    [BoxGroup("Settings")]
    public Color dimColor = Color.grey;
    [BoxGroup("Settings")]
    [LabelText("Delay")]
    [HideInInspector]
    public float dimDelay;
    
    protected override void Apply(FxSettings.FxContext fxContext)
    {
        // if (dimDelay > 0)
        //     GameBoardManager.Get().Run(() => GameScene.Get().SetDimmedEffect(dimDuration), dimDelay);
        // else
        //     GameScene.Get().SetDimmedEffect(dimDuration);

        //FXSystem.RequestCameraDimFx(this, fxContext);
    }
}
