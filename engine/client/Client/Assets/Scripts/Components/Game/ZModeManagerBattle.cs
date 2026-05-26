using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons;
using Commons.Game;
using Commons.Game.Events;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using Febucci.UI;
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.Serialization;
using UnityEngine.UI;

using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.UnitVariable.Types.Type;
using static Commons.Resources.ResourceTrigger.Types.Expression.Types.Operand.Types.Variable.Types.PredefinedVariable.Types.Type;

public class ZModeManagerBattle : ZModeManagerBase
{
    [Title("Essential")] 
    [SerializeField] private RectTransform rtCanvasMask;
    
    [Title("Mission")] 
    public RectTransform rtMissionRoot;
    
    [Title("Mission Complete Bubble")]
    public RectTransform rtMissionCompleteBubble;
    public TextMeshProUGUI txtMissionName;
    public TextMeshProUGUI txtMissionRewardValue;
    public float MissionCompleteBubbleDuration = 0.33f;
    public float MissionCompleteBubbleHoldDuration = 2.5f;

    [Title("Skip")] 
    public CustomButton btnSkip;
    
    [Serializable]
    public class SellCanvasEffectGroup
    {
        public Animator animator;
        public ParticleSystem[] particleSystems = new ParticleSystem[0];
    }
    
    [Title("Sell Effect")]
    public SellCanvasEffectGroup sellCanvasEffectGroup_HP = new();
    public SellCanvasEffectGroup sellCanvasEffectGroup_EXP = new();
    public SellCanvasEffectGroup sellCanvasEffectGroup_Gold = new();

    [Title("MergeBoard")]
    public MergeBoard mergeBoard;
    
    public enum WavePointType
    {
        Start,
        Normal,
        Elite,
        Boss,
    }
    
    public TextMeshProUGUI txtWaveInfo;
    public TextBoardTickTimer timerWaveStart;
    public TextAnimator_TMP txtAnimWaveStart;
    
    [Serializable]
    public class WavePointCell : UIElement
    {
        public Image imgIcon;
        public TextMeshProUGUI txtWave;
        public Slider sliderProgress;
    }

    public RectTransform rtWavePointParent;
    public UIElementContainer<WavePointCell> wavePoints = new();

    [Title("Player Status")]
    public Slider sliderMyUnitExp;
    public TextMeshProUGUI txtMyUnitExp;
    public Slider sliderMyUnitHp;
    public TextMeshProUGUI txtMyUnitHp;
    public TextMeshProUGUI txtMyUnitHpPercent;
    public TextMeshProUGUI txtMyUnitAttack;
    public TextMeshProUGUI txtMyUnitDefense;
    public Image imgCanvasHitEffect;
    
    [Serializable]
    public class BuffCell : UIElement
    {
        public CustomButton btnBuffCell;
        public Image imgIcon;
        public Image imgBackground;
        public TextMeshProUGUI txtCount;
    }

    public UIElementContainer<BuffCell> buffContainer = new();

    private int stageLevel;
    
    public void GoToLobby()
    {
        GameBoardManager.Get().PauseBoard();
        
        var popup = Popup_Alert.Show();
        if (popup != null)
        {
            popup.SetDesc("Battle_LeaveGame".L())
                .SetOkText("OK".L())
                .SetButtonType(Popup_Alert.ButtonViewFlag.ALL)
                .ShowCloseButton(false)
                .SetNoCallback(() =>
                {
                    GameBoardManager.Get().ResumeBoard();
                })
                .SetOkCallback(() => ShowGameFailure());
        }
    }

    public async UniTask ShowGameFailure(PlayerRankingMessage prevRanking = null, PlayerRankingMessage currentRanking = null)
    {
        var leaveBoardPacket = Packet.Pop(0, new LeaveBoardRequest());
        var response = await ZWorldClient.Get().SendPacket(leaveBoardPacket);

        if (response.Status.IsSuccess())
        {
            await GameBoardManager.Get().ShowGameResult();
        }
        else
        {
            Debug.LogError(response);
            Toast.Show<Popup_Toast>($"Fail_To_LeaveBoard".L());
            if (response.Status == StatusCode.BoardNotJoined)
            {
                GameBoardManager.Get().GoToLobby();
            }
        }
    }

    public void ShowMission()
    {
        GameManager.Get().ShowPopup<Popup_Mission>();
    }

    public void ShowHoldingTraits()
    {
        GameManager.Get().ShowPopup<Popup_HoldingTrait>();
    }

    private int? winningTeam = null;
    private PlayerRankingMessage myPreviousRanking = null;
    private PlayerRankingMessage myCurrentRanking = null;
    public override IEnumerator Initialize(ResourceMap resMap)
    {
        winningTeam = null;
        myPreviousRanking = null;
        myCurrentRanking = null;
        MyPlayer.tempAccDamage.Clear();

        InitSkipButton(resMap);
        
        RefreshHp();
        
        RefreshWaveInfo();
        RefreshTimer();
        RefreshBattleProgress();
        TryShowTraitPopup();
        TryShowRebirthPopup();

        rtMissionRoot.SetActive(resMap.MissionDataIds.Count > 0);
        rtMissionCompleteBubble.SetActive(false);
                
        RefreshBuffTable();
                
        var myGameUnit = MyPlayer.GameUnit;
        RefreshPlayerExp(myGameUnit.Level, 0);
        RefreshPlayerStatus(true);
        RefreshAcquiredCredit();
        
#if UNITY_EDITOR
        StartCoroutine(AutoPlay());
#endif
        yield return mergeBoard.Initialize(resMap);
    }

