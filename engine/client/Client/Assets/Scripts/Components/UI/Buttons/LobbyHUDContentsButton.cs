using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class LobbyHUDContentsButton : CustomButton
{
    public Image imgIcon;
    public TextMeshProUGUI txtName;
    public TextTimer txtTimer;
    public RedDot redDot;

    private LobbyHUDLayoutDefine.LobbyHUDButtonDefine _define = null;
    public void Initialize(LobbyHUDLayoutDefine.LobbyHUDButtonDefine define)
    {
        if (define == null || !define.IsValid())
        {
            gameObject.SetActive(false);
            return;
        }
        
        _define = define;
        
        imgIcon.sprite = define.Icon;
        txtName.text = define.Name;
        
        txtTimer.SetTargetTime(define.DisplayUntilAt);
        
        redDot.Register(define.noticeEntities.GetNoticeRelevanceEntities());
        
        SetOnClick(define.ShowPopup);
    }

    public void Refresh()
    {
        gameObject.SetActive(_define?.IsValid() == true);
    }
    
}
