using Commons.Game.Actions;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private StatusCode UseItemSkill(PlayerItemModel item, int count = 1, long targetItemId = 0L,
        int slot = 0, int param1 = 0, int param2 = 0, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (count != 1)
            return StatusCode.BadRequest;
        
        var status = CanRemoveItem(item, count);
        if (!status.IsSuccess())
            return status;

        if (Player.Board == null)
            return StatusCode.BoardNotJoined;
        
        var resItem = item.Data;
        switch (resItem.Type)
        {
            case ResourceItem.Types.Type.PlayerUnitActiveSkill:
            {
                var skillCount = Math.Max(1, Player.Board.ResMap.PlayerUnitCount);
                Player.BoardPlayerSkillCount[resItem.SkillDataId] =
                    Player.BoardPlayerSkillCount.GetValueOrDefault(resItem.SkillDataId) + skillCount;
                break;
            }
        }

        if (status.IsSuccess())
            RemoveItem(item, count, false);
        
        return StatusCode.Ok;
    }
}
