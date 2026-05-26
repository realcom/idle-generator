using System.Diagnostics;
using Commons.Resources;
using Commons.Utility;
using log4net;
using Microsoft.Extensions.Hosting;
using NCrontab;
using Server.Managers;
using Server.Models;

namespace Server.Services;

// cron 기반으로 player_pushes에 푸시 후보를 적재하는 서비스
public sealed class PushCronService : IHostedService
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    private static readonly Dictionary<(long, int), DateTime> _lastTicketItemUpdate = new();
    private static readonly Dictionary<(long, int), DateTime> _lastScoutItemUpdate = new();

    private readonly List<CronJob> _jobs = new();
    private CancellationTokenSource? _cts;
    private Task? _runner;

    public PushCronService()
    {
        // a) 10분마다 티켓 관리 
        _jobs.Add(new CronJob(
            name: "Item_Ticket",
            cron: "*/10 * * * *",
            work: HandleRegenTicket
        ));
        
        // a) 10분마다 정찰 관리 
        _jobs.Add(new CronJob(
            name: "Item_ScoutNormal",
            cron: "*/10 * * * *",
            work: HandleScoutNormal
        ));
        
        // 1시간 마다 OnlineAtHour 푸시 
        _jobs.Add(new CronJob(
            name: "Achievement_OnlineAtHour",
            cron: "0 * * * *",
            work: HandleOnlineAtHour
        ));
        
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        Logger.Info("Push Cron Service is starting.");
        _cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        _runner = RunAsync(_cts.Token);
        return Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        Logger.Info("Push Cron Service is stopping.");
        if (_cts is null) return;
        await _cts.CancelAsync();
        if (_runner is not null)
        {
            try { await _runner.ConfigureAwait(false); }
            catch (OperationCanceledException) { /* ignore */ }
        }
    }

    private async Task RunAsync(CancellationToken ct)
    {
        // 잡별로 독립 루프 수행
        var tasks = _jobs.Select(job => job.RunLoopAsync(ct)).ToArray();
        await Task.WhenAll(tasks).ConfigureAwait(false);
    }
    private async Task HandleRegenTicket(CancellationToken ct)
    {
        var offsetTime = DateTime.UtcNow.ToOffsetTime();
        var now = DateTime.UtcNow;

        var players =
            (await PlayerModel.GetAllByDayResetAtGreaterThan(DateTime.UtcNow.AddDays(-1)).ConfigureAwait(false))
            .ToArray();
        
        foreach (var player in players)
        {
            var account = await AccountModel.GetByMainPlayerIdAsync(player.id);
            if (account?.push_token == null) continue;
            
            foreach (var resItem in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Ticket))
            {
                if (resItem.RegenPeriod <= 0) continue;
                var item = await PlayerItemModel.GetAsync(player.id, resItem.Id);
                if (item is null) continue;

                var key = (player.id, resItem.Id);
                _lastTicketItemUpdate.TryGetValue(key, out var lastUpdate);

                if (item.updated_at > lastUpdate)
                {
                    var msgKey = $"Push/TicketFull/{resItem.Id}";
                    await PlayerPushModel.DeleteByPlayerIdAndKeyAndPublished(player.id, msgKey, false);
                    var totalCount = item.count;
                    if (resItem.ContainsTag(Tag.AddParam1ToCount))
                        totalCount += item.param1;
                    var (maxCountBonus, regenPeriodBonus) = await GetTicketBonusValues(player.id, resItem.Id, now).ConfigureAwait(false);
                    var maxCount = resItem.MaxCount + maxCountBonus;
                    var needed = (int)(maxCount - totalCount);
                
                    if (needed > 0)
                    {
                        var regenPeriod = resItem.RegenPeriod + regenPeriodBonus;
                        var refreshOffsetTime = item.param2;
                        var fullOffsetTime = refreshOffsetTime + needed * regenPeriod;
                    
                        if (fullOffsetTime > offsetTime)
                        {
                            await new PlayerPushModel
                            {
                                type = PlayerPushModel.PushType.Volatile,
                                publish_at = DateTimeExtensions.FromOffsetTime(fullOffsetTime),
                                player_id = player.id,
                                key = msgKey,
                                message = msgKey,
                            }.SaveAsync().ConfigureAwait(false);
                        }
                    }

                    _lastTicketItemUpdate[key] = item.updated_at;
                }
            }
        }
    }

    private async Task HandleOnlineAtHour(CancellationToken ct)
    {
        var hour = DateTime.UtcNow.Hour;
        var players =
            (await PlayerModel.GetAllByDayResetAtGreaterThan(DateTime.UtcNow.AddDays(-3)).ConfigureAwait(false))
            .ToArray();
        
        foreach (var player in players)
        {
            var account = await AccountModel.GetByMainPlayerIdAsync(player.id);
            if (account?.push_token == null) continue;
            foreach (var resAchievement in ResourceAchievement.GetAllByCondition(ResourceAchievement.Types.Condition.OnlineAtHour))
            {
                if (!resAchievement.IsValid)
                    continue;
                var world = WorldManager.GetWorldById(player.world_id);
                if (world.utc_offset_hours + resAchievement.ConditionValue1 != hour)
                    continue;

                var msgKey = $"Push/AchievementComplete/{resAchievement.Id}";
                await PlayerPushModel.DeleteByPlayerIdAndKeyAndPublished(player.id, msgKey, false);
                    
                // TODO: bulk insert
                await new PlayerPushModel
                {
                    type = PlayerPushModel.PushType.Volatile,
                    publish_at = null,
                    player_id = player.id,
                    key = msgKey,
                    message = msgKey,
                }.SaveAsync().ConfigureAwait(false);
            }
        }
    }
    private async Task HandleScoutNormal(CancellationToken ct)
    {
        var offsetTime = DateTime.UtcNow.ToOffsetTime();
        var now = DateTime.UtcNow;
    
        var players =
            (await PlayerModel.GetAllByDayResetAtGreaterThan(DateTime.UtcNow.AddDays(-10)).ConfigureAwait(false))
            .ToArray();
        
        foreach (var player in players)
        {
            foreach (var resItem in ResourceItem.GetAllByTag(Tag.ScoutNormal))
            {
                var item = await PlayerItemModel.GetAsync(player.id, resItem.Id);
                if (item is null) continue;
    
                var key = (player.id, resItem.Id);
                _lastScoutItemUpdate.TryGetValue(key, out var lastUpdate);
    
                if (item.updated_at > lastUpdate)
                {
                    var msgKey = $"Push/ScoutFull/{resItem.Id}";
                    await PlayerPushModel.DeleteByPlayerIdAndKeyAndPublished(player.id, msgKey, false);
                    var minutes = (offsetTime - item.param2) / 60;
                    var map = ResourceMap.Get(item.param1)!;

                    var maxMinutes = map.ScoutAddItemGroups.FirstOrDefault().MaxMinutes;
                    var boostItems = ResourceItem.GetAllByTag(Tag.BoostScoutMaxMinutes)
                        .Where(i => map.Group == i.MapGroup && i.IsValid);
                    var playerBoostItem =
                        await PlayerItemModel.GetAllByPlayerIdDataIdsAsync(player.id, boostItems.Select(i => i.Id).ToArray());
                    var boostMinutes = playerBoostItem
                        .Where(i => i.count > 0 && (i.until_at == null || i.until_at > now) && !i.Data.ContainsTag(Tag.Deprecated))
                        .Sum(i => i.Data.BoostScoutMaxMinutes);
                    maxMinutes += boostMinutes;
                    var ScoutMaxTime = item.param2 + maxMinutes * 60; 
                    if (ScoutMaxTime > offsetTime)
                    {
                        await new PlayerPushModel
                        {
                            type = PlayerPushModel.PushType.Volatile,
                            publish_at = DateTimeExtensions.FromOffsetTime(ScoutMaxTime),
                            player_id = player.id,
                            key = msgKey,
                            message = msgKey,
                        }.SaveAsync().ConfigureAwait(false);
                    }

                    _lastScoutItemUpdate[key] = item.updated_at;
                }
            }
        }
    }

    private static async Task<(int maxCountBonus, int regenPeriodBonus)> GetTicketBonusValues(long playerId, int ticketItemDataId,
        DateTime now)
    {
        var ticketBoostItems = ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Utility)
            .Where(item => item.BonusItemDataId == ticketItemDataId &&
                           (item.Type == ResourceItem.Types.Type.AddMaxCount || item.Type == ResourceItem.Types.Type.AddRegenPeriod))
            .Select(item => item.Id)
            .ToArray();

        if (ticketBoostItems.Length == 0)
            return (0, 0);

        var playerItems = await PlayerItemModel.GetAllByPlayerIdDataIdsAsync(playerId, ticketBoostItems).ConfigureAwait(false);
        long maxCountBonus = 0;
        long regenPeriodBonus = 0;

        foreach (var item in playerItems.Where(item =>
                     item.count > 0 && (item.until_at == null || item.until_at > now) && !item.Data.ContainsTag(Tag.Deprecated)))
        {
            if (item.Data.Type == ResourceItem.Types.Type.AddMaxCount)
                maxCountBonus += item.Data.BonusCount * item.count;
            else if (item.Data.Type == ResourceItem.Types.Type.AddRegenPeriod)
                regenPeriodBonus += item.Data.RegenPeriod * item.count;
        }

        return (checked((int)maxCountBonus), checked((int)regenPeriodBonus));
    }
    

    // 내부 Cron 잡
    private sealed class CronJob
    {
        private readonly string _name;
        private readonly CrontabSchedule _schedule;
        private readonly Func<CancellationToken, Task> _work;

        public CronJob(string name, string cron, Func<CancellationToken, Task> work)
        {
            _name = name;
            _schedule = CrontabSchedule.Parse(cron, new CrontabSchedule.ParseOptions { IncludingSeconds = false });
            _work = work;
        }

        public async Task RunLoopAsync(CancellationToken ct)
        {
            // next 계산 시작점
            var next = _schedule.GetNextOccurrence(DateTime.UtcNow);

            while (!ct.IsCancellationRequested)
            {
                var now = DateTime.UtcNow;
                if (next <= now) next = _schedule.GetNextOccurrence(now);

                var delay = next - now;
                if (delay < TimeSpan.Zero) delay = TimeSpan.Zero;

                try
                {
                    await Task.Delay(delay, ct).ConfigureAwait(false);
                    // 실행 시각 스냅샷 후 바로 다음 예약 계산(드리프트 방지)
                    var fire = next;
                    next = _schedule.GetNextOccurrence(fire);

                    var sw = Stopwatch.StartNew();
                    await _work(ct).ConfigureAwait(false);
                    sw.Stop();
                    Logger.Info($"[Cron:{_name}] ran in {sw.ElapsedMilliseconds}ms");
                }
                catch (OperationCanceledException) { throw; }
                catch (Exception ex)
                {
                    Logger.Error($"[Cron:{_name}] job error", ex);
                    // 에러가 나도 다음 사이클로 진행
                }
            }
        }
    }
}
