using UnityEngine;
using System.Runtime.InteropServices;
using System;
using System.Text;
using System.Collections.Generic;
using System.Collections;
using System.Collections.Concurrent;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Components;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using TMPro;
using Unity.Services.Core;
using Unity.Services.Core.Environments;
using UnityEngine.Networking;
using UnityEngine.Purchasing;
using Resources = UnityEngine.Resources;

#if UNITY_IOS
using Unity.Notifications.iOS; // 유니티 iOS Notifications 패키지 사용 시
#endif

public class PlatformManager : MonoBehaviour
{
    // private static ClientMeta Meta;
    // private static WalletConnect Wallet;
    // private static int WalletDisconnectedCounter;
    
    private static bool _initialized;
    private static bool _isInitializing;

    private static int InvalidScreenSizeCounter;
    
    public bool Paused;

    //
    public delegate void OnImagePicked(Sprite sprite);

    //
    private static PlatformManager _singleton;
    public static PlatformManager Get()
    {
        if (_singleton == null)
        {
            _singleton = new GameObject("[PlatformManager]").AddComponent<PlatformManager>();
        }

        return _singleton;
    }

    public void Awake()
    {
        DontDestroyOnLoad(gameObject);
        Init();
        

        Application.lowMemory += OnLowMemory;
    }
    
    private static bool IsInvalidMessage(string message)
    {
        if (message == null)
            return false;
        if (message.Contains("Failed to register for remote notifications"))
            return true;
        if (message.Contains("Screen position out of view frustum")
            && message.Contains("(Camera rect 0 0 450 800)"))
        {
            if (++InvalidScreenSizeCounter == 10)
                GameManager.OnInvalidScreenSizeDetected();
            return true;
        }
        return false;
    }
    
