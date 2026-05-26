using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Types.Players;
using Components.UI.Toggle;
using Cysharp.Text;
using Google.Protobuf.WellKnownTypes;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;

public class TextTimer : MonoBehaviour
{
    public enum Type
    {
        FORMAT_KEY,
        PRETTY_FORMAT_3,
        HHMMSS,
        BEAUTY_TIME_WITH_END_TEXT,
        SIMPLIFY,
        NONE
    }
    
    public enum DisplayTime
    {
        PENDING_TIME,
        REMAIN_TIME        
    }
    
    public TextMeshProUGUI text;
    public Type type = Type.FORMAT_KEY;
    public string formatKey = "TimeLeft_F";
    public int formatDigit = 0;
    public DisplayTime displayTime = DisplayTime.REMAIN_TIME;
    [ShowIf("@displayTime == DisplayTime.PENDING_TIME")]
    public CustomToggle togglePendingMaxTime;
    
    public bool appendTotalTime = false;
    public string totalTimeFormatKey = "";
    public int totalTimeDigit = 0;
    
    [ShowIf("@displayTime == DisplayTime.REMAIN_TIME")]
    public CustomToggle toggleDeadlineApproaching;
    [ShowIf("@displayTime == DisplayTime.REMAIN_TIME")]
    public int deadlineApproachingSeconds = 60;
    
    public int infinityMarkDeltaTime = 1_000_000_000; //대충 1년 => 초

    [NonSerialized] public double pendingTime;
    [NonSerialized] public double remainTime = double.MaxValue;

    public float normalizedProgress => (float)Math.Clamp(pendingTime / (pendingTime + remainTime), 0f, 1f);

    private double _targetTimeAt = 0f;
    public virtual double targetTimeAt
    {
        get => _targetTimeAt;
        set
        {
            if (value <= 0f)
            {
                enabled = false;
                return;
            }
            
            _targetTimeAt = value;
            remainTime = (int)Math.Ceiling(_targetTimeAt - ZWorldClient.Get().serverTime);

            if (startTimeAt < double.Epsilon)
                startTimeAt = ZWorldClient.Get().serverTime;

            wasExpired = false;
            
            enabled = remainTime > 0;
            HandleTick();
        }
    }

    private double _startTimeAt = 0f;
    public virtual double startTimeAt
    {
        get => _startTimeAt;
        set
        {
            _startTimeAt = value;
            pendingTime = (int)Math.Ceiling(ZWorldClient.Get().serverTime - _startTimeAt);
            
            enabled = true;
            HandleTick();
        }
    }

    public void SetTargetTime(Timestamp timestamp)
    {
        if (timestamp == null)
        {
            Stop();
            gameObject.SetActive(false);
            return;
        }
        
        gameObject.SetActive(true);
        targetTimeAt = timestamp.ToSeconds();
    }

    public void SetByItem(PlayerItemMessage item)
    {
        if (item == null)
        {
            Stop();
            gameObject.SetActive(false);
            return;
        }
        
        SetTargetTime(item.UntilAt);
        deadlineApproachingSeconds = item.GetData()!.DeadlineApproachingSeconds;
    }

    private void Awake()
    {
        if (enabled && targetTimeAt < double.Epsilon && startTimeAt < double.Epsilon)
            enabled = false;
    }

    protected virtual void LateUpdate()
    {
        if (targetTimeAt > 0f)
        {
            remainTime = Math.Ceiling(_targetTimeAt - ZWorldClient.Get().serverTime);
        }

        if (startTimeAt > 0f)
        {
            pendingTime = Math.Ceiling(ZWorldClient.Get().serverTime - _startTimeAt);
        }
        
        HandleTick();
    }

