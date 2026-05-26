using UnityEngine;
using System.Runtime.InteropServices;
using System;
using System.Collections.Generic;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Components;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;

public class PluginManager : MonoBehaviour
{
    //
    private static PluginManager _singleton;
    public static PluginManager Get()
    {
        if (_singleton == null)
        {
            _singleton = new GameObject("[PluginManager]").AddComponent<PluginManager>();
        }

        return _singleton;
    }

    public void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }
    
    private List<string> removables = new();
    private void LateUpdate()
    {
        foreach (var c in _pluginCallbacks)
        {
            if (c.Value.untilAt < Time.time)
            {
                removables.Add(c.Key);
            }
        }
        if(removables.Count != 0)
        {
            foreach (var functionName in removables)
            {
                if (!_pluginCallbacks.TryGetValue(functionName, out var c))
                    continue;
                if (c.hideLoading)
                    GameManager.Get().HideLoading().Forget();
                _pluginCallbacks.Remove(functionName);
                
                Toast.Show<Popup_Toast>("Popup_Toast_PluginCallbackTimeout".L());
            }
            removables.Clear();
        }
    }

    #region Plugin Functions
    public void SendStarTransactionCallback(int statusCode)
    {
        if (!CheckPluginCallback(nameof(SendStarTransactionCallback)))
            return;
        
        // 0: failed
        // -1: timeout
        // 1: success
        // -2: payment not loaded
        // -3: pending (아직 유저가 confirm하지 않은 경우)
        Debug.Log($"SendStarTransactionCallback: stats={statusCode}");
        
        //
        switch (statusCode)
        {
            case 1:
                Toast.Show<Popup_Toast>("Popup_Toast_TransactionSuccess".L(), 2f);
                GameManager.Get().ShowLoading();
                break;
            case 0:
                Toast.Show<Popup_Toast>("Popup_Toast_TransactionCanceled".L(), 2f);
                break;
            default:
                Toast.Show<Popup_Toast>("Popup_Toast_TransactionFailed".L(), 2f);
                break;
        }
    }

    public void SendTransactionCallback(string transactionHash)
    {
        if (!CheckPluginCallback(nameof(SendTransactionCallback)))
            return;
        
        Debug.Log($"SendTransactionCallback: hash={transactionHash}");
        
        //
        if (!string.IsNullOrEmpty(transactionHash))
        {
            Toast.Show<Popup_Toast>("Popup_Toast_TonTransactionWithHash".L(transactionHash), 5f);
            GameManager.Get().ShowLoading();
        }
        else
            Toast.Show<Popup_Toast>("Popup_Toast_TransactionFailed".L(), 2f);
    }
    
    //
    public void OnReferral(string referralCode)
    {
        try
        {
            var refCode = referralCode.Split("_", 2);
            var userId = long.Parse(refCode[1]);
            var req = new AddPlayerReferralRequest
            {
                TelegramUserId = userId,
            };
            var packet = Packet.Pop(0, req);
            ZWorldClient.Get().SendPacket(packet).Forget();
        }
        catch (Exception ex)
        {
            Debug.LogException(ex);
        }
    }
    
    public void SetPlatform(string derivedPlatform)
    {
        Debug.Log($"SetPlatform: setting platform = {derivedPlatform}");
        PlatformManager.Get().platform = derivedPlatform switch
        {
            "web" => PlatformManager.Platform.Web,
            "iphone" => PlatformManager.Platform.IPhone,
            "ipad" => PlatformManager.Platform.IPad,
            "android" => PlatformManager.Platform.Android,
            _ => PlatformManager.Platform.Web
        };
    }
    
    public void DebugUnityUseCheat(string cheatString)
    {
        if (!Config.IsDebug)
            return;
    
        CheatManager.HandleInputCheat(cheatString).Forget();
    }
    
    #endregion
    
    /// <summary>
    /// Plugin function callback handling
    /// </summary>
    
    public delegate void PluginCallback([CanBeNull] object param);
    private class PluginCallbackInfo
    {
        public readonly float untilAt;
        public readonly bool hideLoading;
        public readonly PluginCallback callback;
        
        // no such thing as callback failure for plugin functions...

        public PluginCallbackInfo(bool hideLoading, float timeOut, PluginCallback callback)
        {
            this.hideLoading = hideLoading;
            this.untilAt = Time.time + timeOut;
            this.callback = callback;
        }
    }

    private bool TryCallPluginFunction_internal(Action action, string callbackNameFromPlugin, PluginCallback callback, bool withLoading, float timeout)
    {
        try
        {
            action.Invoke();

            if (!string.IsNullOrEmpty(callbackNameFromPlugin))
            {
                _pluginCallbacks[callbackNameFromPlugin] = new PluginCallbackInfo(withLoading, timeout, callback);

                if (withLoading)
                    GameManager.Get().ShowLoading().Forget();
            }
        }
        catch (Exception e)
        {
            GameManager.Get().HideLoading().Forget();
            Toast.Show<Popup_Toast>("Popup_Toast_PluginCallbackFailed".L());
            Debug.LogWarning(e);
            return false;
        }

        return true;
    }

    public bool TryCallPluginFunction(Action action, Action callbackFromPlugin = null, PluginCallback callback = null, bool withLoading = true, float timeout = 60f)
    {
        return TryCallPluginFunction_internal(action, callbackFromPlugin?.Method.Name, callback, withLoading, timeout);
    }
    
    public bool TryCallPluginFunction(Action action, Action<string> callbackFromPlugin = null, PluginCallback callback = null, bool withLoading = true, float timeout = 60f)
    {
        return TryCallPluginFunction_internal(action, callbackFromPlugin?.Method.Name, callback, withLoading, timeout);
    }
    
    public bool TryCallPluginFunction(Action action, Action<int> callbackFromPlugin = null, PluginCallback callback = null, bool withLoading = true, float timeout = 60f)
    {
        return TryCallPluginFunction_internal(action, callbackFromPlugin?.Method.Name, callback, withLoading, timeout);
    }
    
    // TODO: improve this
    public bool TryCallPluginFunctionImplicitly(Action action, PluginCallback callback = null, bool withLoading = true, float timeout = 60f)
    {
        return TryCallPluginFunction_internal(action, action.Method.Name + "Callback", callback, withLoading, timeout);
    }

    private Dictionary<string, PluginCallbackInfo> _pluginCallbacks = new();
    
    public bool CheckPluginCallback(string functionName, object param = null)
    {
        if (_pluginCallbacks.Remove(functionName, out var info))
        {
            if (info.hideLoading)
                GameManager.Get().HideLoading().Forget();
            
            info.callback?.Invoke(param);
            return true;
        }
        else
        {
            Debug.LogWarning($"Callback {functionName} not found.");
        }
        return false;
    }
}
