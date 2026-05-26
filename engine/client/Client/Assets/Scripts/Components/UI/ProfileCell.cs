using Commons.Resources;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

public class ProfileCell : MonoBehaviour
{
    [SerializeField] private CustomButton _btnProfile;
    [SerializeField] private Image _imgPortrait;
    
    public void Refresh(PlayerMessage playerMessage)
    {
        if (playerMessage == null)
            return;
        
        if (_imgPortrait)
            _imgPortrait.sprite = ResourceItem.Get(playerMessage.AvatarCharacterItemDataId)?.ClientSpriteIcon;
        if (_btnProfile)
            _btnProfile.SetOnClickAsync(async () =>
            {
                var popup = await GameManager.Get().GetOrShowPopupAsync<Popup_Profile>();
                popup.Initialize(playerMessage.Id).Forget();
            });
    }
    
}
