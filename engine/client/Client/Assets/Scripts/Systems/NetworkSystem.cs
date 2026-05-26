using System.Collections;
using System.Collections.Generic;
using Commons.Packets;
using Commons.Packets.Requests;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

public class NetworkSystem : BaseSystem<NetworkSystem>
{

#if UNITY_EDITOR
    [InitializeOnLoadMethod]
#else
    [RuntimeInitializeOnLoadMethod]
#endif
    private static void Initialize()
    {
        enableSocketConnection = LoadBool(nameof(enableSocketConnection), enableSocketConnection);
        checkOutPing = LoadBool(nameof(checkOutPing), checkOutPing);
        doNotSendBoardToServer = LoadBool(nameof(doNotSendBoardToServer), doNotSendBoardToServer);

#if UNITY_IOS || UNITY_ANDROID
        enableSocketConnection = true;
        checkOutPing = true;
#endif
    }
    
    [ShowInInspector, OnValueChanged("OnValueChanged_enableSocketConnection")]
    public static bool enableSocketConnection = true;
    
    [ShowInInspector, OnValueChanged("OnValueChanged_checkOutPing")]
    public static bool checkOutPing = true;

    [ShowInInspector, OnValueChanged("OnValueChanged_doNotSendBoardToServer"), Tooltip("많은 치트 사용하려면 해당 옵션을 체크하세요.\n 주의! 해당 옵션을 체크하면 틱이 깨지는 상황을 발견할 수 없습니다.")]
    public static bool doNotSendBoardToServer = false;


#if UNITY_EDITOR
    [Button]
    public static void ForceCloseSocketConnection()
    {
        ZWorldClient.Get().Close();
    }
#endif


#if UNITY_EDITOR
    [Button]
    public static void RefreshBoard()
    {
        GameBoardManager.Get().BlockBoardPacketSending(true);
        var getBoardPacket = Packet.Pop(0, new GetBoardRequest());
        ZWorldClient.Get().SendPacket(getBoardPacket).Forget();
    }
#endif

#if UNITY_EDITOR
    [Button]
    public static void BlockPacketSendingFor30Seconds()
    {
        ZWorldClient.Get().BlockPacketSendingForTest(30);
    }
#endif
    

    private static void OnValueChanged_enableSocketConnection()
    {
        SaveBool(nameof(enableSocketConnection), enableSocketConnection);
    }
    
    private static void OnValueChanged_checkOutPing()
    {
        SaveBool(nameof(checkOutPing), checkOutPing);
    }
    
    private static void OnValueChanged_doNotSendBoardToServer()
    {
        SaveBool(nameof(doNotSendBoardToServer), doNotSendBoardToServer);
    }
    
}
