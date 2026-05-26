using System.Reflection;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class WorldPlayerPowerTests
{
    [Fact]
    public void RecalculatePower_DoesNotThrow_WhenPlayerHasNoStats()
    {
        var harness = new WorldPlayerTestHarness();
        harness.Player.ItemStat.Clear();

        var recalculatePower = typeof(WorldServer.WorldPlayer.WorldPlayer)
            .GetMethod("RecalculatePower", BindingFlags.Instance | BindingFlags.NonPublic)!;

        var exception = Record.Exception(() => recalculatePower.Invoke(harness.Player, null));
        if (exception is TargetInvocationException invocationException)
            exception = invocationException.InnerException;

        Assert.Null(exception);
        Assert.Equal(0, harness.Player.Power);
    }
}
