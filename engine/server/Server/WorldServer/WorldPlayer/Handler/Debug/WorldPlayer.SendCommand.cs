using System.Text;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Newtonsoft.Json.Linq;
using Server.Managers;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, SendCommandRequest request)
    {
        var status = StatusCode.Ok;
        if (!Config.IsDebug && !Model.is_admin)
            status = StatusCode.BadRequest;
        else
        {
            var commands = request.Command.Split(" ");
            if (commands.Length == 0)
                status = StatusCode.BadRequest;
            else
            {
                switch (commands[0])
                {
                    case "/whoami":
                    {
                        SendDisplayMessageUpdate(message: Id.ToString());
                        break;
                    }
                    case "/item":
                    {
                        if (commands.Length < 2)
                        {
                            status = StatusCode.BadRequest;
                            break;
                        }

                        switch (commands[1])
                        {
                            case "exp":
                            {
                                if (commands.Length < 4)
                                {
                                    status = StatusCode.BadRequest;
                                    break;
                                }
                                
                                var itemDataId = int.Parse(commands[2]);
                                var item = CashItemManager.GetItemByDataId(itemDataId, checkCount: true, checkDeprecated: true);
                                if (item == null)
                                {
                                    SendDisplayMessageUpdate(message: nameof(StatusCode.ItemNotFound));
                                    break;
                                }
                                
                                var exp = long.Parse(commands[3]);
                                CashItemManager.AddExp(item, exp);
                                SendDisplayMessageUpdate(message: "Ok!");
                                
                                break;
                            }
                            case "info":
                            {
                                var itemDataId = int.Parse(commands[2]);
                                var foundItem = CashItemManager.GetItemByDataId(itemDataId);

                                SendDisplayMessageUpdate(message: foundItem == null ? nameof(StatusCode.ItemNotFound) : foundItem.ToMessage().ToString());
                                break;
                            }
                            default:
                            {
                                var itemDataId = int.Parse(commands[1]);
                                var count = commands.Length > 2 ? long.Parse(commands[2]) : 1;
                                status = CashItemManager.AddItem(itemDataId, count);
                                SendDisplayMessageUpdate(message: "Ok!");
                                break;
                            }
                        }
                        
                        break;
                    }
                    case "/allweapons":
                    {
                        foreach (var resourceItem in ResourceItem.GetAllByType(ResourceItem.Types.Type.InventorySkill))
                        {
                            var item = CashItemManager.GetItemByDataId(resourceItem.Id, checkCount: true);
                            if (item == null)
                            {
                                CashItemManager.AddItem(resourceItem.Id, 1);
                            }
                        }
                        SendDisplayMessageUpdate(message: "Ok!");
                        break;
                    }
                    
                    case "/allequipments":
                    {
                        var grade = commands.Length > 1 ? int.Parse(commands[1]) : int.MaxValue;
                        var count = commands.Length > 2 ? int.Parse(commands[2]) : 1;

                        for (var i = 0; i < count; i++)
                        {
                            foreach (var resourceItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Equipment))
                            {
                                if (resourceItem.IsValid && resourceItem.Grade > 0 && resourceItem.Grade <= grade)
                                    CashItemManager.AddItem(resourceItem.Id);
                            }   
                        }
                        SendDisplayMessageUpdate(message: "Ok!");
                        break;
                    }
                    
                    
                    case "/allpets":
                    {
                        foreach (var resourceItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Pet))
                        {
                            CashItemManager.AddItem(resourceItem.Id, 1);
                        }
                        SendDisplayMessageUpdate(message: "Ok!");
                        break;
                    }
                    case "/mail":
                    {
                        if (commands.Length < 3)
                        {
                            status = StatusCode.BadRequest;
                            break;
                        }
                        
                        var playerId = long.Parse(commands[1]);
                        var title = commands[2];
                        var itemDataId = commands.Length > 3 ? int.Parse(commands[3]) : 0;
                        var itemCount = commands.Length > 4 ? int.Parse(commands[4]) : 1;
                        var itemDays = commands.Length > 5 ? int.Parse(commands[5]) : 0;
                        var untilAtDays = commands.Length > 6 ? int.Parse(commands[6]) : 0;
                        var untilAt = untilAtDays > 0 ? DateTime.UtcNow.AddDays(untilAtDays) : (DateTime?)null;

                        await new PlayerMailModel
                        {
                            player_id = playerId,
                            title = title,
                            item_data_id = itemDataId,
                            item_count = itemCount,
                            item_days = itemDays,
                            until_at = untilAt,
                        }.SaveAsync().ConfigureAwait(false);
                        
                        SendDisplayMessageUpdate(message: "Ok!");
                        break;
                    }
                    case "/ach":
                    {
                        if (commands.Length < 3)
                        {
                            status = StatusCode.BadRequest;
                            break;
                        }

                        if (commands[1] == "info")
                        {
                            var achievementDataId = int.Parse(commands[2]);
                            var achievement = AchievementManager.GetAchievementByDataId(achievementDataId);
                            if (achievement == null || achievement.state == PlayerAchievementMessage.Types.State.Disabled)
                                SendDisplayMessageUpdate(message: "Disabled");
                            else 
                                SendDisplayMessageUpdate(message: $"{achievement.progress}/{achievement.Data.TargetProgress} ({achievement.state})");
                        }
                        else
                        {
                            // 마지막 값은 progress
                            var progress = int.Parse(commands[^1]);

                            // 1번째부터 마지막 직전까지는 achievementDataIds
                            for (int i = 1; i < commands.Length - 1; i++)
                            {
                                var achievementDataId = int.Parse(commands[i]);
                                AchievementManager.IncreaseAchievement(achievementDataId, progress);
                            }
                            SendDisplayMessageUpdate(message: "Ok!");
                        }
                        
                        break;
                    }
                    case "/dayreset":
                    {
                        var days = 1;
                        if (commands.Length > 1)
                            days = int.Parse(commands[1]);
                        Model.day_reset_at = DateTime.UtcNow.AddDays(-days);
                        SendDisplayMessageUpdate(message: "OK!");
                        break;
                    }
                    case "/createboard":
                    {
                        if (commands.Length < 2)
                        {
                            status = StatusCode.BadRequest;
                            break;
                        }
                        
                        var mapDataId = int.Parse(commands[1]);
                        (status, _) = BoardManager.CreateBoard(this, mapDataId);
                        SendDisplayMessageUpdate(message: GetString(status));
                        break;
                    }
                    case "/spendscouttime":
                    {
                        if (commands.Length < 2)
                        {
                            status = StatusCode.BadRequest;
                            break;
                        }
                        
                        var minutes = int.Parse(commands[1]);
                        if (commands.Length > 2)
                        {
                            var itemDataId = int.Parse(commands[2]);
                            var item = CashItemManager.GetItemByDataId(itemDataId, checkCount: true, checkDeprecated: true, checkUntilAt: true);
                            if (item == null)
                            {
                                status = StatusCode.ItemNotFound;
                                break;
                            }
                            
                            CashItemManager.SpendScoutTime(item, minutes);
                        }
                        else
                        {
                            foreach (var itemModel in CashItemManager.GetItemsByTag(Tag.ScoutNormal, checkCount: true, checkDeprecated: true, checkUntilAt: true))
                            {
                                CashItemManager.SpendScoutTime(itemModel, minutes);
                            }    
                        }
                        
                        SendDisplayMessageUpdate(message: GetString(status));
                        
                        break;
                    }
                    case "/rerollscoutrewards":
                    {
                        if (commands.Length > 2)
                        {
                            // seed, itemDataId
                            var seed = int.Parse(commands[1]);
                            var itemDataId = int.Parse(commands[2]);
                            var item = CashItemManager.GetItemByDataId(itemDataId, checkCount: true, checkDeprecated: true, checkUntilAt: true);
                            if (item == null)
                            {
                                status = StatusCode.ItemNotFound;
                                break;
                            }
                            
                            CashItemManager.RerollScoutRewards(item, seed);
                        }
                        else if (commands.Length > 1)
                        {
                            // seed, reroll all
                            var seed = int.Parse(commands[1]);
                            foreach (var itemModel in CashItemManager.GetItemsByTag(Tag.ScoutNormal, checkCount: true, checkDeprecated: true, checkUntilAt: true))
                            {
                                CashItemManager.RerollScoutRewards(itemModel, seed);
                            }
                        }
                        else
                        {
                            // no seed, reroll all
                            foreach (var itemModel in CashItemManager.GetItemsByTag(Tag.ScoutNormal, checkCount: true, checkDeprecated: true, checkUntilAt: true))
                            {
                                CashItemManager.RerollScoutRewards(itemModel);
                            }
                        }
                        
                        SendDisplayMessageUpdate(message: GetString(status));
                        
                        break;
                    }
                }
            }
            
            PlayerLogManager.Queue(PlayerLogModel.Type.SendCommand, new
            {
                Commands = commands,
            });
        }

        var packet = Packet.Pop(GetNextPacketKey(), new SendCommandRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language),
        }, requestId);
        SendPacket(packet);

        return true;
    }
}
