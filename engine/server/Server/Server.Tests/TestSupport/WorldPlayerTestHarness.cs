using DotNetty.Transport.Channels.Embedded;
using Server.Models;
using Server.Session;

namespace Server.Tests.TestSupport;

internal sealed class WorldPlayerTestHarness
{
    private long _nextTransientItemId = -1;

    public WorldPlayerTestHarness(long playerId = 1, long accountId = 1, bool sentLoginResponse = true)
    {
        Server = new WorldServer.WorldServer(0);
        Channel = new EmbeddedChannel();
        Session = new Session<WorldServer.WorldServer, WorldServer.WorldPlayer.WorldPlayer>(Server, Channel, "127.0.0.1");

        var playerModel = new PlayerModel
        {
            id = playerId,
            account_id = accountId,
            world_id = 1,
            name = $"Player{playerId}",
            level = 1,
            power = 0,
            day_reset_at = DateTime.UtcNow.AddDays(-1),
        };

        var accountModel = new AccountModel
        {
            id = accountId,
            sns_id = $"Guest_{playerId}",
            play_game_id = "",
            game_center_id = "",
            device_id = "",
            device_os = "",
            device_model = "",
            push_token = "",
            name = $"Account{accountId}",
            country = "KR",
            language = "English",
            main_player_id = playerId,
        };

        Player = new WorldServer.WorldPlayer.WorldPlayer(Server, Session, playerModel, accountModel)
        {
            SentLoginResponse = sentLoginResponse,
        };
    }

    public WorldServer.WorldServer Server { get; }
    public EmbeddedChannel Channel { get; }
    public Session<WorldServer.WorldServer, WorldServer.WorldPlayer.WorldPlayer> Session { get; }
    public WorldServer.WorldPlayer.WorldPlayer Player { get; }
    public WorldServer.Managers.CashItemManager.CashItemManager Manager => Player.CashItemManager;

    public void AssignTransientItemIds(IEnumerable<PlayerItemModel> items)
    {
        var itemByIdField = typeof(WorldServer.Managers.CashItemManager.CashItemManager)
            .GetField("_itemById", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic)!;
        var itemById = (Dictionary<long, PlayerItemModel>)itemByIdField.GetValue(Manager)!;

        foreach (var item in items.Where(item => item.id == 0))
        {
            item.id = _nextTransientItemId--;
            itemById[item.id] = item;
        }
    }
}
