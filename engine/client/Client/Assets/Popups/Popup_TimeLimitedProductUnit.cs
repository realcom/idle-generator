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

public class Popup_TimeLimitedProductUnit : Popup_TimeLimitedProduct
{
    [SerializeField]
    protected UnitUIRenderer m_UnitUIRenderer;
    public override void Initialize(ResourceItem productItem)
    {
        base.Initialize(productItem);
        var productItemDataId = resProductItem.ProductItemDataId;
        var resUnit = ResourceUnit.Get(productItemDataId);
        var animationName = resProductItem.GetLocalizedString("AnimationName", "Idle");
        m_UnitUIRenderer.Initialize(resUnit, animationName);
    }
}
