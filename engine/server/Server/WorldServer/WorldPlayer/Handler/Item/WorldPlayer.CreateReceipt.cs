using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Server.Managers;
using Server.Models;
using Telegram.Bot;
using Telegram.Bot.Types.Payments;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, CreateReceiptRequest request)
    {
        var response = new CreateReceiptRequest.Types.Response();

        var resProductItem = ResourceItem.Get(request.ProductItemDataId)!;
        response.Status = CashItemManager.ValidationAchievements(resProductItem, StatusCode.ItemNotBuyable);

        PlayerReceiptModel? receipt = null;
        if (response.Status.IsSuccess())
        {
            var onProgressReceipt = await PlayerReceiptModel.GetOnProgressAsync(Id, resProductItem.Id).ConfigureAwait(false);
            switch (request.Currency)
            {
                case "USD":
                {
                    if (resProductItem.PriceUsd == 0)
                    {
                        response.Status = StatusCode.ItemNotBuyable;
                        break;
                    }

                    if (onProgressReceipt != null)
                    {
                        // response. = onProgressReceipt.telegram_invoice_link;
                        receipt = onProgressReceipt;
                        break;
                    }

                    var receiptUuid = Guid.NewGuid();
                    var productName = GetString(ResourceString.Types.Category.Item, resProductItem.Id, "Name");

                    receipt = await new PlayerReceiptModel
                    {
                        uuid = receiptUuid,
                        player_id = Id,
                        product_item_data_id = resProductItem.Id,
                        valid_until = DateTime.UtcNow.AddSeconds(PlayerReceiptModel.ReceiptValiditySeconds),

                        price = resProductItem.PriceUsd,
                        currency = request.Currency,
                    }.SaveAsync().ConfigureAwait(false);

                    break;
                }
                case "XTR":
                {
                    if (resProductItem.PriceXtr == 0)
                    {
                        response.Status = StatusCode.ItemNotBuyable;
                        break;
                    }

                    if (onProgressReceipt != null)
                    {
                        response.TelegramInvoiceLink = onProgressReceipt.telegram_invoice_link;
                        receipt = onProgressReceipt;
                        break;
                    }

                    var receiptUuid = Guid.NewGuid();
                    var productName = GetString(ResourceString.Types.Category.Item, resProductItem.Id, "Name");

                    var telegramBotClient = new TelegramBotClient(Config.Telegram.BotToken!);
                    var invoiceLink = await telegramBotClient.CreateInvoiceLinkAsync(
                        title: productName,
                        description: productName,
                        payload: receiptUuid.ToString(),
                        providerToken: "",
                        currency: "XTR",
                        prices: new[] { new LabeledPrice("Price", resProductItem.PriceXtr) }
                    ).ConfigureAwait(false);
                    if (string.IsNullOrEmpty(invoiceLink))
                    {
                        response.Status = StatusCode.ServerMaintenance;
                        break;
                    }

                    receipt = await new PlayerReceiptModel
                    {
                        uuid = receiptUuid,
                        player_id = Id,
                        product_item_data_id = resProductItem.Id,
                        valid_until = DateTime.UtcNow.AddSeconds(PlayerReceiptModel.ReceiptValiditySeconds),

                        price = resProductItem.PriceXtr,
                        currency = request.Currency,

                        telegram_invoice_link = invoiceLink,
                    }.SaveAsync().ConfigureAwait(false);
                    response.TelegramInvoiceLink = invoiceLink;

                    break;
                }
                case "TON":
                {
                    // price is not updated
                    if (CoinPriceManager.TonUsdtPrice == null || CoinPriceManager.TonUsdtPrice == 0)
                    {
                        response.Status = StatusCode.ItemNotBuyable;
                        break;
                    }

                    if (onProgressReceipt != null)
                    {
                        response.TonPayload = onProgressReceipt.uuid.ToString();
                        response.TonAddress = Config.Ton.TonAddress;
                        response.TonPrice = (long)onProgressReceipt.price;
                        receipt = onProgressReceipt;
                        break;
                    }

                    var receiptUuid = Guid.NewGuid();
                    var productName = GetString(ResourceString.Types.Category.Item, resProductItem.Id, "Name");
                    var priceTon = (float)(resProductItem.PriceUsd / CoinPriceManager.TonUsdtPrice.Value * 1000000000);

                    receipt = await new PlayerReceiptModel
                    {
                        uuid = receiptUuid,
                        player_id = Id,
                        product_item_data_id = resProductItem.Id,
                        valid_until = DateTime.UtcNow.AddSeconds(PlayerReceiptModel.ReceiptValiditySeconds),

                        price = priceTon,
                        currency = request.Currency,
                    }.SaveAsync().ConfigureAwait(false);
                    response.TonPayload = receiptUuid.ToString();
                    response.TonAddress = Config.Ton.TonAddress;
                    response.TonPrice = (long)priceTon;

                    break;
                }
                default:
                {
                    response.Status = StatusCode.BadRequest;
                    break;
                }
            }
        }

        response.Message = GetString(response.Status);
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        if (response.Status.IsSuccess())
        {
            _lastCreateReceiptAt = DateTime.UtcNow;
            PlayerLogManager.Queue(PlayerLogModel.Type.CreateReceipt, new
            {
                Request = request,
                Response = response,
                Receipt = receipt,
            });
        }
        
        return true;
    }
}
