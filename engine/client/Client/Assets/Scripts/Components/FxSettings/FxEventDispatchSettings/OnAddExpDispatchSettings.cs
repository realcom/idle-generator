using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "OnAddExp", menuName = "Scriptable Object/OnAddExpDispatchSetting", order = int.MaxValue)]
public class OnAddExpDispatchSettings : FxEventDispatchSettings
{
    public override GameEventType EventType => GameEventType.FxEventDispatchOnAddExp;
}
