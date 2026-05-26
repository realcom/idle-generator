using System;
using Sirenix.OdinInspector;
using UnityEngine;

// [CreateAssetMenu(fileName = "TimeScaleFxSettings", menuName = "Scriptable Object/TimeScaleFxSettings", order = int.MaxValue)]
// [InlineEditor(InlineEditorObjectFieldModes.Hidden)]
// public class TimeScaleFxSettings : FxSettings
// {
//     [LabelText("Timescale Fx Settings")]
//     public TimeScaleFxSettingsProperties timeScaleFxSettingsProperties = new();
//     
//     public override void Apply(FxContext fxContext)
//     {
//         timeScaleFxSettingsProperties.TryApply(fxContext);
//     }
// }

// [Serializable]
// public class TimeScaleFxSettingsProperties : FxSettingsProperties
// {
//     
//     public TimeScaleFxSettingsProperties(float boardSpeed, float editorSpeed, float duration)
//     {
//         triggerType = EffectTriggerType.LOCAL;
//         this.boardSpeed = boardSpeed;
//         this.editorSpeed = editorSpeed;
//         this.duration = duration;
//     }
//     
//     [BoxGroup("Settings")]
//     public float boardSpeed;
//     
//     [BoxGroup("Settings")]
//     public float editorSpeed;
//     
//     [BoxGroup("Settings")]
//     public float duration;
//
//
//     protected override void Apply(FxSettings.FxContext fxContext)
//     {
//         FXSystem.RequestTimeScaleFx(this, fxContext);
//     }
//     
// }
