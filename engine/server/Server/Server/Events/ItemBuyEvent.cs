using Commons.Resources;
using Server.Models;

namespace Server.Events;

public class ItemBuyEvent : ServerEvent
{
    public override Type EventType => Type.ItemBuyEvent;

    public ResourceItem ResProductItem = null!;
    public int Count;
}