    private void InitSkipButton(ResourceMap resourceMap)
    {
        btnSkip.SetActive(false);
        btnSkip.SetOnClick(() =>
        {
            RequestSkip().Forget();
        });
    }

    private async UniTask RequestSkip()
    {
        btnSkip.interactable = false;

        var gameBoardManager = GameBoardManager.Get();
        gameBoardManager.BlockShowGameResult(true);
        
        var response = await ZWorldClient.Get().SendPacket<AutoPlayToTickBoardRequest.Types.Response>(Packet.Pop(0, new AutoPlayToTickBoardRequest { ToTick = 0 }));

        if (this)
            btnSkip.interactable = true;

        if (response.Status.IsSuccess())
        {
            MyPlayer.SetGameBoard(response.CompressedBoard.Decompress<GameBoard>());
            gameBoardManager.SetShouldForceUpdateGameBoard(true);
            gameBoardManager.Run(() =>
            {
                gameBoardManager.BlockShowGameResult(false);
                gameBoardManager.ShowGameResult(myPreviousRanking, myCurrentRanking).Forget();
            }, 0.5f);
        }
    }
    
    
#if UNITY_EDITOR
    IEnumerator AutoPlay()
    {
        var interval = Config.AutoPlayInterval;
        while (true)
        {
            if (!Config.AutoPlay)
            {
                yield return Utility.GetWaitForSeconds(interval);
                continue;
            }
            var playerId = MyPlayer.Player.Id;
            if (MyPlayer.BoardPlayer?.Inventories.Count == 0)
            {
                yield return Utility.GetWaitForSeconds(interval);
                continue;
            }

            var playerInventory = MyPlayer.BoardPlayer.Inventories[0];
            var actionDone = false;
            // TODO: 특성창 떠있으면 특성 찍기
            var popup = GameManager.Get().GetPopup<Popup_SelectTrait>();
            if (popup != null && popup.IsActive())
            {
                GameBoardManager.Get().Run(() => { popup.SelectRandom(); }, interval * 5);
                yield return Utility.GetWaitForSeconds(interval * 5);
                continue;
            }

            var gotTraits = GameManager.Get().GetPopup<Popup_GotTraits>();
            if (gotTraits != null && popup.IsActive())
            {
                GameBoardManager.Get().Run(() => { gotTraits.Continue(); }, interval * 5);
                yield return Utility.GetWaitForSeconds(interval * 5);
                continue;
            }
            
            var tutorialPopup = GameManager.Get().GetPopup<Popup_TutorialBase>();
            if (tutorialPopup != null && tutorialPopup.IsActive())
            {
                tutorialPopup.OnCancel();
                yield return Utility.GetWaitForSeconds(interval);
                continue;
            }
            
            for(var i = 0; i< MyPlayer.BoardPlayer.HoldItems.Count ;i++)
            {
                var holdItem = MyPlayer.BoardPlayer.HoldItems[i];
                var resItem = ResourceItem.Get(holdItem.ItemDataId);
                if (resItem == null) continue;
                if (resItem.ContainsTag(Tag.InventoryExpand))
                {
                    if (FindPlaceForExpand(playerInventory, out var inventoryIndex))
                    {
                        GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(BoardPlayerInventoryTransferUpdate.Types.Type.Hold, 0, i , BoardPlayerInventoryTransferUpdate.Types.Type.Inventory, -1, -2, playerId);
                        GameBoardManager.Get().UpdateBoardPlayerInventoryExpand(inventoryIndex.Item1, inventoryIndex.Item2, MyPlayer.Player.Id);
                        
                    }

                    yield return Utility.GetWaitForSeconds(interval);
                }
                else
                {
                    for (var j = 0; j < MyPlayer.BoardPlayer.Inventories[0].Rows.Count; j++)
                    {
                        var row = MyPlayer.BoardPlayer.Inventories[0].Rows[j];
                        for (var k = 0; k < row.Items.Count; k++)
                        {
                            var item = row.Items[k];
                            if (resItem.Id == item.ItemDataId)
                            {
                                GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(BoardPlayerInventoryTransferUpdate.Types.Type.Hold, 0, i , BoardPlayerInventoryTransferUpdate.Types.Type.Inventory, j, k, playerId);
                                actionDone = true;
                                // GameBoardManager.Get().UpdateBoardPlayerInventoryMerge();
                            }
                        }
                    }
                    if (actionDone)
                    {
                        yield return Utility.GetWaitForSeconds(interval);
                        continue;
                    }
                    
                        // 아니면 보드 배치
                    var placeable = false;
                    int itemX = 0, itemY = 0;
                    
                    for (var pivotX = 0; pivotX < playerInventory.Rows.Count; ++pivotX)
                    {
                        for (var pivotY = 0;
                             pivotY < playerInventory.Rows[pivotX].Items.Count;
                             ++pivotY)
                        {
                            var pivot = playerInventory.Rows[pivotX].Items[pivotY];
                            // blocked cell: item cannot be placed
                            if (pivot.Id == -1)
                                continue;
                            
                            if (pivot.ItemDataId >0)
                                continue;
                            var placableForPivot = true;
                            foreach (var cell in resItem.InventoryCells)
                            {
                                var x = pivotX + cell.Dx;
                                var y = pivotY + cell.Dy;
                                // item cannot be placed
                                if (x < 0 || y < 0 || x >= playerInventory.Rows.Count ||
                                    y >= playerInventory.Rows[x].Items.Count)
                                {
                                    placableForPivot = false;
                                    break;
                                }

                                if (playerInventory.Rows[x].Items[y].Id == -1)
                                {
                                    placableForPivot = false;
                                    break;
                                }
                            }

                            if (placableForPivot)
                            {
                                placeable = true;
                                itemX = pivotX;
                                itemY = pivotY;
                                break;
                            }
                        }

                        if (placeable)
                            break;
                    }

                    if (placeable)
                    {
                        GameBoardManager.Get().UpdateBoardPlayerInventoryTransfer(BoardPlayerInventoryTransferUpdate.Types.Type.Hold, 0, i , BoardPlayerInventoryTransferUpdate.Types.Type.Inventory, itemX, itemY, playerId);
                        yield return Utility.GetWaitForSeconds(interval);
                        break;
                    }
                }
            }

            //
            GameBoardManager.Get().UpdateBoardPlayerInventorySpawn(MyPlayer.Player.Id);
            
            yield return Utility.GetWaitForSeconds(interval);
        }
    }
#endif

