using Commons.Types.Players;
using Server.Models;
using Server.Stuffs;

namespace Server.Events;

public class ItemAddedEvent : ServerEvent
{
    public override Type EventType => Type.ItemAddedEvent;

    public PlayerItemModel Item = null!;
    public long Count;
    public int Level;
    public TimeSpan? Duration;
    public IList<AddedItemStuff>? AddedItemStuffs = null;
}
