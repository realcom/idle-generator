using UnityEngine;
using System.Collections;

using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game;
using Commons.Game.Events;
using Commons.Resources;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using UnityEngine.Serialization;
using Resources = UnityEngine.Resources;

#if UNITY_EDITOR
using Sirenix.OdinInspector.Editor;
using UnityEditor;
#endif

public abstract class ZModeManagerBase : ZEventBehaviour
{
    protected virtual void OnEnable()
    {
        Refresh();
    }

    protected virtual void OnDisable()
    {
    }

    public abstract IEnumerator Initialize(ResourceMap resMap);
    public abstract IEnumerator Release();
    
    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            {
                var resMap = GameBoardManager.Get().gameBoard.ResMap;
                AudioManager.Get().PlayBGM("BGM_Stage_" + resMap.Id);
                
                var followCamera = GameScene.Get().followTargetCamera;
                followCamera.FOV = resMap.Fov <= 0f ? followCamera.FOV : resMap.Fov;
                followCamera.targetTransformPivot = resMap.TargetCameraPivot ?? new Vector2(0.5f, 0.5f);
                break;
            }
            case GameEventType.MAP_RELEASED:
            {
                Resources.UnloadUnusedAssets();
                break;
            }
            case GameEventType.BoardResetMapScroll:
            {
                if (e.args.GetSafe(0) is not ResetMapScrollEvent resetMapScrollEvent)
                    return;

                if (resetMapScrollEvent.PlayerId != MyPlayer.Player.Id)
                    return;

                GameBoardManager.Get().mapScreen.ResetScroll();
                break;
                
            }
        }
    }
}
