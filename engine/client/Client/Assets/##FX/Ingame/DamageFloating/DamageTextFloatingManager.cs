using System;
using System.Collections.Generic;
using System.Linq;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Serialization;
using Random = System.Random;

public class DamageTextFloatingManager : SerializedMonoBehaviour
{
    public readonly Dictionary<DamageTextType, DamageText> damageTextDict = new();
    

    public static DamageTextFloatingManager Get()
    {
        return instance != null ? instance : null;
    }
    
    private static DamageTextFloatingManager instance;

    private void Awake()
    {
        instance = this;
    }

    private void OnDestroy()
    {
        if (instance == this)
            instance = null;
    }

    public static void ShowDamage(Vector3 pos, IconType type, ulong value, DamageTextType textType = DamageTextType.Default, Color? textColor = null)
    {
        Get()?.damageTextDict.GetValueOrDefault(textType)?.Show(pos, type, value, textColor);
    }

}