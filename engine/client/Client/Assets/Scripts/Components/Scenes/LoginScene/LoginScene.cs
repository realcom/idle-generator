using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using Commons;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;
using Resources = UnityEngine.Resources;

#if UNITY_IOS
using Unity.Advertisement.IosSupport;
#endif

public class LoginScene : BaseScene<LoginScene>
{
    private static readonly ConcurrentQueue<Action> _mainThreadWorkQueue = new ConcurrentQueue<Action>();
    
    private bool _logining = false;
    private LoginType _loginType = LoginType.None;
    
    private enum LoginType
    {
        None,
        GooglePlay,
        Facebook,
        GameCenter,
        Apple,
        Guest,
        Telegram,
    }
    
    private class ConstantStrings
    {
        public static SystemLanguage Lang
        {
            get => PlatformManager.GetSystemLanguage();
        }
        public static string Connecting
        {
            get
            {
                
                return Lang switch
                {
                    SystemLanguage.Korean => "햄찌 월드로 들어가는 중...",
                    _ => "Entering Hamzzi World..."
                };
            }
        }
        
        public static string Connected
        {
            get
            {
                return Lang switch
                {
                    SystemLanguage.Korean => "출입문 찾는 중...",
                    _ => "Looking for the door..."
                };
            }
        }
        
        public static string Signing
        {
            get
            {
                return Lang switch
                {
                    SystemLanguage.Korean => "열쇠 찾는 중...",
                    _ => "Looking for the Key..."
                };
            }
        }
        
        public static string PrepareDownload
        {
            get
            {
                return Lang switch
                {
                    SystemLanguage.Korean => "출격 준비 중...",
                    _ => "Preparing for Combat..."
                };
            }
        }
        
