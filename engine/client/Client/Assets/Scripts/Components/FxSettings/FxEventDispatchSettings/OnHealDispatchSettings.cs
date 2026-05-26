using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "OnHeal", menuName = "Scriptable Object/OnHealDispatchSetting", order = int.MaxValue)]
public class OnHealDispatchSettings : FxEventDispatchSettings
{
    public override GameEventType EventType => GameEventType.FxEventDispatchOnHeal;
}