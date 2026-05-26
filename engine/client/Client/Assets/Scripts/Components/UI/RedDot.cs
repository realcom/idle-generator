using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RedDot : NoticeListener
{
    public void SetActive(bool bActive)
    {
        gameObject.SetActive(bActive);
    }   
    
    public override void RefreshNotice(bool bActive)
    {
        gameObject.SetActive(bActive);
    }
    
}
