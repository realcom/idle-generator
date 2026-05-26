using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using Components.UI.Toggle;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class Popup_TimeLimitedProductEquipment : Popup_TimeLimitedProduct
{
    [SerializeField]
    protected Image m_ProductImage;
    public override void Initialize(ResourceItem productItem)
    {
        base.Initialize(productItem);
        var productItemDataId = resProductItem.ProductItemDataId;
        var resProduct = ResourceItem.Get(productItemDataId)!;
        m_ProductImage.sprite = resProduct.ClientSpriteIcon;
    }
}
