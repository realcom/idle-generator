using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Google.Protobuf;
using Server.Models;
using Server.Utility;
using Xunit;

namespace Server.Tests;

public sealed class MaterialItemExtensionsTests
{
    [Fact]
    public void IsValid_rejects_missing_or_not_consumable_items()
    {
        using var _ = new ResourceItemScope(CreateResourceItem(1000));

        var material = new MaterialItem { Id = 1000, Count = 1 };
        Assert.False(material.IsValid(null));

        var item = new PlayerItemModel(1, 1000, count: 1, level: 1);
        item.AddFlag(PlayerItemMessage.State.InUse);

        Assert.False(material.IsValid(item));
    }

    [Fact]
    public void IsValid_counts_param1_when_item_uses_add_param1_to_count()
    {
        using var _ = new ResourceItemScope(CreateResourceItem(1000, Tag.AddParam1ToCount));

        var material = new MaterialItem { Id = 1000, Count = 10 };
        var item = new PlayerItemModel(1, 1000, count: 7, level: 1)
        {
            param1 = 4,
        };

        Assert.True(material.IsValid(item));
        Assert.True(material.IsValid(item, requiredCount: 11));
        Assert.False(material.IsValid(item, requiredCount: 12));
    }

    [Fact]
    public void IsValid_respects_min_and_max_level_bounds()
    {
        using var _ = new ResourceItemScope(CreateResourceItem(1000));

        var material = new MaterialItem
        {
            Id = 1000,
            Count = 1,
            MinLevel = 2,
            MaxLevel = 3,
        };

        Assert.False(material.IsValid(new PlayerItemModel(1, 1000, count: 1, level: 1)));
        Assert.True(material.IsValid(new PlayerItemModel(1, 1000, count: 1, level: 2)));
        Assert.False(material.IsValid(new PlayerItemModel(1, 1000, count: 1, level: 4)));
    }

    private static ResourceItem CreateResourceItem(int id, params Tag[] tags)
    {
        var item = new ResourceItem { Id = id };
        foreach (var tag in tags)
            item.Tags.Add(tag);
        return item;
    }

    private sealed class ResourceItemScope : IDisposable
    {
        public ResourceItemScope(params ResourceItem[] items)
        {
            Load(items);
        }

        public void Dispose()
        {
            Load();
        }

        private static void Load(params ResourceItem[] items)
        {
            var resources = new Resources
            {
                ItemGlobal = new ResourceItem.Types.Global(),
            };
            resources.Items.Add(items);
            ResourceItem.ReloadBinary(resources.ToByteArray());
        }
    }
}
