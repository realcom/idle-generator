using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Pool;
using UnityEngine.UI;

public class Popup_MailBox : UIPopup
{
    public override bool contentsActiveManually => true;

    [Serializable]
    public class MailCell : UIElement
    {
        public Image imgMailState;
        
        public TextMeshProUGUI txtName;
        public TextMeshProUGUI txtSender;
        public TextMeshProUGUI txtUntilAt;
        public CustomButton btnGetIt;
        public CustomButton btnDelete;
        public PurchaseProductCell cellADWatch;

        public UIElementContainer<ItemCellBehaviourWrapperElement> rewards = new();

        public void Refresh(PlayerMailMessage mail)
        {
            txtName.text = mail.Title;
            txtSender.text = "Sender_F".L(mail.Sender?.Name ?? "GameManagerName".L());
            var inUntilAtText = "Everlasting".L();
            if (mail.UntilAt != null)
                inUntilAtText = "ExpireTime_F".L(mail.UntilAt.ToDateTime().ToLocalTime().ToString("yyyy-MM-dd HH:mm"));

            using var addItems = PooledList<PlayerMailAddItem>.Get();
            if (mail.IsClientPredefinedMail())
                inUntilAtText = mail.Message;
            else if (mail.ItemDataId != 0)
            {
                addItems.Add(mail);
            }

            foreach (var (element, _, addItem) in rewards.GetElements(addItems.Concat(mail.Option?.AddItems ?? Enumerable.Empty<PlayerMailAddItem>())))
            {
                element.Get<ItemCell>().Refresh(addItem);
            }
            
            txtUntilAt.text = inUntilAtText;
        }
    }

    [Serializable]
    public class MailTableElement : UITableElement<MailCell>
    {
    }
    
    public MailTableElement mailTableElement = new();
    
    public CustomButton btnGetAll;
    public RedDot redDotGetAll;
    
    [SerializeField] private SpriteContainer mailStates;

    public static IEnumerable<ResourceEntity> GetNoticeRelevanceEntities()
    {
        yield return ResourceItem.Get(ResourceItem.Global.DataId.MailNoticeCache);

        foreach (var resourceItem in ResourceItem.GetAllByTargetPopupName(nameof(Popup_MailBox)))
        {
            if (resourceItem.Category != ResourceItem.Types.Category.Product)
                continue;

            yield return resourceItem;
        }
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }

    protected override void Awake()
    {
        base.Awake();
        
        btnGetAll.SetOnClick(OnClickGetAll);
    }

    protected override async void Start()
    {
        SetContentActive(false);

        await GetMails();

        SetContentActive(true);
    }

    public override void Refresh()
    {
        base.Refresh();
        
        RefreshTable();

        using (var interactor = new ButtonInteractor(btnGetAll))
        {
            interactor.Update(GetValidMails().Count(x => x.HasRelevanceNotice()) > 0, "HasNotReadableMail".L());
        }

        redDotGetAll.SetActive(btnGetAll.interactable);
    }

    private IEnumerable<PlayerMailMessage> GetValidMails()
    {
        foreach (var mail in mails_)
        {
            if (mail.IsClientPredefinedMail())
                continue;

            yield return mail;
        }
    }

    private List<PlayerMailMessage> mails_ = new();
    private void RefreshTable()
    {
        mailTableElement.table.Initialize<PlayerMailMessage, MailCell>(mails_, ((mails, idx, element) =>
        {
            var mail = mails[idx];
            
            element.Refresh(mail);
            element.imgMailState.sprite = mailStates[mail.HasRelevanceNotice() ? 1 : 0];

            var isPredefinedMail = mail.IsClientPredefinedMail();
            if (isPredefinedMail)
                element.imgMailState.sprite = mailStates[2];
            
            var hasRelevanceNotice = mail.HasRelevanceNotice();
            element.btnGetIt.SetActive(!isPredefinedMail && hasRelevanceNotice);
            element.btnGetIt.SetOnClick(() =>
            {
                SendReadMail(mail.Id);
            });
            
            element.btnDelete.SetActive(!isPredefinedMail && !hasRelevanceNotice);
            element.btnDelete.SetOnClick(() =>
            {
                RemoveMail(mail.Id);
            });

            element.cellADWatch.elementRoot.SetActive(isPredefinedMail);
            if (isPredefinedMail)
                element.cellADWatch.Refresh(ResourceItem.Get(mail.ItemDataId));
        }));
    }

