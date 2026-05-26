using Commons.Types.Players;
using Server.Models;
using Server.Stuffs;
using Xunit;

namespace Server.Tests;

public sealed class AddedItemStuffTests
{
    [Fact]
    public void Equality_uses_model_reference_and_item_value()
    {
        var model = new PlayerItemModel(1, 1000) { id = 42 };
        var sameValueItem = new PlayerItemMessage
        {
            ItemDataId = 1000,
            Count = 3,
            Level = 2,
        };

        var left = new AddedItemStuff(model, sameValueItem);
        var right = new AddedItemStuff(model, sameValueItem.Clone());
        var otherModel = new AddedItemStuff(new PlayerItemModel(1, 1000) { id = 42 }, sameValueItem.Clone());

        Assert.Equal(left, right);
        Assert.True(left == right);
        Assert.NotEqual(left, otherModel);
        Assert.True(left != otherModel);
    }

    [Fact]
    public void Implicit_conversion_sets_message_id_from_model()
    {
        var model = new PlayerItemModel(1, 1000) { id = 77 };
        var message = new PlayerItemMessage
        {
            ItemDataId = 1000,
            Count = 1,
        };

        var stuff = new AddedItemStuff(model, message);
        PlayerItemMessage converted = stuff;

        Assert.Same(message, converted);
        Assert.Equal(77, converted.Id);
    }
}