    public static async void Init()
    {
        if (_initialized || _isInitializing)
            return;

        _isInitializing = true;
        try
        {
            try
            {
                // https://forum.unity.com/threads/load-font-from-mobile-device-and-assign-as-fallback-tmp_fontasset.657151/
                var fallbackFontPaths = new[]
                {
                    "roboto",
                    "noto",
                    "nanum",
#if UNITY_EDITOR
                    "malgun",
#elif UNITY_ANDROID
                    "droid",
#elif UNITY_IOS
                    "sf",
                    "sd",
                    "hiragino",
                    "pingfang",
#endif
                    "arial",
                };
                var fallbackFontCount = new int[fallbackFontPaths.Length];

                var availableFontPathsByPriority = new List<(int, string)>();
                foreach (var fontPath in Font.GetPathsToOSFonts())
                {
                    for (var i = 0; i < fallbackFontPaths.Length; ++i)
                    {
                        var path = fallbackFontPaths[i];
                        var lower = fontPath.ToLowerInvariant();
                        if (lower.Contains("bold") || lower.Contains("italic") || lower.Contains("heavy") ||
                            lower.Contains("light") || lower.Contains("thin"))
                            continue;
                        if (lower.Contains(path))
                        {
                            fallbackFontCount[i] += 1;
                            availableFontPathsByPriority.Add((i, fontPath));
                            break;
                        }
                    }
                }

                var availableFontPaths =
                    availableFontPathsByPriority.OrderBy(p => p.Item1).Select(p => p.Item2).Distinct().ToList();
                Debug.Log($"Available fallback fonts: {string.Join(',', availableFontPaths)}");

                TMP_Settings.fallbackFontAssets.Clear();
                foreach (var path in availableFontPaths)
                {
                    try
                    {
                        var font = new Font(path);
                        var fallbackFont = TMP_FontAsset.CreateFontAsset(font);
                        if (fallbackFont)
                            TMP_Settings.fallbackFontAssets.Add(fallbackFont);
                    }
                    catch (Exception ex)
                    {
                        Debug.LogException(ex);
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.LogException(ex);
            }

            //TMP_Text.OnSpriteAssetRequest -= OnSpriteAssetRequest;
            //TMP_Text.OnSpriteAssetRequest += OnSpriteAssetRequest;



            try
            {
                var environment = "production";
#if UNITY_EDITOR || DEVELOPMENT_BUILD
                environment = "development";
#endif
                var options = new InitializationOptions()
                    .SetEnvironmentName(environment);

                await AuthManager.InitFirebase();
#if UNITY_ANDROID
                AuthManager.SigninPlayGame();
#endif
                await UnityServices.InitializeAsync(options);
            }
            catch (Exception exception)
            {
                Debug.LogException(exception);
                // An error occurred during initialization.
            }

            InitFcm();
        }
        finally
        {
            _isInitializing = false;
        }
    }

    private static void InitFcm()
    {
#if !UNITY_EDITOR && UNITY_IOS
        //  try
        // {
        //     await FirebaseApp.CheckAndFixDependenciesAsync();
        //     var authReq = new iOSAuthorizationRequestData
        //     {
        //         alert = true,
        //         badge = true,
        //         sound = true
        //     };
        //     var req = new AuthorizationRequest(authReq, true); // provisional 등 옵션 가능
        //     while (!req.IsFinished) await Task.Yield();
        //     Debug.Log($"iOS Noti Permission: {req.Granted}");
        // }
        // catch (Exception ex)
        // {
        //     Debug.LogException(ex);
        // }
#endif
#if !UNITY_EDITOR && UNITY_ANDROID
        Debug.Log("Andorid init fcm.");
        InitChannel();
        const string POST_NOTI = "android.permission.POST_NOTIFICATIONS";

        // Android 13+ 에서만 의미 있음. (낮은 OS에선 무시)
        if (!UnityEngine.Android.Permission.HasUserAuthorizedPermission(POST_NOTI))
        {
            Debug.Log("Requesting push permission.");
            UnityEngine.Android.Permission.RequestUserPermission(POST_NOTI);
        }
#endif
    }

    private const string SPRITE_ASSET_PATH = "TextSpriteAssets/";
    private static TMP_SpriteAsset OnSpriteAssetRequest(int spriteAssetHashCode, string spriteAssetName)
    {
        var path = SPRITE_ASSET_PATH + spriteAssetName + ".asset";
        var asset = Utility.LoadResource<TMP_SpriteAsset>(path);

        if (asset == null)
        {
            Debug.LogWarning("Can't find sprite asset: " + path);
        }
        
        return asset;
    }
    
    private static void CreateChannel(string id, string name, int importance = 3)
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        var sdk = 0;
        using (var version = new AndroidJavaClass("android.os.Build$VERSION"))
        {
            sdk = version.GetStatic<int>("SDK_INT");
        }
        if (sdk >= 26)
        {
            using (var NotificationChannel = new AndroidJavaObject("android.app.NotificationChannel", id, name, importance))
            using (var unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
            using (var context = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity"))
            using (var notificationManager = context.Call<AndroidJavaObject>("getSystemService", "notification"))
            {
                notificationManager.Call("createNotificationChannel", NotificationChannel);
            }
        }
#endif
    }
    

    public static void InitChannel()
    {
        CreateChannel("default", "Push_Channel_Default".L());
        CreateChannel("friend", "Push_Channel_Friend".L());
        CreateChannel("clan", "Push_Channel_Clan".L());
        CreateChannel("reward", "Push_Channel_Reward".L());
    }

    public static void InitWallet()
    {
        // Meta = new ClientMeta
        // {
        //     Name = "Idlez 4",
        //     Description = "action role-playing game created, developed, and published by Gamevil",
        //     Icons = new[] { "https://djf7qc4xvps5h.cloudfront.net/game/cover/original/3-10370-48.webp" },
        //     URL = "https://play.google.com/store/apps/details?id=com.gamevil.zenonia4.global",
        // };
        //
        // GameManager.Get().ShowLoading();
        //
        // Wallet?.Dispose();
        // Wallet = new WalletConnect(Meta, bridgeUrl: "https://bridge.walletconnect.org", chainId: 37);
        // Wallet.OnTransportConnect += (sender, protocol) =>
        // {
        //     _singleton.Run(() =>
        //     {
        //         GameManager.Get().HideLoading();
        //         Debug.Log(Wallet.URI);
        //         Application.OpenURL(Wallet.URI);
        //     }, 2f);
        // };
        // Wallet.Connect();
        // WalletDisconnectedCounter = 0;
    }

    public delegate void VideoADCallback(bool success);

    public static void ShowVideoAD(VideoADCallback callback, bool forced = false)
    {
        
        Init();

        // if (!Advertisement.IsReady())
        // {
        //     GameManager.Get().ShowAlert(Popup_Alert.Type.OK, "Alert_VideoAD_NotReady".L(), (r) =>
        //   {
        //       callback(Application.isEditor);
        //   });
        //     return;
        // }
        //
        // //
        // Advertisement.Show("rewardedVideo", new ShowOptions()
        // {
        //     resultCallback = delegate (ShowResult sr)
        //     {
        //         callback(sr == ShowResult.Finished);
        //     },
        // });

        // AdManager.ShowAd(AdType.Rewarded, () =>
        // {
        //     GameManager.Get().scene.SetADCallback(() => callback(true));
        // }, () =>
        // {
        //     GameManager.Get().ShowAlert(Popup_Alert.Type.OK, "Alert_VideoAD_NotReady".L(), (r) =>
        //     {
        //         callback(Application.isEditor);
        //     });
        // });
    }

    public static void ShowPromotion(string key)
    {
        Init();

    }

    private static OnImagePicked _onImagePicked;
    public static void PickImage(int width, int height, OnImagePicked onImagePicked)
    {
        Init();
        _onImagePicked = onImagePicked;

#if UNITY_ANDROID && !UNITY_EDITOR

#elif UNITY_EDITOR
        if (_onImagePicked != null)
        {
            _onImagePicked(Resources.Load<Sprite>("img_preview"));
        }
#endif
    }

    public static void PostKakaoStory(string title, string text, string url)
    {
        Init();

    }

    public void Update()
    {
        // if (Wallet == null)
        //     return;
        //
        // var address = Wallet.Accounts?.GetSafe(0);
        // if (address != null)
        // {
        //     Wallet.Dispose();
        //     Wallet = null;
        //
        //     if (Utility.isDebugMode)
        //         Toast.Show<Popup_Toast>(address);
			     //
        //     WorldClient.Get().SendPacket(Packet.Type.SetEthAddress, new SetEthAddress
        //     {
        //         address = address,
        //     }, p =>
        //     {
        //         var l = p.Get<SetEthAddress.Result>();
        //         if (!GameManager.HandleCommonStatus(l.status, l.message))
        //             return;
        //
        //         Toast.Show<Popup_Toast>("Popup_Menu_Wallet_Registered".L());
        //         LogEvent("Wallet_Connect");
        //     });
        // }
        // else if (!Wallet.TransportConnected && !GameManager.Get().GetPopup<Popup_Loading>() && !Paused)
        // {
        //     if (++WalletDisconnectedCounter >= 3f / Time.deltaTime)
        //     {
        //         Toast.Show<Popup_Toast>("Popup_Menu_Wallet_RegisterFailed".L());
        //         Wallet.Dispose();
        //         Wallet = null;
        //     }
        // }
    }

    public void OnApplicationPause(bool pauseStatus)
    {
        Paused = pauseStatus;
        if (!Paused)
        {
            ZWorldClient.Get().ResetLastPingAt();
            // EdgeClient.Get().ResetLastPingAt();
        }
    }

    public static string CheckCheats()
    {
        Init();

        return null;
    }

    public void NativeHandlePushToken(string pushToken)
    {
        //GameManager.Get().HandlePushToken(pushToken);
    }

    public static void ConfirmLastTransaction()
    {
        Init();

    }

    public void NativeHandleInvitedRoom(string data)
    {
        //		var args = data.Split('\n');
    }

    public void NativePickImage(string filePath)
    {
        var tex = new Texture2D(1, 1);

        Debug.Log(filePath);
        try
        {
            if (!tex.LoadImage(System.IO.File.ReadAllBytes(filePath)))
                return;
        }
        catch (Exception e)
        {
            Debug.LogWarning(e);
            return;
        }

        if (_onImagePicked != null)
            _onImagePicked(Sprite.Create(tex, new Rect(0, 0, tex.width, tex.height), new Vector2(0.5f, 0.5f), 100f, 0,
                                          SpriteMeshType.FullRect));
    }

    private static string _language;
    private static SystemLanguage _systemLanguage;
    private static string _selectedLanguage;
    private static SystemLanguage _selectedSystemLanguage;

    public static void ClearLanguage()
    {
        _language = null;
        _selectedLanguage = null;
    }

    public static string GetLanguage()
    {
        return GetLanguageWithSystemLanguage().Item1;
    }
    
    public static SystemLanguage GetSystemLanguage()
    {
        return GetLanguageWithSystemLanguage().Item2;
    }

    public static (string, SystemLanguage) GetLanguageWithSystemLanguage()
    {
        if (!string.IsNullOrEmpty(_selectedLanguage))
            return (_selectedLanguage, _selectedSystemLanguage);
        
        // var selected = Popup_Language.selected.Get();
        // if (selected > -1)
        // {
        //     _selectedSystemLanguage = (SystemLanguage)selected;
        //     _selectedLanguage = _selectedSystemLanguage.ToString();
        //     return (_selectedLanguage, _selectedSystemLanguage);
        // }

#if UNITY_EDITOR
        if (string.IsNullOrEmpty(_language) && !string.IsNullOrEmpty(Config.defaultLanguage))
        {
            if (Enum.TryParse<SystemLanguage>(Config.defaultLanguage, out var systemLanguage))
            {
                _language = Config.defaultLanguage;
                _systemLanguage = systemLanguage;
            }
        }
#endif
        
        if (!string.IsNullOrEmpty(_language))
            return (_language, _systemLanguage);
        
        //
        Init();

        //
        var code = "";
        _systemLanguage = Application.systemLanguage;
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            if (code.StartsWith("zh-Hans"))
                _systemLanguage = SystemLanguage.ChineseSimplified;
            else if (code.StartsWith("zh-Hant") || code.StartsWith("zh-HK"))
                _systemLanguage = SystemLanguage.ChineseTraditional;
        }
        else if (Application.platform == RuntimePlatform.Android)
        {
            if (code.StartsWith("zh_CN"))
                _systemLanguage = SystemLanguage.ChineseSimplified;
            else if (code.StartsWith("zh_TW"))
                _systemLanguage = SystemLanguage.ChineseTraditional;
        }

        _language = _systemLanguage.ToString();
        return (_language, _systemLanguage);
    }

    public static bool IsKorean() => GetLanguageWithSystemLanguage().Item2 == SystemLanguage.Korean;

    public static bool isChinese
    {
        get
        {
            var systemLanguage = GetLanguageWithSystemLanguage().Item2;
            return systemLanguage == SystemLanguage.Chinese 
               || systemLanguage == SystemLanguage.ChineseSimplified 
               || systemLanguage == SystemLanguage.ChineseTraditional;
        }
    }

    private static string _country;
#if UNITY_IOS
	[System.Runtime.InteropServices.DllImport("__Internal")]
	extern static public string _getCountryCode();
#endif
    public static string GetCountry()
    {
        if (!string.IsNullOrEmpty(_country))
            return _country;
        
        var country = "";

#if UNITY_EDITOR
        country = "KR";
#elif UNITY_ANDROID
        using(AndroidJavaClass cls = new AndroidJavaClass("java.util.Locale"))
        {
            if (cls != null)
            {
                using (AndroidJavaObject locale = cls.CallStatic<AndroidJavaObject>("getDefault"))
                {
                    if (locale != null)
                    {
                        country = locale.Call<string>("getCountry");
                    }
                }
            }
        }
#elif UNITY_IOS
		{
            country = _getCountryCode();
        }
#endif

        _country = country;
        return country;
    }

    private static string _ipCountry;
    private static Regex _ipCountryRegex = new Regex(@"\nloc=(.+)\n");
    
    public static string GetIPCountry()
    {
        return string.IsNullOrEmpty(_ipCountry) ? GetCountry() : _ipCountry;
    }

    public static void LoadIpCountry()
    {
        _singleton.StartCoroutine(LoadIpCountryCoroutine());
    }

    public static IEnumerator LoadIpCountryCoroutine()
    {
        var url = "CountryCodeURL".L();
        if (string.IsNullOrEmpty(url))
            yield break;
        
        using (var req = UnityWebRequest.Get(url))
        {
            yield return req.SendWebRequest();

            if (req.result == UnityWebRequest.Result.Success)
            {
                var match = _ipCountryRegex.Match(req.downloadHandler.text);
                _ipCountry = match.Groups[1].Value;
            }
        }
    }

    /*
	public static void CheckEdges(List<TEdge> edges) {
		Get().StartCoroutine (_CheckEdges (edges));
	}

	private static IEnumerator _CheckEdges(List<TEdge> edges) {
		foreach (var edge in edges.ToArray()) {
			var www = new WWW("http://" + edge.host);
			var sw = new System.Diagnostics.Stopwatch();
			sw.Start();
			yield return www;
			sw.Stop ();

			var _edge = AppManager.Get ().GetEdge(edge.id);
			if(_edge != null)
				_edge.latency = (int)sw.ElapsedMilliseconds;
		}

		var l = new CheckedEdges ();
		l.edges.AddRange (AppManager.Get ().loginResult.edges);
		WorldClient.Get ().SendPacket (Packet.Type.CheckedEdges, l);

		AppManager.Get ().DispatchEvent (GameEvent.Get(GameEventType.EDGE_LATENCY_UPDATED));
	}
    */

    public static string GetMarketURL()
    {
#if UNITY_IPHONE
		return "MarketURL_IOS".L();
#else
        return "MarketURL_Android".L();
#endif
    }

    public static string GetDeviceID()
    {
        //
        Init();

#if UNITY_ANDROID && !UNITY_EDITOR

#endif

        return SystemInfo.deviceUniqueIdentifier;
    }


    public void LogEvent(string eventCategory, string eventAction = "", string eventLabel = "", long value = 0)
    {
#if UNITY_EDITOR || DEVELOPMENT_BUILD
        Debug.Log($"[Analytics] {eventCategory} action={eventAction} label={eventLabel} value={value}");
#endif
    }
    
    public void LogEvent(
    string eventCategory,
    params (string key, string value)[] values)
    {
#if UNITY_EDITOR || DEVELOPMENT_BUILD
        var formattedValues = values == null || values.Length == 0
            ? string.Empty
            : string.Join(", ", values.Select(value => $"{value.key}={value.value}"));
        Debug.Log($"[Analytics] {eventCategory} {formattedValues}");
#endif
    }
    
    public static void OpenURL(string url)
    {
        Application.OpenURL(url);
    }

    private double _nextReleaseMemory;
    private void OnLowMemory()
    {
        try
        {
            var now = Utility.GetTime();
            if (now < _nextReleaseMemory)
                return;
            _nextReleaseMemory = now + 30d;
            
            LazyLoad.UnloadAll();
            Resources.UnloadUnusedAssets();
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }
        catch (Exception ex)
        {
            Debug.LogException(ex);
        }
    }

    private void OnDestroy()
    {
        if (_singleton == this)
            _singleton = null;
        
        DOTween.KillAll();
        ZWorldClient.Get().CloseSilently();
        // EdgeClient.Get().Close()
    }
    
    
    /// <summary>
    /// Callback from web js functions
    /// </summary>
    public int telegramLoginTryCount;
    
    public enum Platform
    {
        Web,
        IPhone,
        IPad,
        Android
    }

    public Platform platform;

    public void RequestSendSupportEmail()
    {
        if (MyPlayer.GetAchievementByDataID(ResourceAchievement.Global.DataId.SentFeedback).State == PlayerAchievementMessage.Types.State.InProgress)
        {
            ZWorldClient.Get().SendPacket(Packet.Pop(0, new IncreaseAchievementRequest()
            {
                AchievementDataId = ResourceAchievement.Global.DataId.SentFeedback,
                Progress = 1
            })).Forget();
        }
        
        string email = "SupportEmail".L();
        string subject = Utility.EscapeURL("EmailSubject".L());
        string body = Utility.EscapeURL("EmailBody".L() + "\n\n------\n" + $"device = {SystemInfo.deviceModel} / " + $"deviceOS = {SystemInfo.operatingSystem} / " + $"deviceID = {SystemInfo.deviceUniqueIdentifier} / " + $"id = {~MyPlayer.Player.Id} / " + "Hamster " + Application.version);

        Application.OpenURL("mailto:" + email + "?subject=" + subject + "&body=" + body);
    }
}
