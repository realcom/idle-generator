using System.Collections.Concurrent;
using System.Data;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Utility;
using Commons.Utility.Protobuf;
using Google.Protobuf.WellKnownTypes;
using Newtonsoft.Json.Linq;
using Server.Managers;
using Server.Models;
using Server.Player;
using Server.Session;
using Enum = System.Enum;
using TimeoutException = DotNetty.Handlers.TimeoutException;

namespace Server;

public abstract partial class Server<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player.Player<TServer, TPlayer>
{
    public static readonly TimeSpan SemaphoreTimeout = TimeSpan.FromSeconds(10);
    
    // TODO: make these configurable
    public const int ConcurrentLoginLimit = 128;
    public const int LoginSemaphoreCount = 1024;
    
    protected class LoginFailedException(StatusCode status) : Exception
    {
        public readonly StatusCode Status = status;
        public DateTime? MaintenanceUntilAt;
    }

    public class MultiPlayerTaskContext(long playerId)
    {
        public readonly long PlayerId = playerId;

        public TPlayer? Player;
        public PlayerModel Model = null!;
        public readonly List<Func<IDbConnection, IDbTransaction, Task>> SaveFunctions = [];

        public bool LoginSemaphoreLocked;
        public bool PlayerSemaphoreLocked;
    }

    private readonly ConcurrentDictionary<long, TPlayer> _playerById = new();
    private readonly ConcurrentDictionary<string, TPlayer> _playerBySnsId = new();
    
    public IEnumerable<TPlayer> Players => _playerById.Values;
    public int PlayerCount => _playerById.Count;
    
    private int _concurrentLoginCount;
    private readonly SemaphoreSlim[] _loginSemaphores = new SemaphoreSlim[LoginSemaphoreCount].Fill(() => new SemaphoreSlim(1, 1));
    
