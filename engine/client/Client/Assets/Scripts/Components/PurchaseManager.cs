using SimpleJSON;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.Purchasing;
using UnityEngine.Purchasing.Extension;

public class PurchaseManager : MonoBehaviour, IDetailedStoreListener
{
    
    [Serializable]
    public class ReceiptWrapper
    {
        public string Store;
        public string TransactionID;
        public PayloadData Payload;
    }
    
    [Serializable]
    public class PayloadData
    {
        public GoogleReceiptJson json;
    }
    
    
    [Serializable]
    public class GoogleReceiptJson
    {
        public string purchaseToken;
        public string orderId;
    }
    
    
    //
    private static PurchaseManager _singleton;
    private IStoreController _storeController;
    private IExtensionProvider _storeExtensionProvider;
    public static PurchaseEventArgs lastArgs;
    public static int lastPurchaseProductDataId;
    public static PurchaseManager Get()
    {
        if (_singleton == null)
            _singleton = new GameObject("[PurchaseManager]").AddComponent<PurchaseManager>();

        return _singleton;
    }

    //
    public void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }

    private void OnDestroy()
    {
        if (_singleton == this)
            _singleton = null;
    }

    private bool _inited = false;
    private HashSet<string> _addedItems = new HashSet<string>();

    public void Init(bool forced = false)
    {
        if (_inited)
            return;
        _inited = true;

        // Create a builder, first passing in a suite of Unity provided stores.
        Debug.Log($"PurchaseManager Initialized");
        var builder = ConfigurationBuilder.Instance(StandardPurchasingModule.Instance());
        var items = ResourceItem.GetAllByType(ResourceItem.Types.Type.MaterialRealPrice)
            .Where(product =>  product.IsValid);
        foreach (var item in items)
        {
            builder.AddProduct(item.IapIdentifier, ProductType.Consumable);
        }
        
        try
        {
            UnityPurchasing.Initialize(this, builder);
        }
        catch (Exception ex)
        {
            Debug.LogWarning(ex);
        }
    }

    private Action<StatusCode, IList<PlayerItemMessage>> _callback = null;

    private void InvokeCallback(StatusCode statusCode, IList<PlayerItemMessage> list)
    {
        _callback?.Invoke(statusCode, list);
        _callback = null;
        
        GameManager.Get().HideLoading().Forget();
    }
    
    public void RequestPurchase(ResourceItem resItem, Action<StatusCode, IList<PlayerItemMessage>> callback = null)
    {
        _callback = callback;
        if (!resItem.IsValid)
        {
            InvokeCallback(StatusCode.ItemNotFound, EmptyList<PlayerItemMessage>.Get());
            return;
        }

        if (!IsValidProduct(resItem))
        {
            InvokeCallback(StatusCode.ItemNotBuyable, EmptyList<PlayerItemMessage>.Get());
            return;
        }
        
        lastPurchaseProductDataId = resItem.Id;
        RequestCreateRecept(resItem).Forget();
    }

    private async UniTask RequestCreateRecept(ResourceItem resItem)
    {
        var req = new CreateReceiptRequest { ProductItemDataId = resItem.Id, Currency = "USD" };
        var request = Packet.Pop(0, req);
        var response = await ZWorldClient.Get().SendPacket(request);

        await GameManager.Get().ShowLoading();
        
        if (response.Status.IsSuccess())
        {
#if UNITY_EDITOR
            StartCoroutine(VerifyReceiptOnServer("afbadsfwe", resItem));
#elif UNITY_IOS || UNITY_ANDROID
            _storeController.InitiatePurchase(resItem.IapIdentifier);
#endif
        }
        else
        {
            InvokeCallback(response.Status, EmptyList<PlayerItemMessage>.Get());
        }
    }
    

    public void OnInitialized(IStoreController controller, IExtensionProvider extensions)
    {
        Debug.Log("store OnInitialized: PASS");
        _storeController = controller;
        _storeExtensionProvider = extensions;
        
        
    }

    public void OnPurchaseFailed(Product product, PurchaseFailureDescription failureDescription)
    {
        OnPurchaseFailed(product, failureDescription.reason);
    }

    public void OnInitializeFailed(InitializationFailureReason error)
    {
        // Obsolete
        // Purchasing set-up has not succeeded. Check error for reason. Consider sharing this reason with the user.
        Debug.Log("OnInitializeFailed InitializationFailureReason:" + error);
    }
    
    public void OnInitializeFailed(InitializationFailureReason error, string message)
    {
        // Purchasing set-up has not succeeded. Check error for reason. Consider sharing this reason with the user.
        Debug.Log("OnInitializeFailed InitializationFailureReason:" + error);
    }

    public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs args)
    {
        string iapIdentifier = args.purchasedProduct.definition.id;
        var product = ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Product).FirstOrDefault(e => e.IapIdentifier == iapIdentifier);
        string receipt = args.purchasedProduct.receipt;
        lastArgs = args;
        
        StartCoroutine(VerifyReceiptOnServer(receipt, product));

        return PurchaseProcessingResult.Pending;
    }

    private IEnumerator VerifyReceiptOnServer(string receipt, ResourceItem resourceItem)
    {
        RequestVerifyReceipt(receipt, resourceItem).Forget();
        yield return PurchaseProcessingResult.Complete;
    }

    private async UniTask RequestVerifyReceipt(string receipt, ResourceItem resourceItem)
    {
        var product = _storeController.products.WithID(resourceItem.IapIdentifier);
        var req = new VerifyReceiptRequest { ProductItemDataId = resourceItem.Id, Currency = "USD", Receipt = receipt };
#if UNITY_EDITOR
        req.Store = StoreType.Unknown;
#elif UNITY_ANDROID
        req.Store = StoreType.Google;
#elif UNITY_IOS
        req.Store = StoreType.Apple;
#endif 
        var packet = Packet.Pop(0, req);
        var response = await ZWorldClient.Get().SendPacket<VerifyReceiptRequest.Types.Response>(packet);

        if (!response.Status.IsSuccess())
        {
            InvokeCallback(response.Status, EmptyList<PlayerItemMessage>.Get());
            return;
        }
        
        InvokeCallback(response.Status, response.Items);
#if UNITY_EDITOR

#elif UNITY_ANDROID || UNITY_IOS
        _storeController.ConfirmPendingPurchase(product);
#endif
        
    }
    
    public bool IsValidProduct(ResourceItem resourceItem)
    {
#if UNITY_EDITOR
        return true;
#endif
        if (_storeController == null)
        {
            Debug.LogError("IAP not initialized");
            return false;
        }
        var iapIdentifier= resourceItem.IapIdentifier;
        Product product = _storeController.products.WithID(iapIdentifier);
        if (product == null)
        {
            Debug.LogError($"Product {iapIdentifier} not found in configuration.");
            return false;
        }
        if (product.availableToPurchase)
            return true;
        
        Debug.LogWarning($"❌ Product {iapIdentifier} is not available to purchase (invalid or not recognized by store).");
        return false;
    }
    

    public void OnPurchaseFailed(Product product, PurchaseFailureReason failureReason)
    {
        InvokeCallback(StatusCode.BadRequest, EmptyList<PlayerItemMessage>.Get());

        GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.PURCHASE_CANCELLED));
        
        "PurchaseFailed".ToToast();
        
        PlatformManager.Get().LogEvent("purchase_failed", 
            ("ProductId", product.definition.id),
            ("PurchaseFailureReason", failureReason.ToString()),
            ("Product", product.definition.storeSpecificId), ("PurchaseFailureReason", failureReason.ToString()));
        Debug.Log(string.Format("OnPurchaseFailed: FAIL. Product: '{0}', PurchaseFailureReason: {1}",
            product.definition.storeSpecificId, failureReason));
    }

    public string GetLocalizedPriceString(ResourceItem product)
    {
#if UNITY_EDITOR
        return product.PriceDisplayUsd.ToString();
#endif
        try
        {
            var priceString = _storeController.products.WithID(product.IapIdentifier).metadata.localizedPriceString;
            if (priceString.ToLower() == "free")
                return "";    
            return priceString;
        } catch (Exception ex)
        {
            Debug.LogWarning(ex);
            return "";
        }
    }
    // 구현 필요
    public void Restore()
    {
#if UNITY_EDITOR
        Toast.Show<Popup_Toast>("Restore_Button_Clicked".L());
#elif  UNITY_ANDROID
        _storeExtensionProvider.GetExtension<IGooglePlayStoreExtensions>().RestoreTransactions(OnTransactionsRestored);
#elif UNITY_IOS
        _storeExtensionProvider.GetExtension<IAppleExtensions>().RestoreTransactions(OnTransactionsRestored);
#endif
    }

    public void OnTransactionsRestored(bool result, string errorString)
    {
        if (result)
            Toast.Show<Popup_Toast>("Restore_Succeed".L());
        else
            Toast.Show<Popup_Toast>("Restore_Failed".L() + $": {errorString}");
    }
}
