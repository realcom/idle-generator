public class Popup_Feedback : UIPopup
{
    protected override void RefreshByFlag()
    {
        
    }

    public void OnFeedback()
    {
        PlatformManager.Get().RequestSendSupportEmail();
        OnCancel();
    }
    
    public override void Refresh()
    {
        
    }
}
