using Commons.Resources;
using Server.Models;

namespace Server.Events;

public class ItemCreateEvent : ServerEvent
{
    public override Type EventType => Type.ItemCreateEvent;

    public ResourceItem ResRecipeItem = null!;
    public int Count;
}
