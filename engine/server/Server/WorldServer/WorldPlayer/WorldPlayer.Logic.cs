using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using WorldServer.Managers;
using Server.Models;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    public const int MaxRequestsPerSecond = 32;
    public const int MaxUpdatesPerSecond = 32;
    
    public static double SaveIntervalSeconds => Config.IsDebug ? 5 : 30;
    public const double HandleReceiptsLongIntervalSeconds = 30;
    public const double HandleReceiptsShortIntervalSeconds = 3;
    
    private DateTime _packetCounterAt = DateTime.UtcNow;
    private int _requestCounterThisSecond;
    private int _updateCounterThisSecond;
    
    private DateTime _nextSaveAt = DateTime.UtcNow.AddSeconds(SaveIntervalSeconds);
    private DateTime _nextHandleReceiptsAt = DateTime.UtcNow;
    private DateTime _lastCreateReceiptAt;

    protected override async Task UpdateInternal()
    {
        await base.UpdateInternal().ConfigureAwait(false);
        if (Destroyed)
            return;

        var now = DateTime.UtcNow;
        if (now.Second != _packetCounterAt.Second)
        {
            _packetCounterAt = now;
            _requestCounterThisSecond = 0;
            _updateCounterThisSecond = 0;
        }
        else if (_requestCounterThisSecond >= MaxRequestsPerSecond)
        {
            Logger.Warn($"{this} exceeded MaxRequestsPerSecond");
            await DestroyInternal().ConfigureAwait(false);
            return;
        }
        else if (_updateCounterThisSecond >= MaxUpdatesPerSecond)
        {
            Logger.Warn($"{this} exceeded MaxUpdatesPerSecond");
            await DestroyInternal().ConfigureAwait(false);
            return;
        }
        
        if (now >= _nextHandleReceiptsAt)
        {
            if (now - _lastCreateReceiptAt < TimeSpan.FromSeconds(PlayerReceiptModel.ReceiptValiditySeconds))
                _nextHandleReceiptsAt = DateTime.UtcNow.AddSeconds(HandleReceiptsShortIntervalSeconds);
            else
                _nextHandleReceiptsAt = DateTime.UtcNow.AddSeconds(HandleReceiptsLongIntervalSeconds);
            await HandleReceipts().ConfigureAwait(false);
        }
        
        await CashItemManager.Update().ConfigureAwait(false);
        await CashItemManager.UpdatePerMinute().ConfigureAwait(false);
        await AchievementManager.UpdatePerMinute().ConfigureAwait(false);
        
        if (IsSavePending || now >= _nextSaveAt || CashItemManager.ItemsCreated || _saveQueue.Count > 0)
        {
            IsSavePending = false;
            _nextSaveAt = DateTime.UtcNow.AddSeconds(SaveIntervalSeconds);
            await SaveAsync().ConfigureAwait(false);
        }
    }
    
    private readonly Queue<Action> _savePostProcesses = new();
    internal void QueueSavePostProcess(Action action)
    {
        _savePostProcesses.Enqueue(action);
    }
    
    private Task HandleSavePostProcesses()
    {
        while (_savePostProcesses.TryDequeue(out var action))
            action();
        return Task.CompletedTask;
    }

    protected override async Task PostUpdateInternal()
    {
        await base.PostUpdateInternal();
        UpdatePower();
    }

    protected override async Task SendUpdates()
    {
        await base.SendUpdates().ConfigureAwait(false);
        
        var playerItemUpdate = CashItemManager.GetUpdate();
        if (playerItemUpdate != null)
        {
            var packet = Packet.Pop(GetNextPacketKey(), playerItemUpdate);
            SendPacket(packet);
            if (Config.IsDebug)
                Logger.Info($"{this} sent PlayerItemUpdate");
        }
        
        var playerAvatarUpdate = CashItemManager.GetAvatarUpdate();
        if (playerAvatarUpdate != null)
        {
            var packet = Packet.Pop(GetNextPacketKey(), playerAvatarUpdate);
            SendPacket(packet);
            if (Config.IsDebug)
                Logger.Info($"{this} sent PlayerAvatarUpdate");
        }
        
        var playerAchievementUpdate = AchievementManager.GetUpdate();
        if (playerAchievementUpdate != null)
        {
            var packet = Packet.Pop(GetNextPacketKey(), playerAchievementUpdate);
            SendPacket(packet);
            if (Config.IsDebug)
                Logger.Info($"{this} sent PlayerAchievementUpdate");
        }
    }

    public override void DayReset(DateTime prevDate, DateTime date)
    {
        base.DayReset(prevDate, date);
        Model.day_reset_at = date;
        AchievementManager.DayReset(prevDate, date);
        CashItemManager.DayReset(prevDate, date);
    }

    protected override async Task DestroyInternal()
    {
        if (Destroyed)
            return;
        await base.DestroyInternal().ConfigureAwait(false);
        await SaveAsync(destroyIfFailed: false).ConfigureAwait(false);
        ChatManager.UnsubscribeAll(this);
        // await CashItemManager.ScheduleItemPushes().ConfigureAwait(false);
    }
}
