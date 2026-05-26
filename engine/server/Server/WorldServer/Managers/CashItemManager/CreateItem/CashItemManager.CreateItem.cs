using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Server.Events;
using Server.Models;
using Server.Stuffs;
using Server.Utility;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode CreateItem(int recipeItemDataId, IList<PlayerItemMessage> consumedItemMessages, int count,
        List<PlayerItemModel>? selectedMaterialItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resRecipeItem = ResourceItem.Get(recipeItemDataId);
        if (resRecipeItem?.Category != ResourceItem.Types.Category.Recipe)
            return StatusCode.BadRequest;

        return CreateItem(resRecipeItem, consumedItemMessages, count, selectedMaterialItems, addedItemStuffs);
    }
    
    public StatusCode CreateItems(IEnumerable<int> recipeItemDataIds, IList<PlayerItemMessage> consumedItemMessages, int count = 1,
        List<PlayerItemModel>? selectedMaterialItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        foreach (var recipeItemDataId in recipeItemDataIds)
        {
            var statusCode = CreateItem(recipeItemDataId, consumedItemMessages, count, selectedMaterialItems, addedItemStuffs);
            if (!statusCode.IsSuccess())
                Player.SendDisplayMessageUpdate(message: Player.GetString(statusCode));
        }

        return StatusCode.Ok;
    }
    
    public StatusCode CreateItem(ResourceItem resRecipeItem, IList<PlayerItemMessage> consumedItemMessages, int count = 1,
        List<PlayerItemModel>? selectedMaterialItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var status = ValidationAchievements(resRecipeItem, StatusCode.ItemNotCreatable);
        if (!status.IsSuccess())
            return status;
        
        status = TryConsumeMaterials(out var selectedMaterialItemModels, resRecipeItem.MaterialItemGroups, selectedMaterialItems, count);
        if (!status.IsSuccess())
            return status;
        
        foreach (var (materialItemModel, materialItemCount) in selectedMaterialItemModels)
        {
            RemoveItem(materialItemModel, materialItemCount, checkCanRemove: false);
            
            var itemMessage = materialItemModel.ToMessage();
            itemMessage.Count = materialItemCount;
            consumedItemMessages.Add(itemMessage);
        }

        AddItem(resRecipeItem.AddItemGroups, count, addedItemStuffs: addedItemStuffs);
        
        Player.PublishEvent(new ItemCreateEvent
        {
            ResRecipeItem = resRecipeItem,
            Count = count,
        });

        return StatusCode.Ok;
    }
}
