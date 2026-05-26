using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface INoticeListener
{
    public void RefreshNotice(bool bActive);
    public void OnDestroy();
}
