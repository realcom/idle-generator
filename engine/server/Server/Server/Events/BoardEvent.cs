namespace Server.Events;

public class BoardEvent : ServerEvent
{
    public override Type EventType => Type.BoardEvent;

    public Commons.Game.Events.BoardEvent Event;
}
