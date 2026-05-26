using Commons.Resources;
using Server.Models;

namespace Server.Events;

public class ItemConsumeEvent : ServerEvent
{
    public override Type EventType => Type.ItemConsumeEvent;

    public PlayerItemModel Item = null!;
    public int Count;
}