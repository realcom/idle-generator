using System.Diagnostics;
using Commons;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using Dapper;
using log4net.Core;
using Server;
using Server.Managers;
using Server.Models;
using Server.Session;

namespace WorldServer;

public partial class WorldServer
{
    protected override async Task<WorldPlayer.WorldPlayer?> LoginInternal(Session<WorldServer, WorldPlayer.WorldPlayer> session, LoginRequest loginRequest)
    {
        if (string.IsNullOrEmpty(loginRequest.SnsId))
            return null;

        // Compare commonsCommitHash
        // if (Config.IsDebug && loginRequest.CommonsCommitHash != Commons.Config.CommonsCommitHash)
        // {
        //     Logger.Info($"CommonsCommitHash are inconsistent. client: {loginRequest.CommonsCommitHash} server: {Commons.Config.CommonsCommitHash} ");
        //     throw new LoginFailedException(StatusCode.InconsistentCommonsVersion);
        // }

        PlayerModel mainPlayer = null!;
        AccountModel accountModel = null!;
        await DbManager.WithTransactionAsync(async (db, transaction) =>
        {
            accountModel = await AccountModel.GetBySnsIdAsync(loginRequest.SnsId) ?? new AccountModel
            {
                name = "",
                sns_id = loginRequest.SnsId,
            };
            
            if (OnMaintenance && !accountModel.is_admin)
                throw new LoginFailedException(StatusCode.ServerMaintenance)
                {
                    MaintenanceUntilAt = MaintenanceUntilAt == default ? null : MaintenanceUntilAt,
                };
            
            // update columns.
            {
                accountModel.language = loginRequest.Language;
                accountModel.country = loginRequest.Country;
                accountModel.device_id = loginRequest.DeviceId.Truncate(128);
                accountModel.device_os = loginRequest.DeviceOS.Truncate(32);
                accountModel.device_model = loginRequest.DeviceModel.Truncate(64);
                accountModel.push_token = loginRequest.PushToken;
            }
            switch (accountModel.sns_type)
            {
                case AccountModel.SnsType.Telegram:
                {
                    var telegramUserId = long.Parse(accountModel.sns_key);
                    var telegramModel = await PlayerTelegramModel.GetByTelegramUserIdAsync(telegramUserId);
                    if (telegramModel == null)
                        throw new InvalidOperationException($"Telegram user not found: {telegramUserId}");
                    if (string.IsNullOrEmpty(telegramModel.last_name))
                        accountModel.name = telegramModel.first_name;
                    else
                        accountModel.name = $"{telegramModel.first_name} {telegramModel.last_name}";
                    accountModel.name = accountModel.name.SafeUtf8Substring(0, AccountModel.MaxNameLength);
                    break;
                }
                case AccountModel.SnsType.Google:
                    break;
                case AccountModel.SnsType.Apple:
                    break;
                case AccountModel.SnsType.Guest:
                    break;
            }
           
            await accountModel.SaveAsync(db, transaction).ConfigureAwait(false);
            
            var player = await accountModel.GetMainPlayer().ConfigureAwait(false);
            if (player == null)
            {
                var world = await WorldModel.GetDefaultGlobalWorld().ConfigureAwait(false);
                Enum.TryParse(loginRequest.Language, true, out ResourceString.Types.Language language);

                await db.ExecuteAsync("LOCK TABLE players IN EXCLUSIVE MODE", transaction: transaction).ConfigureAwait(false);
                var lastPlayerId =
                    await db.QuerySingleAsync<long>("SELECT COALESCE(MAX(id), 0) FROM players", transaction: transaction)
                        .ConfigureAwait(false);
                var id = lastPlayerId + 1;
                var randomNumber = StaticRandom.CryptoNext(0, 1000); // 3-digit number
                
                //마지막 playerId + 1 을 붙여서 닉네임 중복 가능성 제거 혹여 중복되더라도 앞의 랜덤으로 충분히 희박
                var name = $"{ResourceString.Get("Hamzzi", language)}_{randomNumber:D3}{id}";

                player = new PlayerModel
                {
                    account_id = accountModel.id,
                    world_id = world.id,
                    name = name,
                    level = 1,
                    day_reset_at = (DateTime.UtcNow.AddHours(world.utc_offset_hours) - TimeSpan.FromDays(1)).Date // day reset로직 타도록 변경
                };
                await player.SaveAsync(db, transaction).ConfigureAwait(false);
                accountModel.main_player_id = player.id;
                await accountModel.SaveAsync(db, transaction).ConfigureAwait(false);
            }
            mainPlayer = player;
        });
        
        var player = new WorldPlayer.WorldPlayer(this, session, mainPlayer, accountModel);
        Logger.Info($"WorldPlayer logined: {player.Id} {player.Name} (total {PlayerCount + 1} players)");
        return player;
    }
    
    public static async Task<PlayerMessage> GetPlayerMessageById(long id)
    {
        var playerModel = await PlayerModel.GetAsync(id).ConfigureAwait(false);
        if (playerModel == null)
            throw new InvalidOperationException($"Player {id} not found");
        var playerMessage = playerModel.ToMessage();
        
        var accountModel = await playerModel.GetAccountModel();
        if (accountModel.sns_type == AccountModel.SnsType.Telegram && long.TryParse(accountModel.sns_key, out var telegramUserId))
        {
            var telegramModel = await PlayerTelegramModel.GetByTelegramUserIdAsync(telegramUserId).ConfigureAwait(false);
            playerMessage.Telegram = telegramModel?.ToMessage();
        }

        return playerMessage;
    }

    public static async Task<IEnumerable<PlayerMessage>> GetPlayerMessagesByIds(IEnumerable<long> ids)
    {
        var idsArray = ids.ToArray();
        var players = (await PlayerModel.GetAllByIdsAsync(idsArray).ConfigureAwait(false)).ToArray();

        var telegramUserIds = new Dictionary<long, long>();
        
        foreach (var playerModel in players)
        {
            var accountModel = await playerModel.GetAccountModel();
            if (accountModel.sns_type == AccountModel.SnsType.Telegram && long.TryParse(accountModel.sns_key, out var telegramUserId))
                telegramUserIds.Add(telegramUserId, playerModel.id);
        }
        var telegramUsers = (await PlayerTelegramModel.GetAllByTelegramUserIdsAsync(telegramUserIds.Keys).ConfigureAwait(false))
            .ToDictionary(u => telegramUserIds[u.telegram_user_id]);

        return players.Select(player =>
        {
            var message = player.ToMessage();
            message.Telegram = telegramUsers.GetValueOrDefault(player.id)?.ToMessage();
            return message;
        });
    }

    public static async Task<BoardPlayerMessage> GetBoardPlayerMessage(long playerId)
    {
        var playerModel = await PlayerModel.GetAsync(playerId).ConfigureAwait(false);
        if (playerModel == null)
            throw new InvalidOperationException($"Player {playerId} not found");
        var playerMessage = new BoardPlayerMessage
        {
            Id = playerModel.id,
            BytesName = playerModel.name.ToByteString(),
            Level = playerModel.level,
        };

        var itemStat = await Server.Utility.PlayerItemModelExtensions.GetPlayerItemStat(playerId).ConfigureAwait(false);
        itemStat.CopyTo(playerMessage.ItemStat);

        return playerMessage;
    }
}
