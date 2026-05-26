using Commons.Resources;
using Server.Models;
using static Commons.Resources.ResourceAchievement.ConditionQuery;
using static Commons.Resources.ResourceAchievement.Types;

namespace WorldServer.Managers.AchievementManager;

public partial class AchievementManager
{
    public async Task RefreshReferralAchievements()
    {
        try
        {
            await RefreshReferralAchievementsInternal().ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error($"{Player}.RefreshReferralAchievements failed", ex);
        }
    }

    private async Task RefreshReferralAchievementsInternal()
    {
        var referrals = (await PlayerReferralModel.GetAllByReferredPlayerIdAsync(Player.Id).ConfigureAwait(false)).ToArray();
        var unappliedReferralIds = new List<long>();
        var unappliedReferralCount = 0;
        var unappliedPremiumReferralCount = 0;
        var unappliedNonPremiumReferralCount = 0;
        foreach (var referral in referrals)
        {
            if (referral.applied)
                continue;
            unappliedReferralIds.Add(referral.id);
            unappliedReferralCount += 1;
            var referrerPlayerModel = (await PlayerModel.GetAsync(referral.referrer_player_id).ConfigureAwait(false))!;
            var accountModel = await referrerPlayerModel.GetAccountModel();
            if (accountModel.sns_type == AccountModel.SnsType.Telegram && long.TryParse(accountModel.sns_key, out var telegramUserId))
            {
                var telegram = await PlayerTelegramModel.GetByTelegramUserIdAsync(telegramUserId).ConfigureAwait(false);
                if (telegram != null && telegram.is_premium)
                    unappliedPremiumReferralCount += 1;
                else
                    unappliedNonPremiumReferralCount += 1;
            }
        }
        
        Player.QueueSave((db, task) => PlayerReferralModel.ApplyByIdsAsync(db, task, unappliedReferralIds));
        IncreaseAchievement(Condition.AcquireReferral, unappliedReferralCount);
        IncreaseAchievement(Condition.AcquirePremiumReferral, unappliedPremiumReferralCount);
        IncreaseAchievement(Condition.AcquireNonPremiumReferral, unappliedNonPremiumReferralCount);
        
        var referralCount = referrals.Length;
        IncreaseAchievement(new ResourceAchievement.ConditionQuery(Condition.HasReferrals, Comparer.GreaterOrEqual, referralCount), -1);
    }
}
