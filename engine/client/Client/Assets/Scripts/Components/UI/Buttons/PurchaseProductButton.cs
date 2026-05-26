using System;
using System.Collections;
using System.Collections.Generic;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Components;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class PurchaseProductButton : CustomButton
{
    [SerializeField] private RedDot redDot;
    [SerializeField] private Image imgButtonFrame;
    
    protected override void Awake()
    {
        base.Awake();
        
        onClick.RemoveAllListeners();
        onClick.AddListener(() => PurchaseProduct().Forget());
    }

    public sealed override CustomButton SetOnClick(UnityAction action)
    {
        return this;
    }
    
    private Action onPurchaseSuccess = null;
    private Action onPurchaseFailed = null;
    
    public void SetPurchaseCallback(Action onSuccess, Action onFailed = null)
    {
        onPurchaseSuccess = onSuccess;
        onPurchaseFailed = onFailed;
    }
    
    private Action<StatusCode, IList<PlayerItemMessage>> onPurchaseDetailedCallback = null;
    public void SetPurchaseDetailedCallback(Action<StatusCode, IList<PlayerItemMessage>> callback)
    {
        onPurchaseDetailedCallback = callback;
    }

    private Func<UniTask<bool>> _prePurchaseTask = null;
    public void SetPrePurchaseTask(Func<UniTask<bool>> prePurchaseTask)
    {
        _prePurchaseTask = prePurchaseTask;
    }
    
    private Action _overrideBuyAction = null;
    public void SetOverrideBuyAction(Action overrideBuyAction)
    {
        _overrideBuyAction = overrideBuyAction;
    }

    public event Action onStartPurchaseProcess = null;

    private ResourceItem m_Product = null;
    private int m_PurchaseUnit = 1;

    public void SetProduct(ResourceItem product)
    {
        if (product == null)
            return;

        if (product.Category != ResourceItem.Types.Category.Product)
        {
            Debug.LogError($"Invalid product item category itemDataId: {product.Id}, category: {product.Category}");
            return;
        }

        if (redDot)
            redDot.Register(product);

        if (imgButtonFrame)
            imgButtonFrame.sprite = product.GetSpriteByKey("ButtonFrame");
        
        m_Product = product;
        m_PurchaseUnit = product.GetPurchaseUnit();

        Refresh();
    }

    public void Refresh()
    {
        if (m_Product == null)
            return;

        using var _ = GetInteractor();
    }

    public ButtonInteractor GetInteractor()
    {
        var interactor = new ButtonInteractor(this);
        var purchasableAt = MyPlayer.GetItemByDataID(m_Product.Id)?.Option?.ProductOption?.ReprocessableAt.ToOffsetSeconds() ?? 0;
        interactor.Update(TimeSystem.offsetTime >= purchasableAt, "PurchasableTimeNotYet".L());
        var productMaterial = m_Product.GetProductMaterial();
        interactor.Update(MyPlayer.HasEnoughMaterial(productMaterial, m_PurchaseUnit), () => { productMaterial?.ShowAcquisitionablePopup(); });
        interactor.Update(m_Product.CheckExclusiveAchievements(out var exclusiveAchievementMessage), exclusiveAchievementMessage);
        interactor.Update(m_Product.CheckRequiredAchievements(out var requiredAchievementMessage), requiredAchievementMessage);
        
        return interactor;
    }

    protected virtual async UniTask PurchaseProduct()
    {
        if (m_Product == null)
            return;

        if (_prePurchaseTask != null)
        {
            var result = await _prePurchaseTask();
            if (!result)
                return;
        }

        switch (m_Product.Type)
        {
            case ResourceItem.Types.Type.MaterialRealPrice:
            {
                onStartPurchaseProcess?.Invoke();
                PurchaseManager.Get().RequestPurchase(m_Product, (statusCode, items) =>
                {
                    if (statusCode.IsSuccess())
                    {
                        onPurchaseSuccess?.Invoke();
                        onPurchaseSuccess = null;
                    }
                    else
                    {
                        onPurchaseFailed?.Invoke();
                        onPurchaseFailed = null;
                    }
                
                    onPurchaseDetailedCallback?.Invoke(statusCode, items);
                });
                break;
            }
            case ResourceItem.Types.Type.MaterialAd:
            {
                onStartPurchaseProcess?.Invoke();
                AdManager.Instance.ShowRewardedAd(m_Product.Id, m_Product.ClientName,  BuyItemInternal, () =>
                {
                    onPurchaseFailed?.Invoke();
                    onPurchaseFailed = null;
                    onPurchaseDetailedCallback?.Invoke(StatusCode.BadRequest, ArraySegment<PlayerItemMessage>.Empty);
                    onPurchaseDetailedCallback = null;
                });
                break;
            }
            default:
            {
                onStartPurchaseProcess?.Invoke();
                BuyItemInternal();
                break;
            }
        }
    }

    private void BuyItemInternal()
    {
        if (_overrideBuyAction != null)
        {
            _overrideBuyAction.Invoke();
            return;
        }
        
        RequestBuyItem().Forget();
    }

    private async UniTask RequestBuyItem()
    {
        var response = await ZWorldClient.Get().SendPacket<BuyItemRequest.Types.Response>(Packet.Pop(0, new BuyItemRequest { ProductItemDataId = m_Product.Id, Count = m_PurchaseUnit }), this.GetCancellationTokenOnDestroy());
        if (!response.Status.IsSuccess())
        {
            onPurchaseFailed?.Invoke();
            onPurchaseFailed = null;
            onPurchaseDetailedCallback?.Invoke(response.Status, response.Items);
            onPurchaseDetailedCallback = null;
            return;
        }
        
        onPurchaseSuccess?.Invoke();
        onPurchaseSuccess = null;
        onPurchaseDetailedCallback?.Invoke(response.Status, response.Items);
        onPurchaseDetailedCallback = null;
    }

}
