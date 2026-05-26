using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Game;
using Cysharp.Text;
using TMPro;
using UnityEngine;

public class TextBoardTickTimer : MonoBehaviour, IBoardTickUpdateListener
{
    
    public enum DisplayTime
    {
        PENDING_TIME,
        REMAIN_TIME        
    }
    
    public TextMeshProUGUI text;
    public TextTimer.Type type = TextTimer.Type.FORMAT_KEY;
    public string formatKey = "TimeLeft_F";
    public int formatDigit = 0;
    public TextTimer.DisplayTime displayTime = TextTimer.DisplayTime.REMAIN_TIME;
    public bool appendTotalTime = false;
    
    public int infinityMarkDeltaTime = 1_000_000_000; //대충 1년 => 초

    [NonSerialized] public double pendingTime;
    [NonSerialized] public double remainTime = double.MaxValue;

    public float normalizedProgress => (float)Math.Clamp(pendingTime / (pendingTime + remainTime), 0f, 1f);

    private uint _targetBoardTick = 0;
    public uint targetBoardTick
    {
        get => _targetBoardTick;
        set
        {
            _targetBoardTick = value;
            var boardTick = GameBoardManager.Get().gameBoard.Tick;
            var deltaTick = _targetBoardTick >= boardTick ? _targetBoardTick - boardTick : 0;
            remainTime = (double)GameBoard.TicksToTime(deltaTick);

            if (startBoardTick == 0)
                startBoardTick = boardTick;

            wasExpired = false;
            
            enabled = remainTime > 0;
            HandleTick();
        }
    }

    private uint _startBoardTick = 0;
    public uint startBoardTick
    {
        get => _startBoardTick;
        set
        {
            _startBoardTick = value;
            var boardTick = GameBoardManager.Get().gameBoard.Tick;
            var deltaTick = boardTick >= _startBoardTick ? boardTick - _startBoardTick : 0;
            pendingTime = (double)GameBoard.TicksToTime(deltaTick);
            
            enabled = true;
            HandleTick();
        }
    }
    
    public bool IsWorking => enabled && (targetBoardTick > 0 || startBoardTick > 0);

    private void Awake()
    {
        if (!IsWorking)
            enabled = false;
    }

    private void OnEnable()
    {
        GameBoardManager.Get()?.AddBoardTickUpdateListener(this);
    }

    private void OnDisable()
    {
        GameBoardManager.Get()?.RemoveBoardTickUpdateListener(this);
    }

    private void HandleTick()
    {
        if (!IsWorking)
            return;
        
        var totalTime = pendingTime + remainTime;
        var totalTimeStr = infinityMarkDeltaTime > totalTime ? TimeToText(totalTime, int.MaxValue) : text.GetInfiniteSignContainBuilder();

        var pendingTimeStr = TimeToText(appendTotalTime ? Math.Min(totalTime, pendingTime) : pendingTime, formatDigit);
        var remainTimeStr = infinityMarkDeltaTime > remainTime ? 
            TimeToText(appendTotalTime ? Math.Max(0, remainTime) : 
                remainTime, formatDigit) : text.GetInfiniteSignContainBuilder();

        switch (displayTime)
        {
            case TextTimer.DisplayTime.PENDING_TIME:
                text.SetTextWithDispose(MakeUpString(pendingTimeStr, totalTimeStr));
                break;
            case TextTimer.DisplayTime.REMAIN_TIME:
                text.SetTextWithDispose(MakeUpString(remainTimeStr, totalTimeStr));
                break;
        }
        
        if (remainTime <= 0)
        {
            onUpdateTime?.Invoke((totalTime, 0));
            
            if (!wasExpired && targetBoardTick - lastExpiredBoardTick > 0)
            {
                lastExpiredBoardTick = targetBoardTick;
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
            case TextTimer.Type.HHMMSS:
            case TextTimer.Type.FORMAT_KEY:
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
            case TextTimer.Type.BEAUTY_TIME_WITH_END_TEXT:
            {
                return Utility.BeautyTimeHHMMSS(time, digit, true, formatKey);
            }
            case TextTimer.Type.SIMPLIFY:
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
    private uint lastExpiredBoardTick = 0;
    
    private Action onExpired;
    public void SetExpiredCallback(Action callback)
    {
        wasExpired = false;
        onExpired = callback;
        HandleTick();
    }

    public void OnBoardTickUpdated(uint boardTick)
    {
        var safePendingTime = boardTick >= startBoardTick ? boardTick - startBoardTick : 0;
        pendingTime = (double)GameBoard.TicksToTime(safePendingTime);
        var safeRemainTime = targetBoardTick >= boardTick ? targetBoardTick - boardTick : 0;
        remainTime = (double)GameBoard.TicksToTime(safeRemainTime);
        
        HandleTick();
    }

    public void OnPaused()
    {
        
    }

    public void OnResumed()
    {
        
    }
}
