using System.Collections.Concurrent;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Utility;
using Google.Protobuf;
using Server.Managers;
using Server.Models;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    public static readonly TimeSpan SemaphoreTimeout = TimeSpan.FromSeconds(5);
    
    public SemaphoreSlim Semaphore { get; } = new(1, 1);

    public bool Destroyed { get; private set; }
    
    private readonly ConcurrentQueue<Packet> _packets = new();

    public async void Run()
    {
        while (!Destroyed)
        {
            var updateAt = DateTime.UtcNow;
            try
            {
                await Update().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                Logger.Error($"{typeof(TPlayer)}.Update", ex);
            }

            await Task.Delay(Math.Max(10,
                    (int)(updateAt + TimeSpan.FromSeconds(TickSeconds) - DateTime.UtcNow).TotalMilliseconds))
                .ConfigureAwait(false);
        }
    }
    
    private async Task Update()
    {
        await Semaphore.WaitAsyncWithTimeoutException(SemaphoreTimeout).ConfigureAwait(false);
        try
        {
            if (Destroyed)
                return;
            await UpdateInternal().ConfigureAwait(false);
            if (Destroyed)
                return;
            await PostUpdateInternal().ConfigureAwait(false);
            if (UpdateMaintenance())
            {
                await DestroyInternal().ConfigureAwait(false);
                return;
            }
        }
        finally
        {
            Semaphore.Release();
        }
    }
    
    protected virtual async Task UpdateInternal()
    {
        await ProcessPackets().ConfigureAwait(false);
        if (Destroyed)
            return;

        HandleEvents();
        
        var now = DateTime.UtcNow;
        
        if (now >= _lastPingAt + TimeSpan.FromSeconds(PingIntervalSeconds))
            SendPing();
        
        if (now >= _lastPacketAt + TimeSpan.FromSeconds(DestroyTimeoutSeconds))
        {
            await DestroyInternal().ConfigureAwait(false);
            return;
        }
        
        
        var world = WorldManager.GetWorldById(model.world_id); // 실제 구현에 맞게 Account, WorldManager 사용
        int utcOffsetHours = world?.utc_offset_hours ?? 0;

        // 오프셋 적용된 서버 시간 계산
        var nowServerDate = now.AddHours(utcOffsetHours).Date;
        var lastResetDate = Model.day_reset_at.AddHours(utcOffsetHours).Date;

        if (nowServerDate != lastResetDate)
        {
            DayReset(lastResetDate, nowServerDate);
            Logger.Info($"{this} DayReset {lastResetDate} -> {nowServerDate}");
        }
    }
    
    protected virtual async Task PostUpdateInternal()
    {
        await SendUpdates().ConfigureAwait(false);
    }

    protected virtual async Task SendUpdates()
    {
    }

    public virtual void DayReset(DateTime prevDate, DateTime date)
    {
        PlayerLogManager.Queue(PlayerLogModel.Type.DayReset, new
        {
            PrevDate = prevDate,
            Date = date,
        });
    }
    
    public async Task Destroy()
    {
        await Semaphore.WaitAsyncWithTimeoutException(SemaphoreTimeout).ConfigureAwait(false);
        try
        {
            if (Destroyed)
                return;
            await DestroyInternal().ConfigureAwait(false);
        }
        finally
        {
            Semaphore.Release();
        }
    }
    
    protected virtual async Task DestroyInternal()
    {
        if (Destroyed)
            return;
        Destroyed = true;
        
        if (Board != null)
            BoardManager.LeaveBoard(this);
        
        Server.RemovePlayer((TPlayer)this);
        Session?.Close();
    }
}
