using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;
using Server.Stuffs;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private async Task HandleReceipts()
    {
        var appliedReceiptIds = new List<long>();
        foreach (var receipt in await PlayerReceiptModel.GetAllPaidUnappliedByPlayerIdAsync(Id).ConfigureAwait(false))
        {
            var resProductItem = ResourceItem.Get(receipt.product_item_data_id);
            if (resProductItem == null)
            {
                Logger.Error($"{this} receipt {receipt.id} references missing product item {receipt.product_item_data_id}");
                continue;
            }

            var addedItemStuffs = new List<AddedItemStuff>();
            CashItemManager.ProcessBuyItem(resProductItem, 1, out var multiplier, addedItemStuffs: addedItemStuffs);
            SendAcquiredItemsUpdate(
                addedItemStuffs.ToPlayerItemMessages(),
                PlayerAcquiredItemsUpdate.Types.Type.BuyProduct, productItemDataId: resProductItem.Id,
                handleUpdateAction: update => { update.Multiplier = multiplier; });
            appliedReceiptIds.Add(receipt.id);
            
            var productName = GetString(ResourceString.Types.Category.Item, resProductItem.Id, "Name");
            Logger.Info($"{this} applied receipt {receipt.id} for {productName} / {resProductItem.PriceUsd} USD / {receipt.price} {receipt.currency}");
        }
        
        if (appliedReceiptIds.Count > 0)
            QueueSave((db, transaction) => PlayerReceiptModel.ApplyByIdsAsync(db, transaction, appliedReceiptIds));
    }
}
