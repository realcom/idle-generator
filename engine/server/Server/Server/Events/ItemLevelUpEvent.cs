using Server.Models;

namespace Server.Events;

public class ItemLevelUpEvent : ServerEvent
{
    public override Type EventType => Type.ItemLevelUpEvent;

    public PlayerItemModel Item = null!;
    public int Count;
}