        public static string Downloading(Constants.AssetBundleType assetBundleType)
        {
            var lang = PlatformManager.GetSystemLanguage();
            switch (assetBundleType)
            {
                case Constants.AssetBundleType.COMMONS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "햄찌가 볼 안에 씨앗을 우겨넣는 중...",
                        _ => "Hamster is cramming seeds into its cheeks..."
                    };
                case Constants.AssetBundleType.MAPS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "지도를 확인하는 중...",
                        _ => "Unfolding the map... hope it’s not upside down!"
                    };
                case Constants.AssetBundleType.UNITS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "슬라임과 투닥이는 중...",
                        _ => "Wrestling with some slimy troublemakers..."
                    };
                case Constants.AssetBundleType.ITEMS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "너무 많이 담은 짐을 덜어내는 중...",
                        _ => "Trying to squeeze one more thing into the backpack..."
                    };
                case Constants.AssetBundleType.SKILLS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "쓸만한 무기를 찾는 중...",
                        _ => "Digging around for a weapon that won’t break..."
                    };
                case Constants.AssetBundleType.BUFFS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "챗바퀴 굴리는 중...",
                        _ => "Running on the hamster wheel... forever..."
                    };
                case Constants.AssetBundleType.SOUNDS:
                    return lang switch
                    {
                        SystemLanguage.Korean => "목소리를 가다듬는 중...",
                        _ => "Clearing the throat... testing, one, two!"
                    };
                case Constants.AssetBundleType.ETC:
                    return lang switch
                    {
                        SystemLanguage.Korean => "문밖으로 나가는 중...",
                        _ => "Heading out the door... did I forget my keys?"
                    };
                
                default:
                    return $"Downloading... ({assetBundleType.ToString().ToCamelCase()})";
            }
        }
        
        public static string DownloadFailed
        {
            get
            {
                return PlatformManager.GetSystemLanguage() switch
                {
                    SystemLanguage.Korean => "패치를 받아오는 도중 문제가 발생했습니다.\n네트워크 및 기기 용량을 확인해 주세요.\n계속해서 문제가 발생하는 경우 최신 버전의 앱인지 확인해 주세요.",
                    SystemLanguage.Japanese => "パッチのダウンロード中に問題が発生しました。\nネットワーク状態と端末の空き容量をご確認ください。\n引き続き問題が発生する場合は、アプリが最新バージョンになっているかご確認ください。",
                    SystemLanguage.ChineseSimplified => "下载补丁时发生错误。\n请确认网络状态以及设备内存。\n持续发生错误时，请确认应用程序是否为最新版本。",
                    SystemLanguage.ChineseTraditional => "下載更新檔時發生問題，\n請確認網路狀態與裝置容量。\n若持續發生問題時，請確認應用程式是否為最新版本。",
                    _ => "Failed to download the patch.\nPlease check your network and device capacity.\nIf the problem persists, please check if the app is the latest version."
                };
            }
        }
        
        public static string Loading(Constants.AssetBundleType assetBundleType)
        {
            var lang = PlatformManager.GetSystemLanguage();
            return $"Loading... ({assetBundleType.ToString().ToCamelCase()})";
        }
        
        public static string LoadFailed
        {
            get
            {
                return PlatformManager.GetSystemLanguage() switch
                {
                    SystemLanguage.Korean => "패치를 불러오는 도중 문제가 발생했습니다.\n네트워크 및 기기 용량을 확인해 주세요.\n계속해서 문제가 발생하는 경우 최신 버전의 앱인지 확인해 주세요.",
                    SystemLanguage.Japanese => "パッチの読み込み中に問題が発生しました。\nネットワーク状態と端末の空き容量をご確認ください。\n引き続き問題が発生する場合は、アプリが最新バージョンになっているかご確認ください。",
                    SystemLanguage.ChineseSimplified => "加载补丁时发生错误。\n请确认网络状态以及设备内存。\n持续发生错误时，请确认应用程序是否为最新版本。",
                    SystemLanguage.ChineseTraditional => "載入更新檔時發生問題，\n請確認網路狀態與裝置容量。\n若持續發生問題時，請確認應用程式是否為最新版本。",
                    _ => "Failed to load the patch.\nPlease check your network and device capacity.\nIf the problem persists, please check if the app is the latest version."
                };
            }
        }

        public static string LoginFailed
        {
            get
            {
                return PlatformManager.GetSystemLanguage() switch
                {
                    SystemLanguage.Korean => "로그인에 실패했습니다",
                    _ => "Failed to Login",
                };
            }
        }

        public static string VersionOutDated
        {
            get
            {
                return PlatformManager.GetSystemLanguage() switch
                {
                    SystemLanguage.Korean => "앱 업데이트가 필요합니다",
                    _ => "App Update is Required"
                };
            }
        }

        public static string GotoStore
        {
            get
            {
                return PlatformManager.GetSystemLanguage() switch
                {
                    SystemLanguage.Korean => "스토어로 이동",
                    _ => "Move to Store"
                };
            }
        }

        public static string Retry
        {
            get
            {
                return PlatformManager.GetSystemLanguage() switch
                {
                    SystemLanguage.Korean => "재시도",
                    _ => "Retry"
                };
            }
        }
        
    }

    public SkeletonAnimation splashSpine;
    public float splashLoopStartDelay = 1f;
    public TextMeshProUGUI txtDetails;
    public Button btLogin;
    public Slider loadingSlider;

    public ZButton btGuest;
    public ZButton btTelegram;

    public override void Awake()
    {
        base.Awake();
        
        Config.InitializeConfigForUnity();

        // if (Config.IsDebug)
        //     Debug.unityLogger.logEnabled = true;
        // else
        //     Debug.unityLogger.logEnabled = false;
        
        ResourceEntity.InitLanguage();

        Input.simulateMouseWithTouches = true;
        
        ZWorldClient.Get().CloseSilently();
        // EdgeClient.Get().CloseSilently();
    }
    
    public override void Update()
    {
        base.Update();
        
        while (_mainThreadWorkQueue.TryDequeue(out var action))
            action.Invoke();
    }

    public void OnGuestButtonTouched()
    {
        LoginV2(LoginType.Guest);
    }

    private async void LoginV2(LoginType loginType)
    {
        
        if (_logining)
            return;

        if (_foundBadApp != null)
        {
            // Popup_Alert.Show()
            //     .SetDesc($"Bad App Detected: {_foundBadApp}")
            //     .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
            //     .ShowCloseButton(false)
            //     .SetOkCallback(Application.Quit);
            return;
        }
        PlatformManager.Get().LogEvent("login_start", ("Type", loginType.ToString()));
        switch (loginType)
        {
            case LoginType.Guest:
            {
                OnLoggingIn(loginType);
                var prefKey = AuthManager.AuthPrefKey;              
                var deviceID = PlatformManager.GetDeviceID();
                var snsId = PlayerPrefs.GetString(AuthManager.AuthPrefKey, "");
                if (!string.IsNullOrEmpty(Config.snsID))
                    snsId = Config.snsID;

                if (string.IsNullOrEmpty(snsId))
                    snsId = "Guest_" + System.Guid.NewGuid().ToString("N");
                
                PlayerPrefs.SetString(prefKey, snsId);
                var pushToken = PlayerPrefs.GetString(Constants.Key.PUSH_TOKEN, "");
                var loginRequest = new LoginRequest
                {
                    SnsId = snsId,
                    ClientVersion = (uint)Utility.GetVersionInt(Application.version),
                    DeviceId = deviceID,
                    DeviceOS = Utility.GetOS(),
                    DeviceModel = SystemInfo.deviceModel,
                    Language = PlatformManager.GetLanguage(),
                    Country = PlatformManager.GetCountry(),
                    PushToken = pushToken,
                };

                // --- Start: Add commonsCommitHash logic ---
#if UNITY_EDITOR
                if (Constants.IGNORE_ASSETBUNDLE)
                {
                    string commonsPath = Path.Combine(Application.dataPath, "Scripts/Commons");
                    string commonsCommitHash = Utility.GetCommitHash(commonsPath);
                    loginRequest.CommonsCommitHash = commonsCommitHash;
                }
#endif
                
                ZWorldClient.Get().SendLoginPacket(Packet.Pop(0, loginRequest)).Forget();
                
                break;
            }

            default:
                break;
        }
    }

    private void OnScreenTouched()
    {
        if (_touchable)
        {
            LoginV2(LoginType.Guest);
        }
    }
    
    private void OnLoggingIn(LoginType loginType)
    {
        _touchable = false;
        _logining = true;
        
        // ShowPanelLogin(false);
        
        _loginType = loginType;
            
        if (txtDetails)
            txtDetails.text = ConstantStrings.Signing;
    }

    public override async void Start()
    {
        base.Start();
        
        // Init PlatformManager
        PlatformManager.Get();
        PluginManager.Get();
        PlatformManager.Init();
        AudioManager.Get().PlayBGM("BGM_Title");

        loadingSlider.value = 0;
        _logining = true;
        txtDetails.text = ConstantStrings.PrepareDownload;
        try
        {
            var (host, patchsetHost) = await ApiManager.Get().FetchBootstrap();
            if (!String.IsNullOrEmpty(host))
                ZWorldClient.Get().Host = host;
            if (!String.IsNullOrEmpty(patchsetHost))
                AssetBundleManager.Get().PatchsetHost = patchsetHost;
            AssetBundleManager.Get().FetchStatus(delegate (bool _success, string _error)
            {
                AssetBundleManager.Get().PrepareDownload(delegate(ulong size)
                {
                    DownloadAndLoad();
                });
            });
        }
        catch (Exception e)
        {
           Debug.LogError("[AssetBundleManager] Failed to fetch server bootstrap:" + e);
           Popup_Alert.Show()
               .SetDesc("FailedToFetchServerBootstrap".L())
               .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
               .ShowCloseButton(false)
               .SetOkCallback(() =>
               {
                   GoScene(Constants.LOGIN_SCENE, true);
               });
        }
        
        btGuest.SetOnClick(OnGuestButtonTouched);
        btGuest.SetActive(false);

        this.Run(() =>
        {
            splashSpine.AnimationState.SetAnimation(0, "Loop", true);
        }, splashLoopStartDelay);

#if UNITY_IOS && !UNITY_EDITOR
        this.Run(() =>
        {
            if (ATTrackingStatusBinding.GetAuthorizationTrackingStatus() ==
                ATTrackingStatusBinding.AuthorizationTrackingStatus.NOT_DETERMINED)
                ATTrackingStatusBinding.RequestAuthorizationTracking();
        }, 1f);
#endif

    }
    
    private void DownloadAndLoad()
    {
        PlatformManager.Get().LogEvent("downloadAssets_start");
        AssetBundleManager.Get().DownloadAll(delegate (float progress,Constants.AssetBundleType assetBundleType, float downloadedSize, float size)
        {
            downloadedSize /= 1024 * 1024;
            size /= 1024 * 1024;
            loadingSlider.value = progress;
            txtDetails.text = ConstantStrings.Downloading(assetBundleType);
        }, delegate (bool success, string error)
        {
            _logining = false;

            //
            if (!success)
            {
                PlatformManager.Get().LogEvent("downloadAssets_failed", ("Reason", "NetworkError"));
                Popup_Alert.Show()
                    .SetDesc(ConstantStrings.DownloadFailed)
                    .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                    .ShowCloseButton(false)
                    .SetOkCallback(() => GoScene(Constants.LOGIN_SCENE, true));
                return;
            }

            //
            _logining = true;
            loadingSlider.DOValue(1f, 1f);
            AssetBundleManager.Get().LoadAll(delegate(float progress, Constants.AssetBundleType assetBundleType, float downloadedSize, float size)
            {
                txtDetails.text = ConstantStrings.Loading(assetBundleType);
            }, delegate (bool successLoad, string error2)
            {
                _logining = false;

                //
                if (!successLoad)
                {
                    PlatformManager.Get().LogEvent("downloadAssets_failed",  ("Reason", "LoadError"));
                    Popup_Alert.Show()
                        .SetDesc(ConstantStrings.LoadFailed)
                        .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                        .ShowCloseButton(false)
                        .SetOkCallback(() =>
                        {
                            GoScene(Constants.LOGIN_SCENE, true);
                        });
                    return;
                }

                PlatformManager.Get().LogEvent("downloadAssets_success");

                //
                Utility.ResetMissingResources();
                LazyLoad.UnloadAll();
                Resources.UnloadUnusedAssets();
                Config.InitializeConfigFromGameConfig();
                BadWordFilter.Init();
                // TODO: implement below
                // Localizer.Get().Initialize(true);
                // GameData.Get();
                // AdManager.Initialize();
                // ResourceManager.Reset();

                // since this is WebGl, we need to load all resources from Resources folder
                if (Constants.IGNORE_ASSETBUNDLE)
                {
                    string json;
                    Config.LogInfo($"Reload ResourceGlobals.json");
                    json = Utility.LoadResource<string>("ResourceGlobals.json", true);
                    Commons.Resources.Resources.ReloadJson(json);
                    
                    // 반드시 Triggers 가장 먼저 로드
                    Config.LogInfo($"Reload Triggers.json");
                    json = Utility.LoadResource<string>("Triggers.json", true);
                    ResourceTrigger.ReloadJson(json);

                    Config.LogInfo($"Reload Strings.json");
                    json = Utility.LoadResource<string>("Strings.json", true);
                    ResourceString.ReloadJson(json);

                    Config.LogInfo($"Reload Achievements.json");
                    json = Utility.LoadResource<string>("Achievements.json", true);
                    ResourceAchievement.ReloadJson(json);

                    Config.LogInfo($"Reload Buffs.json");
                    json = Utility.LoadResource<string>("Buffs.json", true);
                    ResourceBuff.ReloadJson(json);

                    Config.LogInfo($"Reload Items.json");
                    json = Utility.LoadResource<string>("Items.json", true);
                    ResourceItem.ReloadJson(json);

                    Config.LogInfo($"Reload Maps.json");
                    json = Utility.LoadResource<string>("Maps.json", true);
                    ResourceMap.ReloadJson(json);

                    Config.LogInfo($"Reload Skills.json");
                    json = Utility.LoadResource<string>("Skills.json", true);
                    ResourceSkill.ReloadJson(json);

                    Config.LogInfo($"Reload Units.json");
                    json = Utility.LoadResource<string>("Units.json", true);
                    ResourceUnit.ReloadJson(json);

                    Config.LogInfo($"Reload Audios.json");
                    json = Utility.LoadResource<string>("Audios.json", true);
                    ResourceAudio.ReloadJson(json);
                }
                else
                {
                    byte[] bytes;
                    Config.LogInfo($"Reload ResourceGlobals.bytes");
                    bytes = Utility.LoadResource<byte[]>("ResourceGlobals.bytes", true);
                    Commons.Resources.Resources.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Triggers.bytes");
                    bytes = Utility.LoadResource<byte[]>("Triggers.bytes", true);
                    ResourceTrigger.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));
                    
                    Config.LogInfo($"Reload Strings.bytes");
                    bytes = Utility.LoadResource<byte[]>("Strings.bytes", true);
                    ResourceString.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Achievements.bytes");
                    bytes = Utility.LoadResource<byte[]>("Achievements.bytes", true);
                    ResourceAchievement.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Buffs.bytes");
                    bytes = Utility.LoadResource<byte[]>("Buffs.bytes", true);
                    ResourceBuff.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Items.bytes");
                    bytes = Utility.LoadResource<byte[]>("Items.bytes", true);
                    ResourceItem.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Maps.bytes");
                    bytes = Utility.LoadResource<byte[]>("Maps.bytes", true);
                    ResourceMap.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Skills.bytes");
                    bytes = Utility.LoadResource<byte[]>("Skills.bytes", true);
                    ResourceSkill.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Units.bytes");
                    bytes = Utility.LoadResource<byte[]>("Units.bytes", true);
                    ResourceUnit.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));

                    Config.LogInfo($"Reload Audios.bytes");
                    bytes = Utility.LoadResource<byte[]>("Audios.bytes", true);
                    ResourceAudio.ReloadBinary(bytes.DecryptAes(ResourceManager.EncryptKey));
                }
                
                // initialize after json load ends
                PurchaseManager.Get().Init();

                // TODO: temp, should be removed or at least modified after edge server is ready
                if (NetworkSystem.enableSocketConnection)
                {
                    ConnectNow();
                }
                else
                {
                    this.Run(() =>
                    {
                        MyPlayer.Player = new PlayerMessage()
                        {
                            Id = 1,
                        };

                        MyPlayer.CacheLevel(1);
                        MyPlayer.CacheAvatar(new PlayerAvatar
                        {
                            Character = new PlayerItemMessage
                            {
                                Id = 3,
                                ItemDataId = ResourceItem.Global.DataId.DefaultCharacter,
                                Count = 1,
                                Level = 1,
                            },
                        });

                        var homeMap = MyPlayer.GetCurrentHomeMap() ??
                                      ResourceMap.Get(ResourceMap.Global.DataId.TutorialMap);
                        if (homeMap == null)
                        {
                            Debug.LogError("Failed to resolve a local home map.");
                            return;
                        }

                        var gameBoard = MyPlayer.SetGameBoardLocal(homeMap.Id);
                        MyPlayer.Player.BoardId = gameBoard.Id;
                        SceneLoader.Get().LoadScene(Constants.GAME_SCENE, forced: true);
                    }, .5f);
                }
                
                // StartCoroutine(ResourceManager.Get().Load(
                //     progress =>
                //     {
                //         
                //     },
                //     () =>
                //     {
                //         PurchaseManager.Get().Init();
                //
                //         PlatformManager.InitSentry();
                //         PlatformManager.InitChannel();
                //         
                //         ConnectNow();
                //     }
                // ));
            });
        });
    }
    
    private void ConnectNow()
    {
        //
        ShowPanelLogin(false);
        ////
        if (txtDetails)
            txtDetails.text = ConstantStrings.Connecting;
        
        Debug.Log($"Connecting to World Server... {ZWorldClient.Get().Host}");
        ZWorldClient.Get().ConnectAsync().ConfigureAwait(false);
    }

    #region Old Login Functions
    public void LoginAsGuest()
    {
        // Login(LoginType.Guest);
    }
    
    private void Login(LoginType loginType)
    {
        PlayClick();
        // If login-ing, just ignore!
        if (_logining)
            return;

        if (_foundBadApp != null)
        {
            //GameManager.Get().ShowAlert(Popup_Alert.Type.OK, string.Format("Format_System_BadApps".L(), _foundBadApp),
            //                             delegate (int result)
            //                             {
            //                                 Application.Quit();
            //                             });
        }

        //

        //
        if (PlayerPrefs.GetInt(Constants.Key.LOGIN_TYPE, -1) != (int)loginType)
        {
            PlayerPrefs.DeleteKey(Constants.Key.SNS_ID);
        }
        else
        {
            if (!string.IsNullOrEmpty(PlayerPrefs.GetString(Constants.Key.SNS_ID)))
            {
                _loginType = loginType;
                ConnectNow();
                return;
            }
        }

        //
        //
        _loginType = loginType;
        if (txtDetails)
            txtDetails.text = ConstantStrings.Signing;

        //
        ShowPanelLogin(false);

        //
        // if(Application.isEditor || Application.platform == RuntimePlatform.OSXPlayer) {
        // 	PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
        // 	PlayerPrefs.Save ();

        // 	ConnectNow();
        // 	return;
        // }

        //


//         if (loginType == (int)LoginType.GOOGLE_PLAY)
//         {
// #if UNITY_ANDROID
//             if (GooglePlayGames.PlayGamesPlatform.Instance.localUser.authenticated)
//             {
//                 //
//                 PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                 PlayerPrefs.SetString(Constants.Key.SNS_ID, "GOOGLE_" + Social.localUser.id);
//                 PlayerPrefs.Save();
//
//                 PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                 //
//                 ConnectNow();
//                 return;
//             }
//             else
//             {
//                 _logining = true;
//
//                 //
//                 this.Run(delegate
//                 {
//                     if (WorldClient.Get().connected)
//                         return;
//
//                     if (txtDetails)
//                         txtDetails.text = "GOOGLE PLAY LOGIN ERROR";
//                 }, 7f);
//
//                 GooglePlayGames.PlayGamesPlatform.Instance.Authenticate(status =>
//                 {
//                     _mainThreadWorkQueue.Enqueue(() =>
//                     {
//                         _logining = false;
//                         if (status != SignInStatus.Success)
//                         {
//                             PlatformManager.Get().LogEvent("Auth_Fail", ("Login_Type", _loginType.ToString()));
//                             GameManager.Get().ShowAlert(Popup_Alert.Type.OK, "Scene_Login_GooglePlayFailed".L(), r =>
//                             {
//                                 OnRetry();
//                             });
//                             return;
//                         }
//
//                         if (WorldClient.Get().connected)
//                             return;
//
//                         //
//                         PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                         PlayerPrefs.SetString(Constants.Key.SNS_ID, "GOOGLE_" + Social.localUser.id);
//                         PlayerPrefs.Save();
//                         PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                         //
//                         ConnectNow();
//                     });
//                 });
//             }
// #endif
//         }
//         if (loginType == (int)LoginType.GAME_CENTER)
//         {
//             if (Social.localUser.authenticated)
//             {
//                 //
//                 PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                 PlayerPrefs.SetString(Constants.Key.SNS_ID, "APPLE_" + Social.localUser.id);
//                 PlayerPrefs.Save();
//
//                 //
//                 PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                 ConnectNow();
//
//                 return;
//             }
//             else
//             {
//                 _logining = true;
//
//                 //
//                 this.Run(delegate
//                 {
//                     if (WorldClient.Get().connected)
//                         return;
//
//                     if (txtDetails)
//                         txtDetails.text = "GAME CENTER LOGIN ERROR";
//                 }, 10f);
//
//                 Social.localUser.Authenticate((bool success) =>
//                 {
//                     _mainThreadWorkQueue.Enqueue(() =>
//                     {
//                         _logining = false;
//                         if (!success)
//                         {
//                             PlatformManager.Get().LogEvent("Auth_Fail", ("Login_Type", _loginType.ToString()));
//                             OnRetry();
//                             return;
//                         }
//
//                         if (WorldClient.Get().connected)
//                             return;
//
//                         //
//                         PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                         PlayerPrefs.SetString(Constants.Key.SNS_ID, "APPLE_" + Social.localUser.id);
//                         PlayerPrefs.Save();
//
//                         //
//                         PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                         ConnectNow();
//                     });
//                 });
//             }
//         }
//         else if (loginType == (int)LoginType.FACEBOOK)
//         {
//
//             if (FB.IsLoggedIn)
//             {
//                 //
//                 PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                 PlayerPrefs.SetString(Constants.Key.SNS_ID, "FB_" + AccessToken.CurrentAccessToken.UserId);
//                 PlayerPrefs.Save();
//
//                 //
//                 PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                 ConnectNow();
//             }
//             else
//             {
//                 _logining = true;
//                 FB.LogInWithReadPermissions(null, delegate (ILoginResult result)
//                 {
//                     _mainThreadWorkQueue.Enqueue(() =>
//                     {
//                         _logining = false;
//                         if (!FB.IsLoggedIn)
//                         {
//                             PlatformManager.Get().LogEvent("Auth_Fail", ("Login_Type", _loginType.ToString()));
//                             OnRetry();
//                             return;
//                         }
//
//                         if (!string.IsNullOrEmpty(result.Error))
//                         {
//                             GameManager.Get().ShowAlert(Popup_Alert.Type.OK, result.Error, delegate (int popupResult)
//                             {
//                                 GoScene(Constants.LOGIN_SCENE , true);
//                             });
//                             return;
//                         }
//
//
//                         //
//                         PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                         PlayerPrefs.SetString(Constants.Key.SNS_ID, "FB_" + AccessToken.CurrentAccessToken.UserId);
//                         PlayerPrefs.Save();
//
//                         //
//                         PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                         ConnectNow();
//                     });
//                 });
//             }
//         }
//         else if (loginType == (int)LoginType.APPLE)
//         {
//             var apple = this.Get<SignInWithApple>();
//
//             _logining = true;
//             var snsID = GameManager.Get().GetSNSID();
//             if (!string.IsNullOrEmpty(snsID) && snsID.StartsWith("APPLE2_"))
//             {
//                 ConnectNow();
//             }
//             else 
//             {
//                 apple.Login((s) =>
//                 {
//                     _mainThreadWorkQueue.Enqueue(() =>
//                     {
//                         _logining = false;
//
//                         if (!string.IsNullOrEmpty(s.error))
//                         {
//                             PlatformManager.Get().LogEvent("Auth_Fail", ("Login_Type", _loginType.ToString()));
//                             GameManager.Get().ShowAlert(Popup_Alert.Type.OK, s.error, delegate (int popupResult)
//                             {
//                                 GoScene(Constants.LOGIN_SCENE , true);
//                             });
//                             return;
//                         }
//
//                         //
//                         if (string.IsNullOrEmpty(s.userInfo.userId))
//                         {
//                             PlatformManager.Get().LogEvent("Auth_Fail", ("Login_Type", _loginType.ToString()));
//                             OnRetry();
//                             return;
//                         }
//
//                         //
//                         PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
//                         PlayerPrefs.SetString(Constants.Key.SNS_ID, "APPLE2_" + s.userInfo.userId);
//                         //PlayerPrefs.SetString(Constants.Key.EMAIL, s.userInfo.email);
//                         PlayerPrefs.Save();
//
//                         //
//                         PlatformManager.Get().LogEvent("Auth_Success", ("Login_Type", _loginType.ToString()));
//                         ConnectNow();
//                     });
//
//                 });
//             }
//         }
//         else if (loginType == (int)LoginType.GUEST)
        // {
        //     PlayerPrefs.SetInt(Constants.Key.LOGIN_TYPE, loginType);
        //     PlayerPrefs.Save();
        //
        //     ConnectNow();
        //     return;
        // }
    }
    
    private void ShowPanelLogin(bool visible)
    {
        btLogin.SetActive(visible);

// #if UNITY_IPHONE || UNITY_WEBGL
// 		if(panelLoginIOS) panelLoginIOS.SetActive(visible);
// 		if(panelLoginAndroid) panelLoginAndroid.SetActive(false);
// #else
//         if (panelLoginIOS) panelLoginIOS.SetActive(false);
//         if (panelLoginAndroid) panelLoginAndroid.SetActive(visible);
// #endif
    }
    
    #endregion
    

    bool _touchable = false;
    protected override bool OnBack()
    {
        if (base.OnBack())
            return true;

        Application.Quit();
        return true;
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);
        switch (e.type)
        {
            case GameEventType.SOCKET_CONNECTED:
            {
                if (txtDetails)
                    txtDetails.text = ConstantStrings.Connected;
                _touchable = true;

                if (Config.IsDebug)
                {
                    btGuest.gameObject.SetActive(true);
                    // btTelegram.gameObject.SetActive(true);
                }
                else
                {
                    LoginV2(LoginType.Guest);
                }
                break;
            }
            case GameEventType.SOCKET_DISCONNECTED:
            case GameEventType.EDGE_SOCKET_DISCONNECTED:
            {
                if (!this) return;
                _logining = false;
                HideLoading();
                // EdgeClient.Get().CloseSilently();
                Popup_Alert.Show()
                    .SetDesc(ConstantStrings.LoginFailed)
                    .SetOkText(ConstantStrings.Retry)
                    .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                    .ShowCloseButton(false)
                    .SetOkCallback(() =>
                    {
                        if (!this) return;
                        GoScene(Constants.LOGIN_SCENE, true);
                    });
                break;
            }
            case GameEventType.SOCKET_CONNECT_FAILED:
            {
                if (!this) return;
                _logining = false;
                HideLoading();
                Popup_Alert.Show()
                    .SetDesc(ConstantStrings.LoginFailed)
                    .SetOkText(ConstantStrings.Retry)
                    .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                    .ShowCloseButton(false)
                    .SetOkCallback(() =>
                    {
                        if (!this) return;
                        GoScene(Constants.LOGIN_SCENE, true);
                    });
                break;
            }
            case GameEventType.SOCKET_GOT_PACKET:
            {
                var p = e.args[0] as Packet;
                switch (p.PacketType)
                {
                    case Packet.Type.Request:
                    {
                        var r = p.Request;
                        if (r.RequestCase == Request.RequestOneofCase.LoginResponse)
                        {
                            var loginResponse = r.LoginResponse;

                            GameManager.HandleCommonStatus(loginResponse.Status, loginResponse.Message);

                            if (loginResponse.Status.IsSuccess())
                            {
#if !UNITY_EDITOR
#endif
                                AuthManager.RegisterFirebase();
                                // Refresh MyPlayer
                                Debug.Log($"Login Succeeded! Player ID: {loginResponse.Player.Id}, Name: {loginResponse.Player.Name}");
                                ZWorldClient.Get().ResetLastPingAt();
                                MyPlayer.Player = loginResponse.Player;
                                MyPlayer.World = loginResponse.World;
                                MyPlayer.CacheAvatar(loginResponse.Avatar);
                                MyPlayer.OverrideItems(loginResponse.Items);
                                MyPlayer.OverrideAchievements(loginResponse.Achievements);

                                // Get Board from server
                                if (loginResponse.Player.BoardId != default)
                                {
                                    var getBoardPacket = Packet.Pop(0, new GetBoardRequest());
                                    var response = await ZWorldClient.Get().SendPacket(getBoardPacket);
                                    if (!response.Status.IsSuccess())
                                    {
                                        if (response.Status == StatusCode.RequestTimeOut)
                                        {
                                            var leaveBoardPacket = Packet.Pop(0, new LeaveBoardRequest());
                                            await ZWorldClient.Get().SendPacket(leaveBoardPacket);
                                            
                                            GoToLobby();
                                        }
                                        else
                                        {
                                            GoScene(Constants.LOGIN_SCENE, true);
                                        }
                                    }
                                }
                                else
                                {
                                    // get current challenging map
                                    GoToLobby();
                                }
                            }
                            else if (loginResponse.Status == StatusCode.ServerMaintenance)
                            {
                                PlatformManager.Get().LogEvent("login_failed", ("Reason", "ServerMaintenance"));
                                var localTime = loginResponse.MaintenanceUntilAt.ToDateTime().ToLocalTime();
                                var utcOffset = TimeZoneInfo.Local.GetUtcOffset(localTime).Hours;
                                var formattedTime = localTime.ToString("yyyy-MM-dd HH:mm:ss");
                                var description = "Alert_ServerMaintenance".L($"{formattedTime} (UTC+{utcOffset})");
                                
                                Popup_Alert.Show()
                                    .SetDesc(description)
                                    .SetOkText(ConstantStrings.Retry)
                                    .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                                    .ShowCloseButton(false)
                                    .SetOkCallback(() =>
                                    {
                                        if (!this) return;
                                        GoScene(Constants.LOGIN_SCENE, true);
                                    });    
                            }
                            else if (loginResponse.Status == StatusCode.OutdatedClient)
                            {
                                PlatformManager.Get().LogEvent("login_failed", ("Reason", "OutdatedClient"));
                                Popup_Alert.Show()
                                    .SetDesc(ConstantStrings.VersionOutDated)
                                    .SetOkText(ConstantStrings.GotoStore)
                                    .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                                    .ShowCloseButton(false)
                                    .SetOkCallback(() =>
                                    {
                                        if (!this)
                                            return;
                                        Application.OpenURL(PlatformManager.GetMarketURL());
                                    });
                            }
                            else
                            {
                                PlatformManager.Get().LogEvent("login_failed", ("Reason", loginResponse.Status.ToString()));
                                Popup_Alert.Show()
                                    .SetDesc(ConstantStrings.LoginFailed)
                                    .SetOkText(ConstantStrings.Retry)
                                    .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
                                    .ShowCloseButton(false)
                                    .SetOkCallback(() =>
                                    {
                                        if (!this) return;
                                        GoScene(Constants.LOGIN_SCENE, true);
                                    });
                            }
                        }
                        else if (r.RequestCase == Request.RequestOneofCase.GetBoardResponse)
                        {
                            if (!_logining)
                                return;
                            
                            var res = p.Request.GetBoardResponse;
                            GameManager.HandleCommonStatus(res.Status, res.Message, showCenterLabel: true);

                            if (res.Status.IsSuccess())
                            {
                                if (res.CompressedBoard != default)
                                {
                                    var board = res.CompressedBoard.Decompress<GameBoard>();
                                    MyPlayer.SetGameBoard(board);
                                
                                    _logining = false;
                                    SceneLoader.Get().LoadScene(Constants.GAME_SCENE, forced: true);
                                }
                                else
                                {
                                    Debug.Log("Bad compressed Board!");
                                    Toast.Show<Popup_Toast>("Failed to initialize".L());
                                    GoScene(Constants.LOGIN_SCENE , true);
                                }
                                
                            }
                            else
                            {
                                //GameManager.Get().ShowAlert(Popup_Alert.Type.OK, "AlertLoginFailed".L(), delegate (int result)
                                //{
                                //    if (!this) return;
                                //    GoScene(Constants.LOGIN_SCENE , true);
                                //});
                            }
                        }
                        break;

//                     if (StatusCode.IsSuccess(l.status))
//                     {
//                         var isWillSave = false;
//                         if (_loginType == LoginType.GUEST)
//                         {
//                             PlayerPrefs.SetString(Constants.Key.SNS_ID, l.snsID);
//                             PlayerPrefs.SetString(Constants.Key.GUEST_SNS_ID, l.snsID);
//                             isWillSave = true;
//                         }
//
//                         var edgeClient = EdgeClient.Get();
//                         if (edgeClient != null)
//                         {
//                             try
//                             {
//                                 var edgeClientDate = edgeClient.serverDateTime;
//                                 var oldDateStr = PlayerPrefs.GetString(Constants.Key.LAST_LOGIN_DATE, string.Empty);
//                                 var isWillDateSave = string.IsNullOrEmpty(oldDateStr);
//                                 if (!isWillDateSave)
//                                 {
//                                     var day = edgeClientDate - DateTime.Parse(oldDateStr);
//                                     if (day.Days > 14)
//                                         PlatformManager.Get().LogEvent("Returning_User", ("Days", day.Days.ToString()));
//
//                                     isWillDateSave = day.Days > 0;
//                                 }
//
//                                 if (isWillDateSave)
//                                 {
//                                     PlayerPrefs.SetString(Constants.Key.LAST_LOGIN_DATE, edgeClientDate.ToString());
//                                     isWillSave = true;
//                                 }
//                             } catch (Exception ex)
//                             {
//                                 Debug.LogError($"[Script] Scene_Login.cs:868 => HandleEvent(GameEvent) : {ex.Message}");
//                             }
//                         }
//                         else
//                             Debug.LogError("[Script] Scene_Login.cs:872 => HandleEvent(GameEvent) : EdgeClient is Null");
//
//                         if (isWillSave)
//                             PlayerPrefs.Save();
// //
// //                         var deviceID = PlatformManager.GetDeviceID();
// // #if UNITY_ANDROID
// //                         AppGuardUnityManager.Instance.setUniqueClientId($"{deviceID.Substring(0, Math.Min(30, deviceID.Length))}{l.player.id:D10}:{(long)(Utility.GetTime() * 1000d)}:TAICCwo=");
// // #elif UNITY_IPHONE
// //                         AppGuardUnityManager.Instance.setUniqueClientId($"{deviceID.Substring(0, Math.Min(30, deviceID.Length))}{l.player.id:D10}:{(long)(Utility.GetTime() * 1000d)}:TAICCw0=");
// // #endif
// //                         AppGuardUnityManager.Instance.setUserId(l.player.id.ToString());
// // #if !UNITY_EDITOR
// //                         SentrySdk.ConfigureScope(scope =>
// //                         {
// //                             scope.User = new User
// //                             {
// //                                 Id = l.player.id.ToString(),
// //                                 Username = l.player.@public.name,
// //                             };
// //                         });
// // #endif
//                         // var airbridgeUser = new AirbridgeUser(l.player.id.ToString());
//                         // airbridgeUser.SetAlias("name", l.player.@public.name);
//                         // AirbridgeUnity.SetUser(airbridgeUser);
//                     }
                    }
                }

                break;
            }
        }
    }

    private void GoToLobby()
    {
        if (MyPlayer.GetAchievementByDataID(ResourceAchievement.Global.DataId.IngameTutorialEnter)?.IsAchievementCompletedOrRewarded() == false)
        {
            ZWorldClient.Get().SendPacket(Packet.Pop(0, new IncreaseAchievementRequest()
            {
                AchievementDataId = ResourceAchievement.Global.DataId.IngameTutorialEnter,
                Progress = 1
            })).Forget();

            SceneLoader.Get().LoadScene(Constants.GAME_SCENE, forced: true, onLoad: () =>
            {
                GameBoardManager.Get().GoToMapLocalToNet(ResourceMap.Global.DataId.TutorialMap).Forget();
            });
        }
        else
        {
            var goToMap = MyPlayer.GetCurrentHomeMap();
            if (goToMap == null)
            {
                Debug.LogError("Failed to resolve a home map after login.");
                GoScene(Constants.LOGIN_SCENE, true);
                return;
            }

            var gameBoard = MyPlayer.SetGameBoardLocal(goToMap.Id);
            MyPlayer.Player.BoardId = gameBoard.Id;
            SceneLoader.Get().LoadScene(Constants.GAME_SCENE, forced: true);
        }
    }
    
    [Serializable]
    public class TelegramLoginData
    {
        public string initData;
        public string userId;
        public string firstName;
        public string lastName;
        public string userName;
    }
    

    private TelegramLoginData _telegramLoginData;

    public void Login(string rawLoginData)
    {
        //Toast.Show<Popup_Toast>("Got Telegram Login Data");
        var loginData = JsonUtility.FromJson<TelegramLoginData>(rawLoginData);
        if (loginData == null)
            return;
        //Toast.Show<Popup_Toast>("Got Telegram Login Data, userId: " + loginData.userId);
        
        Debug.Log($"Telegram Login Data: {loginData.initData}, {loginData.userId}, {loginData.firstName}, {loginData.lastName}, {loginData.userName}");
        
        _telegramLoginData = loginData;
    }
}
