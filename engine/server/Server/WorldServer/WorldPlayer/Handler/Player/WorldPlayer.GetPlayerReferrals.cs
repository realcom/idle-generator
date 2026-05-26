using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, GetPlayerReferralsRequest request)
    {
        var response = new GetPlayerReferralsRequest.Types.Response();

        await AchievementManager.RefreshReferralAchievements().ConfigureAwait(false);
        
        var referrals = (await PlayerReferralModel.GetAllByReferredPlayerIdAsync(Id).ConfigureAwait(false))
            .Where(r => r.applied)
            .Select(r => r.referrer_player_id).ToList();
        var referral = await PlayerReferralModel.GetByReferrerPlayerIdAsync(Id).ConfigureAwait(false);
        if (referral != null)
            referrals.Add(referral.referred_player_id);
        
        var players = (await WorldServer.GetPlayerMessagesByIds(referrals).ConfigureAwait(false));
        response.Players.AddRange(players);

        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        
        return true;
    }
}
