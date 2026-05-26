using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using JetBrains.Annotations;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using Random = UnityEngine.Random;
#if UNITY_EDITOR
#endif

public partial class ZModeManagerLobby : ZModeManagerBase
{
    private static ZModeManagerLobby instance;
    public static ZModeManagerLobby Get() => instance;

    [Title("Chapter Pass")] 
    public TextMeshProUGUI txtPassName;
    public TextMeshProUGUI txtPassDesc;
    public NoticeListener passNoticeListener;
    public CustomButton btnPass;
    
    [Title("Hamburger Menu")] 
    public CustomButton btnHamburger;
    public RedDot redDotHamburger;

    [Title("Temp")] 
    public CustomButton btnDuty;
    public RedDot redDotDuty;
    public CustomButton btnEvent;
    public RedDot redDotEvent;
    public CustomButton btnSetting;

    public override IEnumerator Initialize(ResourceMap resMap)
    {
        var gameBoard = GameBoardManager.Get().gameBoard;
        if (resMap.HasLocationById(ResourceMap.LocationId.Player))
        {
            var pos = resMap.GetLocationById(ResourceMap.LocationId.Player, gameBoard)!.GetRandomPoint(gameBoard);
            //pos.y += GameBoardManager.Get().mapRoot.groundY;

            if (ResourceItem.Get(MyPlayer.PlayerAvatar.Character.ItemDataId) is { } resItem)
            {
                var gameUnit = GameBoardManager.Get().AddPlayerUnitLocal(-1, resItem, (Vector2)pos);
                gameUnit.State |= GameUnit.StateFlag.Running;    
            }
        }
        
        yield return InitBottoms();
        
        InitLobbyButtons();
        InitCenterContentsButtons();

        btnHamburger.SetOnClick(() => GameManager.Get().ShowPopup<Popup_HamburgerMenu>());
        redDotHamburger.Register(NoticeEntities.GetNoticeRelevanceEntitiesByQuery(NoticeEntities.PredefinedNoticeEntitiesQuery.HamburgerMenu));
        
        //btnDuty.SetOnClick(() => GameManager.Get().ShowPopup<Popup_Quest>());
        //redDotDuty.Register(ResourceAchievement.GetAllByTargetPopupName(nameof(Popup_Quest)));
        btnEvent.SetOnClick(() => GameManager.Get().ShowPopup<Popup_SelectEventDungeon>());
        redDotEvent.Register(ResourceMap.GetAllByTargetPopupName(nameof(Popup_SelectEventDungeon)));
        //btnSetting.SetOnClick(() => GameManager.Get().ShowPopup<Popup_Settings>());
        
        RefreshHUDButtons();
        RefreshHUDContentsButtons();
        RefreshChapterPass();
        RefreshStageButtons();
                
        txtStageMapName.text = resMap.ClientName;
        txtStageMaxWave.text = StringKeys.Client.Lobby_MaxWave.L(MyPlayer.GetMaxWaveByMapId(MyPlayer.GetCurrentMap().Id));
        
        RunMailCacheProcess(this.GetCancellationTokenOnDestroy()).Forget();
        
        yield break;
    }

    public override IEnumerator Release()
    {
        GameManager.Get().ClearAllPopups();
        yield break;
    }

    public override void Awake()
    {
        base.Awake();
        
        instance = this;
    }

    public override void OnDestroy()
    {
        instance = null;
        
        base.OnDestroy();
    }

    private async UniTask RunMailCacheProcess(CancellationToken token)
    {
        try
        {
            while (!token.IsCancellationRequested)
            {
                Popup_MailBox.SendCacheMailNotice().Forget();
                await UniTask.Delay(TimeSpan.FromSeconds(30),
                    ignoreTimeScale: true, cancellationToken: token);
            }
        }
        catch (OperationCanceledException)
        {
        }
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        if (!enabled)
            return;

        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            case GameEventType.SOCKET_CONNECTED:
            {
                var followCamera = GameScene.Get().followTargetCamera;
                followCamera.viewRect = new Rect(0, 0, 1, 1);
                
                TryStartUISequence();
                break;
            }
            case GameEventType.AcquiredItemsUpdated:
            {
                if (e.args.GetSafe(0) is PlayerAcquiredItemsUpdate { Silent : false, Type: not PlayerAcquiredItemsUpdate.Types.Type.EndGame and not PlayerAcquiredItemsUpdate.Types.Type.WinWave } update)
                {
                    EnqueueAcquiredItems(update.Items, update);
                }
                
                TryStartUISequence();
                break;
            }
            case GameEventType.LobbyHUDPageUpdated:
            {
                TryStartUISequence();
                break;
            }
            case GameEventType.PopupHidden:
            {
                DequeueAcquiredItems();
                TryStartUISequence();
                break;
            }
            case GameEventType.MyPlayerPowerUpdated:
            {
                var prevPower = (long)e.args.GetSafe(0);
                var newPower = (long)e.args.GetSafe(1);

                var toast = GameManager.Get().ShowPopup<Popup_Toast_Power>();
                toast.DoSequence(prevPower, newPower, prevPower < newPower ? "Popup_Toast_PowerUp" : "Popup_Toast_PowerDown").Forget();
                
                break;
            }
            case GameEventType.MyPlayerUpdated:
            case GameEventType.MY_PLAYER_LEVEL_UP:
            {
                RefreshPlayerLevel();
                break;
            }
            case GameEventType.MyPlayerItemUpdated:
            {
                RefreshChapterPass();
                RefreshHUDButtons();
                RefreshHUDContentsButtons();
                break;
            }
            case GameEventType.MyPlayerAchievementUpdated:
            {
                RefreshHUDContentsButtons();
                RefreshHUDButtons();
                
                RefreshStageButtons();
                RefreshChapterPass();
                
                TryStartUISequence();
                break;
            }
            case GameEventType.UnitCanvasCreated:
            case GameEventType.TransientBubbleReleased:
            {
                var gameUnitObject = e.args.GetSafe(0) as GameUnitObject;
                if (gameUnitObject == null || gameUnitObject.gameUnit == null)
                    break;
                
                if (ClientBubbleTextDefine.Get().BubbleSequenceByBehaviour.GetValueOrDefault(UnitBehaviour.Work) is { } battleSequence)
                {
                    gameUnitObject.SetBubbleSequence(battleSequence);
                }
                break;
            }
            case GameEventType.UnitDestroyed:
            {
                var gameUnitObject = e.args.GetSafe(0) as GameUnitObject;
                if (gameUnitObject == null || gameUnitObject.gameUnit == null)
                    break;
                
                gameUnitObject.SetBubbleSequence(null);

                break;
            }
        }
        
    }
}