    internal async Task Login(Session<TServer, TPlayer> session, long requestId, LoginRequest loginRequest)
    {
        Enum.TryParse(loginRequest.Language, true, out ResourceString.Types.Language language);
        Logger.Info($"Received packet LoginRequest {requestId}");

        if (loginRequest.ClientVersion < MinimumClientVersion)
        {
            Logger.Error($"Outdated client: {loginRequest.ClientVersion} < {MinimumClientVersion}");
            var loginResult = Packet.Pop(session.GetNextPacketKey(), new LoginRequest.Types.Response
            {
                Status = StatusCode.OutdatedClient,
                Message = ResourceString.Get(StatusCode.OutdatedClient, language),
            }, requestId);
            session.SendPacket(loginResult);
            return;
        }

        var concurrentLoginCount = Interlocked.CompareExchange(ref _concurrentLoginCount, 0, 0);
        if (concurrentLoginCount >= ConcurrentLoginLimit)
        {
            if (StaticRandom.NextFloat() < 0.01f)
                Logger.Warn($"Concurrent login limit reached: {concurrentLoginCount} / {ConcurrentLoginLimit}");
            var loginResult = Packet.Pop(session.GetNextPacketKey(), new LoginRequest.Types.Response
            {
                Status = StatusCode.TooManyRequests,
                Message = ResourceString.Get(StatusCode.TooManyRequests, language),
            }, requestId);
            session.SendPacket(loginResult);
            return;
        }

        var loginSemaphoreIndex = Math.Abs(loginRequest.SnsId.GetHashCode()) % LoginSemaphoreCount;
        Interlocked.Increment(ref _concurrentLoginCount);
        var semaphoreLocked = false;
        try
        {
            semaphoreLocked = await _loginSemaphores[loginSemaphoreIndex]
                .WaitAsyncWithTimeoutException(SemaphoreTimeout).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error($"Login failed: {loginRequest.SnsId}", ex);
            Interlocked.Decrement(ref _concurrentLoginCount);
            var loginResult = Packet.Pop(session.GetNextPacketKey(), new LoginRequest.Types.Response
            {
                Status = StatusCode.TooManyRequests,
                Message = ResourceString.Get(StatusCode.TooManyRequests, language),
            }, requestId);
            session.SendPacket(loginResult);
            return;
        }
        try
        {
            var snsId = loginRequest.SnsId.Split("_", 2);
            Enum.TryParse<AccountModel.SnsType>(snsId[0], true, out var snsType);
            var snsKey = snsId[1];
            switch (snsType)
            {
                case AccountModel.SnsType.Telegram:
                {
                    var telegramUserId = long.Parse(snsKey);
                    if (!await ValidateTelegramWebAppData(telegramUserId, loginRequest.LoginKey).ConfigureAwait(false))
                        throw new LoginFailedException(StatusCode.BadRequest);
                    break;
                }
            }
            
            var alreadyLoggedIn = false;
            if (_playerBySnsId.TryGetValue(loginRequest.SnsId, out var player))
            {
                alreadyLoggedIn = true;
                player.SetSession(session);
                player.Language = language;
            }
            else
                player = await LoginInternal(session, loginRequest);

            if (player == null)
                throw new LoginFailedException(StatusCode.BadRequest);

            session.SetPlayer(player);
            if (!alreadyLoggedIn)
            {
                await player.Init().ConfigureAwait(false);
                _playerById[player.Id] = player;
                var accountModel = await player.Model.GetAccountModel();
                player.SnsId = accountModel.sns_id;
                _playerBySnsId[player.SnsId] = player;
            }
            var worldModel = WorldManager.GetWorldById(player.Model.world_id)!;
            var loginResponse = new LoginRequest.Types.Response
            {
                Player = player.ToMessage(),
                World = worldModel.ToMessage(),
            };
            player.HandleLoginResponse(loginResponse);
            var loginResponsePacket = Packet.Pop(session.GetNextPacketKey(), loginResponse, requestId);
            Logger.Info($"Login Success: {loginRequest.SnsId}");
            
            player.SentLoginResponse = true;
            player.SendPacket(loginResponsePacket);

            if (!alreadyLoggedIn)
                player.Run();
            
        }
        catch (LoginFailedException ex)
        {
            Logger.Error($"Login failed: {loginRequest.SnsId}", ex);
            var loginResult = Packet.Pop(session.GetNextPacketKey(), new LoginRequest.Types.Response
            {
                Status = ex.Status,
                Message = ResourceString.Get(ex.Status, language),
                MaintenanceUntilAt = ex.MaintenanceUntilAt?.ToTimestamp(),
            }, requestId);
            session.SendPacket(loginResult);
        }
        catch (Exception ex)
        {
            Logger.Error($"Login failed: {loginRequest.SnsId}", ex);
            var loginResult = Packet.Pop(session.GetNextPacketKey(), new LoginRequest.Types.Response
            {
                Status = StatusCode.BadRequest,
                Message = ResourceString.Get(StatusCode.BadRequest, language),
            }, requestId);
            session.SendPacket(loginResult);
        }
        finally
        {
            Interlocked.Decrement(ref _concurrentLoginCount);
            if (semaphoreLocked)
                _loginSemaphores[loginSemaphoreIndex].Release();
        }
    }
    
    protected abstract Task<TPlayer?> LoginInternal(Session<TServer, TPlayer> session, LoginRequest loginRequest);

    private async Task<bool> ValidateTelegramWebAppData(long telegramUserId, string webAppData)
    {
        var queryData = webAppData.UrlDecode().Split("&").Select(x => x.Split("=")).ToDictionary(x => x[0], x => x[1]);
        var hash = queryData["hash"];
        var dataCheckString = string.Join("\n",
            queryData.Where(x => x.Key != "hash").OrderBy(x => x.Key).Select(x => $"{x.Key}={x.Value}"));
        if (Config.IsDebug)
            Logger.Info($"Data check string: {dataCheckString}");
        var key = Config.Telegram.BotToken!.ToBytes().HmacSha256("WebAppData".ToBytes());
        var hmac = dataCheckString.ToBytes().HmacSha256(key).ToHex();
        if (hash != hmac)
        {
            if (Config.IsDebug)
                Logger.Warn($"Invalid hash: {hash} != {hmac}");
            return false;
        }

        var data = JObject.Parse(queryData["user"]);
        if (data.Value<long>("id") != telegramUserId)
        {
            if (Config.IsDebug)
                Logger.Warn($"Invalid user id: {data.Value<long>("id")} != {telegramUserId}");
            return false;
        }
        
        var authDate = long.Parse(queryData["auth_date"]);
        var currentTime = DateTime.UtcNow.ToUnixTime();
        if (Math.Abs(currentTime - authDate) > 86400)
        {
            if (Config.IsDebug)
                Logger.Warn($"Invalid auth date: {authDate} != {currentTime}");
            return false;
        }

        var telegramModel = await PlayerTelegramModel.GetByTelegramUserIdAsync(telegramUserId).ConfigureAwait(false);
        if (telegramModel == null)
        {
            await new PlayerTelegramModel
            {
                telegram_user_id = telegramUserId,
                username = data.Value<string>("username"),
                first_name = data.Value<string>("first_name")!.SafeUtf8Substring(0, PlayerTelegramModel.MaxNameLength),
                last_name = data.Value<string>("last_name")?.SafeUtf8Substring(0, PlayerTelegramModel.MaxNameLength),
                is_bot = data.Value<bool>("is_bot"),
                is_premium = data.Value<bool>("is_premium"),
            }.SaveAsync().ConfigureAwait(false);
        }
        else
        {
            telegramModel.username = data.Value<string>("username");
            telegramModel.first_name = data.Value<string>("first_name")!.SafeUtf8Substring(0, PlayerTelegramModel.MaxNameLength);
            telegramModel.last_name = data.Value<string>("last_name")?.SafeUtf8Substring(0, PlayerTelegramModel.MaxNameLength);
            telegramModel.is_premium = data.Value<bool>("is_premium");
            await telegramModel.SaveAsync().ConfigureAwait(false);
        }

        return true;
    }
    
