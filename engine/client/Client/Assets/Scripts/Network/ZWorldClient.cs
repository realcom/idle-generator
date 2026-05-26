using System;
using Commons.Packets;
using Commons.Packets.Requests;
using Cysharp.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ZWorldClient : ZClient
{
    private static readonly ZWorldClient singleton = new();

    public static ZWorldClient Get()
    {
        return singleton;
    }

    private ZWorldClient()
    {
    }
    
    public int retryConnectServer;
    
    // private int _retryConnectEdgeServer;
    // private bool _edgeServerLogined;
    private bool _worldServerLogined;
    private int _disconnectedCounter;
    
    public static DateTime startAt;
    
    // DEBUG
#if UNITY_EDITOR
    public static double debugServerTime;
#endif
    
    [RuntimeInitializeOnLoadMethod]
    private static void Initialize()
    {
        // World 서버 단일 구조여서 주석
        // if (!NetworkSystem.enableSocketConnection)
        //     return;
        
        // Start
        startAt = singleton.serverDateTime;

        // Update
        ZPlayerLoopSystemHelper.InsertSystemBefore(typeof(ZWorldClient), singleton.UpdateThis, typeof(UnityEngine.PlayerLoop.Update.ScriptRunBehaviourUpdate));
        
        // LateUpdate
        ZPlayerLoopSystemHelper.InsertSystemBefore(typeof(ZWorldClient), singleton.LateUpdateThis, typeof(UnityEngine.PlayerLoop.PreLateUpdate.ScriptRunBehaviourLateUpdate));
    }
    
    public void UpdateThis()
    {
        Update();
    }
    
    public void LateUpdateThis()
    {
        LateUpdate();
        
#if UNITY_EDITOR
        debugServerTime = serverTime;
#endif
        
        // if (!BaseScene.isCurrentSceneLogin)
        // {
        //     if (!connected)
        //     {
        //         if (++_disconnectedCounter > 5f / Time.deltaTime)
        //         {
        //             _disconnectedCounter = 0;
        //
        //             Debug.Log($"Reconnect to World Server... {retryConnectServer}");
        //             // EdgeClient.Get().CloseSilently();
        //             
        //             singleton.Reconnect();
        //
        //             // GameManager.Get().ShowAlert(Popup_Alert.Type.OK, "AlertServerDisconnected".L(), delegate (int result)
        //             // {
        //             //     if (!this)
        //             //         return;
        //             //     GoScene("LoginScene", true);
        //             // });
        //         }
        //     }
        //     else
        //         _disconnectedCounter = 0;
        // }
    }

    protected override void HandleConnected()
    {
        base.HandleConnected();
        DispatchEvent(GameEvent.Get(GameEventType.SOCKET_CONNECTED));
        
        if (Utility.isDebugMode)
            Toast.Show<Popup_Toast>("SOCKET_CONNECTED");
    }

    protected override void HandleDisconnected()
    {
        base.HandleDisconnected();
        DispatchEvent(GameEvent.Get(GameEventType.SOCKET_DISCONNECTED));
        
        if (Utility.isDebugMode)
            Toast.Show<Popup_Toast>("SOCKET_DISCONNECTED");
    }

    protected override void HandleConnectFailed()
    {
        base.HandleConnectFailed();
        DispatchEvent(GameEvent.Get(GameEventType.SOCKET_CONNECT_FAILED));
        
        if (Utility.isDebugMode)
            Toast.Show<Popup_Toast>("SOCKET_CONNECT_FAILED");
        
        // override workaround
        if (SceneManager.GetActiveScene().name == Constants.LOGIN_SCENE )
            return;
        
        _worldServerLogined = false;
        if (--retryConnectServer > 0)
        {
            Debug.Log($"Reconnect to World Server... {retryConnectServer}");
            //SceneLoader.Get().Run(Reconnect, 1f);
            return;
        }
                
        var currentScene = GameManager.Get().scene;
        currentScene?.HideLoading();
        // EdgeClient.Get().CloseSilently();
        
        Popup_Alert.Show()
            .SetDesc("Login Failed")
            .SetOkText("Retry")
            .SetButtonType(Popup_Alert.ButtonViewFlag.OK)
            .ShowCloseButton(false)
            .SetOkCallback(() =>
            {
                if (currentScene == null) return;
                currentScene.GoScene(Constants.LOGIN_SCENE, true);
            });
    }


    // Process the command received from the server, and take appropriate action.
    protected override async UniTask HandlePacket(Packet packet)
    {
        await base.HandlePacket(packet);
        var e = GameEvent.Get(GameEventType.SOCKET_GOT_PACKET, packet);
        DispatchEvent(e);
    }
}