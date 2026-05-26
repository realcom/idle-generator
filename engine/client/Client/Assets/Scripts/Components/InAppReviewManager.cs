using System;
using System.Collections;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using UnityEngine;

#if UNITY_ANDROID
using Google.Play.Review;
#elif UNITY_IOS
using UnityEngine.iOS;
#endif

public class InAppReviewManager : MonoBehaviour
{
    private static InAppReviewManager _singleton;
    public static InAppReviewManager Get()
    {
        if (_singleton == null)
        {
            _singleton = new GameObject("[InAppReviewManager]").AddComponent<InAppReviewManager>();
        }

        return _singleton;
    }

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }

    public void Request(bool forced = false)
    {
        var requested = PlayerPrefs.GetInt("InAppReviewManager.requested", 0);

        if (!forced && requested == 1)
            return;

        if (MyPlayer.GetAchievementByDataID(ResourceAchievement.Global.DataId.ReviewedOnStore).State == PlayerAchievementMessage.Types.State.InProgress)
        {
            ZWorldClient.Get().SendPacket(Packet.Pop(0, new IncreaseAchievementRequest()
            {
                AchievementDataId = ResourceAchievement.Global.DataId.ReviewedOnStore,
                Progress = 1
            })).Forget();
        }

        try
        {
#if UNITY_EDITOR || UNITY_DEV
            RequestTest();
#elif UNITY_ANDROID
            StartCoroutine(RequestAndroid());
#elif UNITY_IOS
            RequestIOS();
#endif
        }
        catch (Exception e)
        {
            Debug.LogException(e);
        }
        
        PlayerPrefs.SetInt("InAppReviewManager.requested", 1);
    }

#if UNITY_EDITOR || UNITY_DEV
    private void RequestTest()
    {
        Toast.Show<Popup_Toast>("InAppReviewTest");
    }
#endif

#if UNITY_ANDROID
    private IEnumerator RequestAndroid()
    {
        var reviewManager = new ReviewManager();
        
        var requestFlowOperation = reviewManager.RequestReviewFlow();
        yield return requestFlowOperation;
        if (requestFlowOperation.Error != ReviewErrorCode.NoError)
        {
            Application.OpenURL(PlatformManager.GetMarketURL());
            Debug.LogError(requestFlowOperation.Error.ToString());
            yield break;
        }
        
        var playReviewInfo = requestFlowOperation.GetResult();
        var launchFlowOperation = reviewManager.LaunchReviewFlow(playReviewInfo);
        yield return launchFlowOperation;
        if (launchFlowOperation.Error != ReviewErrorCode.NoError)
        {
            Application.OpenURL(PlatformManager.GetMarketURL());
            Debug.LogError(requestFlowOperation.Error.ToString());
            yield break;
        }
    }
#endif
    
#if UNITY_IOS
    private void RequestIOS()
    {
        if (!Device.RequestStoreReview())
            Application.OpenURL(PlatformManager.GetMarketURL());
    }
#endif
}
