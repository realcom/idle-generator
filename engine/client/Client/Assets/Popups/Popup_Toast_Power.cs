using System;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using UnityEngine;

public class Popup_Toast_Power : Toast
{
    protected override void RefreshByFlag()
    {
    }

    protected override void Initialize_Internal(ToastMessageData messageData)
    {
        throw new NotImplementedException();
    }

    protected override void Release_Internal(ToastData data)
    {
        throw new NotImplementedException();
    }

    public async UniTask DoSequence(long prevPower, long newPower, string key)
    {
        var changeAmount = Math.Abs(newPower - prevPower);
        var curAmount = prevPower;
        
        Text.text = key.L(curAmount.ToPowerString(), changeAmount);
        var cts = this.GetCancellationTokenOnDestroy();
        
        await UniTask.Delay(TimeSpan.FromSeconds(0.5f), cancellationToken: cts);
        DOTween.To(() => changeAmount, x => changeAmount = x, 0, 0.5f);
        DOTween.To(() => curAmount, x => Text.text = key.L(x.ToPowerString(), changeAmount), newPower, 0.5f);
        await UniTask.Delay(TimeSpan.FromSeconds(1.8f), cancellationToken: cts);
          
        Hide();
    }
    
}
