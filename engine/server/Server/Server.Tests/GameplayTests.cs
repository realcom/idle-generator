using Commons.Game;
using Commons.Game.Interfaces;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Commons.Types.Units;
using Google.Protobuf.WellKnownTypes;
using Server.Managers;
using Server.Player;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class GameplayTests
{
    [Fact]
    public void GameUnit_exp_uses_map_required_exps_for_runtime_level_up()
    {
        const int mapId = 950101;
        const int unitId = 950111;
        using var resources = new TestResourceScope(
            maps:
            [
                new ResourceMap
                {
                    Id = mapId,
                    Type = ResourceMap.Types.Type.Dungeon,
                    EnableUnitExp = true,
                    RequiredExps = { 28, 57, 90 },
                },
            ],
            units:
            [
                new ResourceUnit
                {
                    Id = unitId,
                    Type = ResourceUnit.Types.Type.Player,
                    AddStats =
                    {
                        new AddUnitStat { Type = UnitStatType.Hp, Value = { 520f, 548.6f, 578.773f, 610.606f } },
                        new AddUnitStat { Type = UnitStatType.Attack, Value = { 42f, 44.184f, 46.482f, 48.899f } },
                    },
                },
            ]);

        var board = new GameBoard { DataId = mapId }.Init();
        var unit = new GameUnit
        {
            Id = 1,
            DataId = unitId,
            Level = 1,
            Team = 1,
            Position = new Vector2Message { X = 0, Y = 0 },
        };
        board.AddUnit(unit);

        unit.AddExp(27, applyExpStat: false);
        Assert.Equal(1, unit.Level);
        Assert.Equal(27, unit.Exp);
        Assert.Equal((FixedFloat)42, unit.Attack);

        unit.AddExp(1, applyExpStat: false);
        Assert.Equal(2, unit.Level);
        Assert.Equal(0, unit.Exp);
        Assert.Equal((FixedFloat)44.184f, unit.Attack);

        unit.AddExp(147, applyExpStat: false);
        Assert.Equal(4, unit.Level);
        Assert.Equal(0, unit.Exp);
        Assert.Equal((FixedFloat)48.899f, unit.Attack);
    }

    [Fact]
    public void GameUnit_death_drop_exp_levels_attacker_on_unit_exp_maps()
    {
        const int mapId = 950102;
        const int attackerUnitId = 950112;
        const int enemyUnitId = 950113;
        using var resources = new TestResourceScope(
            maps:
            [
                new ResourceMap
                {
                    Id = mapId,
                    Type = ResourceMap.Types.Type.Dungeon,
                    EnableUnitExp = true,
                    RequiredExps = { 28 },
                },
            ],
            units:
            [
                new ResourceUnit
                {
                    Id = attackerUnitId,
                    Type = ResourceUnit.Types.Type.Player,
                    AddStats =
                    {
                        new AddUnitStat { Type = UnitStatType.Hp, Value = { 520f, 548.6f } },
                        new AddUnitStat { Type = UnitStatType.Attack, Value = { 42f, 44.184f } },
                    },
                },
                new ResourceUnit
                {
                    Id = enemyUnitId,
                    Type = ResourceUnit.Types.Type.Normal,
                    AddStats =
                    {
                        new AddUnitStat { Type = UnitStatType.Hp, Value = { 1f } },
                    },
                    DropAddItemGroups =
                    {
                        new AddItemGroup
                        {
                            ShouldAddAll = true,
                            ProbPercent = 100,
                            AddItems = { new AddItem { ItemDataId = 1, Exp = 28 } },
                        },
                    },
                },
            ]);

        var board = new GameBoard { DataId = mapId }.Init();
        var attacker = new GameUnit
        {
            DataId = attackerUnitId,
            Level = 1,
            Team = 1,
            Position = new Vector2Message { X = 0, Y = 0 },
        };
        var enemy = new GameUnit
        {
            DataId = enemyUnitId,
            Level = 1,
            Team = 2,
            Position = new Vector2Message { X = 1, Y = 0 },
        };
        board.AddUnit(attacker);
        board.AddUnit(enemy);

        enemy.HandleDead(new TestAttackSource(attacker));

        Assert.Equal(2, attacker.Level);
        Assert.Equal(0, attacker.Exp);
        Assert.Equal((FixedFloat)44.184f, attacker.Attack);
    }

    private sealed class TestAttackSource(GameUnit attacker) : IAttackSource
    {
        public long AttackerUnitId => attacker.Id;
        public GameUnit Attacker => attacker;
        public void HandleKill(GameUnit target)
        {
        }
    }

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
    public void ResourceItem_game_speed_multiplier_uses_popup_arg()
    {
        var item = new ResourceItem();
        item.PopupArgs.Add(ResourceItem.GameSpeedMultiplierPopupArg, "2");

        Assert.True(item.TryGetGameSpeedMultiplier(out var multiplier));
        Assert.Equal(2f, multiplier, 3);

        item.PopupArgs[ResourceItem.GameSpeedMultiplierPopupArg] = "999";
        Assert.Equal(ResourceItem.MaxGameSpeedMultiplier, item.GetGameSpeedMultiplier(), 3);
    }

    [Fact]
    public void GameBoard_future_tick_validation_uses_game_speed_multiplier()
    {
        var now = DateTime.UtcNow;
        var board = new GameBoard
        {
            CreatedAt = Timestamp.FromDateTime(now.AddSeconds(-70)),
            GameSpeedMultiplier = 1f,
        };
        var tick = GameBoard.TimeToTicks((FixedFloat)150);

        Assert.True(board.IsTickInFuture(tick, now));

        board.GameSpeedMultiplier = 2f;
        Assert.False(board.IsTickInFuture(tick, now));
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
