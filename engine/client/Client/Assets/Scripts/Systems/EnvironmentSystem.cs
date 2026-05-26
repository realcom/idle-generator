using System.Collections;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

public partial class EnvironmentSystem : BaseSystem<EnvironmentSystem>
{
    
#if UNITY_EDITOR
    [InitializeOnLoadMethod]
#else
    [RuntimeInitializeOnLoadMethod]
#endif
    private static void Initialize()
    {
        listeners.Clear();
        
        currentWeather = LoadEnum(nameof(currentWeather), currentWeather);
        currentTimeOfDay = LoadEnum(nameof(currentTimeOfDay), currentTimeOfDay);
        
        dayNightBlend = LoadFloat(nameof(dayNightBlend), dayNightBlend);
        OnValueChangedDayNightBlend();
        
        //globalWeatherOff = GlobalKeyword.Create(WEATHER_OFF);
        //globalWeatherRain = GlobalKeyword.Create(WEATHER_RAIN);
        //globalWeatherSnow = GlobalKeyword.Create(WEATHER_SNOW);
        //globalWeatherDyed = GlobalKeyword.Create(WEATHER_DYED);
    }
    
    private const string WEATHER_OFF = "_WEATHER_OFF";
    private const string WEATHER_RAIN = "_WEATHER_RAIN";
    private const string WEATHER_SNOW = "_WEATHER_SNOW";
    private const string WEATHER_DYED = "_WEATHER_DYED";
    
    private const string EMISSION_FACTOR = "_EMISSION_FACTOR";

    //private static GlobalKeyword globalWeatherOff;
    //private static GlobalKeyword globalWeatherRain;
    //private static GlobalKeyword globalWeatherSnow;
    //private static GlobalKeyword globalWeatherDyed;

    private static readonly int shaderEmissionFactor = Shader.PropertyToID(EMISSION_FACTOR);
    
    public enum WeatherType
    {
        OFF,
        RAIN,
        SNOW,
        DYED
    };
    
    public enum TimeOfDay
    {
        DAY,
        NIGHT
    };
    
    [ShowInInspector]
    [FoldoutGroup("Environment Settings")]
    [HorizontalGroup("Environment Settings/Horizontal")]
    [VerticalGroup("Environment Settings/Horizontal/Left")]
    public static WeatherType currentWeather { get; private set; } = WeatherType.OFF;
    [ShowInInspector]
    [VerticalGroup("Environment Settings/Horizontal/Left")]
    public static TimeOfDay currentTimeOfDay { get; private set; } = TimeOfDay.DAY;
    
    private static WeatherType? _previousWeather = null;
    private static TimeOfDay? _previousTimeOfDay = null;

    [Button("변경 적용", 40)]
    [HorizontalGroup("Environment Settings/Horizontal", width: 80f)]
    public static void Apply()
    {
        if (_previousWeather == currentWeather && _previousTimeOfDay == currentTimeOfDay)
            return;

        SaveEnum(nameof(currentWeather), currentWeather);
        SaveEnum(nameof(currentTimeOfDay), currentTimeOfDay);
        
        _previousWeather = currentWeather;
        _previousTimeOfDay = currentTimeOfDay;
        
        OnChangeEnvironment();
    }

    [ShowInInspector] 
    [Tooltip("0: Day, 1: Night")]
    [OnValueChanged("OnValueChangedDayNightBlend")]
    [PropertyRange(0f, 1f)]
    public static float dayNightBlend = 0f;
    
    public static void OnValueChangedDayNightBlend()
    {
        Shader.SetGlobalFloat(shaderEmissionFactor, dayNightBlend);
        SaveFloat(nameof(dayNightBlend), dayNightBlend);
    }
    
    [ReadOnly]
    [PropertyOrder(100)]
    [ShowInInspector]
    private static readonly HashSet<IEnvironmentListener> listeners = new();
    private static readonly List<IEnvironmentListener> pendingListeners = new();
    
    public static IEnvironmentListener AddListener(IEnvironmentListener listener)
    {
        if (!IsValidListener(listener))
            return null;
        
        listeners.Add(listener);
        return listener;
    }
    
    public static bool RemoveListener(IEnvironmentListener listener)
    {
        return listeners.Remove(listener);
    }

    private static void OnChangeEnvironment()
    {
        switch(currentWeather)
        {
            case WeatherType.OFF:
                Shader.EnableKeyword(WEATHER_OFF);
                Shader.DisableKeyword(WEATHER_RAIN);
                Shader.DisableKeyword(WEATHER_SNOW);
                Shader.DisableKeyword(WEATHER_DYED);
                break;
            case WeatherType.RAIN:
                Shader.DisableKeyword(WEATHER_OFF);
                Shader.EnableKeyword(WEATHER_RAIN);
                Shader.DisableKeyword(WEATHER_SNOW);
                Shader.DisableKeyword(WEATHER_DYED);
                break;
            case WeatherType.SNOW:
                Shader.DisableKeyword(WEATHER_OFF);
                Shader.DisableKeyword(WEATHER_RAIN);
                Shader.EnableKeyword(WEATHER_SNOW);
                Shader.DisableKeyword(WEATHER_DYED);
                break;
            case WeatherType.DYED:
                Shader.DisableKeyword(WEATHER_OFF);
                Shader.DisableKeyword(WEATHER_RAIN);
                Shader.DisableKeyword(WEATHER_SNOW);
                Shader.EnableKeyword(WEATHER_DYED);
                break;
        }

        foreach (var listener in listeners)
        {
            if (!IsValidListener(listener))
            {
                pendingListeners.Add(listener);
                continue;
            }

            listener.OnChangeEnvironment(currentWeather, currentTimeOfDay);
        }
        
        foreach (var listener in pendingListeners)
        {
            listeners.Remove(listener);
        }
    }
    
    private static bool IsValidListener(IEnvironmentListener listener)
    {
        return listener is Object obj && obj != null;
    }

}

public interface IEnvironmentListener
{
    void OnChangeEnvironment(EnvironmentSystem.WeatherType newWeather, EnvironmentSystem.TimeOfDay newTimeOfDay);
}