using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Tests.TestSupport;
using Xunit;

namespace Server.Tests;

public sealed class ItemManagerTests
{
    [Fact]
    public async Task DisposeItem_request_removes_disposable_items_and_returns_response()
    {
        const int disposableItemId = 1001;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = disposableItemId,
                    Category = ResourceItem.Types.Category.Material,
                    Disposable = true,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(disposableItemId, 2);
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(disposableItemId));
        var item = Assert.Single(harness.Manager.GetItemsByDataId(disposableItemId));

        using var packet = Packet.Pop(0x10, new DisposeItemRequest
        {
            ItemId = item.id,
            Count = 2,
        });
        packet.Request.Id = 77;

        Assert.True(await harness.Player.HandlePacket(packet));

        var response = Assert.IsType<Packet>(harness.Channel.ReadOutbound<Packet>());
        try
        {
            Assert.Equal(Request.RequestOneofCase.DisposeItemResponse, response.Request.RequestCase);
            Assert.Equal(77L, response.Request.Id);
            Assert.Equal(StatusCode.Ok, response.Request.DisposeItemResponse.Status);
        }
        finally
        {
            response.Dispose();
        }

        Assert.Equal(0, item.count);
    }

    [Fact]
    public void RemoveItem_uses_param1_overflow_for_add_param1_to_count_items()
    {
        const int itemDataId = 1001;

        using var resources = new TestResourceScope(
            items:
            [
                CreateItem(itemDataId, category: ResourceItem.Types.Category.Material, tags: [Tag.AddParam1ToCount]),
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(itemDataId, 3);
        var item = Assert.Single(harness.Manager.GetItemsByDataId(itemDataId));
        item.param1 = 4;

        Assert.Equal(StatusCode.Ok, harness.Manager.RemoveItem(item, 5));
        Assert.Equal(0, item.count);
        Assert.Equal(2, item.param1);
    }

    [Fact]
    public void TryConsumeMaterials_supports_any_of_group_and_unstackable_requirements()
    {
        const int stackableMaterialId = 1001;
        const int unstackableMaterialId = 1002;

        using var resources = new TestResourceScope(
            items:
            [
                CreateItem(stackableMaterialId, category: ResourceItem.Types.Category.Material),
                CreateItem(unstackableMaterialId, category: ResourceItem.Types.Category.Material, unstackable: true),
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(stackableMaterialId, 5);
        harness.Manager.AddItem(unstackableMaterialId, 2);
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(stackableMaterialId));
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(unstackableMaterialId));

        var anyOfGroup = new MaterialItemGroup
        {
            ShouldAllValid = false,
            MaterialItems =
            {
                new MaterialItem { Id = 9999, Count = 1 },
                new MaterialItem { Id = stackableMaterialId, Count = 3 },
            }
        };

        var unstackableGroup = new MaterialItemGroup
        {
            ShouldAllValid = true,
            MaterialItems =
            {
                new MaterialItem { Id = unstackableMaterialId, Count = 2 },
            }
        };

        var status = harness.Manager.TryConsumeMaterials(out var selected, [anyOfGroup, unstackableGroup]);

        Assert.Equal(StatusCode.Ok, status);
        var selectedList = selected.ToList();
        Assert.Contains(selectedList, entry => entry.Item1.item_data_id == stackableMaterialId && entry.Item2 == 3);
        Assert.Equal(2, selectedList.Count(entry => entry.Item1.item_data_id == unstackableMaterialId && entry.Item2 == 1));
    }

    [Fact]
    public void ValidationAchievements_enforces_required_and_exclusive_items_and_tags()
    {
        const int requiredItemId = 1001;
        const int exclusiveItemId = 1002;
        const int tagItemId = 1003;
        const int productId = 1004;

        using var resources = new TestResourceScope(
            items:
            [
                CreateItem(requiredItemId, category: ResourceItem.Types.Category.Material),
                CreateItem(exclusiveItemId, category: ResourceItem.Types.Category.Material),
                CreateItem(tagItemId, category: ResourceItem.Types.Category.Material, tags: [Tag.SkipPossible]),
                new ResourceItem
                {
                    Id = productId,
                    Category = ResourceItem.Types.Category.Product,
                    RequiredItemDataIds = { requiredItemId },
                    ExclusiveItemDataIds = { exclusiveItemId },
                    RequiredItemTags = { Tag.SkipPossible },
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(requiredItemId, 1);
        harness.Manager.AddItem(tagItemId, 1);

        var product = ResourceItem.Get(productId)!;
        Assert.Equal(StatusCode.Ok, harness.Manager.ValidationAchievements(product, StatusCode.ItemNotBuyable));

        harness.Manager.AddItem(exclusiveItemId, 1);
        Assert.Equal(StatusCode.ItemNotBuyable, harness.Manager.ValidationAchievements(product, StatusCode.ItemNotBuyable));
    }

    [Fact]
    public void GetBuyItemPredictionResult_rejects_paid_products_and_reprocess_cooldowns()
    {
        const int paidProductId = 1001;
        const int cooldownProductId = 1002;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = paidProductId,
                    Category = ResourceItem.Types.Category.Product,
                    PriceUsd = 4.99f,
                },
                new ResourceItem
                {
                    Id = cooldownProductId,
                    Category = ResourceItem.Types.Category.Product,
                    ReprocessableDelayMinutes = 30,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(cooldownProductId, 1);
        var cooldownItem = Assert.Single(harness.Manager.GetItemsByDataId(cooldownProductId));
        cooldownItem.param2 = DateTime.UtcNow.AddMinutes(5).ToOffsetTime();

        Assert.Equal(StatusCode.ItemNotBuyable, harness.Manager.GetBuyItemPredictionResult(ResourceItem.Get(paidProductId)!, 1).status);
        Assert.Equal(StatusCode.ItemNotBuyable, harness.Manager.GetBuyItemPredictionResult(ResourceItem.Get(cooldownProductId)!, 1).status);
    }

    [Fact]
    public void BuyItem_consumes_materials_adds_rewards_and_emits_acquired_items_update()
    {
        const int materialId = 1001;
        const int rewardId = 1002;
        const int productId = 1003;

        using var resources = new TestResourceScope(
            items:
            [
                CreateItem(materialId, category: ResourceItem.Types.Category.Material),
                CreateItem(rewardId, category: ResourceItem.Types.Category.Material),
                new ResourceItem
                {
                    Id = productId,
                    Category = ResourceItem.Types.Category.Product,
                    ProductMaterialItemGroups =
                    {
                        new MaterialItemGroup
                        {
                            ShouldAllValid = true,
                            MaterialItems =
                            {
                                new MaterialItem { Id = materialId, Count = 2 },
                            }
                        },
                    },
                    AddItemGroups =
                    {
                        new AddItemGroup
                        {
                            ShouldAddAll = true,
                            AddItems =
                            {
                                new AddItem { ItemDataId = rewardId, Count = 1 },
                            }
                        },
                    },
                },
            ]);

        var harness = new WorldPlayerTestHarness(sentLoginResponse: true);
        harness.Manager.AddItem(materialId, 5);

        var consumed = new List<PlayerItemMessage>();
        var status = harness.Manager.BuyItem(productId, 1, out var multiplier, consumed);

        Assert.Equal(StatusCode.Ok, status);
        Assert.Equal(1, multiplier);
        Assert.Single(consumed);
        Assert.Equal(2, consumed[0].Count);

        var material = Assert.Single(harness.Manager.GetItemsByDataId(materialId));
        Assert.Equal(3, material.count);

        var reward = Assert.Single(harness.Manager.GetItemsByDataId(rewardId));
        Assert.Equal(1, reward.count);

        var outbound = Assert.IsType<Packet>(harness.Channel.ReadOutbound<Packet>());
        try
        {
            Assert.Equal(Update.UpdateOneofCase.PlayerAcquiredItemsUpdate, outbound.Update.UpdateCase);
            var update = outbound.Update.PlayerAcquiredItemsUpdate;
            Assert.Equal(PlayerAcquiredItemsUpdate.Types.Type.BuyProduct, update.Type);
            Assert.Equal(productId, update.ProductItemDataId);
            Assert.Single(update.Items);
            Assert.Equal(rewardId, update.Items[0].ItemDataId);
        }
        finally
        {
            outbound.Dispose();
        }
    }

    [Fact]
    public void BuyItem_applies_progressive_material_price()
    {
        const int materialId = 1001;
        const int rewardId = 1002;
        const int productId = 1003;

        using var resources = new TestResourceScope(
            items:
            [
                CreateItem(materialId, category: ResourceItem.Types.Category.Material),
                CreateItem(rewardId, category: ResourceItem.Types.Category.Material),
                new ResourceItem
                {
                    Id = productId,
                    Category = ResourceItem.Types.Category.Product,
                    RegenPeriod = 5,
                    RegenCount = 5,
                    ProductMaterialItemGroups =
                    {
                        new MaterialItemGroup
                        {
                            ShouldAllValid = true,
                            MaterialItems =
                            {
                                new MaterialItem { Id = materialId, Count = 10 },
                            }
                        },
                    },
                    AddItemGroups =
                    {
                        new AddItemGroup
                        {
                            ShouldAddAll = true,
                            AddItems =
                            {
                                new AddItem { ItemDataId = rewardId, Count = 1 },
                            }
                        },
                    },
                },
            ]);

        var harness = new WorldPlayerTestHarness(sentLoginResponse: true);
        harness.Manager.AddItem(materialId, 100);

        for (var i = 0; i < 5; i++)
        {
            var consumed = new List<PlayerItemMessage>();
            Assert.Equal(StatusCode.Ok, harness.Manager.BuyItem(productId, 1, out _, consumed));
            Assert.Single(consumed);
            Assert.Equal(10, consumed[0].Count);
        }

        var sixthConsumed = new List<PlayerItemMessage>();
        Assert.Equal(StatusCode.Ok, harness.Manager.BuyItem(productId, 1, out _, sixthConsumed));
        Assert.Single(sixthConsumed);
        Assert.Equal(15, sixthConsumed[0].Count);

        var material = Assert.Single(harness.Manager.GetItemsByDataId(materialId));
        Assert.Equal(35, material.count);

        var reward = Assert.Single(harness.Manager.GetItemsByDataId(rewardId));
        Assert.Equal(6, reward.count);

        var product = Assert.Single(harness.Manager.GetItemsByDataId(productId));
        using var optionScope = product.GetOptionScope();
        Assert.Equal(6, optionScope.Option.ProductOption?.MultiplyBonusCount);
    }

    [Fact]
    public void UseItem_add_stamina_utility_caps_target_unit_and_consumes_item()
    {
        const int unitItemDataId = 1001;
        const int addStaminaItemDataId = 1002;

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
                new ResourceItem
                {
                    Id = addStaminaItemDataId,
                    Category = ResourceItem.Types.Category.Utility,
                    Type = ResourceItem.Types.Type.AddStamina,
                    Stamina = 4,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(unitItemDataId, 1);
        harness.Manager.AddItem(addStaminaItemDataId, 1);
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(unitItemDataId));
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(addStaminaItemDataId));

        var unit = Assert.Single(harness.Manager.GetItemsByDataId(unitItemDataId));
        var staminaItem = Assert.Single(harness.Manager.GetItemsByDataId(addStaminaItemDataId));
        unit.param1 = 7;

        Assert.Equal(StatusCode.Ok, harness.Manager.UseItem(staminaItem, targetItemId: unit.id));
        Assert.Equal(10, unit.param1);
        Assert.Equal(0, staminaItem.count);
    }

    [Fact]
    public void LevelUpItem_consumes_materials_and_increases_level()
    {
        const int targetItemId = 1001;
        const int materialId = 1002;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = targetItemId,
                    Category = ResourceItem.Types.Category.Material,
                    LevelUpMaterialItemGroups =
                    {
                        new MaterialItemGroup
                        {
                            Level = 1,
                            ShouldAllValid = true,
                            MaterialItems =
                            {
                                new MaterialItem { Id = materialId, Count = 2 },
                            }
                        },
                    },
                },
                CreateItem(materialId, category: ResourceItem.Types.Category.Material),
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(targetItemId, 1);
        harness.Manager.AddItem(materialId, 5);

        var target = Assert.Single(harness.Manager.GetItemsByDataId(targetItemId));
        var consumed = new List<PlayerItemMessage>();

        Assert.Equal(StatusCode.Ok, harness.Manager.LevelUpItem(target, consumed));
        Assert.Equal(2, target.level);
        Assert.Single(consumed);
        Assert.Equal(2, consumed[0].Count);
        Assert.Equal(3, harness.Manager.GetItemsByDataId(materialId).Single().count);
    }

    [Fact]
    public void RefreshAvatar_keeps_equipment_level_when_slot_root_is_absent()
    {
        const int equipmentItemDataId = 1001;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = equipmentItemDataId,
                    Category = ResourceItem.Types.Category.Equipment,
                    Type = ResourceItem.Types.Type.Head,
                    Unstackable = true,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        Assert.Equal(StatusCode.Ok, harness.Manager.AddItem(equipmentItemDataId, level: 4));
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(equipmentItemDataId));

        var equipment = Assert.Single(harness.Manager.GetItemsByDataId(equipmentItemDataId));
        harness.Manager.Avatar.Equipments.Add(equipment.ToMessage());

        harness.Manager.RefreshAvatar();

        Assert.Equal(4, equipment.level);
        Assert.Equal(4, Assert.Single(harness.Manager.Avatar.Equipments).Level);
    }

    [Fact]
    public void RefreshAvatar_uses_slot_root_level_when_matching_slot_root_exists()
    {
        const int equipmentItemDataId = 1001;
        const int slotRootItemDataId = 1002;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = equipmentItemDataId,
                    Category = ResourceItem.Types.Category.Equipment,
                    Type = ResourceItem.Types.Type.Head,
                    Unstackable = true,
                },
                new ResourceItem
                {
                    Id = slotRootItemDataId,
                    Category = ResourceItem.Types.Category.SlotRoot,
                    Type = ResourceItem.Types.Type.Head,
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        Assert.Equal(StatusCode.Ok, harness.Manager.AddItem(equipmentItemDataId, level: 4));
        Assert.Equal(StatusCode.Ok, harness.Manager.AddItem(slotRootItemDataId, level: 7));
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(equipmentItemDataId));
        harness.AssignTransientItemIds(harness.Manager.GetItemsByDataId(slotRootItemDataId));

        var equipment = Assert.Single(harness.Manager.GetItemsByDataId(equipmentItemDataId));
        harness.Manager.Avatar.Equipments.Add(equipment.ToMessage());

        harness.Manager.RefreshAvatar();

        Assert.Equal(4, equipment.level);
        Assert.Equal(7, Assert.Single(harness.Manager.Avatar.Equipments).Level);
    }

    [Fact]
    public void AddItem_rolls_initial_options_for_unstackable_equipment()
    {
        const int equipmentItemDataId = 1001;
        const int firstOptionId = 9001;
        const int secondOptionId = 9002;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = equipmentItemDataId,
                    Category = ResourceItem.Types.Category.Equipment,
                    Type = ResourceItem.Types.Type.Head,
                    Unstackable = true,
                    OptionCounts = { 2 },
                    Options =
                    {
                        new ItemOptionGroup
                        {
                            Options =
                            {
                                new ItemOption
                                {
                                    Id = firstOptionId,
                                    MinLevel = 2,
                                    MaxLevel = 2,
                                },
                                new ItemOption
                                {
                                    Id = secondOptionId,
                                    MinLevel = 2,
                                    MaxLevel = 2,
                                },
                            },
                        },
                    },
                },
            ]);

        var harness = new WorldPlayerTestHarness();

        Assert.Equal(StatusCode.Ok, harness.Manager.AddItem(equipmentItemDataId, 1));

        var equipment = Assert.Single(harness.Manager.GetItemsByDataId(equipmentItemDataId));
        using var optionScope = equipment.GetOptionScope();
        var rolledOptions = optionScope.Option.RerollOptions;

        Assert.Equal(2, rolledOptions.Count);
        Assert.All(rolledOptions, option =>
        {
            Assert.Contains(option.Id, new[] { firstOptionId, secondOptionId });
            Assert.Equal(2, option.Level);
            Assert.Equal(1, option.PoolId);
        });
    }

    [Fact]
    public void LevelDownItem_refunds_only_should_all_valid_materials_and_stops_at_level_one()
    {
        const int targetItemId = 1001;
        const int refundId = 1002;
        const int nonRefundId = 1003;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = targetItemId,
                    Category = ResourceItem.Types.Category.Material,
                    LevelUpMaterialItemGroups =
                    {
                        new MaterialItemGroup
                        {
                            Level = 1,
                            ShouldAllValid = true,
                            MaterialItems =
                            {
                                new MaterialItem { Id = refundId, Count = 2 },
                            }
                        },
                        new MaterialItemGroup
                        {
                            Level = 2,
                            ShouldAllValid = false,
                            MaterialItems =
                            {
                                new MaterialItem { Id = nonRefundId, Count = 9 },
                            }
                        },
                    },
                },
                CreateItem(refundId, category: ResourceItem.Types.Category.Material),
                CreateItem(nonRefundId, category: ResourceItem.Types.Category.Material),
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(targetItemId, 1, level: 3);

        var target = Assert.Single(harness.Manager.GetItemsByDataId(targetItemId));
        var added = new List<Server.Stuffs.AddedItemStuff>();

        Assert.Equal(StatusCode.Ok, harness.Manager.LevelDownItem(target, count: 5, addedItemStuffs: added));
        Assert.Equal(1, target.level);
        Assert.Equal(2, harness.Manager.GetItemsByDataId(refundId).Single().count);
        Assert.Empty(harness.Manager.GetItemsByDataId(nonRefundId));
    }

    [Fact]
    public void RerollItemOption_consumes_materials_updates_option_and_adds_exp_to_pool_item()
    {
        const int equipmentItemDataId = 1001;
        const int optionPoolItemDataId = 1002;
        const int rerollMaterialItemDataId = 1003;
        const int rerollOptionId = 9001;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = equipmentItemDataId,
                    Category = ResourceItem.Types.Category.Equipment,
                    Type = ResourceItem.Types.Type.Passive,
                    Unstackable = true,
                    TargetItemDataIds = { optionPoolItemDataId },
                    OptionCounts = { 1 },
                    Options =
                    {
                        new ItemOptionGroup
                        {
                            Options =
                            {
                                new ItemOption
                                {
                                    Id = rerollOptionId,
                                    MinLevel = 2,
                                    MaxLevel = 2,
                                },
                            },
                        },
                    },
                    RerollMaterialItemGroups =
                    {
                        new MaterialItemGroup
                        {
                            Level = 1,
                            ShouldAllValid = true,
                            MaterialItems =
                            {
                                new MaterialItem
                                {
                                    Id = rerollMaterialItemDataId,
                                    Count = 2,
                                },
                            },
                        },
                    },
                },
                CreateItem(optionPoolItemDataId, category: ResourceItem.Types.Category.Material),
                CreateItem(rerollMaterialItemDataId, category: ResourceItem.Types.Category.Material),
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(equipmentItemDataId, 1);
        harness.Manager.AddItem(optionPoolItemDataId, 1);
        harness.Manager.AddItem(rerollMaterialItemDataId, 5);

        var equipment = Assert.Single(harness.Manager.GetItemsByDataId(equipmentItemDataId));
        var optionPoolItem = Assert.Single(harness.Manager.GetItemsByDataId(optionPoolItemDataId));
        var consumed = new List<PlayerItemMessage>();

        Assert.Equal(StatusCode.Ok, harness.Manager.RerollItemOption(equipment, slot: -1, consumed));

        Assert.Single(consumed);
        Assert.Equal(rerollMaterialItemDataId, consumed[0].ItemDataId);
        Assert.Equal(2, consumed[0].Count);
        Assert.Equal(3, harness.Manager.GetItemsByDataId(rerollMaterialItemDataId).Single().count);
        Assert.Equal(2, optionPoolItem.exp);

        using var optionScope = equipment.GetOptionScope();
        var rerollOption = Assert.Single(optionScope.Option.RerollOptions);
        Assert.Equal(rerollOptionId, rerollOption.Id);
        Assert.Equal(2, rerollOption.Level);
        Assert.Equal(1, rerollOption.PoolId);
    }

    [Fact]
    public void CreateItem_consumes_recipe_materials_and_adds_outputs()
    {
        const int materialId = 1001;
        const int craftedId = 1002;
        const int recipeId = 1003;

        using var resources = new TestResourceScope(
            items:
            [
                CreateItem(materialId, category: ResourceItem.Types.Category.Material),
                CreateItem(craftedId, category: ResourceItem.Types.Category.Material),
                new ResourceItem
                {
                    Id = recipeId,
                    Category = ResourceItem.Types.Category.Recipe,
                    MaterialItemGroups =
                    {
                        new MaterialItemGroup
                        {
                            ShouldAllValid = true,
                            MaterialItems =
                            {
                                new MaterialItem { Id = materialId, Count = 3 },
                            }
                        },
                    },
                    AddItemGroups =
                    {
                        new AddItemGroup
                        {
                            ShouldAddAll = true,
                            AddItems =
                            {
                                new AddItem { ItemDataId = craftedId, Count = 2 },
                            }
                        },
                    },
                },
            ]);

        var harness = new WorldPlayerTestHarness();
        harness.Manager.AddItem(materialId, 7);

        var consumed = new List<PlayerItemMessage>();
        Assert.Equal(StatusCode.Ok, harness.Manager.CreateItem(recipeId, consumed, count: 2));

        Assert.Single(consumed);
        Assert.Equal(6, consumed[0].Count);
        Assert.Equal(1, harness.Manager.GetItemsByDataId(materialId).Single().count);
        Assert.Equal(4, harness.Manager.GetItemsByDataId(craftedId).Single().count);
    }

    [Fact]
    public void DecomposeItem_processes_all_items_in_a_batch()
    {
        const int sourceId = 1001;
        const int rewardId = 1002;

        using var resources = new TestResourceScope(
            items:
            [
                new ResourceItem
                {
                    Id = sourceId,
                    Category = ResourceItem.Types.Category.Material,
                    Unstackable = true,
                    DecomposeAddItemGroups =
                    {
                        new AddItemGroup
                        {
                            ShouldAddAll = true,
                            AddItems =
                            {
                                new AddItem { ItemDataId = rewardId, Count = 1 },
                            }
                        },
                    },
                },
                CreateItem(rewardId, category: ResourceItem.Types.Category.Material),
            ]);

        var harness = new WorldPlayerTestHarness();
        var createdItems = new List<Server.Models.PlayerItemModel>();
        Assert.Equal(StatusCode.Ok, harness.Manager.AddItem(sourceId, 2, addedItems: createdItems));
        harness.AssignTransientItemIds(createdItems);
        Assert.Equal(2, createdItems.Count);

        var added = new List<Server.Stuffs.AddedItemStuff>();
        Assert.Equal(StatusCode.Ok, harness.Manager.DecomposeItem(createdItems, added));

        Assert.All(createdItems, item => Assert.True(item.deleted));
        Assert.Equal(2, harness.Manager.GetItemsByDataId(rewardId).Single().count);
    }

    private static ResourceItem CreateItem(
        int id,
        ResourceItem.Types.Category category,
        ResourceItem.Types.Type type = ResourceItem.Types.Type.Passive,
        bool unstackable = false,
        IEnumerable<Tag>? tags = null)
    {
        var item = new ResourceItem
        {
            Id = id,
            Category = category,
            Type = type,
            Unstackable = unstackable,
        };

        if (tags != null)
            item.Tags.Add(tags);

        return item;
    }
}
