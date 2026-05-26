using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility.Protobuf;
using Google.Protobuf.WellKnownTypes;
using Newtonsoft.Json.Linq;
using Server.Models;
using Server.Stuffs;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public StatusCode ClaimDailyReward(IEnumerable<PlayerItemModel?> items, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        foreach (var item in items)
            ClaimDailyReward(item, addedItemStuffs);

        return StatusCode.Ok;
    }
    
    public StatusCode ClaimDailyReward(PlayerItemModel? item, IList<AddedItemStuff>? addedItemStuffs = null)
    {
        if (item == null)
            return StatusCode.ItemNotFound;

        if (item.count <= 0)
            return StatusCode.ItemNotFound;
        
        var nowDate = DateTime.UtcNow.Date;
        if (item.until_at != null && item.until_at.Value.Date <= nowDate)
            return StatusCode.BadRequest;
        
        using var option = item.GetOptionScope();
        option.Option.DailyRewardOption ??= new();
        var dailyRewardOption = option.Option.DailyRewardOption;
        var claimDate = dailyRewardOption.ClaimedAt?.ToDateTime().Date;
        if (claimDate == nowDate)
            return StatusCode.BadRequest;

        var passedDays = (nowDate - claimDate)?.Days ?? 1;
        if (passedDays <= 0)
            return StatusCode.BadRequest;

        var status = AddItem(item.Data.DailyRewardAddItemGroups, passedDays, addedItemStuffs: addedItemStuffs);
        if (status.IsSuccess())
        {
            dailyRewardOption.ClaimedAt ??= new Timestamp();
            dailyRewardOption.ClaimedAt.Set(nowDate);
        }
        
        return status;
    }
    
    private void RetroactiveDailyRewards(DateTime date)
    {
        date = date.Date;
        
        foreach (var item in GetItemsByTag(Tag.RetroactiveDailyReward, checkCount: true))
        {
            using var option = item.GetOptionScope();
            option.Option.DailyRewardOption ??= new();
            var dailyRewardOption = option.Option.DailyRewardOption;
            
            //아직 Claim한 적이 없는 경우 생성일 기준으로 계산
            var claimDate = dailyRewardOption.ClaimedAt?.ToDateTime().Date ?? item.created_at.Date;
            if (item.until_at != null && item.until_at.Value.Date <= claimDate)
                continue;

            var passedDays = (date - claimDate).Days - 1;
            if (item.until_at != null)
                passedDays = Math.Min(passedDays, (item.until_at.Value.Date - claimDate).Days);
            if (passedDays <= 0)
                continue;
            
            var data = item.Data;
            PlayerMailOption? mailOption = null;
            if (data.DailyRewardAddItemGroups.Count > 0)
            {
                mailOption = new PlayerMailOption();
                foreach (var addItemGroup in data.DailyRewardAddItemGroups)
                {
                    for (var i = 0; i < passedDays; i++)
                    {
                        if (addItemGroup.ShouldAddAll)
                        {
                            if (!addItemGroup.CanSampleGroup())
                                continue;

                            foreach (var addItem in addItemGroup.AddItems)
                            {
                                mailOption.AddItems.Add(addItem);
                            }
                        }
                        else
                        {
                            var addItem = addItemGroup.Sample();
                            if (addItem == null)
                                continue;

                            mailOption.AddItems.Add(addItem);
                        }
                    }
                }
            }

            var mailModel = new PlayerMailModel()
            {
                player_id = Player.Id,
                title = Player.GetString(ResourceString.Types.Category.Item, data.Id, "DailyRewardMailTitle"),
                until_at = data.DailyRewardMailDays > 0 ? date.AddDays(data.DailyRewardMailDays) : null,
                option = mailOption == null ? null : JObject.FromObject(mailOption),
            };
            Player.QueueSave(mailModel.SaveAsync);

            dailyRewardOption.ClaimedAt ??= new Timestamp();
            dailyRewardOption.ClaimedAt.Set(date);
        }
    }
}
