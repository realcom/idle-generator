using Server.Models;

namespace Server.Events;

public class ItemLevelDownEvent : ServerEvent
{
    public override Type EventType => Type.ItemLevelDownEvent;
    
    public PlayerItemModel Item = null!;
}