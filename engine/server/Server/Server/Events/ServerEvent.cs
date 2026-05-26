namespace Server.Events;

public abstract class ServerEvent
{
    public enum Type
    {
        BoardEvent,
        
        ItemAddedEvent,
        ItemAddExpEvent,
        ItemLevelUpEvent,
        ItemLevelDownEvent,
        ItemCreateEvent,
        ItemUseEvent,
        ItemBuyEvent,
        ItemConsumeEvent,
    }

    public abstract Type EventType { get; }
}
