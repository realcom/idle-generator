namespace Server.Events;

public interface IServerEventPublisher
{
    public void Subscribe(IServerEventSubscriber subscriber);
    public void Unsubscribe(IServerEventSubscriber subscriber);
    public void PublishEvent(ServerEvent @event);
}
