using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Cysharp.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using static ZClient;

public interface IScene
{
    public Canvas GetCanvas();
    public Camera GetCamera();
    public Transform GetPopupParent();
    public Transform GetToastParent();

    public void ShowLoading(string msg = null);
    public void HideLoading();
    public void GoScene(string name, bool forced = false);
    
    public GraphicRaycaster GraphicRaycaster { get; }
}

public abstract class BaseScene<TScene> : EventBehaviour, IScene where TScene : BaseScene<TScene>
{
    private static TScene _instance;
    public static TScene Get() => _instance;
    
    public static bool isCurrentSceneLogin => SceneManager.GetActiveScene().name == Constants.LOGIN_SCENE ;
    
    protected static string _foundBadApp = null;
    private static int _disconnectedCounter;
    private float _disconnectStartedAt = -1f;
    private const float DisconnectTimeoutSeconds = 30f;
    protected Canvas canvas { get; set; }
    protected Camera camera { get; set; }
    
    [SerializeField] protected Transform trPopup;
    [SerializeField] protected Transform trToast;

    public override void Awake()
    {
        _instance = this as TScene;
        
        foreach (var p in GetComponentsInChildren<UIPopup>())
            p.Hide();
        
        base.Awake();
        
        GameManager.Get().HandleSceneAwake(this);
        
        Screen.orientation = ScreenOrientation.Portrait;
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = Mathf.CeilToInt((float)Screen.currentResolution.refreshRateRatio.value);
        
        canvas  = this.Get<Canvas>();
        if (canvas.renderMode == RenderMode.WorldSpace)
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
        
        camera = Camera.main!;
        camera.backgroundColor = Color.black;
    }

    public override void OnDestroy()
    {
        if (_instance == this)
            _instance = null;
        
        base.OnDestroy();
    }

    public override void Start()
    {
        base.Start();
        GameManager.Get().HandleSceneStart(this);
        
        // startAt = ZWorldClient.Get().serverDateTime;
        
        SceneManager.SetActiveScene(gameObject.scene);
        
        ZWorldClient.Get().ProcessGatheredPackets();
        // EdgeClient.Get().ProcessGatheredPackets();
        
        Refresh();
    }
    
    public override void Refresh()
    {
        base.Refresh();
    }
    
    public virtual void Update()
    {
    }

    long a = 0;
    
    public virtual void LateUpdate()
    {
        if (_foundBadApp != null) 
            return;

        if (Input.GetKeyDown(KeyCode.Escape))
            OnBack();

        if (ZWorldClient.Get().State < ConnectState.Connected)
        {
            if (SceneManager.GetActiveScene().name == Constants.LOGIN_SCENE)
                return;
            
            if (_disconnectStartedAt < 0f)
                _disconnectStartedAt = Time.realtimeSinceStartup;

            // ===== 추가: 15초 제한 초과 시 즉시 로그인 씬으로 =====
            if (Time.realtimeSinceStartup - _disconnectStartedAt >= DisconnectTimeoutSeconds)
            {
                _disconnectStartedAt = -1f;
                GameManager.Get().HideLoading().Forget();
                HandleDisconnected(); // 내부에서 로그인 씬 이동
                return;
            }

            
            if (++_disconnectedCounter > 5f / Time.deltaTime)
            {
                _disconnectedCounter = 0;

                TryReconnect().Forget();
            }
        }
        else
        {
            _disconnectedCounter = 0;
            _disconnectStartedAt = -1f;
        }
    }

    private async UniTask TryReconnect()
    {
        Debug.Log("Reconnect to ...");
        
        var resMap = GameBoardManager.Get()?.gameBoard?.ResMap;
        var showLoading = resMap is { Type: ResourceMap.Types.Type.Lobby };
        if (showLoading)
            await GameManager.Get().ShowLoading("Reconnecting".L());

        if (!await ZWorldClient.Get().Reconnect())
        {
            if (showLoading)
                await GameManager.Get().HideLoading();
            return;
        }

        var response = await SendLoginPacket();
        if (showLoading)
            await GameManager.Get().HideLoading();
        if (!response.Status.IsSuccess())
            HandleDisconnected();

        _disconnectStartedAt = -1f;
    }

    protected virtual bool OnBack()
    {
        if (GameManager.Get().BackPopup())
            return true;
        return false;
    }
    
    public void ShowLoading(string msg = null)
    {
        GameManager.Get().ShowLoading(msg).Forget();
    }

    public void HideLoading()
    {
        GameManager.Get().HideLoading().Forget();
    }

    public void GoScene(string name, bool forced = false)
    {
        if (!forced && SceneManager.GetSceneByName(name).IsValid())
            return;

        try
        {
            EventSystem.current.SetSelectedGameObject(null);
        }
        catch (Exception)
        {
        }

        //
        ZWorldClient.Get().GatherPackets();
        // EdgeClient.Get().GatherPackets();
        
        SceneManager.LoadSceneAsync(name);
    }

    [SerializeField] protected GraphicRaycaster _graphicRaycaster;
    public GraphicRaycaster GraphicRaycaster => _graphicRaycaster;

    public void PlayClick()
    {
        GameManager.Get().PlayClick();
    }

    public void OnApplicationPause(bool pauseStatus)
    {
        if (SceneManager.GetActiveScene().name == Constants.LOGIN_SCENE )
            return;
        
        // TODO: handle pause, e.g. network ping control
    }
    
    public override async UniTask HandleEvent(GameEvent e)
    {
        switch (e.type)
        {
            case GameEventType.SOCKET_GOT_PACKET:
            {
                var p = e.args[0] as Packet;
                switch (p.PacketType)
                {
                    case Packet.Type.Update:
                    {
                        var u = p.Update;
                        if (u.UpdateCase == Commons.Packets.Updates.Update.UpdateOneofCase.PlayerDisconnectedUpdate)
                        {
                            HandleDisconnected();
                        }

                        break;
                    }
                    default:
                        break;
                }
                break;
            }
        }

    }

    private void HandleDisconnected(bool goLoginScene = true)
    {
        Popup_Alert.Show()
            .SetDesc("PlayerDisconnected".L())
            .SetOkText("OK".L())
            .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
            .ShowCloseButton(false)
            .SetOkCallback(() =>
            {
                if (!this) return;
                if (goLoginScene)
                    GoScene(Constants.LOGIN_SCENE, true);
            });
    }

    public async UniTask<LoginRequest.Types.Response> SendLoginPacket()
    {
        if (!ZWorldClient.Get().IsConnected)
        {
            Debug.Log($"send login packet failed, not connected.");
            return new LoginRequest.Types.Response()
            {
                Status = StatusCode.LostConnection,
                Message = ResourceString.Get(StatusCode.LostConnection, ResourceEntity.Language)
            };
        }
        
        var savedSnsId = PlayerPrefs.GetString(Constants.Key.GUEST_SNS_ID);
        if (savedSnsId != null)
        {
            var loginPacket = Packet.Pop(0,
                new LoginRequest
                {
                    SnsId = savedSnsId, ClientVersion = (uint)Utility.GetVersionInt(Application.version)
                });

            return await ZWorldClient.Get().SendLoginPacket(loginPacket);
        }
        
        return new LoginRequest.Types.Response()
        {
            Status = StatusCode.BadRequest,
            Message = ResourceString.Get(StatusCode.BadRequest, ResourceEntity.Language)
        };
    }

    public Canvas GetCanvas()
    {
        return canvas;
    }

    public Camera GetCamera()
    {
        return camera;
    }

    public Transform GetPopupParent()
    {
        return trPopup;
    }

    public Transform GetToastParent()
    {
        return trToast;
    }
}