    private void OnClickGetAll()
    {
        using var _ = ListPool<long>.Get(out var mailIds);
        
        foreach (var mailMessage in mails_)
        {
            if (mailMessage.IsClientPredefinedMail())
                continue;
            mailIds.Add(mailMessage.Id);
        }
        
        SendReadMail(mailIds);
    }
    
    private void RemoveMail(long mailId)
    {
        using var mailIds = PooledList<long>.Get();
        mailIds.Add(mailId);
        RemoveMail(mailIds);
    }

    private void RemoveMail(IList<long> mailIds)
    {
        RequestDeleteMail(mailIds).Forget();
    }

    private async UniTask RequestDeleteMail(IList<long> mailIds)
    {
        await GameManager.Get().ShowLoading();

        var response = await SendPacket<DeletePlayerMailsRequest.Types.Response>(Packet.Pop(0, new DeletePlayerMailsRequest()
        {
            MailIDs = { mailIds }
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            await GetMails();
        }
        
        GameManager.Get().HideLoading().Forget();

    }
    
    private void SendReadMail(long mailId)
    {
        using var mailIds = PooledList<long>.Get();
        mailIds.Add(mailId);
        SendReadMail(mailIds);
    }

    private void SendReadMail(IList<long> mailIds)
    {
        RequestReadMail(mailIds).Forget();
    }

    private async UniTask RequestReadMail(IList<long> mailIds)
    {
        await GameManager.Get().ShowLoading();

        var response = await SendPacket<ReadPlayerMailsRequest.Types.Response>(Packet.Pop(0, new ReadPlayerMailsRequest()
        {
            MailIDs = { mailIds }
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
        {
            ZModeManagerLobby.EnqueueAcquiredItems(response.Items);
            await GetMails();
        }
        
        GameManager.Get().HideLoading().Forget();
    }

    private async UniTask GetMails()
    {
        var response = await SendPacket<GetPlayerMailsRequest.Types.Response>(Packet.Pop(0, new GetPlayerMailsRequest()), cancellationToken: this.GetCancellationTokenOnDestroy(), withLoading: true, freezeInteraction: false);
        if (!response.Status.IsSuccess())
            return;

        CacheMailNotice(response.HasUnread);

        mails_.Clear();

        using var predefinedMails = PooledList<PlayerMailMessage>.Get();
        foreach (var resourceItem in ResourceItem.GetAllByTargetPopupName(nameof(Popup_MailBox)))
        {
            if (!resourceItem.IsValid || resourceItem.Category != ResourceItem.Types.Category.Product)
                continue;

            var option = new PlayerMailOption();
            foreach (var addItem in resourceItem.AddItemGroups.GetAddItems())
            {
                option.AddItems.Add(addItem);
            }

            predefinedMails.Add(new PlayerMailMessage()
            {
                Sender = new PlayerMessage()
                {
                    Id = -resourceItem.Order,
                    Name = resourceItem.GetLocalizedString("MailSenderName")
                },
                Title = resourceItem.GetLocalizedString("MailTitle"),
                Message = resourceItem.GetLocalizedString("MailUntilAt"),
                ItemDataId = resourceItem.Id,
                Option = option
            });
        }

        //predefined 메일은 무조건 Sender가 있음
        predefinedMails.Sort((x, y) => y.Sender.Id.CompareTo(x.Sender.Id));
        mails_.AddRange(predefinedMails);

        using var validMails = PooledList<PlayerMailMessage>.Get();
        validMails.AddRange(response.Mails);
        validMails.Sort((x, y) => y.CreatedAt.CompareTo(x.CreatedAt));
        mails_.AddRange(validMails);

        AddRefreshAll();
    }

    public static async UniTask SendCacheMailNotice()
    {
        var response = await ZWorldClient.Get().SendPacket<GetPlayerMailsRequest.Types.Response>(Packet.Pop(0, new GetPlayerMailsRequest()
        {
            HasUnreadOnly = true
        }));

        if (response.Status.IsSuccess())
            CacheMailNotice(response.HasUnread);
    }

    private static void CacheMailNotice(bool hasUnread)
    {
        MyPlayer.GetItemByDataID(ResourceItem.Global.DataId.MailNoticeCache).Param1 = hasUnread ? 1 : 0;
    }
    
}
