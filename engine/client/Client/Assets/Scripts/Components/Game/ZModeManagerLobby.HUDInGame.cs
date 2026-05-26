using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using Interfaces;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public partial class ZModeManagerLobby
{
    public enum LobbyButtonType
    {
        Goods,
        Premium,
        Attendance,
        Settings,
        AutoSettings,
        Ranking,
        Referral,
        Airdrop,
        Mail,
        Roulette,
    }
    
    [Title("HUD InGame")]
    public CanvasGroup cgLobbyMainHUD;
    public Image imgHUDDim;
    public CanvasGroup cgHUDDim;

    [Title("Stage Info")]
    public CustomButton btnEnterChapter;

    public TextMeshProUGUI txtEnterChapterPrice;
        
    public TextMeshProUGUI txtStageMapName;
    public TextMeshProUGUI txtStageMaxWave;
    
    [Title("Lobby Buttons")]
    public Dictionary<LobbyButtonType, ZButton> lobbyButtons = new();
    
    public void RefreshPlayerInfo()
    {
        RefreshPlayerLevel();
    }
    
    private void RefreshPlayerLevel()
    {
//        txtPlayerLevel.text = $"Lv. {MyPlayer.PlayerLevel}";
    }

    private void RefreshHUDButtons()
    {
        
        using (var interactor = new ButtonInteractor(btnEvent))
        {
            var Id = ResourceAchievement.Global.DataId.LobbyDungeonUnlock;
            interactor.Update(MyPlayer.IsAchievementCompletedOrRewarded(Id), ResourceAchievement.Get(Id)!.ClientUnlockToast);
        }
        
    }
    
    private void RefreshChapterPass()
    {
        var resChapterPass = GlobalResourceItem.ChapterPassItem!;

        txtPassName.text = resChapterPass.ClientName;
        
        var firstSubPassItem = ResourceItem.Get(resChapterPass.TargetItemDataIds.First())!;
        var currentStep = firstSubPassItem.TargetAchievementDataIds.Count(x => MyPlayer.GetAchievementByDataID(x)?.IsAchievementCompletedOrRewarded() == true);
        var index = firstSubPassItem.TargetAchievementDataIds.Count;
        foreach (var itemDataId in resChapterPass.TargetItemDataIds)
        {
            var resSubPassItem = ResourceItem.Get(itemDataId)!;
            
            var foundIndex = resSubPassItem.TargetAchievementDataIds.FindIndex(x => ResourceAchievement.Get(x)!.ContainsTag(Tag.SpecialChapterPassStep) && MyPlayer.GetAchievementByDataID(x)?.IsAchievementCompleted() == true);
            if (foundIndex == -1)
                continue;
            
            index = Math.Min(index, foundIndex + 1);
        }

        var hasAcquirableReward = MyPlayer.GetAchievementByDataID(firstSubPassItem.TargetAchievementDataIds.GetClamped(index) - 1).IsAchievementCompleted();
        txtPassDesc.text = resChapterPass.GetLocalizedString(hasAcquirableReward ? $"HasSpecialChapterReward_{index}" : $"RemainChapterForSpecialReward_{currentStep}");

        passNoticeListener.Register<ResourceItem>(resChapterPass.Group);
        btnPass.SetOnClick(ResourceItem.Get(resChapterPass.Group)!.ShowPopup);
    }
    
    public void ShowLobbyMainHUD(bool bShow)
    {
        cgLobbyMainHUD.alpha = bShow ? 1 : 0;
        cgLobbyMainHUD.blocksRaycasts = bShow;
    }

    private bool wasRequestSummonUnit = false;
    
    public void InitLobbyButtons()
    {
        foreach (var (type, button) in lobbyButtons)
        {
            button.SetOnClick(() => OnClickLobbyButton(type));
        }
    }

    private void OnClickLobbyButton(LobbyButtonType type)
    {
        switch (type)
        {
            case LobbyButtonType.Airdrop:
            {
                return;
            }
            case LobbyButtonType.Ranking:
            {
                GameManager.Get().ShowPopup<Popup_Ranking>();
                return;
            }
            case LobbyButtonType.Settings:
            {
                GameManager.Get().ShowPopup<Popup_Settings>();
                return;
            }
            case LobbyButtonType.Attendance:
            {
                return;
            }
            case LobbyButtonType.Premium:
            {
                return;
            }
            case LobbyButtonType.Mail:
            {
                GameManager.Get().ShowPopup<Popup_MailBox>();
                return;
            }
            case LobbyButtonType.Roulette:
            {
                return;
            }
            default:
            {
                Toast.Show<Popup_Toast>("Coming Soon".L());
                break;
            }

        }
    }
    
    private void OnHandlePlayerAcquiredItems(PlayerAcquiredItemsUpdate update)
    {
    }

    private void RefreshStageButtons()
    {
        
        
        // TODO: 스테이지 버튼
        var currentMap = MyPlayer.GetCurrentMap();
        var materialItem = currentMap.EntryMaterialItemGroups.FirstOrDefault()!.MaterialItems.FirstOrDefault()!;
        btnEnterChapter.SetOnClick(() =>
        {
            MyPlayer.TryEnterMap(currentMap);
        });
        
        // btnEnterChapter.GetComponent()
        // btnEnterChapter.
        txtEnterChapterPrice.text = materialItem.ToStringWithIcon(includeX: true);      
        
    }
    
    private void TryStartUISequence()
    {
        //팝업이 아예 없는 상태에서 시작 가능
        if (GameManager.Get().HasPopup())
        {
            if (!_isUISequenceRunning)
                Tutorial.Get().LoadTutorial().Forget();
            
            return;
        }
        
        if (_isUISequenceRunning)
        {
            bReserveUISequence = true;
            return;
        }

        _isUISequenceRunning = true;
        UISequence().Forget();
    }

    private static Queue<(ResourceItem, IList<PlayerItemMessage>)> _acquiredItemsQueue = new();
    private static Queue<PlayerItemMessage> _acquiredTrainingRanksQueue = new();
    private static Queue<PlayerItemMessage> _acquiredSpecificItemsQueue = new();
    
    public static void EnqueueAcquiredItems(IList<PlayerItemMessage> items, PlayerAcquiredItemsUpdate update = null)
    {
        if (items.Count == 0)
            return;

        ResourceItem resProductItem = null;
        if (update != null && update.ProductItemDataId != 0)
            resProductItem = ResourceItem.Get(update.ProductItemDataId)!;

        var acquiredItems = PooledList<PlayerItemMessage>.Get();
        foreach (var item in items)
        {
            var resItem = item.GetData()!;
            if (resItem.ContainsTag(Tag.SpecificDisplay))
            {
                if (resItem.Type == ResourceItem.Types.Type.TrainingRank)
                {
                    _acquiredTrainingRanksQueue.Enqueue(item);
                }
                else
                {
                    _acquiredSpecificItemsQueue.Enqueue(item);
                }
            }
        }

        items.Shrink();
        
        foreach (var item in items)
        {
            var resItem = item.GetData()!;
            if (!resItem.ContainsTag(Tag.SpecificDisplay))
            {
                acquiredItems.Add(item);
            }
        }

        if (acquiredItems.Count > 0)
        {
            _acquiredItemsQueue.Enqueue((resProductItem, acquiredItems));
        }
        else
        {
            acquiredItems.Dispose();
        }

        DequeueAcquiredItems();
    }

    private static void DequeueAcquiredItems()
    {
        //아이템 획득 관련 팝업은 하나씩만 노출 가능
        if (GameManager.Get().GetPopup<Popup_Promotion>() ||
            GameManager.Get().GetPopup<Popup_GetIt>() ||
            GameManager.Get().GetPopup<Popup_GotItems>())
            return;
        
        if (_acquiredTrainingRanksQueue.TryDequeue(out var acquiredTrainingRank))
        {
            var popup = GameManager.Get().ShowPopup<Popup_Promotion>();
            popup.Initialize(acquiredTrainingRank);
            return;
        }
        
        if (_acquiredSpecificItemsQueue.TryDequeue(out var acquiredSpecificItem))
        {
            var popup = GameManager.Get().ShowPopup<Popup_GetIt>();
            popup.Initialize(acquiredSpecificItem.GetData()!.Id);
            return;
        }
        
        if (_acquiredItemsQueue.TryDequeue(out var pair))
        {
            var (resProduct, acquiredItems) = pair;

            var popupArgs = resProduct?.AcquiredItemViewerPopupArgs ?? nameof(Popup_GotItems);
            var popup = GameManager.Get().ShowPopup(popupArgs);
            
            var viewer = (IAcquiredItemViewer)popup;
            var title = resProduct?.GetLocalizedString("AcquiredItemViewerTitle", "Rewards".L()) ?? "Rewards".L();
            viewer.Initialize(acquiredItems, title, resProduct);
            return;
        }
        
    }

    private bool _isUISequenceRunning = false;
    private bool bReserveUISequence = false;
    private async UniTask UISequence()
    {
        bReserveUISequence = false;

        await SequenceContentsAutoLanding();

        EndSequence();
        return;

        async UniTask SequenceContentsAutoLanding()
        {
            foreach (var notice in LobbyHUDLayoutDefine.Get().contentsAutoLandings)
            {
                if (!notice.IsValid())
                    continue;

                await notice.DoAutoLanding();

                if (notice.TryPostAutoLanding())
                {
                    EndSequence();
                }
            }
        }

        async void EndSequence()
        {
            try
            {
                _isUISequenceRunning = false;

                var isTutorialRunning = await Tutorial.Get().LoadTutorial();
                if (isTutorialRunning)
                    return;
        
                if (bReserveUISequence)
                    TryStartUISequence();
            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }
        }
        
    }
    
}
