using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "OnShieldHeal", menuName = "Scriptable Object/OnShieldHealDispatchSetting", order = int.MaxValue)]
public class OnShieldHealDispatchSettings : FxEventDispatchSettings
{
    public override GameEventType EventType => GameEventType.FxEventDispatchOnShieldHeal;
}
