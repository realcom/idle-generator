using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public abstract class CameraBaseBehaviour<TFxSettings> : ZFxPlayableBehaviour<TFxSettings> where TFxSettings : FxSettings
{
    // public enum ExecutionRole
    // {
    //     Global,
    //     Self
    // };
    //
    // public ExecutionRole role = ExecutionRole.Global;

    // public bool canExecute => role == ExecutionRole.Global || (unit?.old_unit?.isLocalPlayer ?? false);
    public bool canExecute => true;

}
