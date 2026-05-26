using System.Collections.Concurrent;
using Commons.Game.Events;
using Server.Events;
using static Commons.Game.Events.BoardEvent.Type;
using BoardEvent = Server.Events.BoardEvent;

// ReSharper disable once CheckNamespace
namespace Commons.Game;

public partial class GameBoard : IServerEventPublisher
{
    private readonly ConcurrentDictionary<IServerEventSubscriber, byte> _eventSubscribers = new();
    
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
        {
            HandleEvent(@event);
            subscriber.HandleEvent(@event);
        }
    }

    private void HandleEvent(ServerEvent @event)
    {
        switch (@event.EventType)
        {
            case ServerEvent.Type.BoardEvent:
            {
                var boardEvent = ((BoardEvent)@event).Event;
                switch (boardEvent.EventType)
                {
                    case Game.Events.BoardEvent.Type.EndGame:
                    {
                        DestroyNextUpdate = true;
                        break;
                    }
                    case PlayerLeft:
                    {
                        if (DestroyIfNoPlayer && players_.Count == 0)
                        {
                            Logger.Info($"{ToDebugString()} no players, destroying");
                            DestroyNextUpdate = true;
                        }
                        break;
                    }
                }
                break;
            }
        }
    }
}