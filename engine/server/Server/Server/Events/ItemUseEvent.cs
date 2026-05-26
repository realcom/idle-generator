using Server.Models;

namespace Server.Events;

public class ItemUseEvent : ServerEvent
{
    public override Type EventType => Type.ItemUseEvent;

    public PlayerItemModel Item = null!;
    public int Count;
    public long TargetItemId;
    public int Slot;
    public int Param1;
    public int Param2;
}
