using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Utility.ObjectPool;
using Components;
using Sirenix.Utilities;
using UnityEngine;
using ZLinq;

public class Popup_Rebirth : UIPopup
{
    [SerializeField] private TextTimer m_RemainTimer;
    
    [SerializeField] private UIElementContainer<PurchaseProductCell> m_Products = new();

    private ResourceItem m_purchaseItem;
    protected override void Start()
    {
        base.Start();
        m_RemainTimer.targetTimeAt = TimeSystem.time + CRC.Get().globalParameters.rebirthValidDuration;
        m_RemainTimer.SetExpiredCallback(GiveUp);

        var rebirthProductItem = ResourceItem.GetAllByTag(Tag.ProductRespawn).FirstOrDefault(x => x.IsValid && x.IsValidByRequiredAndExclusive());
        if (rebirthProductItem == null)
        {
            GiveUp();
            return;
        }

        var hasNoExpiration = false;
        foreach (var (element, i, product) in m_Products.GetElements(ResourceItem.GetAllByParentId(rebirthProductItem.Id).AsValueEnumerable()
                     .Where(x => x.CanDisplay && x.Category == ResourceItem.Types.Category.Product && x.IsValidByRequiredAndExclusive())
                     .ToArrayPool().ArraySegment))
        {
            element.Refresh(product);
            element.btnPurchaseProduct.SetPurchaseCallback(OnRespawn, GiveUp);
            element.btnPurchaseProduct.onStartPurchaseProcess += () => { m_RemainTimer.Stop(); };

            if (!hasNoExpiration && product.ContainsTag(Tag.NoExpiration))
                hasNoExpiration = true;
        }

        if (hasNoExpiration)
        {
            m_RemainTimer.Stop();
            m_RemainTimer.transform.parent.SetActive(false);
        }

        GameBoardManager.Get()?.PauseBoard(nameof(Popup_Rebirth));
    }

    public void GiveUp()
    {
        GameBoardManager.Get().GetModeManager<ZModeManagerBattle>()?.ShowGameFailure();
        OnCancel();
    }
    
    public void OnRespawn()
    {
        m_RemainTimer.Stop();
        
        GameBoardManager.Get()?.Run(() =>
        {
            GameBoardManager.Get()?.UseSkill(ResourceSkill.Global.DataId.PlayerRespawn);
        }, 0.5f);
        OnCancel();
    }
    
    protected override void RefreshByFlag()
    {
        
    }

    public override void OnCancel()
    {
        base.OnCancel();
        GameBoardManager.Get()?.ResumeBoard(nameof(Popup_Rebirth));        
    }
}
