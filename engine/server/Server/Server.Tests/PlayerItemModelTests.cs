using Commons.Types.Players;
using Server.Models;
using Xunit;

namespace Server.Tests;

public sealed class PlayerItemModelTests
{
    [Fact]
    public void AddFlag_and_RemoveFlag_are_idempotent()
    {
        var model = new PlayerItemModel(1, 1000);
        model.OnSave();

        var added = model.AddFlag(PlayerItemMessage.State.InUse);
        Assert.True(model.Dirty);
        Assert.Equal(PlayerItemMessage.State.InUse, added);
        Assert.True(model.HasFlag(PlayerItemMessage.State.InUse));

        model.OnSave();
        model.AddFlag(PlayerItemMessage.State.InUse);
        Assert.False(model.Dirty);

        var removed = model.RemoveFlag(PlayerItemMessage.State.InUse);
        Assert.True(model.Dirty);
        Assert.Equal(PlayerItemMessage.State.None, removed);
        Assert.False(model.HasFlag(PlayerItemMessage.State.InUse));

        model.OnSave();
        model.RemoveFlag(PlayerItemMessage.State.InUse);
        Assert.False(model.Dirty);
    }

    [Fact]
    public void OptionScope_marks_option_dirty_and_serializes_before_save()
    {
        var model = new PlayerItemModel(1, 1000);
        model.OnSave();

        var scope = model.GetOptionScope();
        scope.Option.ProductOption = new PlayerItemOption.Types.ProductOption
        {
            MultiplyBonusCount = 7,
        };
        scope.Dispose();

        Assert.True(model.Dirty);

        model.BeforeSave();

        Assert.NotNull(model.option);

        var message = model.ToMessage();
        Assert.NotNull(message.Option);
        Assert.Equal(7, message.Option!.ProductOption.MultiplyBonusCount);

        var messageWithoutOption = model.ToMessage(includeOption: false);
        Assert.Null(messageWithoutOption.Option);
    }
}
