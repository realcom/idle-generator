using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Server.Events;
using Server.Models;
using Server.Utility;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode LevelUpItem(PlayerItemModel item, IList<PlayerItemMessage> consumedItemMessages, int count = 1, List<PlayerItemModel>? selectedMaterialItems = null)
    {
        var resItem = item.Data;
        var materialItemGroups = new List<MaterialItemGroup>();
        for (var i = 0; i < count; ++i)
        {
            var capturedI = i;
            materialItemGroups.AddRange(resItem.LevelUpMaterialItemGroups.Where(aig => aig.Level == item.level + capturedI));
        }

        if (materialItemGroups.Count == 0)
            return StatusCode.BadRequest;

        var result = TryConsumeMaterials(out var selectedMaterialItemModels, materialItemGroups, selectedMaterialItems);
        if (!result.IsSuccess())
            return result;
        
        foreach (var (materialItemModel, materialItemCount) in selectedMaterialItemModels)
        {
            RemoveItem(materialItemModel, materialItemCount, checkCanRemove: false);
            
            var itemMessage = materialItemModel.ToMessage();
            itemMessage.Count = materialItemCount;
            consumedItemMessages.Add(itemMessage);
        }
        
        item.level += count;
        
        Player.PublishEvent(new ItemLevelUpEvent
        {
            Item = item,
            Count = count,
        });

        return StatusCode.Ok;
    }
}
