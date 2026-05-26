using Commons.Game;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Server.Managers;
using Server.Player;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class GameplayTests
{
    [Fact]
    public void BoardValidationProbe_round_trips_tick_and_hash_parts()
    {
        const uint tick = 0x1234_5678;
        const int hash = unchecked((int)0xABCD_2468);

        var payload = BoardValidationProbe.Encode(tick, hash);

        Assert.Equal((ushort)0x5678, BoardValidationProbe.DecodeTickPart(payload));
        Assert.Equal(unchecked((ushort)0x2468), BoardValidationProbe.DecodeHashPart(payload));
        Assert.Equal(unchecked((ushort)tick), BoardValidationProbe.GetTickPart(tick));
        Assert.Equal(unchecked((ushort)hash), BoardValidationProbe.GetHashPart(hash));
    }

    [Fact]
    public void GameBoard_tick_conversion_helpers_are_consistent()
    {
        Assert.Equal((uint)30, GameBoard.TimeToTicks((FixedFloat)1));
        Assert.Equal((uint)1, GameBoard.TimeToTicksDuration((FixedFloat)0.001));
        Assert.InRange((float)GameBoard.TicksToTime(75), 2.5f, 2.501f);
    }

    [Fact]
    public void ResourceMap_sync_settings_use_defaults_and_popup_overrides()
    {
        var dungeon = new ResourceMap
        {
            Type = ResourceMap.Types.Type.Dungeon,
        };
        Assert.Equal(ResourceMap.BoardSyncMode.NoReplay, dungeon.GetBoardSyncMode());
        Assert.Equal(0.35f, dungeon.GetBoardValidationSamplingRate(), 3);
        Assert.Equal(5f, dungeon.GetBoardValidationSamplingIntervalSeconds(), 3);

        var replayMap = new ResourceMap
        {
            Type = ResourceMap.Types.Type.Lobby,
        };
        replayMap.PopupArgs.Add(ResourceMap.BoardSyncModePopupArg, "replay");
        replayMap.PopupArgs.Add(ResourceMap.BoardValidationSamplingRatePopupArg, "125");
        replayMap.PopupArgs.Add(ResourceMap.BoardValidationSamplingIntervalSecondsPopupArg, "0.25");

        Assert.Equal(ResourceMap.BoardSyncMode.Replay, replayMap.GetBoardSyncMode());
        Assert.Equal(0f, replayMap.GetBoardValidationSamplingRate());
        Assert.Equal(5f, replayMap.GetBoardValidationSamplingIntervalSeconds(), 3);

        replayMap.PopupArgs[ResourceMap.BoardSyncModePopupArg] = "single-player";
        Assert.Equal(ResourceMap.BoardSyncMode.NoReplay, replayMap.GetBoardSyncMode());
        Assert.Equal(1f, replayMap.GetBoardValidationSamplingRate(), 3);
        Assert.Equal(1f, replayMap.GetBoardValidationSamplingIntervalSeconds(), 3);
    }

    [Fact]
    public void BoardManager_can_join_board_requires_enough_qualified_units()
    {
        const int unitItemDataId = 1001;
        const int mapDataId = 2001;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = unitItemDataId,
                    Category = ResourceItem.Types.Category.Unit,
                    Type = ResourceItem.Types.Type.Passive,
                    Unstackable = true,
                    MaxStamina = 10,
                    StaminaRegenPerSecond = 1,
                },
            ],
            maps:
            [
                new ResourceMap
                {
                    Id = mapDataId,
                    Type = ResourceMap.Types.Type.Lobby,
                    PlayerUnitCount = 2,
                    RequiredUnitStamina = 5,
                },
            ]);

        var previousServer = BoardManager.Server;
        BoardManager.Server = new TestBoardServer();
        try
        {
            var harness = new WorldPlayerTestHarness();
            harness.Manager.AddItem(unitItemDataId, 1);
            harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(unitItemDataId));
            var unit = Assert.Single(harness.Manager.GetItemsByDataId(unitItemDataId));
            unit.param1 = 5;
            unit.param3 = 1;

            harness.Player.Avatar.Units.Add(new PlayerItemMessage
            {
                Id = unit.id,
                ItemDataId = unitItemDataId,
            });

            var board = new GameBoard
            {
                DataId = mapDataId,
            };
            board.CacheResMap();

            var status = BoardManager.CanJoinBoard(board, harness.Player);

            Assert.Equal(StatusCode.ItemNotEnoughStamina, status);

            harness.Manager.AddItem(unitItemDataId, 1);
            harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(unitItemDataId));
            var secondUnit = harness.Manager.GetItemsByDataId(unitItemDataId).Single(i => i.id != unit.id);
            secondUnit.param1 = 5;
            secondUnit.param3 = 1;
            harness.Player.Avatar.Units.Add(new PlayerItemMessage
            {
                Id = secondUnit.id,
                ItemDataId = unitItemDataId,
            });

            Assert.Equal(StatusCode.Ok, BoardManager.CanJoinBoard(board, harness.Player));
        }
        finally
        {
            BoardManager.Server = previousServer;
        }
    }

    private sealed class TestBoardServer(bool onMaintenance = false) : IServer
    {
        public bool OnMaintenance { get; } = onMaintenance;

        public IPlayer? GetIPlayerById(long id)
        {
            return null;
        }
    }
}
