using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Events;
using Server.Models;
using Server.Stuffs;

// ReSharper disable once CheckNamespace
namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private void AddItemPostProcessGamePass(PlayerItemModel item, long count = 1, int level = 0, TimeSpan? duration = null,
        IList<PlayerItemModel>? addedItems = null, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        //각 패스 지급하는 업적등 데이터 구조에서 해당 업적들 오픈 관리
        //var achievementDataIds = item.Data.TargetAchievementDataIds;
        //foreach (var achievementDataId in achievementDataIds)
        //{
        //    Player.AchievementManager.OpenAchievement(achievementDataId, addedItemStuffs);
        //}
    }
}