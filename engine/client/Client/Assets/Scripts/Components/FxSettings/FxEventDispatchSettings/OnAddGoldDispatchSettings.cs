using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "OnAddGold", menuName = "Scriptable Object/OnAddGoldDispatchSetting", order = int.MaxValue)]
public class OnAddGoldDispatchSettings : FxEventDispatchSettings
{
    public override GameEventType EventType => GameEventType.FxEventDispatchOnAddGold;
}