using System.Collections.Concurrent;
using Commons.Game.Events;
using Commons.Packets.Requests;
using Server.Events;
using Server.Managers;
using static Commons.Game.Events.BoardEvent.Type;
using BoardEvent = Server.Events.BoardEvent;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    private readonly ConcurrentDictionary<IServerEventSubscriber, byte> _eventSubscribers = new();
    private readonly ConcurrentQueue<ServerEvent> _queuedEvents = new();

    public void Subscribe(IServerEventSubscriber subscriber)
    {
        _eventSubscribers[subscriber] = 1;
    }

    public void Unsubscribe(IServerEventSubscriber subscriber)
    {
        _eventSubscribers.TryRemove(subscriber, out _);
    }

    public void PublishEvent(ServerEvent @event)
    {
        foreach (var subscriber in _eventSubscribers.Keys)
            subscriber.HandleEvent(@event);
    }

    public void HandleEvent(ServerEvent @event)
    {
        _queuedEvents.Enqueue(@event);
    }

    protected virtual void HandleEventInternal(ServerEvent @event)
    {
        PublishEvent(@event);
        switch (@event.EventType)
        {
            case ServerEvent.Type.BoardEvent:
            {
                var boardEvent = ((BoardEvent)@event).Event;
                switch (boardEvent.EventType)
                {
                    case PlayerMoveBoard:
                    {
                        var playerMoveBoard = (PlayerMoveBoardEvent)boardEvent;
                        if (playerMoveBoard.PlayerId != 0L && playerMoveBoard.PlayerId != Id)
                            break;
                        
                        BoardManager.LeaveBoard(this, true, status =>
                        {
                            if (status.IsSuccess() && playerMoveBoard.MapDataId != 0)
                                BoardManager.JoinBoardByMapDataId(this, playerMoveBoard.MapDataId);
                        });

                        break;
                    }
                }
                break;
            }
        }
    }

    private void HandleEvents()
    {
        while (_queuedEvents.TryDequeue(out var @event))
        {
            try
            {
                HandleEventInternal(@event);
            }
            catch (Exception ex)
            {
                Logger.Error($"{typeof(TPlayer)}.HandleEvent failed", ex);
            }
        }
    }
}
