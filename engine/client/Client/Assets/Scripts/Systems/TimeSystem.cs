using System;
using UnityEditor;
using Sirenix.OdinInspector;
using UnityEngine;

public class TimeSystem : BaseSystem<TimeSystem>
{
    private static float? m_cachedTimeScale = null;
    private static float? m_initialFixedDeltaTime = null;

    [ReadOnly]
    [ShowInInspector]
    private static float m_timeScale
    {
        get => m_cachedTimeScale ??= Time.timeScale;
        set
        {
            m_initialFixedDeltaTime ??= Time.fixedDeltaTime;
            m_cachedTimeScale = Time.timeScale = value;
            Time.fixedDeltaTime = m_initialFixedDeltaTime.Value * value;
        }
    }

#if UNITY_EDITOR
    
    [ReadOnly]
    [ShowInInspector]
    private static float fixedDeltaTime => Time.fixedDeltaTime; // 에디터에서 Time.fixedDeltaTime를 보기 위함 (실제 사용 X)
    
#endif

    public static float timeScale
    {
        get => m_timeScale;
        set => m_timeScale = value;
    }

    public static double time { get; private set; }
    public static int offsetTime { get; private set; }
    
    private static DateTime m_LastDayResetTime = DateTime.MinValue;
    
    [RuntimeInitializeOnLoadMethod]
    private static void Initialize()
    {
        ZPlayerLoopSystemHelper.InsertSystemBefore(typeof(TimeSystem), Update, typeof(UnityEngine.PlayerLoop.Update.ScriptRunBehaviourUpdate));
    }
    
    private static void Update()
    {
        var now = DateTime.UtcNow;
        time = now.ToSeconds();
        offsetTime = now.ToOffsetSeconds();

        if (MyPlayer.Player.Id == 0)
            return;

        var utcOffsetHours = MyPlayer.World?.UtcOffsetHours ?? 0;
        var nowDate = now.AddHours(utcOffsetHours).Date;
        if (m_LastDayResetTime.AddHours(utcOffsetHours).Date != nowDate)
        {
            m_LastDayResetTime = nowDate;
            // Day reset logic can be added here if needed
            // For example, resetting daily quests, rewards, etc.
            GameManager.Get().DispatchEvent(GameEventType.DayReset, nowDate);
        }
    }
    
}
