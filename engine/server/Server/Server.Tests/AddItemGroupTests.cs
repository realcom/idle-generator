using Commons.Types;
using Xunit;

namespace Server.Tests;

public sealed class AddItemGroupTests
{
    [Fact]
    public void AddItem_rng_ranges_are_inclusive_min_max()
    {
        var addItem = new AddItem
        {
            MinCount = 8,
            MaxCount = 15,
            MinLevel = 2,
            MaxLevel = 4,
            MinExp = 100,
            MaxExp = 120,
        };

        for (var seed = 1u; seed <= 100u; seed++)
        {
            var rng = new Rng(seed);

            Assert.InRange(addItem.GetCount(rng), 8, 15);
            Assert.InRange(addItem.GetLevel(rng), 2, 4);
            Assert.InRange(addItem.GetExp(rng), 100, 120);
        }
    }
}
