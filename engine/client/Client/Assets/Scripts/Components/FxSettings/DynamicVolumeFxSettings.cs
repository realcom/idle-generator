using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(fileName = "DynamicVolumeFxSettings", menuName = "Scriptable Object/DynamicVolumeFxSettings", order = int.MaxValue)]
[Serializable, InlineEditor(objectFieldMode: InlineEditorObjectFieldModes.Hidden)]
public class DynamicVolumeFxSettings : FxSettings
{
    public DynamicVolumeFxSettingsProperties dynamicVolumeFxSettingsProperties = new();

    public override void Apply(FxContext fxContext)
    {
        dynamicVolumeFxSettingsProperties.TryApply(fxContext);
    }
}

[Serializable, DisplayName("글로벌 볼륨 설정 속성")]
public class DynamicVolumeFxSettingsProperties : FxSettingsProperties
{
    public VolumeProfile profile;
    public AnimationCurve weightCurve = AnimationCurve.Linear(0, 1, 1, 1);

    public float duration = 1f;

    protected override void Apply(FxSettings.FxContext fxContext)
    {
        FXSystem.RequestGlobalVolumeFx(this, fxContext);
    }
}