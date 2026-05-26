using System.Data;
using Commons.Game;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server;
using Server.Managers;
using Server.Models;
using Server.Session;

namespace EdgeServer.EdgePlayer;

public class EdgePlayer(EdgeServer server, Session<EdgeServer, EdgePlayer> session, PlayerModel model, AccountModel accountModel)
    : Server.Player.Player<EdgeServer, EdgePlayer>(server, session, model, accountModel)
{
    public override float TickSeconds => 1f / 30;
    
    // TODO
    public override PlayerAvatar Avatar => throw new NotImplementedException();

    public override IPlayerLogManager PlayerLogManager => throw new NotImplementedException();

    public override async Task Init()
    {
        // TODO
    }

    public override void HandleLoginResponse(LoginRequest.Types.Response response)
    {
        // TODO
    }
    
    public override void InitBoard(GameBoard board)
    {
        throw new NotImplementedException();
    }

    public override IEnumerable<PlayerItemModel> GetItemsByCategory(ResourceItem.Types.Category category)
    {
        throw new NotImplementedException();
    }

    public override IEnumerable<PlayerItemModel> GetItemsByType(ResourceItem.Types.Type type)
    {
        throw new NotImplementedException();
    }

    public override PlayerItemModel? GetItemById(long id)
    {
        throw new NotImplementedException();
    }

    public override PlayerItemModel? GetItemByDataId(int dataId)
    {
        throw new NotImplementedException();
    }
    

    public override PlayerAchievementModel? GetAchievementByDataId(int dataId)
    {
        throw new NotImplementedException();
    }

    public override Task SaveAsync(IDbConnection? db = null, IDbTransaction? transaction = null, bool destroyIfFailed = true)
    {
        throw new NotImplementedException();
    }
}