    private static bool FindPlaceForExpand(PlayerInventory playerInventory, out (int, int) inventoryIndex)
    {
        var canPlace = false;
        inventoryIndex = (0, 0);
        for (; inventoryIndex.Item1 < playerInventory.Rows.Count; ++inventoryIndex.Item1)
        {
            for (;inventoryIndex.Item2 < playerInventory.Rows[inventoryIndex.Item1].Items.Count; ++inventoryIndex.Item2)
            {
                var pivot = playerInventory.Rows[inventoryIndex.Item1].Items[inventoryIndex.Item2];
                if (pivot.Id != -1)
                    continue;

                if (playerInventory.Rows.GetSafe(inventoryIndex.Item1 + 1)?.Items.GetSafe(inventoryIndex.Item2)?.Id > 0)
                    canPlace = true;
                if (playerInventory.Rows.GetSafe(inventoryIndex.Item1 - 1)?.Items.GetSafe(inventoryIndex.Item2)?.Id > 0)
                    canPlace = true;
                if (playerInventory.Rows.GetSafe(inventoryIndex.Item1)?.Items.GetSafe(inventoryIndex.Item2 + 1)?.Id > 0)
                    canPlace = true;
                if (playerInventory.Rows.GetSafe(inventoryIndex.Item1 )?.Items.GetSafe(inventoryIndex.Item2 - 1)?.Id > 0)
                    canPlace = true;
                if (canPlace)
                    break;
            }
            if (canPlace)
                break;
        }
        
        return canPlace;
    }
    
    public override IEnumerator Release()
    {
        GameManager.Get().ClearAllPopups();
        yield break;
    }
    
    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        if (!enabled)
            return;

        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            {

                
                break;
            }
            case GameEventType.UnitHpUpdated:
            {
                var gameUnitObject = e.args.GetSafe(0) as GameUnitObject;
                if (gameUnitObject == null || gameUnitObject.gameUnit == null)
                    return;
                
                if (gameUnitObject.gameUnit.PlayerId == MyPlayer.Player.Id)
                {
                    RefreshHp();
                }

                break;
            }
            case GameEventType.GameEnded:
            {
                GameManager.Get().HideAllPopups<Popup_GameResults>();
                GameManager.Get().HideAllPopups<Popup_Rebirth>();

                GameBoardManager.Get().ShowGameResult(myPreviousRanking, myCurrentRanking).Forget();  
             
                break;
            }
            case GameEventType.MyPlayerItemUpdated:
            {
                if (e.args[0] is IList<PlayerItemMessage> items)
                {
                    if (items.FirstOrDefault(x => x.ItemDataId == ResourceItem.Global.DataId.Credit) != null)
                    {
                        RefreshAcquiredCredit();
                    }
                }

                break;
            }
            case GameEventType.AcquiredItemsUpdated:
            {
                var update = (PlayerAcquiredItemsUpdate)e.args.GetSafe(0);

                switch (update.Type)
                {
                    case PlayerAcquiredItemsUpdate.Types.Type.EndGame:
                    case PlayerAcquiredItemsUpdate.Types.Type.WinWave:
                    {
                        if (update.MapDataId == GameBoardManager.Get().gameBoard.ResMap.Id)
                        {
                            var myBoardPlayer = MyPlayer.BoardPlayer;
                            var addedItems = update.Items;
                            foreach (var addedItem in addedItems)
                            {
                                MyPlayer.AddResultRewardItem(addedItem.GetData(), addedItem.GetCount(), addedItem.Level);
                            }

                            var popupGameResults = GameManager.Get().GetPopup<Popup_GameResults>();
                            popupGameResults?.AppendResultRewards(MyPlayer.ResultRewardItems);
                        }
                        
                        

                        break;
                    }
                }

                break;
            }
                
