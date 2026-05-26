using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial async Task<bool> HandlePacket(long requestId, SignInOauthRequest request)
    {
        var response = new SignInOauthRequest.Types.Response();
        if (AccountModel.sns_type != AccountModel.SnsType.Guest)
        {
            response.Status = StatusCode.BadRequest;
        }

        var existAccount = await AccountModel.GetBySnsIdAsync(request.SnsId).ConfigureAwait(false);
        if (existAccount != null)
            response.Status = StatusCode.ConnectedAccountExist;   
        
        if (response.Status == StatusCode.Ok)
        {
            var snsType = request.SnsId.Split("_")[0];
            switch (snsType)
            {
                case "Google":
                case "Apple":
                {
                    var prevSnsId = AccountModel.sns_id;
                    AccountModel.sns_id = request.SnsId;
                    await AccountModel.UpdateSnsIdAsync();
                    Server.ChangeSnsId(prevSnsId, AccountModel.sns_id);
                    break;
                }

                default:
                {
                    response.Status = StatusCode.BadRequest;
                    break;
                }
            }
        }
        var packet = Packet.Pop(GetNextPacketKey(), response, requestId);
        SendPacket(packet);
        return true;
    }
}