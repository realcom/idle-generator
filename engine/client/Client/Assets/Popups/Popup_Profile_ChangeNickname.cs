using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using ZLinq;
using Resources = Commons.Resources.Resources;

public class Popup_Profile_ChangeNickname : UIPopup
{
    [SerializeField] private TMP_InputField ifNickname;
    [SerializeField] private PurchaseProductCell productChangeNickname;
    
    private string _newNickname = "";

    protected override void Start()
    {
        ifNickname.text = _newNickname = "";
        
        ifNickname.onEndEdit.RemoveAllListeners();
        ifNickname.onEndEdit.AddListener(OnEndEdit);
        ifNickname.onSubmit.RemoveAllListeners();
        ifNickname.onSubmit.AddListener(OnEndEdit);
        ifNickname.onValueChanged.RemoveAllListeners();
        ifNickname.onValueChanged.AddListener(OnEndEdit);

        productChangeNickname.btnPurchaseProduct.SetPrePurchaseTask(PreChangeNicknamePurchase);
        
        base.Start();
    }

    public override void Refresh()
    {
        base.Refresh();

        var resProduct = ResourceItem.GetAllByTargetPopupName(nameof(Popup_Profile_ChangeNickname)).FirstOrDefault(x => x.IsValid && x.IsValidByRequiredAndExclusive());
        resProduct ??= ResourceItem.GetAllByTargetPopupName(nameof(Popup_Profile_ChangeNickname)).AsValueEnumerable().Where(x => x.IsValid).OrderBy(x => x.Order).Last();
        
        productChangeNickname.Refresh(resProduct);
        productChangeNickname.btnPurchaseProduct.SetOverrideBuyAction(() =>
        {
            RequestUpdateNickname(resProduct).Forget();
        });
        
        RefreshButtonInteractable();
    }

    private async UniTask RequestUpdateNickname(ResourceItem resProduct)
    {
        var response = await SendPacket(Packet.Pop(0, new UpdatePlayerNameRequest()
        {
            Name = _newNickname,
            ProductItemDataId = resProduct.Id
        }), this.GetCancellationTokenOnDestroy());

        if (response.Status.IsSuccess())
            OnCancel();

    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_ACHIEVEMENT_UPDATED | RefreshFlag.MY_AVATAR_UPDATED | RefreshFlag.MY_PLAYER_ITEM_UPDATED))
            Refresh();
    }

    public void OnEndEdit(string text)
    {
        _newNickname = text;

        RefreshButtonInteractable();
    }
    
    private void RefreshButtonInteractable()
    {
        using var interactor = productChangeNickname.btnPurchaseProduct.GetInteractor();
        interactor.Update(!string.Equals(MyPlayer.Player.Name, _newNickname), "Popup_Profile_ChangeNickname_SameAsCurrentName".L());
        interactor.Update(_newNickname.Length >= Resources.Global.MinNameLength, "Popup_Profile_ChangeNickname_TooShortName".L());
        interactor.Update(_newNickname.Length <= Resources.Global.MaxNameLength, "Popup_Profile_ChangeNickname_TooLongName".L());
        interactor.Update(Utility.IsValidLettersOnly(_newNickname), "Popup_Profile_ChangeNickname_CannotUseSpecialCharacters".L());
        interactor.Update(!BadWordFilter.ContainsBadWord(_newNickname), "Popup_Profile_ChangeNickname_ContainsInappropriateWords".L());
    }
    
    private async UniTask<bool> PreChangeNicknamePurchase()
    {
        var popup = Popup_Alert.Show()
            .SetTitle("Popup_Profile_ChangeNickname_Alert_Title".L())
            .SetDesc("Popup_Profile_ChangeNickname_Alert_Desc".L(_newNickname));
        return await popup.WaitResultAsync();
    }
    
}
