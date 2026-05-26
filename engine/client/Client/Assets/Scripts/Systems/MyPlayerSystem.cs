using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

public class MyPlayerSystem : BaseSystem<MyPlayerSystem>
{

#if UNITY_EDITOR
    [InitializeOnLoadMethod]
#else
    [RuntimeInitializeOnLoadMethod]
#endif
    private static void Initialize()
    {
        enableAutoAttack = LoadBool(nameof(enableAutoAttack), enableAutoAttack);
    }
    
    [ShowInInspector]
    [OnValueChanged("OnValueChanged_enableAutoAttack")]
    public static bool enableAutoAttack = true;
    
    private static void OnValueChanged_enableAutoAttack()
    {
        SaveBool(nameof(enableAutoAttack), enableAutoAttack);
    }
    
    [Button]
    public static void PlayAnimation(string animationName = "Attack", int trackIndex = 0)
    {
        if (string.IsNullOrEmpty(animationName))
        {
            Debug.LogError("Animation name cannot be null or empty.");
            return;
        }

        var unitObject = MyGameUnitObject.Get();
        if (unitObject)
        {
            unitObject.unitSkin.SetAnimation(trackIndex, animationName, false, true, timeScale: 1f);
        }
    }
    
}
