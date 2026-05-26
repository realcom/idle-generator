using System.Collections.Generic;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Cysharp.Threading.Tasks;
using Interfaces;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine;

public class Popup_Profile : UIPopup
{
    [SerializeField, TabGroup("Profile")] private ProfileCell _profileCell;
    [SerializeField, TabGroup("Profile")] private TextMeshProUGUI _txtNickname;
    [SerializeField, TabGroup("Profile")] private TextMeshProUGUI _txtUID;
    [SerializeField, TabGroup("Profile")] private TextMeshProUGUI _txtHighestChapter;
    [SerializeField, TabGroup("Profile")] private CustomButton _btnChangeNickname;
    [SerializeField, TabGroup("Profile")] private CustomButton _btnCopyUID;
    
    [SerializeField, TabGroup("Equipment")] private Dictionary<ResourceItem.Types.Type, ItemCellBehaviourWrapperElement> cellsByPartType = new();
    [SerializeField, TabGroup("Equipment")] private UnitUIRenderer _unitUIRenderer;
    [SerializeField, TabGroup("Equipment")] private TextMeshProUGUI _txtPower;
    [SerializeField, TabGroup("Equipment")] private TextMeshProUGUI _txtHp;
    [SerializeField, TabGroup("Equipment")] private TextMeshProUGUI _txtAttack;
    [SerializeField, TabGroup("Equipment")] private TextMeshProUGUI _txtDefense;
    
    [SerializeField, TabGroup("Pets")] private UIElementContainer<ItemCellBehaviourWrapperElement> _petElements = new();

    protected override void Awake()
    {
        base.Awake();

        _btnChangeNickname.SetOnClick(() =>
        {
            GameManager.Get().ShowPopup<Popup_Profile_ChangeNickname>();
        });

        _btnCopyUID.SetOnClick(() =>
        {
            GUIUtility.systemCopyBuffer = _playerInfo.Player.Id.ToString();
            "Popup_Profile_CopyUID_Success".ToToast();
        });
    }

    public override bool contentsActiveManually => true;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0 && long.TryParse(tokens[0], out var id))
        {
            Initialize(id).Forget();
        }
    }

    protected override void RefreshByFlag()
    {
        
    }

    private PlayerInfoMessage _playerInfo = null;
    private bool IsMyPlayerInfo => _playerInfo!.Player.Id == MyPlayer.Player.Id;
    
    public async UniTask Initialize(long playerId)
    {
        SetContentActive(false);

        var response = await SendPacket<GetPlayerInfoRequest.Types.Response>(Packet.Pop(0, new GetPlayerInfoRequest { PlayerId = MyPlayer.Player.Id == playerId ? 0L : playerId }), this.GetCancellationTokenOnDestroy(), withLoading: true);

        if (!response.Status.IsSuccess() || !this)
            return;

        _playerInfo = response.PlayerInfo;
        
        Refresh();
        
        SetContentActive(true);
    }

    public override void Refresh()
    {
        base.Refresh();

        if (_playerInfo == null)
            return;

        RefreshProfile();
        RefreshEquipment();
        RefreshPet();
        RefreshVisibility();
    }
    
    private void RefreshProfile()
    {
        _profileCell.Refresh(_playerInfo.Player);
        _txtNickname.text = _playerInfo.Player.Name;
        _txtUID.text = _playerInfo.Player.Id.ToString();
        _txtHighestChapter.text = ResourceMap.Get(_playerInfo.HighestChapter)?.ClientName ?? "Popup_Profile_HasNotClearedAnyChapter".L();
    }

    private static UnitStat _unitStat = new();
    private void RefreshEquipment()
    {
        foreach (var (partType, element) in cellsByPartType)
        {
            var slot = PlayerAvatar.ToEquipmentSlot(partType);
            if (partType == ResourceItem.Types.Type.Ring)
                slot = PlayerAvatar.EquipmentSlot.Ring1;

            var item = _playerInfo.Avatar.Equipments.GetSafe(slot);
            var cell = element.Get<PlacedItemCell>();
            cell.Refresh(item);
            cell.btnCell.interactable = item != null;
        }
        
        _unitUIRenderer.Initialize(ResourceItem.Get(_playerInfo.Avatar.Character.ItemDataId));
        _txtPower.text = _playerInfo.Player.Power.ToPowerString();
        
        _unitStat.Clear(_playerInfo.Stat);
        
        _txtHp.text = CRC.Get().statInfo[UnitStatType.Hp].Format((double)_unitStat.MaxHp);
        _txtAttack.text = CRC.Get().statInfo[UnitStatType.Attack].Format((double)_unitStat.Attack);
        _txtDefense.text = CRC.Get().statInfo[UnitStatType.Defense].Format((double)_unitStat.Defense);
    }

    private void RefreshPet()
    {
        foreach (var (element, i, pet) in _petElements.GetElements(_playerInfo.Avatar.Pets))
        {
            element.Get<PetCell>().Refresh(pet);
        }
    }

    private void RefreshVisibility()
    {
        _btnChangeNickname.SetActive(IsMyPlayerInfo);
    }
    
}
