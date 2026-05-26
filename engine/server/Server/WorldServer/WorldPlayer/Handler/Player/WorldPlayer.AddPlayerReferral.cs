using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;
using Server.Player;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, AddPlayerReferralRequest request)
    {
        var status = StatusCode.Ok;

        do
        {
            if (Telegram == null)
            {
                if (Config.IsDebug)
                    Logger.Info("Not Telegram user");
                break;
            }
            if (DateTime.UtcNow - Model.created_at > TimeSpan.FromHours(12))
            {
                if (Config.IsDebug)
                    Logger.Info("Player created more than 12 hours ago");
                break;
            }
            var telegram = await PlayerTelegramModel.GetByTelegramUserIdAsync(request.TelegramUserId).ConfigureAwait(false);
            if (telegram == null)
            {
                if (Config.IsDebug)
                    Logger.Info("Telegram user not found");
                break;
            }
            var referredPlayerModel = await AccountModel.GetBySnsIdAsync($"Telegram_{request.TelegramUserId}").ConfigureAwait(false);
            if (referredPlayerModel == null)
            {
                if (Config.IsDebug)
                    Logger.Info("Referred player not found");
                break;
            }
            if (referredPlayerModel.id == Id)
            {
                if (Config.IsDebug)
                    Logger.Info("Referred player is the same as the referrer");
                break;
            }
            var playerReferral = await PlayerReferralModel.GetByReferrerPlayerIdAsync(Id).ConfigureAwait(false);
            if (playerReferral != null)
            {
                if (Config.IsDebug)
                    Logger.Info("Referrer already exists");
                break;
            }
            QueueSave(new PlayerReferralModel
            {
                referrer_player_id = Id,
                referred_player_id = referredPlayerModel.id,
            }.SaveAsync);
            QueueSave(new PlayerPushModel
            {
                player_id = referredPlayerModel.id,
                message = referredPlayerModel.GetString("Push/AcquireReferral", Name),
            }.SaveAsync);
            
            AchievementManager.IncreaseAchievement(ResourceAchievement.Types.Condition.AddReferral);
            if (Telegram?.is_premium == true)
                AchievementManager.IncreaseAchievement(ResourceAchievement.Types.Condition.AddPremiumReferral);
            else
                AchievementManager.IncreaseAchievement(ResourceAchievement.Types.Condition.AddNonPremiumReferral);
            
            PlayerLogManager.Queue(PlayerLogModel.Type.AddPlayerReferral, new
            {
                TelegramUserId = telegram.telegram_user_id,
                ReferredPlayerId = referredPlayerModel.id,
            });
        } while (false);

        var packet = Packet.Pop(GetNextPacketKey(), new LeaveBoardRequest.Types.Response
        {
            Status = status,
            Message = ResourceString.Get(status, Language),
        }, requestId);
        SendPacket(packet);
        
        return true;
    }
}
