using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Types.Players;
using TMPro;
using UnityEngine;

public class Popup_WeaponFloatingDropdown : Popup_FloatingUIBase<Popup_WeaponFloatingDropdown>
{
    [SerializeField] private CustomButton btnWeaponInfo;
    
    [SerializeField] private CustomButton btnSell;
    [SerializeField] private TextMeshProUGUI txtSellPrice;
    
    [SerializeField] private CustomButton btnUseConsumable;

    private PlayerItemMessage _item = null;
    
    public static Popup_WeaponFloatingDropdown Show(PlayerItemMessage item, Vector2? screenPoint = null)
    {
        if (item == null)
            return null;

        var popup = ShowInternal(screenPoint);
        popup.Init(item);
        
        return popup;
    }
    
    private void Init(PlayerItemMessage item)
    {
        if (item == null)
            return;
        
        _item = item;
        var resItem = _item.GetData()!;

        var isConsumable = resItem.ContainsTag(Tag.Consumable);
        
        btnSell.gameObject.SetActive(!isConsumable);
        btnUseConsumable.gameObject.SetActive(isConsumable);
        btnWeaponInfo.SetActive(!resItem.ContainsTag(Tag.InventoryExpand));

        txtSellPrice.text = ResourceItem.Get(ResourceItem.Global.DataId.Gold)!.ClientSpriteIconString + resItem.SellPrice.ToUnitString();
    }
    
    protected override void RefreshByFlag()
    {
        
    }

    protected override void Clear()
    {
        
    }

    public void ShowWeaponInfo()
    {
        GameManager.Get().ShowPopup<Popup_WeaponInfo>().Initialize(_item.GetData());
        OnCancel();
    }

    public void Sell()
    {
        GameBoardManager.Get().GetModeManager<ZModeManagerBattle>().mergeBoard.SellItem(_item);
        OnCancel();
    }

}
