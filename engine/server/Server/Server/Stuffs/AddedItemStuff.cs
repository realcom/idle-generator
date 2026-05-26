using Commons.Types.Players;
using Google.Protobuf.Collections;
using Server.Models;

namespace Server.Stuffs;

public struct AddedItemStuff(PlayerItemModel itemModelReference, PlayerItemMessage item) : IEquatable<AddedItemStuff>
{
    public readonly PlayerItemModel itemModelReference = itemModelReference;
    public readonly PlayerItemMessage item = item;
    
    public bool Equals(AddedItemStuff other)
    {
        return itemModelReference == other.itemModelReference && (ReferenceEquals(item, other.item) || item.Equals(other.item));
    }

    public static bool operator ==(AddedItemStuff left, AddedItemStuff right)
    {
        return left.Equals(right);
    }

    public static bool operator !=(AddedItemStuff left, AddedItemStuff right)
    {
        return !(left == right);
    }

    public static implicit operator PlayerItemMessage(AddedItemStuff stuff)
    {
        stuff.item.Id = stuff.itemModelReference.id;
        return stuff.item;
    }
    
}

public static class AddedItemStuffExtensions
{
    public static IEnumerable<PlayerItemMessage> ToPlayerItemMessages(this IList<AddedItemStuff> addedItemStuffs)
    {
        return addedItemStuffs.Select(x => (PlayerItemMessage)x);
    }
    
}