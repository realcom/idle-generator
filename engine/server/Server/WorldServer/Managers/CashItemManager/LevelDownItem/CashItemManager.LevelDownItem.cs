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
    public StatusCode LevelDownItem(PlayerItemModel item, int count = 1,  IList<AddedItemStuff>? addedItemStuffs = null)
    {
        var resItem = item.Data;
        var materialItemGroups = new List<MaterialItemGroup>();
        for (; item.level > 1 && count > 0; count--, item.level--)
        {
            var index = item.level - 1;
            //TODO: Only ShouldAllValid items can be used for level down (temporary). 추후 레벨업 재료를 담아두는 구조 필요.
            materialItemGroups.AddRange(resItem.LevelUpMaterialItemGroups.Where(aig => aig.ShouldAllValid && aig.Level == index));
        }
        
        foreach (var group in materialItemGroups)
        {
            foreach (var materialItem in group.MaterialItems)
            {
                AddItem(materialItem.Id, materialItem.Count, addedItemStuffs: addedItemStuffs);
            }
        }
        
        Player.PublishEvent(new ItemLevelDownEvent
        {
            Item = item,
        });

        return StatusCode.Ok;
    }
} 