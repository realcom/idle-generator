using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Types;
using Components.UI.Toggle;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class PremiumLandingBanner : MonoBehaviour
{
    [SerializeField] private CustomButton btnLandingPremium;
    
    [SerializeField] private Image imgBanner;
    [SerializeField] private TextMeshProUGUI txtName;
    [SerializeField] private TextMeshProUGUI txtDesc;

    [SerializeField] private CustomToggle togglePremiumActivated;

    public void Refresh(int itemDataId)
    {
        if (itemDataId == 0)
        {
            gameObject.SetActive(false);
            return;
        }
        
        Refresh(ResourceItem.Get(itemDataId));
    }
    
    public void Refresh(ResourceItem resPremiumProduct)
    {
        if (resPremiumProduct == null)
        {
            gameObject.SetActive(false);
            return;
        }

        gameObject.SetActive(true);

        imgBanner.sprite = resPremiumProduct.GetSpriteByKey("LandingBanner");
        txtName.text = resPremiumProduct.GetLocalizedString("LandingName");
        txtDesc.text = resPremiumProduct.GetLocalizedString("LandingDesc");

        togglePremiumActivated.isOn = MyPlayer.GetItemByDataID(resPremiumProduct.AddItemGroups.GetAddItem()!.ItemDataId, checkCount: true) != null;


        btnLandingPremium.SetOnClick(() =>
        {
            GameManager.Get().ShowPopup<Popup_Premium>().SetLandingTargetProductItemDataId(resPremiumProduct.Id);
        });
    }

}
