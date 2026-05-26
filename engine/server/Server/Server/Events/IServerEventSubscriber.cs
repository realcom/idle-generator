namespace Server.Events;

public interface IServerEventSubscriber
{
    public void HandleEvent(ServerEvent @event);
}