    private void HandleTick()
    {
        if (!enabled || _targetTimeAt < double.Epsilon && _startTimeAt < double.Epsilon)
            return;

        var totalTime = Math.Ceiling(targetTimeAt - startTimeAt);
        using var totalTimeStr = infinityMarkDeltaTime > totalTime ? TimeToText(totalTime, totalTimeDigit) : text.GetInfiniteSignContainBuilder();

        using var pendingTimeStr = TimeToText(Math.Min(totalTime, pendingTime), formatDigit);
        using var remainTimeStr = infinityMarkDeltaTime > remainTime ? TimeToText(appendTotalTime ? Math.Max(0, remainTime) : remainTime, formatDigit) : text.GetInfiniteSignContainBuilder();

        switch (displayTime)
        {
            case DisplayTime.PENDING_TIME:
                text.SetTextWithDispose(MakeUpString(pendingTimeStr, totalTimeStr));
                if (togglePendingMaxTime)
                    togglePendingMaxTime.isOn = pendingTime >= totalTime;
                break;
            case DisplayTime.REMAIN_TIME:
                text.SetTextWithDispose(MakeUpString(remainTimeStr, totalTimeStr));
                if (toggleDeadlineApproaching)
                    toggleDeadlineApproaching.isOn = remainTime <= deadlineApproachingSeconds;
                break;
        }
        
        if (remainTime <= 0)
        {
            onUpdateTime?.Invoke((totalTime, 0));
            
            if (!wasExpired && Math.Abs(targetTimeAt - lastExpiredAt) > double.Epsilon)
            {
                lastExpiredAt = targetTimeAt;
                wasExpired = true;
                onExpired?.Invoke();
            }
        }
        else
        {
            onUpdateTime?.Invoke((pendingTime, remainTime));
        }
    }
    
    private Utf16ValueStringBuilder MakeUpString(Utf16ValueStringBuilder timeStringBuilder, Utf16ValueStringBuilder totalTimeStringBuilder)
    {
        var builder = ZString.CreateStringBuilder();
        if (appendTotalTime)
        {
            if (!string.IsNullOrEmpty(totalTimeFormatKey))
            {
                builder.AppendFormat(totalTimeFormatKey.L(), timeStringBuilder, totalTimeStringBuilder);
                return builder;
            }
            
            builder.AppendFormat("{0} / {1}", timeStringBuilder, totalTimeStringBuilder);
            return builder;
        }
        
        builder.Append(timeStringBuilder);
        return builder;
    }

    private Utf16ValueStringBuilder TimeToText(double doubleTime, int digit)
    {
        var time = (int)Math.Ceiling(doubleTime);
        switch (type)
        {
            case Type.HHMMSS:
            case Type.FORMAT_KEY:
            {
                var builder = ZString.CreateStringBuilder();
                using var timeBuilder = Utility.BeautyTimeHHMMSS(time, digit);
                if (!string.IsNullOrEmpty(formatKey))
                    builder.AppendFormat(formatKey.L(), timeBuilder);
                else
                    builder.Append(timeBuilder);
                return builder;
                break;
            }
            case Type.BEAUTY_TIME_WITH_END_TEXT:
            {
                return Utility.BeautyTimeHHMMSS(time, digit, true, formatKey);
            }
            case Type.SIMPLIFY:
            {
                return Utility.BeautyTimeSimplify(time);
            }
            default:
            {
                var builder = ZString.CreateStringBuilder();
                builder.Append(time);
                return builder;
            }
        }
    }
    
    private Action<(double pendingTime, double remainTime)> onUpdateTime;
    public void SetUpdateTimeCallback(Action<(double pendingTime, double remainTime)> callback)
    {
        onUpdateTime = callback;
        HandleTick();
    }
    
    private bool wasExpired = false;
    private double lastExpiredAt = 0f;
    
    private Action onExpired;
    public void SetExpiredCallback(Action callback)
    {
        wasExpired = false;
        onExpired = callback;
        HandleTick();
    }

    public void Stop()
    {
        enabled = false;
        onExpired = null;
        onUpdateTime = null;
        _targetTimeAt = 0f;
        _startTimeAt = 0f;
    }

}
