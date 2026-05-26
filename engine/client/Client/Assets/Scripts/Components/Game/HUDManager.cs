using System;
using System.Collections.Generic;
using System.Linq;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;

public partial class HUDManager : EventBehaviour
{
    private static HUDManager _instance;

    public static HUDManager Get()
    {
        return _instance ? _instance : null;
    }

    public CanvasGroup cgHUD;
    public ZGamePad gamePad;
    
    public override void Awake()
    {
        base.Awake();
        // TODO: move to base scene
        _instance = this;
    }

    public void SetHUDActive(bool active)
    {
        cgHUD.DOFade(active ? 1f : 0f, 0.2f);
        cgHUD.blocksRaycasts = active;
        
    }

    public override void Start()
    {
        base.Start();
        SetHUDActive(true);
    }

    public override UniTask HandleEvent(GameEvent e)
    {
        return UniTask.CompletedTask;
    }
}