using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text;
using Commons.Packets.Requests;
using Commons.Utility;
using Server.Events;
using Server.Managers;
using Server.Player;

// ReSharper disable once CheckNamespace
namespace Commons.Game;

public partial class GameBoard
{
    public static readonly TimeSpan SemaphoreTimeout = TimeSpan.FromSeconds(5);
    
    public const uint MaxTicksPerUpdate = 1800;
    
    public readonly SemaphoreSlim Semaphore = new(1, 1);

    public float TickSeconds = TickDuration;
    
    private readonly ConcurrentQueue<Action> _serverPostActions = new();
    
    public bool DestroyNextUpdate { get; private set; }
    public bool Destroyed { get; private set; }

    private bool _clearLog;
    
    public void QueueServerPostAction(Action action)
    {
        _serverPostActions.Enqueue(action);
    }
    
    private void HandleServerPostActions()
    {
        while (_serverPostActions.TryDequeue(out var action))
            action();
    }

    private void HandleEvents()
    {
        foreach (var boardEvent in Events)
            PublishEvent(new BoardEvent
            {
                Event = boardEvent,
            });
        ClearEvents();
    }
    
    public void ProgressTick()
    {
        EarlyUpdate();
        HandleInput();
        PostprocessUpdatesAndActions();
        Update();
        PostUpdate();
        // uncomment to enable debug dump
        // if (Config.IsDebug && !Config.IsLinux)
        //     this.SaveDebugDump("HashDump-Server_log.txt", ref _clearLog);
        HandleEvents();
        RecordNoReplayValidationHash();
        HandleServerPostActions();
    }
    
    private async Task ServerUpdate()
    {
        await Semaphore.WaitAsyncWithTimeoutException(SemaphoreTimeout).ConfigureAwait(false);
        try
        {
            if (Destroyed)
                return;
            if (DestroyNextUpdate)
            {
                DestroyInternal();
                return;
            }
            ServerUpdateInternal();
        }
        finally
        {
            Semaphore.Release();
        }
    }
    
    public void ServerUpdateInternal()
    {
        if (AutoProgress)
            ProgressTick();
        else
        {
            if (tick_ >= LastUnhandledTick)
                HandleServerPostActions();
            else
            {
                var tickToUpdate = Math.Min(tick_ + MaxTicksPerUpdate, LastUnhandledTick);
                if (Config.IsDebug && tickToUpdate != LastUnhandledTick)
                    Logger.Warn($"{ToDebugString()} tickToUpdate != LastUnhandledActionTick ({tickToUpdate} != {LastUnhandledTick})");
                while (tick_ < tickToUpdate && !DestroyNextUpdate)
                    ProgressTick();
            }
        }
    }

    public async void Run()
    {
        while (!Destroyed)
        {
            var updateAt = DateTime.UtcNow;
            try
            {
                await ServerUpdate().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                Logger.Error($"GameBoard.ServerUpdate", ex);
            }

            await Task.Delay(Math.Max(10,
                    (int)(updateAt + TimeSpan.FromSeconds(TickSeconds) - DateTime.UtcNow).TotalMilliseconds))
                .ConfigureAwait(false);
        }
    }
    
    public async Task Destroy()
    {
        await Semaphore.WaitAsyncWithTimeoutException(SemaphoreTimeout).ConfigureAwait(false);
        try
        {
            if (Destroyed)
                return;
            Destroyed = true;
            DestroyInternal();
        }
        finally
        {
            Semaphore.Release();
        }
    }
    
    private void DestroyInternal()
    {
        if (Destroyed)
            return;
        Destroyed = true;
        
        ClearPlayers();
        HandleEvents();
        BoardManager.RemoveBoard(this);
        
        Logger.Info($"{ToDebugString()} destroyed");
    }

	public void AutoPlayToTick(uint toTick = 0, Action<StatusCode>? callback = null)
    {
        var maxAutoPlayToTick = TicksPerSecond * 60 * 10;
        if (toTick == 0)
            toTick = maxAutoPlayToTick;
        
        toTick = Math.Min(maxAutoPlayToTick, toTick);
        
        // TODO: check tag for possibility for auto play
        // AutoProgress = true;
        var mainUnit = GetMainPlayerUnit();
        if (mainUnit == null)
        {
            callback?.Invoke(StatusCode.BadRequest);
            return;
        }

        if (state_ < Types.State.Playing)
        {
            callback?.Invoke(StatusCode.BadRequest);
            return;
        }
        while (tick_ < toTick)
        {
            if (Destroyed)
                break;
            ProgressTick();
            if (state_ >= Types.State.Ended)
                break;
            // TODO: Check it is read dead
            if (mainUnit.Destroyed)
            {
                EndGame(Team.Enemy);
                break;
            }    
        }

        if (tick_ >= toTick)
        {
            EndGame(Team.Enemy);
        }

        callback?.Invoke(StatusCode.Ok);
	}
}
