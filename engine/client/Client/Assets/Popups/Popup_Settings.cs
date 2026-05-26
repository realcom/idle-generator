using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Commons;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;

public partial class Popup_Settings : UIPopup
{
    public CustomToggle toggleBGM;
    public CustomToggle toggleSFX;

    public CustomButton btnSignInGoogle;
    public CustomButton btnSignInApple;

    protected override void Start()
    {
        toggleBGM.onValueChanged.AddListener(OnToggleBGM);
        toggleSFX.onValueChanged.AddListener(OnToggleSFX);

        base.Start();
    }

    protected override void RefreshByFlag()
    {

    }

    public override void Refresh()
    {
        base.Refresh();
        
        btnSignInGoogle.SetActive(false);
        btnSignInApple.SetActive(false);
        toggleBGM.isOn = GameManager.Get().bgmVolume.Get() > 0;
        toggleSFX.isOn = GameManager.Get().fxVolume.Get() > 0;
    }

    public void OnToggleBGM(bool isOn)
    {
        GameManager.Get().bgmVolume.Set(isOn ? 1 : 0);
    }

    public void OnToggleSFX(bool isOn)
    {
        GameManager.Get().fxVolume.Set(isOn ? 1 : 0);
    }

    public void OnClickSignInGoogle()
    {
        Toast.Show<Popup_Toast>("Google sign-in is temporarily unavailable.");
    }

    private async UniTask RequestSinInOauth(string snsId)
    {
        var response = await SendPacket(Packet.Pop(0, new SignInOauthRequest()
        {
            SnsId = snsId,
        }), this.GetCancellationTokenOnDestroy());
        
        switch (response.Status)
        {
            case StatusCode.Ok:
            {
                PlayerPrefs.SetString(Constants.Key.GUEST_SNS_ID, snsId);
                Refresh();
                break;
            }
            case StatusCode.ConnectedAccountExist:
            {
                Popup_Alert.Show()
                    .SetDesc("Already Connected Account. Would you like to sign in?".L())
                    .SetButtonType(Popup_Alert.ButtonViewFlag.ALL)
                    .ShowCloseButton(false)
                    .SetOkCallback(() =>
                    {
                        PlayerPrefs.SetString(Constants.Key.GUEST_SNS_ID, snsId);
                        GameManager.Get().scene.GoScene(Constants.LOGIN_SCENE, true);
                    });
                break;
            }
        }
        
    }


    public void OnClickRestore()
    {
        PurchaseManager.Get().Restore();
    }
    
    public void OnClickCommunity()
    {
        Application.OpenURL("Community_Url".L());
        
    }
    

    public void OnClickReview()
    {
        try
        {
            InAppReviewManager.Get().Request(true);
        }
        catch (Exception ex)
        {
            Application.OpenURL(PlatformManager.GetMarketURL());
        }
    }

    public void OnClickEmail()
    {
        PlatformManager.Get().RequestSendSupportEmail();
    }

    
}
