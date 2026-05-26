using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Net.Http.Json;
using System.Security.Cryptography;
using System.Text;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Google.Apis.AndroidPublisher.v3;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Security;
using Server.Managers;
using Server.Models;
using Server.Stuffs;
using Telegram.Bot;
using Telegram.Bot.Types.Payments;
using ECCurve = Org.BouncyCastle.Math.EC.ECCurve;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, VerifyReceiptRequest request)
    {
        var response = new VerifyReceiptRequest.Types.Response
        {
            Status = StatusCode.Ok
        };

        var resProductItem = ResourceItem.Get(request.ProductItemDataId);
        if (resProductItem == null)
        {
            response.Status = StatusCode.ItemNotFound;
            var itemNotFoundPacket = Packet.Pop(GetNextPacketKey(), response, requestId);
            SendPacket(itemNotFoundPacket);
            return true;
        }

        var onProgressReceipt = await PlayerReceiptModel.GetOnProgressAsync(Id, resProductItem.Id).ConfigureAwait(false);
        if (onProgressReceipt == null)
        {
            response.Status = StatusCode.BadRequest;
            var invalidReceiptPacket = Packet.Pop(GetNextPacketKey(), response, requestId);
            SendPacket(invalidReceiptPacket);
            return true;
        }

        try
        {
            if (Config.IsDebug)
            {
                await UpdateReceipt(onProgressReceipt, null, $"debug-{onProgressReceipt.uuid}", request.Receipt)
                    .ConfigureAwait(false);
                response.Status = StatusCode.Ok;
            }
            else
            {
                response.Status = await VerifyStoreReceipt(request, resProductItem, onProgressReceipt).ConfigureAwait(false);
            }

            if (response.Status == StatusCode.Ok)
            {
                await HandleReceipts().ConfigureAwait(false);
                IsSavePending = true;
                await SaveAsync().ConfigureAwait(false);
            }
        }
        catch (Exception ex)
        {
            Logger.Error($"{this} VerifyReceipt failed", ex);
            response.Status = StatusCode.BadRequest;
        }
            
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        return true;
    }

    private async Task<StatusCode> VerifyStoreReceipt(VerifyReceiptRequest request, ResourceItem expectedProductItem,
        PlayerReceiptModel receiptModel)
    {
        Logger.Info($"player: {Id} {Name} receipt: {request.Receipt}");

        JObject receiptData;
        try
        {
            receiptData = JObject.Parse(request.Receipt);
        }
        catch (Exception ex)
        {
            Logger.Warn("Receipt payload is not valid JSON", ex);
            return StatusCode.BadRequest;
        }

        return request.Store switch
        {
            StoreType.Google => await VerifyGoogleReceipt(receiptData, request.Receipt, expectedProductItem, receiptModel)
                .ConfigureAwait(false),
            StoreType.Apple => await VerifyAppleStoreReceipt(receiptData, request.Receipt, expectedProductItem, receiptModel)
                .ConfigureAwait(false),
            _ => StatusCode.BadRequest
        };
    }

    private async Task<StatusCode> VerifyGoogleReceipt(JObject receiptData, string receipt,
        ResourceItem expectedProductItem, PlayerReceiptModel receiptModel)
    {
        var payloadText = receiptData["Payload"]?.Value<string>();
        if (string.IsNullOrWhiteSpace(payloadText))
            return StatusCode.BadRequest;

        JObject payload;
        JObject payloadJson;
        try
        {
            payload = JObject.Parse(payloadText);
            payloadJson = JObject.Parse(payload["json"]?.Value<string>() ?? "");
        }
        catch (Exception ex)
        {
            Logger.Warn("Google receipt payload is malformed", ex);
            return StatusCode.BadRequest;
        }

        var productId = payloadJson["productId"]?.Value<string>();
        var purchaseToken = payloadJson["purchaseToken"]?.Value<string>();
        if (string.IsNullOrWhiteSpace(productId) || string.IsNullOrWhiteSpace(purchaseToken))
            return StatusCode.BadRequest;

        var verifiedProductItem = ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Product)
            .FirstOrDefault(e => e.IapIdentifier == productId);
        if (verifiedProductItem == null)
        {
            Logger.Error($"Product item not found for IAP identifier {productId}");
            return StatusCode.ItemNotFound;
        }

        if (verifiedProductItem.Id != expectedProductItem.Id)
        {
            Logger.Warn($"Requested product {expectedProductItem.Id} does not match verified IAP {verifiedProductItem.Id}");
            return StatusCode.BadRequest;
        }

        var orderId = payloadJson["orderId"]?.Value<string>();
        if (string.IsNullOrWhiteSpace(orderId))
            orderId = receiptData["TransactionID"]?.Value<string>();

        var isCompleted = await VerifyWithGooglePlay(productId, purchaseToken).ConfigureAwait(false);
        if (!isCompleted)
        {
            Logger.Warn("Verify google failed");
            Logger.Info(payloadJson.ToString());
            return StatusCode.BadRequest;
        }

        Logger.Info($"android purchased: {orderId} / {verifiedProductItem.Name}");
        await UpdateReceipt(receiptModel, purchaseToken, orderId, receipt).ConfigureAwait(false);
        return StatusCode.Ok;
    }

    private async Task<StatusCode> VerifyAppleStoreReceipt(JObject receiptData, string receipt,
        ResourceItem expectedProductItem, PlayerReceiptModel receiptModel)
    {
        var payload = receiptData["Payload"]?.Value<string>();
        if (string.IsNullOrWhiteSpace(payload))
            return StatusCode.BadRequest;

        AppleReceiptData iosPurchase;
        try
        {
            iosPurchase = await VerifyAppleReceiptAsync(payload).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Warn("VerifyAppleReceiptAsync failed", ex);
            return StatusCode.BadRequest;
        }

        if (iosPurchase.status != 0 || iosPurchase.receipt?.in_app == null || iosPurchase.receipt.in_app.Length == 0)
        {
            Logger.Error("Verification failed! (in_app is empty or status is not success)");
            return StatusCode.BadRequest;
        }

        Logger.Info($"ios purchased (total {iosPurchase.receipt.in_app.Length})");
        foreach (var inAppData in iosPurchase.receipt.in_app)
        {
            if (string.IsNullOrWhiteSpace(inAppData.transaction_id) || string.IsNullOrWhiteSpace(inAppData.product_id))
                continue;

            var prevReceipt = await PlayerReceiptModel.GetByOrderIdAsync(inAppData.transaction_id).ConfigureAwait(false);
            if (prevReceipt is { applied: true, paid: true })
            {
                Logger.Info($"already applied ${inAppData.transaction_id}");
                continue;
            }

            var verifiedProductItem = ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Product)
                .FirstOrDefault(e => e.IapIdentifier == inAppData.product_id);
            if (verifiedProductItem == null)
            {
                Logger.Error($"Product item not found for IAP identifier {inAppData.product_id}");
                continue;
            }

            if (verifiedProductItem.Id != expectedProductItem.Id)
                continue;

            Logger.Info($"ios purchased: {inAppData.transaction_id} / {verifiedProductItem.Name}");
            await UpdateReceipt(receiptModel, null, inAppData.transaction_id, receipt).ConfigureAwait(false);
            return StatusCode.Ok;
        }

        return StatusCode.BadRequest;
    }

    private async Task UpdateReceipt(PlayerReceiptModel receiptModel, string? purchaseToken, string? orderId, string receipt)
    {
        receiptModel.paid = true;
        receiptModel.applied = false;
        receiptModel.purchase_token = purchaseToken ?? "";
        receiptModel.data = receipt;
        if (!string.IsNullOrWhiteSpace(orderId))
            receiptModel.order_id = orderId;
        await receiptModel.SaveAsync().ConfigureAwait(false);
    }

    #region 결제 관련 검증 로직들 
    
        
    private async Task<bool> VerifyWithGooglePlay(string productId, string purchaseToken)
    {
        // 1. 인증
        GoogleCredential credential = await GoogleCredential
            .FromFileAsync(Config.Path.GoogleServiceAccountForBillingCredential, CancellationToken.None);
        credential = credential.CreateScoped(AndroidPublisherService.Scope.Androidpublisher);

        // 2. AndroidPublisherService 초기화
        var service = new AndroidPublisherService(new BaseClientService.Initializer
        {
            HttpClientInitializer = credential
        });

        // 3. 검증 요청
        var purchase = await service.Purchases.Products
            .Get("com.puzzlemonsters.backpack", productId, purchaseToken)
            .ExecuteAsync();

        Console.WriteLine("Google response: " + JsonConvert.SerializeObject(purchase));

        // 4. 상태 확인
        // purchaseState: 0 = Purchased, 1 = Canceled, 2 = Pending
        return purchase.PurchaseState == 0;
    }

        class GoogleSignatureVerify
        {
            RSAParameters _rsaKeyInfo;

            public GoogleSignatureVerify(String GooglePublicKey)
            {
                var rsaParameters = (RsaKeyParameters)PublicKeyFactory.CreateKey(Convert.FromBase64String(GooglePublicKey));

                byte[] rsaExp = rsaParameters.Exponent.ToByteArray();
                byte[] Modulus = rsaParameters.Modulus.ToByteArray();

                // Microsoft RSAParameters modulo wants leading zero's removed so create new array with leading zero's removed
                int Pos = 0;
                for (int i = 0; i < Modulus.Length; i++)
                {
                    if (Modulus[i] == 0)
                        Pos++;
                    else
                        break;
                }
                byte[] rsaMod = new byte[Modulus.Length - Pos];
                Array.Copy(Modulus, Pos, rsaMod, 0, Modulus.Length - Pos);

                // Fill the Microsoft parameters
                _rsaKeyInfo = new RSAParameters()
                {
                    Exponent = rsaExp,
                    Modulus = rsaMod
                };
            }

            public bool Verify(String Message, String Signature)
            {
                using (var rsa = new RSACryptoServiceProvider())
                {
                    rsa.ImportParameters(_rsaKeyInfo);
                    return rsa.VerifyData(Encoding.ASCII.GetBytes(Message), "SHA1", Convert.FromBase64String(Signature));
                }
            }
        }

        public class AppleReceiptData
        {
            public int status { get; set; }
            public string environment { get; set; } = "";
            public AppleReceipt receipt { get; set; } = new();
        }



        public class AppleReceipt
        {
            public string receipt_type { get; set; } = "";
            public long? adam_id { get; set; }
            public long? app_item { get; set; }
            public string bundle_id { get; set; } = "";
            public string application_version { get; set; } = "";
            public long? download_id { get; set; }
            public long? version_external_identifier { get; set; }
            public string receipt_creation_date { get; set; } = "";
            public string receipt_creation_date_ms { get; set; } = "";
            public string request_date { get; set; } = "";
            public string request_date_ms { get; set; } = "";
            public string request_date_pst { get; set; } = "";
            public string original_purchase_date { get; set; } = "";
            public string original_purchase_date_ms { get; set; } = "";
            public string original_purchase_date_pst { get; set; } = "";
            public string original_application_version { get; set; } = "";
            public InAppData[] in_app { get; set; } = Array.Empty<InAppData>();
        }

        public class InAppData
        {
            public string quantity { get; set; } = "";
            public string product_id { get; set; } = "";
            public string transaction_id { get; set; } = "";
            public string original_transaction_id { get; set; } = "";
            public string purchase_date { get; set; } = "";
            public string purchase_date_ms { get; set; } = "";
            public string purchase_date_pst { get; set; } = "";
            public string original_purchase_date { get; set; } = "";
            public string original_purchase_date_ms { get; set; } = "";
            public string original_purchase_date_pst { get; set; } = "";
            public string is_trial_period { get; set; } = "";
        }

        private async Task<AppleReceiptData> VerifyAppleReceiptAsync(string receiptData, bool production = true)
        {
            try
            {
                var json = new JObject(new JProperty("receipt-data", receiptData)).ToString();
                using var client = new HttpClient();
                using var content = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await client.PostAsync(
                    production
                        ? "https://buy.itunes.apple.com/verifyReceipt"
                        : "https://sandbox.itunes.apple.com/verifyReceipt",
                    content).ConfigureAwait(false);
                var responseBody = (await response.Content.ReadAsStringAsync().ConfigureAwait(false)).Trim();

                var receipt = JsonConvert.DeserializeObject<AppleReceiptData>(responseBody) ?? new AppleReceiptData
                {
                    status = 9999
                };
                if (receipt.status != 0)
                {
                    if (receipt.status == 21007 && production)
                        return await VerifyAppleReceiptAsync(receiptData, false).ConfigureAwait(false);
                }

                return receipt;
            }
            catch (Exception ex)
            {
                Logger.Warn("", ex);
            }

            var error = new AppleReceiptData();
            error.status = 9999;
            return error;
        }
    
        #endregion
}
