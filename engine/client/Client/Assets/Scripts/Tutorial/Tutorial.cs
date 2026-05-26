using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.UI;

public class Tutorial : EventBehaviour
{
    public enum Step
    {
        InGameTutorial_1_Merge,
        InGameTutorial_2_ExpandInventory,
        InGameTutorial_3_Consumable,
        OutGameTutorial_1_Training,
        OutGameTutorial_2_Gacha,
        OutGameTutorial_3_Equipment,
        OutGameTutorial_4_Pass,
        OutGameTutorial_5_Pet,
        End,
    }

    [Serializable]
    public class TutorialChatParameter
    {
        public enum Pivot
        {
            Middle,
            Top,
            Bottom
        }
        
        public Step step;
        public Pivot pivot;
        public string descKey;
        public float durationPerCharacter = 0.25f;
    }
    
    private static Tutorial inst;
    public static Tutorial Get() => inst != null ? inst : null;

    public Animator animator;

    public RectTransform rtChatAnchor;
    public TextMeshProUGUI txtChat;

    public CanvasGroup canvasGroupRoot;
    public CanvasGroup canvasGroupFingerZone;
    public RectTransform rtFinger;
    public Image imgDim;
    public GameObject goMaskPrefab;
    
    public TutorialChatParameter[] chatParameters = new TutorialChatParameter[0];
    
    private class MaskInstance
    {
        public Transform tr;
        public TutorialUIMaskTarget target;
        public Action clickCallback;
        public bool accurateClick;
    }
    
    private readonly Dictionary<TutorialUIMaskTarget, MaskInstance> maskInstances = new();

    public override void Awake()
    {
        base.Awake();
        
        inst = this;
        gameObject.SetActive(false);
        
        imgDim.SetActive(false);
        
        ShowFinger(false);
        
        GameManager.Get().AddListener(this);
        ZWorldClient.Get().AddListener(this);
    }

    public override void OnDestroy()
    {
        GameManager.Get().RemoveListener(this);
        ZWorldClient.Get().RemoveListener(this);

        if (inst == this)
            inst = null;
        
        base.OnDestroy();
    }

    private void CloseTutorial()
    {
        if (!this)
            return;
        
        _cts?.Cancel();
        _cts?.Dispose();
        _cts = null;

        currentStep = Step.End;
        
        ClearMask();
        imgDim.SetActive(false);

        StopAllCoroutines();
            
        enabled = false;
        gameObject.SetActive(false);
    }

    private bool isInProgressStep => _cts != null;
    private CancellationTokenSource _cts = null;
    public async UniTask<bool> LoadTutorial()
    {
        if (isInProgressStep)
            return true;
        
        if (MyPlayer.GetAchievementByDataID(ResourceAchievement.Global.DataId.TutorialComplete).IsAchievementCompletedOrRewarded())
        {
            CloseTutorial();
            return false;
        }
        
        var currentMap = GameBoardManager.Get()?.gameBoard?.ResMap;
        if (currentMap == null)
        {
            CloseTutorial();
            return false;
        }

        if (currentMap.GetPopupArgument("ClientModeManager") == nameof(ModeManagerMushroom))
        {
            CloseTutorial();
            return false;
        }
        
        for (var i = 0; i < ResourceAchievement.Global.DataId.TutorialSteps.Count; i++)
        {
            var achievementId = ResourceAchievement.Global.DataId.TutorialSteps[i];
            var achievement = MyPlayer.GetAchievementByDataID(achievementId);
            if (achievement == null)
                continue;

            var step = (Step)i;
            var canProgress = step switch
            {
                Step.InGameTutorial_1_Merge or Step.InGameTutorial_2_ExpandInventory or Step.InGameTutorial_3_Consumable => GameBoardManager.Get().gameBoard?.ResMap?.Type != ResourceMap.Types.Type.Lobby,
                _ => GameBoardManager.Get().gameBoard?.ResMap?.Type == ResourceMap.Types.Type.Lobby
            };
            
            if (canProgress && achievement.State == PlayerAchievementMessage.Types.State.InProgress)
            {
                if ((int)currentStep != i)
                    currentStep = step;
            }
            else
            {
                var resAchievement = achievement.GetData()!;
                if (!resAchievement.AutoReward && achievement.State == PlayerAchievementMessage.Types.State.Completed)
                {
                    await ClaimAchievementReward(achievementId, CancellationToken.None);
                }   
            }
        }
        
        //if ((int)currentStep % stepPadding == 0 &&
        //    GameBoardManager.Get()?.gameBoard?.ResMap?.Type == ResourceMap.Types.Type.Lobby &&
        //    GameBoardManager.Get()?.GetModeManager<ZModeManagerLobby>()?.currentType != ZModeManagerLobby.BottomButtonType.LOBBY)
        //{
        //    CloseTutorial();
        //    return;
        //}

        if (currentStep != Step.End)
        {
            enabled = true;
            gameObject.SetActive(true);
            
            _cts?.Cancel();
            _cts?.Dispose();
            _cts = CancellationTokenSource.CreateLinkedTokenSource(this.GetCancellationTokenOnDestroy());

            ProgressStep(_cts.Token).Forget();
            
            return true;
        }

        return false;
    }
    