    public TPlayer? GetPlayerById(long id)
    {
        return _playerById.GetValueOrDefault(id);
    }
    
    public IPlayer? GetIPlayerById(long id)
    {
        return _playerById.GetValueOrDefault(id);
    }

    public bool ChangeSnsId(string prevSnsId, string newSnsId)
    {
        if (_playerBySnsId.TryRemove(prevSnsId, out var player))
        {
            _playerBySnsId[newSnsId] = player;
            return true;
        }
        
        return false;
    }
    internal void RemovePlayer(TPlayer player)
    {
        _playerById.TryRemove(player.Id, out _);
        _playerBySnsId.TryRemove(player.SnsId!, out _);
    }
    
    public async Task RunMultiPlayerTasks(Func<Task> work, params MultiPlayerTaskContext[] contexts)
    {
        try
        {
            Array.Sort(contexts, (t1, t2) => t1.PlayerId.CompareTo(t2.PlayerId));
            foreach (var task in contexts)
            {
                task.Player = GetPlayerById(task.PlayerId);
                if (task.Player == null)
                    task.Model = await PlayerModel.GetAsync(task.PlayerId).ConfigureAwait(false)!;
                else
                    task.Model = task.Player.Model;
            }

            foreach (var task in contexts)
            {
                var accountModel = await AccountModel.GetAsync(task.PlayerId).ConfigureAwait(false)!;
                var loginSemaphoreIndex = Math.Abs(accountModel.sns_id.GetHashCode()) % LoginSemaphoreCount;
                await _loginSemaphores[loginSemaphoreIndex].WaitAsync().ConfigureAwait(false);
                task.LoginSemaphoreLocked = true;
            }

            foreach (var task in contexts)
            {
                if (task.Player == null)
                    task.Player = GetPlayerById(task.PlayerId);
                if (task.Player != null)
                {
                    await task.Player.Semaphore.WaitAsync().ConfigureAwait(false);
                    task.PlayerSemaphoreLocked = true;
                    if (task.Player.Destroyed)
                    {
                        task.Player.Semaphore.Release();
                        task.PlayerSemaphoreLocked = false;
                        task.Player = null;
                    }
                }
            }

            await work().ConfigureAwait(false);
            
            await DbManager.WithTransactionAsync(async (db, transaction) =>
            {
                foreach (var task in contexts)
                {
                    if (task.Player != null)
                        await task.Player.SaveAsync(db, transaction).ConfigureAwait(false);
                    foreach (var saveFunction in task.SaveFunctions)
                        await saveFunction(db, transaction).ConfigureAwait(false);
                }
            }).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error("Failed to run MultiPlayerTasks", ex);
        }
        finally
        {
            try
            {
                foreach (var task in contexts)
                {
                    if (task.PlayerSemaphoreLocked)
                        task.Player!.Semaphore.Release();
                    if (task.LoginSemaphoreLocked)
                    {
                        var accountModel = await AccountModel.GetAsync(task.PlayerId).ConfigureAwait(false)!;
                        var loginSemaphoreIndex = Math.Abs(accountModel.sns_id.GetHashCode()) % LoginSemaphoreCount;
                        _loginSemaphores[loginSemaphoreIndex].Release();
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to release MultiPlayerTasks semaphores", ex);
            }
        }
    }
}
