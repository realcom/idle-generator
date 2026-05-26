using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class NoticeListener : MonoBehaviour, INoticeListener
{
    public abstract void RefreshNotice(bool bActive);

    public void OnDestroy()
    {
        NoticeSystem.UnregisterListener(this);
    }
}