    private void ShowFinger(bool show)
    {
        canvasGroupFingerZone.SetActive(show);
    }
    
    public bool IsEnd() => currentStep == Step.End;
    public Step GetStep() => currentStep;
    
    private Step currentStep = Step.End;
    private PlayerAchievementMessage currentAchievement => MyPlayer.GetAchievementByDataID(ResourceAchievement.Global.DataId.TutorialSteps.GetClamped((int)currentStep))!;

    private async UniTask ProgressStep(CancellationToken ct)
    {
        try
        {
            if (currentStep > Step.InGameTutorial_3_Consumable)
                GameManager.Get().ClearAllPopups();
        
            animator.Play(Animator.StringToHash(currentStep.ToString()), -1, 0);
            ShowFinger(false);
            HideChat();
        
            canvasGroupRoot.interactable = canvasGroupRoot.blocksRaycasts = currentStep >= Step.OutGameTutorial_1_Training;
            PlatformManager.Get().LogEvent("TutorialEnd", value: (long) currentStep);
            switch (currentStep)
            {
                //InGame Tutorial
                case Step.InGameTutorial_1_Merge:
                {
                    GameManager.Get().blockDisplayWeaponFloatingDropdown = true;

                    await UniTask.Delay(333, cancellationToken: ct);
                    
                    await DoInGameTutorialSequence("Popup_Tutorial_01", ct, delay: 0.33f, increaseAchievement: false);
                
                    //진입 조건 탐색: 머지 가능한 무기 존재 여부 체크
                    using var itemDataIdSet = PooledHashSet<int>.Get();
                    while (!ct.IsCancellationRequested)
                    {
                        await UniTask.Delay(500, cancellationToken: ct);
                    
                        itemDataIdSet.Clear();
                        var myBoardPlayer = MyPlayer.BoardPlayer;
                        if (myBoardPlayer is { Id: not 0 })
                        {
                            var foundDuplicatedItemDataId = false;
                            foreach (var item in myBoardPlayer.GetFlatInventories().Concat(myBoardPlayer.HoldItems))
                            {
                                if (item.Id <= 0)
                                    continue;
                            
                                if (!itemDataIdSet.Add(item.DataId))
                                {
                                    foundDuplicatedItemDataId = true;
                                    break;
                                }
                            }

                            if (foundDuplicatedItemDataId)
                                break;
                        }
                    }

                    await DoInGameTutorialSequence("Popup_Tutorial_02", ct);
                
                    GameManager.Get().blockDisplayWeaponFloatingDropdown = false;
                
                    break;
                }
                case Step.InGameTutorial_2_ExpandInventory:
                {
                    //진입 조건 탐색: 확장칸 아이템 찾기
                    while (!ct.IsCancellationRequested)
                    {
                        await UniTask.Delay(500, cancellationToken: ct);
                    
                        var myBoardPlayer = MyPlayer.BoardPlayer;
                        if (myBoardPlayer is { Id: not 0 })
                        {
                            var foundExpandItem = false;
                            foreach (var item in myBoardPlayer.GetFlatInventories().Concat(myBoardPlayer.HoldItems))
                            {
                                if (item.Id <= 0)
                                    continue;

                                if (item.GetData()?.ContainsTag(Tag.InventoryExpand) == true)
                                {
                                    foundExpandItem = true;
                                    break;
                                }
                            }

                            if (foundExpandItem)
                                break;
                        }
                    }

                    await DoInGameTutorialSequence("Popup_Tutorial_03", ct);
                
                    break;
                }
                case Step.InGameTutorial_3_Consumable:
                {
                    //진입 조건 탐색: 소모품 아이템 찾기
                    while (!ct.IsCancellationRequested)
                    {
                        await UniTask.Delay(500, cancellationToken: ct);
                    
                        var myBoardPlayer = MyPlayer.BoardPlayer;
                        if (myBoardPlayer is { Id: not 0 })
                        {
                            var foundConsumable = false;
                            foreach (var item in myBoardPlayer.GetFlatInventories().Concat(myBoardPlayer.HoldItems))
                            {
                                if (item.Id <= 0)
                                    continue;

                                if (item.GetData()?.ContainsTag(Tag.Consumable) == true)
                                {
                                    foundConsumable = true;
                                    break;
                                }
                            }

                            if (foundConsumable)
                                break;
                        }
                    }
                
                    await DoInGameTutorialSequence("Popup_Tutorial_04", ct);
                
                    break;
                }
                //OutGame Tutorial
                case Step.OutGameTutorial_1_Training:
                {
                    await ShowDim(ct);
                    await ShowMask(TutorialUIMaskTarget.MaskTarget.TrainingTab, () =>
                    {
                        GameBoardManager.Get().GetModeManager<ZModeManagerLobby>().ClickBottomButton(ZModeManagerLobby.BottomButtonType.TRAIN);
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.TrainingCell, () =>
                    {
                        var pageAbility = (Page_Ability)GameBoardManager.Get()
                            .GetModeManager<ZModeManagerLobby>().pages
                            .First(x => x.type == ZModeManagerLobby.BottomButtonType.TRAIN).page;

                        pageAbility.OnClickCell();
                    }, ct, clearMask: false);

                    while (currentAchievement.Progress < currentAchievement.GetData()!.TargetProgress)
                    {
                        await UniTask.Yield();

                        if (GameManager.Get().GetPopup<Popup_GotItems>() != null)
                        {
                            await HideDim(ct);
                            await UniTask.WhenAny(UniTask.WaitUntilCanceled(GameManager.Get().GetPopup<Popup_GotItems>().GetCancellationTokenOnDestroy()), UniTask.WaitUntilCanceled(ct));
                            await ShowDim(ct);
                            break;
                        }
                    }

                    await WaitForCurrentAchievementComplete(ct);
                
                    break;
                }
                case Step.OutGameTutorial_2_Gacha:
                {
                    await ShowDim(ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.ShopTab, () =>
                    {
                        GameBoardManager.Get().GetModeManager<ZModeManagerLobby>().ClickBottomButton(ZModeManagerLobby.BottomButtonType.SHOP);
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.GachaButton, () =>
                    {
                        BuyItem(ResourceItem.Global.DataId.TutorialGachaProduct);
                    }, ct);

                    await HideDim(ct);
                    
                    //생성 될 때까지 대기
                    await UniTask.WaitUntil(() => GameManager.Get().GetPopup<Popup_GachaResult>() != null, cancellationToken: ct);

                    //제거 될 때까지 대기
                    var popupGachaResult = GameManager.Get().GetPopup<Popup_GachaResult>();
                    await UniTask.WhenAny(UniTask.WaitUntilCanceled(popupGachaResult.GetCancellationTokenOnDestroy()), UniTask.WaitUntilCanceled(ct));

                    await ClaimAchievementReward(currentAchievement.AchievementDataId, ct);

                    await WaitForCurrentAchievementComplete(ct);
                
                    break;
                }
                case Step.OutGameTutorial_3_Equipment:
                {
                    await ShowDim(ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.EquipmentTab, () =>
                    {
                        GameBoardManager.Get().GetModeManager<ZModeManagerLobby>().ClickBottomButton(ZModeManagerLobby.BottomButtonType.UNIT);
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.Equipment, () =>
                    {
                        var pageShop = (Page_Equipment)GameBoardManager.Get()
                            .GetModeManager<ZModeManagerLobby>().pages
                            .First(x => x.type == ZModeManagerLobby.BottomButtonType.UNIT).page;

                        GameManager.Get().ShowPopup<Popup_EquipInfo>().Initialize(pageShop.GetFirstEquipment());
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.EquipButton, () =>
                    {
                        var popupEquipInfo = GameManager.Get().GetPopup<Popup_EquipInfo>();
                        popupEquipInfo.OnClickEquipButton();
                    }, ct);
                    
                    //장비 장착 시까지 대기
                    await UniTask.WaitUntil(() => MyPlayer.GetItemsByCategory(ResourceItem.Types.Category.Equipment).FirstOrDefault(x => x.IsValid() && x.IsEquipped()) != null, cancellationToken: ct);
                    
                    var popupEquipInfo = GameManager.Get().GetPopup<Popup_EquipInfo>();
                    popupEquipInfo.OnCancel();

                    await IncreaseAchievementToComplete(currentAchievement.AchievementDataId, ct);

                    await WaitForCurrentAchievementComplete(ct);

                    //1챕터 한번에 못 깬 경우에만 하단 튜토리얼 진행
                    if (MyPlayer.IsAchievementCompletedOrRewarded(ResourceAchievement.Global.DataId.ChapterEnterAgainCondition))
                        break;
                    
                    await ShowMask(TutorialUIMaskTarget.MaskTarget.LobbyTab, () =>
                    {
                        GameBoardManager.Get().GetModeManager<ZModeManagerLobby>().ClickBottomButton(ZModeManagerLobby.BottomButtonType.LOBBY);
                    }, ct);
                    
                    await ShowMask(TutorialUIMaskTarget.MaskTarget.EnterChapterButton, () =>
                    {
                        MyPlayer.TryEnterMap();
                    }, ct);
                    
                    break;
                }
                case Step.OutGameTutorial_4_Pass:
                {
                    await ShowDim(ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.Pass, () =>
                    {
                        ResourceItem.Get(GlobalResourceItem.ChapterPassItem!.Group)!.ShowPopup();
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.PassReward, () =>
                    {
                        var passPopup = GameManager.Get().GetPopup<Popup_GamePass>();
                        passPopup.tableElement.table.ScrollToIndex(0);
                        passPopup.SendClaimAchievementRewardRequest();
                    }, ct);

                    await WaitForCurrentAchievementComplete(ct);

                    break;
                }
                case Step.OutGameTutorial_5_Pet:
                {
                    await ShowDim(ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.EquipmentTab, () =>
                    {
                        GameBoardManager.Get().GetModeManager<ZModeManagerLobby>().ClickBottomButton(ZModeManagerLobby.BottomButtonType.UNIT);
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.PetButton, () =>
                    {
                        GameManager.Get().ShowPopup<Popup_Pet>();
                    }, ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.PetGachaButton, () =>
                    {
                        BuyItem(ResourceItem.Global.DataId.TutorialSummonPetProduct);
                    }, ct);
                    
                    await HideDim(ct);

                    await UniTask.WaitUntil(() => GameManager.Get().GetPopup<Popup_GotItems>() != null, cancellationToken: ct);
                    await WaitForCurrentAchievementComplete(ct);
                    await UniTask.WhenAny(UniTask.WaitUntilCanceled(GameManager.Get().GetPopup<Popup_GotItems>().GetCancellationTokenOnDestroy()), UniTask.WaitUntilCanceled(ct));
                    
                    await ShowDim(ct);

                    await ShowMask(TutorialUIMaskTarget.MaskTarget.PetManagementButton, () =>
                    {
                        var popupPet = GameManager.Get().GetPopup<Popup_Pet>();
                        popupPet.tabBar.selectedIndex = 1;
                    }, ct);
                    
                    break;
                }
                default:
                {
                    Debug.LogError($"[Tutorial] Unknown Step: {currentStep}");
                    break;
                }
            }
        }
        catch (OperationCanceledException)
        {
        }
        catch (Exception e)
        {
            Debug.LogException(e);
        }
        finally
        {
            // 스텝 종료 정리
            _cts?.Dispose();
            _cts = null;

            // 전체 종료/맵 해제 등 외부 취소가 아니면 다음 스텝으로 이어가기
            if (!ct.IsCancellationRequested)
            {
                CloseTutorial();             // 여기서는 '끝냈다'로 간주
                LoadTutorial().Forget();     // 다음 스텝 진입 시 다시 enable/active 됨
            }
            else
            {
                // 외부 취소(MAP_RELEASED 등)라면 깔끔히 닫기만
                CloseTutorial();
            }
        }
    }
    
    private async UniTask WaitForCurrentAchievementComplete(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested && !currentAchievement.IsAchievementCompletedOrRewarded())
            await UniTask.Yield();
    }

    private async UniTask DoInGameTutorialSequence(string popupName, CancellationToken ct , float delay = 1f, bool increaseAchievement = true)
    {
        GameBoardManager.Get().PauseBoard(currentStep.ToString());
        HUDManager.Get().cgHUD.blocksRaycasts = false;

        if (delay > 0f)
            await UniTask.Delay((int)delay * 1000, cancellationToken: ct);

        if (increaseAchievement)
            await IncreaseAchievementToComplete(currentAchievement.AchievementDataId, ct);
                
        //팝업 보여주기
        var popup = await GameManager.Get().ShowPopupAsync(popupName);
        await UniTask.WhenAny(UniTask.WaitUntilCanceled(ct), UniTask.WaitUntilCanceled(popup.GetCancellationTokenOnDestroy()));
        
        GameBoardManager.Get().ResumeBoard(currentStep.ToString());
        HUDManager.Get().cgHUD.blocksRaycasts = true;
    }

    private async UniTask ShowDim(CancellationToken ct, float duration = float.NegativeInfinity, float delay = float.NegativeInfinity, float afterDelay = float.NegativeInfinity)
    {
        if (!float.IsNegativeInfinity(delay))
            await UniTask.Delay((int)(delay * 1000), cancellationToken: ct);

        imgDim.SetActive(true);
        canvasGroupRoot.blocksRaycasts = true;

        if (!float.IsNegativeInfinity(duration))
        {
            imgDim.color = new Color(0, 0, 0, 0);
            await imgDim.DOFade(0.5f, duration).ToUniTask(cancellationToken: ct);
        }
        else
        {
            imgDim.color = new Color(0, 0, 0, 0.5f);
        }

        if (!float.IsNegativeInfinity(afterDelay))
            await UniTask.Delay((int)(afterDelay * 1000), cancellationToken: ct);
    }

    private async UniTask HideDim(CancellationToken ct, float duration = float.NegativeInfinity, float delay = float.NegativeInfinity, float afterDelay = float.NegativeInfinity)
    {
        if (!float.IsNegativeInfinity(delay))
            await UniTask.Delay((int)(delay * 1000), cancellationToken: ct);

        canvasGroupRoot.blocksRaycasts = false;
        
        if (!float.IsNegativeInfinity(duration))
        {
            await imgDim.DOFade(0f, duration).ToUniTask(cancellationToken: ct);
            imgDim.SetActive(false);
        }
        else
        {
            imgDim.color = new Color(0, 0, 0, 0);
            imgDim.SetActive(false);
        }

        if (!float.IsNegativeInfinity(afterDelay))
            await UniTask.Delay((int)(afterDelay * 1000), cancellationToken: ct);
    }

    private async UniTask ShowMask(TutorialUIMaskTarget.MaskTarget maskTarget, Action clickCallback, CancellationToken ct, bool accurateClick = true, bool clearMask = true)
    {
        var target = TutorialUIMaskTarget.MaskTargets[maskTarget];
        
        ClearMask();
        
        if (maskInstances.Remove(target, out var instance))
        {
            Destroy(instance.tr.gameObject);
        }

        instance = maskInstances[target] = new MaskInstance()
        {
            accurateClick = accurateClick,
            target = target,
            tr = goMaskPrefab.Clone().transform,
        };

        var bWait = true;
        await UniTask.Delay(333, cancellationToken: ct); //클릭 방지용 딜레이
        instance.clickCallback = () =>
        {
            clickCallback?.Invoke();
            bWait = false;
        };

        await UniTask.WaitUntil(() => !bWait, cancellationToken: ct);

        if (clearMask)
            ClearMask();
    }
    
    private void ClearMask()
    {
        foreach (var instance in maskInstances.Values)
        {
            Destroy(instance.tr.gameObject);
        }
        maskInstances.Clear();
    }
    
    private async UniTask HideMask(TutorialUIMaskTarget.MaskTarget maskTarget)
    {
        var target = TutorialUIMaskTarget.MaskTargets[maskTarget];
        
        if (maskInstances.Remove(target, out var instance))
        {
            Destroy(instance.tr.gameObject);
        }
    }

    private IEnumerator ShowChat()
    {
        var parameter = chatParameters.FirstOrDefault(p => p.step == currentStep);
        if (parameter == null)
        {
            rtChatAnchor.SetActive(false);
            yield break;
        }
        
        rtChatAnchor.SetActive(!string.IsNullOrEmpty(parameter.descKey));
        if (string.IsNullOrEmpty(parameter.descKey))
            yield break;

        rtChatAnchor.anchorMin = rtChatAnchor.anchorMax = new Vector2(0.5f, parameter.pivot switch
        {
            TutorialChatParameter.Pivot.Middle => 0.5f,
            TutorialChatParameter.Pivot.Top => 0.75f,
            TutorialChatParameter.Pivot.Bottom => 0.25f,
            _ => throw new ArgumentOutOfRangeException()
        });

        txtChat.text = string.Empty;
        var text = parameter.descKey.L();
        yield return txtChat.DOText(text, parameter.durationPerCharacter * text.Length).WaitForCompletion();
    }

    private void HideChat()
    {
        rtChatAnchor.SetActive(false);
    }

    private void Update()
    {
        using var __ = ListPool<TutorialUIMaskTarget>.Get(out var toRemoval);
        
        foreach (var (tutorialUIMaskTarget, instance) in maskInstances)
        {
            if (instance?.target == null || instance.target.rt == null)
            {
                toRemoval.Add(tutorialUIMaskTarget);
                continue;
            }
            
            var bounds = instance.target.rt.GetWorldBounds();
            instance.tr.position = bounds.center;
            instance.tr.localScale = bounds.size;
        }
        
        foreach (var tutorialUIMaskTarget in toRemoval)
        {
            if (maskInstances.Remove(tutorialUIMaskTarget, out var instance))
            {
                Destroy(instance.tr.gameObject);
            }
        }

        if (Input.GetMouseButtonUp(0))
        {
            canvasGroupFingerZone.alpha = 1;
            
            using var _ = ListPool<MaskInstance>.Get(out var toInvoke);
            foreach (var instance in maskInstances.Values)
            {
                if (instance.accurateClick)
                {
                    var bounds = instance.target.rt.GetWorldBounds();
                    var mousePos = Input.mousePosition;
                    if (bounds.IncludePoint2D(mousePos))
                    {
                        toInvoke.Add(instance);
                    }
                }
                else
                {
                    toInvoke.Add(instance);
                }
            }

            foreach (var instance in toInvoke)
            {
                instance.clickCallback?.Invoke();
            }
        }
    }

    private async UniTask IncreaseAchievementToComplete(int achievementDataId, CancellationToken ct)
    {
        await ZWorldClient.Get().SendPacket(Packet.Pop(0, new IncreaseAchievementRequest()
        {
            AchievementDataId = achievementDataId,
            Progress = 1
        }), ct);
    }
    
    private async UniTask ClaimAchievementReward(int achievementDataId, CancellationToken ct)
    {
        if (ResourceAchievement.Get(achievementDataId)!.AutoReward)
            return;
        
        await ZWorldClient.Get().SendPacket(Packet.Pop(0, new ClaimAchievementRewardRequest()
        {
            AchievementDataId = achievementDataId,
            Count = 1
        }), ct);
    }

    private void BuyItem(int productItemDataId)
    {
        var resItem = ResourceItem.Get(productItemDataId)!;
        ZWorldClient.Get().SendPacket(Packet.Pop(0, new BuyItemRequest { ProductItemDataId = productItemDataId, Count = resItem.GetPurchaseUnit() })).Forget();
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        switch (e.type)
        {
            case GameEventType.MAP_LOADED:
            case GameEventType.MyPlayerAchievementUpdated:
            case GameEventType.LobbyHUDPageUpdated:
            {
                var resMap = GameBoardManager.Get().gameBoard?.ResMap;
                if (resMap == null)
                    return;

                if (resMap.Type == ResourceMap.Types.Type.Lobby)
                    return;

                LoadTutorial().Forget();
                break;
            }
            case GameEventType.MAP_RELEASED:
            {
                _cts?.Cancel();
                break;
            }
        }
    }
}
