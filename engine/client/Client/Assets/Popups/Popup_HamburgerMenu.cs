using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Popup_HamburgerMenu : UIPopup
{
    [SerializeField] private RedDot redDotSetting;
    [SerializeField] private RedDot redDotMailBox;
    [SerializeField] private RedDot redDotAttendance;

    protected override void Start()
    {
        redDotSetting.Register(NoticeEntities.GetNoticeRelevanceEntitiesByQuery(NoticeEntities.PredefinedNoticeEntitiesQuery.Setting));
        redDotMailBox.Register(NoticeEntities.GetNoticeRelevanceEntitiesByQuery(NoticeEntities.PredefinedNoticeEntitiesQuery.MailBox));
        redDotAttendance.Register(NoticeEntities.GetNoticeRelevanceEntitiesByQuery(NoticeEntities.PredefinedNoticeEntitiesQuery.Attendance));
        
        base.Start();
    }

    protected override void RefreshByFlag()
    {
        
    }

    public void OnClickSetting()
    {
        GameManager.Get().ShowPopup<Popup_Settings>();
        OnCancel();
    }

    public void OnClickMailBox()
    {
        GameManager.Get().ShowPopup<Popup_MailBox>();
        OnCancel();
    }
    
    public void OnClickAttendance()
    {
        GameManager.Get().ShowPopup<Popup_Attendance_7Day>();
        OnCancel();
    }
    
}
