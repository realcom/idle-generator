using Server.Models;

namespace Server.Events;

public class ItemAddExpEvent : ServerEvent
{
    public override Type EventType => Type.ItemAddExpEvent;

    public PlayerItemModel Item;
    public long Exp;
}