            case GameEventType.TimerUpdated:
            {
                // InitTimer();
                break;
            }
            case GameEventType.UnitCreated:
            {
                var gameUnitObject = e.args.GetSafe(0) as GameUnitObject;
                if (gameUnitObject == null || gameUnitObject.gameUnit == null)
                    break;
                
                if (gameUnitObject.ResUnit.Type == ResourceUnit.Types.Type.Boss)
                {
                    rtWavePointParent.SetActive(false);
                    GameManager.Get().GetOrShowPopupAsync<Popup_BossAppearanceAlert>().Forget();
                    GameManager.Get().PlayFX("SFX_Boss_Appear");
                    //OnBossCreated(gameUnitObject.ResUnit);
                }
                else if (gameUnitObject.ResUnit.Type == ResourceUnit.Types.Type.MidBoss)
                {
                    GameManager.Get().GetOrShowPopupAsync<Popup_BossAppearanceAlert>().Forget();
                    GameManager.Get().PlayFX("SFX_MidBoss_Appear");
                    //OnEliteCreated(gameUnitObject.ResUnit);
                }
                // if (gameUnitObject.gameUnit.PlayerId != 0)
                // {
                //     if (ClientBubbleTextDefine.Get().BubbleSequenceByBehaviour.GetValueOrDefault(UnitBehaviour.Battle) is { } battleSequence)
                //     {
                //         gameUnitObject.SetBubbleSequence(battleSequence);
                //     }
                // }
                
                break;
            }
            case GameEventType.TransientBubbleReleased:
            {
                var gameUnitObject = e.args.GetSafe(0) as GameUnitObject;
                if (gameUnitObject == null || gameUnitObject.gameUnit == null || gameUnitObject.gameUnit.PlayerId == 0)
                    break;

                if (ClientBubbleTextDefine.Get().BubbleSequenceByBehaviour.GetValueOrDefault(UnitBehaviour.Battle) is { } battleSequence)
                {
                    gameUnitObject.SetBubbleSequence(battleSequence);
                }
                
                break;
            }
            case GameEventType.MyUnitAttackUpdated:
            case GameEventType.MyUnitDefenseUpdated:
            {
                RefreshPlayerStatus();
                break;
            }
            case GameEventType.MyUnitExpUpdated:
            {
                var myGameUnit = MyPlayer.GameUnit;

                var newLevel = myGameUnit.Level;

                // level up
                if (newLevel > stageLevel)
                {
                    GameManager.Get().PlayFX("MyPlayer_LevelUp");
                }

                RefreshPlayerExp(myGameUnit.Level, myGameUnit.Exp);
                break;
            }
            case GameEventType.MyUnitBuffUpdated:
            {
                RefreshBuffTable();
                break;
            }
            case GameEventType.BoardSelectTrait:
            {
                var gameBoardManager = GameBoardManager.Get();
                var gameBoard = gameBoardManager.gameBoard;
                if (gameBoard == null || MyPlayer.GameUnit == null || gameBoard.ResMap == null)
                    return;

                if (e.args.GetSafe(0) is not SelectTraitEvent traitEvent)
                    return;

                var popup = Popup_TraitHelper.ShowTraitPopup(gameBoard);
                popup.Initialize();

                if (traitEvent.Reroll)
                {
                    popup.OnReroll();
                }
                
                break;
            }
            // case GameEventType.BoardEncounterTrait:
            // {
            //     var gameBoardManager = GameBoardManager.Get();
            //     var gameBoard = gameBoardManager.gameBoard;
            //     if (gameBoard == null || MyPlayer.GameUnit == null || gameBoard.ResMap == null)
            //         return;
            //
            //     using var _ = ListPool<ResourceItem>.Get(out var statDataList);
            //
            //     for (var i = 0; i < ResourceMap.Global.BoardConstants.LevelUpChoiceCount; ++i)
            //     {
            //         var choiceDataId = (int)gameBoard.Variables.Get((int)ResourceTrigger.Types.Expression.Types
            //             .Operand.Types.Variable.Types.PredefinedVariable.Types.Type.EncounterTraitChoices + i + 1);
            //         if (choiceDataId > 0)
            //         {
            //             var statResItem = ResourceItem.Get(choiceDataId);
            //             if (statResItem != null)
            //                 statDataList.Add(statResItem);
            //             else
            //                 Debug.LogError($"Level up choice data Not Found: {choiceDataId}");
            //         }
            //
            //         if (choiceDataId == 0)
            //             break;
            //     }
            //
            //     if (statDataList.Count > 0)
            //     {
            //         m_PopupSelectTrait = GameManager.Get().GetOrShowPopup<Popup_SelectTrait>();
            //         m_PopupSelectTrait.Initialize(statDataList);
            //     }
            //     break;
            // }
            case GameEventType.BoardInventoryMerged:
            case GameEventType.BoardInventorySpawned:
            case GameEventType.BoardInventoryMoved:
            {
                RefreshPlayerStatus();
                break;
            }
            case GameEventType.UnitAttacked:
            {
                if (e.args.GetSafe(0) is not UnitAttackedEvent attackedEvent)
                    break;
                var gameUnitObject = GameBoardManager.Get().GetUnitByID(attackedEvent.UnitId);
                if (gameUnitObject == null || gameUnitObject.gameUnit == null)
                    break;
                
                if (gameUnitObject.gameUnit.IsEnemyWith(MyPlayer.GameUnit))
                {
                    if (attackedEvent.SkillDataId != 0)
                    {
                        if (attackedEvent.IsCritical)
                            GameManager.Get().PlayFX("MyPlayer_CriticalHit");
                        else
                            GameManager.Get().PlayFX("MyPlayer_DefaultHit");
                        var inventory = mergeBoard.inventory;
                        var tempList = PooledHashSet<int>.Get();
                        foreach (var item in inventory)
                        {
                            if (item is { Id: > 0 } && !tempList.Contains((int)item.Id))
                            {
                                var resItem = ResourceItem.Get(item.ItemDataId);
                                if (resItem == null)
                                    continue;
                                
                                var replaceSkillDataId = MyPlayer.GameUnit.GetReplaceSkillDataId(resItem.SkillDataId);
                                var resSkill = ResourceSkill.Get(replaceSkillDataId);
                                if (resSkill == null)
                                    continue;
                                
                                tempList.Add((int)item.Id);
                                
                                if (resSkill.RelatedUseSkillIds.Contains((int)attackedEvent.SkillDataId))
                                {
                                    if (MyPlayer.tempAccDamage.ContainsKey(item.ItemDataId))
                                        MyPlayer.tempAccDamage[item.ItemDataId] += attackedEvent.Damage;
                                    else
                                        MyPlayer.tempAccDamage[item.ItemDataId] = attackedEvent.Damage;
                                }
                            }
                        }
                    }
                }
                
                break;
            }
            case GameEventType.UnitDied:
            {
                if (e.args.GetSafe(0) is not UnitDeathEvent deathEvent)
                    return;
                var gameUnitObject = GameBoardManager.Get().GetUnitByID(deathEvent.UnitId);
                if (gameUnitObject == null || gameUnitObject.gameUnit == null || gameUnitObject.gameUnit.PlayerId == 0)
                    break;

                gameUnitObject.SetBubbleSequence(null);

                if (gameUnitObject.isLocalPlayer && GameBoardManager.Get()?.gameBoard.WinningTeam == GameBoard.Team.Neutral)
                {
                    GameManager.Get().PlayFX("MyPlayer_Dead");

                    if (gameUnitObject.gameUnit.RespawnTick > 0)
                        break;

                    var variables = gameUnitObject.gameUnit.Variables;
                    var purchaseRespawnCount = variables.GetInt((int)PurchaseRespawnCount);
                    var maxPurchaseRespawnCount = GameBoardManager.Get()?.gameBoard?.ResMap?.PlayerUnitMaxPurchaseRespawnCount ?? 1;
                    if (purchaseRespawnCount < maxPurchaseRespawnCount)
                    {
                        this.Run(() =>
                        {
                            GameManager.Get().ShowPopup<Popup_Rebirth>();
                        }, CRC.Get().globalParameters.rebirthDelay);
                    }
                    else
                    {
                        ShowGameFailure();
                    }
                }

                break;
            }
            case GameEventType.BoardCompleteMission:
            {
                if (e.args.GetSafe(0) is not CompleteMissionEvent @event)
                    return;

                OnMissionCompleted(@event);
                
                break;
            }
            case GameEventType.FxEventDispatchOnHeal:
            case GameEventType.FxEventDispatchOnAddExp:
            case GameEventType.FxEventDispatchOnAddGold:
            {
                if (e.args[0] is not PlayFxEvent fxEvent)
                    return;

                var canvasEffectGroup = e.type switch
                {
                    GameEventType.FxEventDispatchOnHeal => sellCanvasEffectGroup_HP,
                    GameEventType.FxEventDispatchOnAddExp => sellCanvasEffectGroup_EXP,
                    GameEventType.FxEventDispatchOnAddGold => sellCanvasEffectGroup_Gold,
                    _ => null
                };
                
                PlayCanvasDropFx(canvasEffectGroup, (int)fxEvent.Count);
                break;
            }
            case GameEventType.FxEventDispatchOnShieldHeal:
            {
                if (e.args[0] is not PlayFxEvent fxEvent)
                    return;

                var gameUnitObject = GameBoardManager.Get().GetUnitByID(fxEvent.UnitId);
                if (gameUnitObject != null)
                {
                    gameUnitObject.unitCanvasCell.EmitShieldParticle((Vector2)fxEvent.Position);
                }
                break;
            }
            case GameEventType.BoardWaveQueued:
            {
                if (e.args.GetSafe(0) is not WaveQueuedEvent waveQueuedEvent)
                    return;
                if (waveQueuedEvent.PlayerId != MyPlayer.Player.Id)
                    return;

                RefreshWaveInfo();
                RefreshTimer();
                RefreshBattleProgress();
                break;
            }
            case GameEventType.BoardWaveStarted:
            {
                if (e.args.GetSafe(0) is not WaveStartedEvent waveStartedEvent)
                    return;
                if (waveStartedEvent.PlayerId != MyPlayer.Player.Id)
                    return;

                RefreshWaveInfo();
                RefreshTimer();
                RefreshBattleProgress();
                break;
            }
            case GameEventType.BoardEventDispatched:
            {
                if (e.args.GetSafe(0) is not BoardEvent boardEvent)
                    return;

                switch (boardEvent)
                {
                    case CompleteSelectTraitEvent completeSelectTraitEvent:
                    {
                        if (completeSelectTraitEvent.PlayerId != MyPlayer.Player.Id)
                            break;
                        
                        RefreshBuffTable();
                        
                        break;
                    }
                    case UnitAttackedEvent unitAttackedEvent:
                    {
                        var myGameUnit = MyGameUnitObject.Get().gameUnit;
                        if (myGameUnit == null)
                            break;
                        
                        if (myGameUnit.Id == unitAttackedEvent.UnitId)
                        {
                            GameManager.Get().PlayFX("MyPlayer_Attacked");
                            var hpRatio = (float)myGameUnit.Hp / myGameUnit.MaxHp;
                            if (hpRatio <= 0.35f)
                            {
                                imgCanvasHitEffect.DOKill();
                                imgCanvasHitEffect.SetAlpha(1f);
                                imgCanvasHitEffect.DOFade(0f, 0.33f);
                            }
                        }
                        
                        break;
                    }
                    case BoardStateChangedEvent boardStateChangedEvent:
                    {
                        var state = GameBoardManager.Get().gameBoard.State;
                        var resMap = GameBoardManager.Get().gameBoard.ResMap;
                        btnSkip.SetActive(state == GameBoard.Types.State.Playing && resMap.ContainsTag(Tag.SkipPossible));
                        break;
                    }
                }
                
                break;
            }
        }
    }
    
    [Button]
    public void Test_PlayCanvasDropFx_HP(int count = 100)
    {
        PlayCanvasDropFx(sellCanvasEffectGroup_HP, count);
    }
    
    [Button]
    public void Test_PlayCanvasDropFx_EXP(int count = 100)
    {
        PlayCanvasDropFx(sellCanvasEffectGroup_EXP, count);
    }
    
    [Button]
    public void Test_PlayCanvasDropFx_Gold(int count = 100)
    {
        PlayCanvasDropFx(sellCanvasEffectGroup_Gold, count);
    }
    
    private void PlayCanvasDropFx(SellCanvasEffectGroup group, int count)
    {
        if (group == null)
            return;
        
        group.animator.Play(AnimatorHash.Anim, -1, 0.0f);
        foreach (var ps in group.particleSystems)
        {
            ps.Emit(count);
        }
    }

    private void OnMissionCompleted(CompleteMissionEvent completeMissionEvent)
    {
        if (completeMissionEvent != null)
        {
            var resAchievement = ResourceAchievement.Get(completeMissionEvent.AchievementDataId)!;
            txtMissionName.text = resAchievement.ClientName;
            txtMissionRewardValue.text = completeMissionEvent.AddItems.First().GetStringWithIcon();   
        }

        DoSequenceMissionBubble();
    }

    [Button]
    private void DoSequenceMissionBubble()
    {
        rtMissionCompleteBubble.SetActive(true);
        rtMissionCompleteBubble.DOKill();
        rtMissionCompleteBubble.localScale = Vector3.zero;

        var sequence = DOTween.Sequence();
        sequence.Append(rtMissionCompleteBubble.DOScale(Vector3.one, MissionCompleteBubbleDuration).SetEase(Ease.OutBack));
        sequence.Append(rtMissionCompleteBubble.DOScale(Vector3.zero, MissionCompleteBubbleDuration).SetEase(Ease.InBack).SetDelay(MissionCompleteBubbleHoldDuration));
        sequence.OnComplete(() =>
        {
            rtMissionCompleteBubble.SetActive(false);
        });
    }

    private void RefreshHp()
    {
        var myUnit = GameBoardManager.Get().gameBoard?.GetUnitByPlayerId(MyPlayer.Player.Id);
        if (myUnit == null)
            return;
        
        sliderMyUnitHp.value = (float)myUnit.Hp / myUnit.MaxHp;
        txtMyUnitHpPercent.text = $"{(int)(sliderMyUnitHp.value * 100)}%";
        txtMyUnitHp.text = $"{myUnit.Hp}/{myUnit.MaxHp}";
    }

    private void RefreshPlayerStatus(bool init = false)
    {
        var myGameUnit = MyPlayer.GameUnit;
        
        var originAttack = int.Parse(txtMyUnitAttack.text);
        var newAttack = GetAppliedAttackValue();
        RefreshStatText(txtMyUnitAttack, originAttack, newAttack);

        var originDefense = int.Parse(txtMyUnitDefense.text);
        var newDefense = (int)myGameUnit.Defense;
        RefreshStatText(txtMyUnitDefense, originDefense, newDefense);
        
        void RefreshStatText(TMP_Text txt, int originValue, int newValue)
        {
            txt.text = newValue.ToString();
        }

    }

    private int GetAppliedAttackValue()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard?.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return 0;

        var totalEquipmentPower = 0;
        var inventory = myBoardPlayer.GetFlatInventories();
        foreach (var item in inventory)
        {
            if (item is { Id: > 0 })
            {
                var resItem = ResourceItem.Get(item.ItemDataId);
                if (resItem != null)
                    totalEquipmentPower += resItem.Power;
            }
        }

        var baseAttack = (int)MyPlayer.GameUnit.Attack;
        if (totalEquipmentPower <= 0)
            return baseAttack;

        return baseAttack * totalEquipmentPower;
    }

    private void RefreshPlayerExp(int level, long exp)
    {
        stageLevel = level;
        var requiredExp = GameBoardManager.Get().gameBoard.ResMap.RequiredExps.GetClamped(stageLevel - 1);
        
        if (exp == 0)
            sliderMyUnitExp.value = 0;
        else
            sliderMyUnitExp.DOValue(requiredExp > 0 ? exp / (float)requiredExp : 0f, 0.5f);
        var isMaxLevel = stageLevel >= GameBoardManager.Get().gameBoard.ResMap.RequiredExps.Count + 1;
            txtMyUnitExp.text = isMaxLevel ? "Max" : $"Lv.{level}";
    }

    private void RefreshBuffTable()
    {
        var myBoardUnit = GameBoardManager.Get()?.gameBoard?.GetUnitByPlayerId(MyPlayer.Player.Id);
        if (myBoardUnit == null)
            return;

        //using var commandBuffList = PooledList<GameBuff>.Get();
        //foreach (var gameBuff in myBoardUnit.Buffs.Values)
        //{
        //    var resBuff = gameBuff.ResBuff;
        //    if (resBuff?.CanDisplay == false)
        //        continue;
        //    
        //    commandBuffList.Add(gameBuff);
        //}
        //
        //foreach (var (element, index, gameBuff) in buffContainer.GetElements(commandBuffList))
        //{
        //    var resBuff = gameBuff.ResBuff;
        //    element.btnBuffCell.SetOnClick(() =>
        //    {
        //        Popup_Tooltip.Show(resBuff);
        //    });
        //    element.imgIcon.sprite = resBuff.ClientSpriteIcon;
        //    element.imgBackground.sprite = resBuff.ClientSpriteBackground;
        //}

        //using var holdingTraits = PooledList<ResourceItem>.Get();
        using var holdingTraitsCountsByRarity = PooledSortedDictionary<int, int>.Get();
        foreach (var playerAppliedTrait in myBoardUnit.Player?.AppliedTraits ?? Enumerable.Empty<PlayerItemMessage>())
        {
            if (!playerAppliedTrait.IsValid())
                continue;
            
            var resItem = playerAppliedTrait.GetData();
            if (resItem == null)
                continue;

            if (!resItem.CanDisplay || resItem.Category != ResourceItem.Types.Category.Trait)
                continue;

            holdingTraitsCountsByRarity[resItem.Rarity] = holdingTraitsCountsByRarity.GetValueOrDefault(resItem.Rarity) + 1;
        }

        foreach (var (cell, index, (rarity, count)) in buffContainer.GetElements(holdingTraitsCountsByRarity))
        {
            cell.imgIcon.SetActive(false);
            cell.imgBackground.sprite = CRC.Get().GetRarityCellFrameSprite(rarity);
            cell.txtCount.text = "x" + count;
            //cell.btnBuffCell.SetOnClick(resTrait.ShowTooltip);
        }
    }

    private void RefreshBattleProgress()
    {
        rtWavePointParent.SetActive(true);
        const int tempBossAchId = -100;
        const int tempStartAchId = -200;
        var resMap = GameBoardManager.Get().gameBoard.ResMap;
        using var waveAchList = PooledList<int>.Get();
        waveAchList.Add(tempStartAchId);
        if (!resMap.ContainsTag(Tag.InfiniteWaves))
        {
            foreach (var ach in resMap.GetWaveAchievementIds())
                waveAchList.Add(ach);
        }
        waveAchList.Add(tempBossAchId);

        const int paddingPixel = 25; //Icon에 가려지는 부분 뺀 값
        foreach (var (cell, index, waveAchievementID) in wavePoints.GetElements(waveAchList))
        {
            var indexToWave = index + 1;
            var currentWave = GetCurrentWave();
            if (indexToWave == currentWave)
            {
                cell.sliderProgress.value = timerWaveStart.normalizedProgress;
            }
            else if (indexToWave < currentWave)
            {
                cell.sliderProgress.value = 1;
            }
            else
            {
                cell.sliderProgress.value = 0;
            }

            cell.sliderProgress.SetActive(indexToWave != waveAchList.Count);
            
            switch (waveAchievementID)
            {
                case tempStartAchId:
                    cell.imgIcon.sprite = CRC.Get().GetWavePointSprite(WavePointType.Start);
                    cell.txtWave.text = string.Empty;
                    continue;
                case tempBossAchId:
                    cell.imgIcon.sprite = CRC.Get().GetWavePointSprite(WavePointType.Boss);
                    cell.txtWave.text = "Boss".L();
                    continue;
            }

            var waveAch = ResourceAchievement.Get(waveAchievementID);
            if (waveAch == null)
            {
                cell.elementRoot.SetActive(false);
                continue;
            }
            var waveTypeStr = waveAch.GetPopupArgument("WaveDisplayType");
            var waveType = Enum.TryParse(waveTypeStr, out WavePointType type) ? type : WavePointType.Normal;
            cell.imgIcon.sprite = CRC.Get().GetWavePointSprite(waveType);
            cell.txtWave.text = index.ToString();
            cell.elementRoot.transform.localScale = GetCurrentWave() == index + 1 ? Vector3.one * 1.1f : Vector3.one;
        }
    }
    
    private void TryShowTraitPopup()
    {
        var board = GameBoardManager.Get().gameBoard;
        if (board.Variables.GetInt((int)SelectTraitUnitDataId) > 0)
        {
            var popup = Popup_TraitHelper.ShowTraitPopup(board);
            popup.Initialize();
        }
    }
    
    private void TryShowRebirthPopup()
    {
        var gameBoardManager = GameBoardManager.Get();
        if (gameBoardManager == null || gameBoardManager.gameBoard == null)
            return;

        var myGameUnit = MyPlayer.GameUnit;
        if (myGameUnit == null)
            return;

        if (myGameUnit.IsAlive)
            return;

        if (myGameUnit.RespawnTick > 0)
            return;
        
        var variables = myGameUnit.Variables;
        var purchaseRespawnCount = variables.GetInt((int)PurchaseRespawnCount);
        var maxPurchaseRespawnCount = gameBoardManager.gameBoard.ResMap.PlayerUnitMaxPurchaseRespawnCount;
        
        if (purchaseRespawnCount < maxPurchaseRespawnCount)
        {
            GameManager.Get().ShowPopup<Popup_Rebirth>();
        }
    }
    
    private void RefreshAcquiredCredit()
    {
        var myBoardPlayer = GameBoardManager.Get().gameBoard.GetPlayerById(MyPlayer.Player.Id);
        if (myBoardPlayer == null)
            return;
        var acquiredCredit = myBoardPlayer.AcquiredItems.FirstOrDefault(x => x.ItemDataId == ResourceItem.Global.DataId.Credit);
    }

    private void RefreshWaveInfo()
    {
        var gameBoard = GameBoardManager.Get().gameBoard!;
        var resMap = gameBoard.ResMap;
        txtWaveInfo.text = GetWaveString();
        txtWaveInfo.SetActive(!resMap.ContainsTag(Tag.HideWaveInfo));
    }

    private int GetCurrentWave()
    {
        var gameBoard = GameBoardManager.Get().gameBoard!;
        var variables = gameBoard.Variables;
        return (int)variables.Get(BoardVariableId.Map.wave);
    }

    private string GetWaveString()
    {
        var gameBoard = GameBoardManager.Get().gameBoard!;
        var variables = gameBoard.Variables;
        var state = (int)variables.Get(BoardVariableId.Map.Wave.state);
        return gameBoard.ResMap.GetLocalizedString($"WaveInfo_{GetCurrentWave()}_{state}");
    }
    
    
    private void RefreshTimer()
    {
        var gameBoard = GameBoardManager.Get().gameBoard!;
        var variables = gameBoard.Variables;
        var endTick = (uint)variables.Get(BoardVariableId.Map.Wave.endTick);
        var startTick = (uint)variables.Get(BoardVariableId.Map.Wave.startTick);
        timerWaveStart.SetActive(!gameBoard.ResMap.ContainsTag(Tag.HideTimer));
        timerWaveStart.targetBoardTick = endTick;
        timerWaveStart.startBoardTick = startTick; 
        timerWaveStart.SetUpdateTimeCallback((pair) =>
        {
            var value = pair.remainTime.MapRangeClamped(10f, 0f);
            var modifer = new ModifierInfo()
            {
                name = "a",
                value = (float)value
            };
            txtAnimWaveStart.Behaviors.ModifyModiferValues(modifer);
            wavePoints.RefreshElements(GetCurrentWave() - 1, (cell, idx) =>
            {
                cell.sliderProgress.value = timerWaveStart.normalizedProgress;
            });
        });
        timerWaveStart.SetExpiredCallback(() =>
        {
            txtAnimWaveStart.Behaviors.ModifyModiferValues(new ModifierInfo()
            {
                name = "a",
                value = 0f
            });
        });
    }
    
}
