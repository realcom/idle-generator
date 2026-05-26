using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;

public partial class HapticSystem : BaseSystem<HapticSystem>
{
    [RuntimeInitializeOnLoadMethod]
    static void Initialize()
    {
        Vibration.Init();
        
        ZPlayerLoopSystemHelper.InsertSystemAfter(typeof(HapticSystem), Update,
            typeof(UnityEngine.PlayerLoop.Update));
        
        Application.quitting += Release;
    }
    
    private static void Release()
    {
        
    }

    private static readonly PriorityQueue<ResourceAudio.Types.HapticType, double> hapticQueue = new();
    private static void Update()
    {
        var currentTime = TimeSystem.time;
        while (hapticQueue.TryPeek(out var hapticType, out var launchAt))
        {
            if (launchAt > currentTime)
                break;
            
            hapticQueue.Dequeue();
            HapticInternal(hapticType);
        }
    }

    public static void Haptic(ResourceAudio resAudio)
    {
        if (resAudio == null || resAudio.HapticType == ResourceAudio.Types.HapticType.None)
            return;

        if (!GameManager.Get().hapticEnabled.Get())
            return;

        Haptic(resAudio.HapticType, resAudio.HapticDelay);
    }
    
    public static void Haptic(ResourceAudio.Types.HapticType hapticType, float delay = 0f)
    {
        if (hapticType == ResourceAudio.Types.HapticType.None)
            return;

        if (delay > 0f)
        {
            hapticQueue.Enqueue(hapticType, TimeSystem.time + delay);
        }
        else
        {
            HapticInternal(hapticType);
        }
    }

    private static void HapticInternal(ResourceAudio.Types.HapticType hapticType)
    {
        switch (hapticType)
        {
            case ResourceAudio.Types.HapticType.Small:
                Vibration.VibratePop();
                break;
            case ResourceAudio.Types.HapticType.Medium:
                Vibration.VibratePeek();
                break;
            case ResourceAudio.Types.HapticType.Large:
                Vibration.Vibrate();
                break;
        }
    }
    
}
