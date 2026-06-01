import importlib.util
import copy
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MODULE_PATH = ROOT / "harness" / "tools" / "idlez_compile.py"

spec = importlib.util.spec_from_file_location("idlez_compile", MODULE_PATH)
idlez_compile = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(idlez_compile)


class IdlezCompileTests(unittest.TestCase):
    def test_compile_game_emits_required_bootstrap_globals(self):
        bundles, _, globals_out, warns, errors = idlez_compile.compile_game("idlez")

        self.assertEqual([], errors)
        self.assertTrue(isinstance(warns, list))
        self.assertEqual(1, globals_out["itemGlobal"]["dataId"]["playerLevel"])
        self.assertEqual(110101, globals_out["itemGlobal"]["dataId"]["defaultCharacter"])
        self.assertEqual(500101, globals_out["mapGlobal"]["dataId"]["tutorialMap"])
        self.assertGreater(
            len(globals_out["mapGlobal"]["boardConstants"]["defaultPlayerInventoryShapes"]),
            0,
        )
        self.assertGreaterEqual(len(bundles["item"]), 16)

    def test_compile_game_keeps_tutorial_manifest_achievements(self):
        bundles, _, globals_out, _, errors = idlez_compile.compile_game("idlez")

        self.assertEqual([], errors)
        achievement_ids = {entry["id"] for entry in bundles["achievement"]}
        self.assertIn(600001, achievement_ids)
        self.assertIn(610000, achievement_ids)
        self.assertIn(610205, achievement_ids)
        self.assertEqual(
            [610101, 610102, 610103, 610201, 610202, 610203, 610204, 610205],
            globals_out["achievementGlobal"]["dataId"]["tutorialSteps"],
        )

    def test_compile_game_bootstraps_default_character_and_map(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("idlez")

        self.assertEqual([], errors)
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}
        unit_by_id = {entry["id"]: entry for entry in bundles["unit"]}
        tutorial_map = bundles["map"][0]

        self.assertEqual("Character", item_by_id[110101]["category"])
        self.assertEqual(110111, item_by_id[110101]["unitDataId"])
        self.assertIn(110111, unit_by_id)
        self.assertEqual(
            200201,
            item_by_id[110101]["equipAddItemGroups"][0]["addItems"][0]["itemDataId"],
        )
        self.assertEqual(
            ["MAP_ONSTART_MEADOW1WAVE1", "MAP_ONUPDATE_MEADOW1UPDATE"],
            tutorial_map["triggers"],
        )
        self.assertEqual("PFB_MAP_Meadow_Day_Chapter", tutorial_map["scene"])

    def test_inventory_shape_is_only_required_for_inventory_maps(self):
        bundles, triggers, globals_out, _, errors = idlez_compile.compile_game("idlez")

        self.assertEqual([], errors)

        bundles = copy.deepcopy(bundles)
        globals_out = copy.deepcopy(globals_out)
        bundles["map"][0]["tags"] = []
        globals_out["mapGlobal"]["boardConstants"]["defaultPlayerInventoryShapes"] = []

        warns = []
        errors = []
        idlez_compile.validate("idlez", bundles, triggers, globals_out, warns, errors)

        self.assertEqual([], errors)

    def test_expression_method_call_uses_engine_parameter_type(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        update_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "MAP_ONUPDATE_MUSHROOMFIELDUPDATE"
        )
        unit_count_call = next(
            statement["call"]
            for statement in update_trigger["statements"]
            if "call" in statement
            and statement["call"]["method"].get("boardMethod", {}).get("type") == "GetUnitCountByTeam"
        )

        self.assertEqual(
            "Team",
            unit_count_call["assignments"][0]["variable"]["parameter"]["type"],
        )

    def test_mushroomer_auto_attack_uses_target_position_skill(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        attack_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "UNIT_ONUPDATE_MUSHROOMHEROATTACK"
        )
        method = attack_trigger["statements"][0]["call"]["method"]["unitMethod"]

        self.assertEqual("UseSkillToTarget", method["type"])
        self.assertTrue(attack_trigger["statements"][0]["call"]["caller"])

    def test_string_map_fields_emit_string_values(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        dungeon_map = next(entry for entry in bundles["map"] if entry["id"] == 500201)

        self.assertEqual("500101", dungeon_map["popupArgs"]["ClientHomeMapDataId"])

    def test_mushroomer_equipment_summon_price_uses_achievements(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}
        achievement_by_id = {entry["id"]: entry for entry in bundles["achievement"]}
        product = item_by_id[200503]
        price_achievement_ids = list(range(600124, 600134))

        self.assertEqual(price_achievement_ids, product["targetAchievementDataIds"])
        self.assertEqual(5, product["regenPeriod"])
        self.assertEqual(5, product["regenCount"])

        for index, achievement_id in enumerate(price_achievement_ids, start=1):
            achievement = achievement_by_id[achievement_id]
            self.assertEqual("BuyItemProduct", achievement["condition"])
            self.assertEqual(200503, achievement["conditionValue1"])
            self.assertEqual(index * 5, achievement["targetProgress"])
            self.assertIn("HideDisplay", achievement["tags"])
            self.assertIn("EquipmentSummonLevel", achievement["tags"])
            self.assertIn("EquipmentSummonPrice", achievement["tags"])
            self.assertEqual(str(index + 1), achievement["popupArgs"]["SummonLevel"])

    def test_mushroomer_infinite_map_chain_advances_to_next_map(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        maps_by_id = {entry["id"]: entry for entry in bundles["map"]}
        achievements_by_id = {entry["id"]: entry for entry in bundles["achievement"]}
        main_maps = [entry for entry in bundles["map"] if "Main" in entry.get("tags", [])]
        progression_ids = list(range(500101, 500131))

        self.assertEqual([500101], [entry["id"] for entry in main_maps])
        self.assertTrue(all(map_id in maps_by_id for map_id in progression_ids))

        chain = {
            map_id: (map_id + 1 if map_id < 500130 else 500101)
            for map_id in progression_ids
        }
        enemy_levels = {
            map_id: map_id - 500100
            for map_id in progression_ids
        }
        for map_id, next_map_id in chain.items():
            infinite_map = maps_by_id[map_id]
            self.assertEqual(map_id, infinite_map["group"])
            self.assertIn("InfiniteWaves", infinite_map["tags"])
            self.assertEqual("true", infinite_map["popupArgs"]["ClientAutoAdvance"])
            self.assertEqual(str(next_map_id), infinite_map["popupArgs"]["ClientNextMapDataId"])
            self.assertEqual("self", infinite_map["popupArgs"]["ClientRetryMapDataId"])
            self.assertEqual(
                [
                    {"callerKey": 605, "value": enemy_levels[map_id]},
                    {"callerKey": 606, "value": enemy_levels[map_id]},
                ],
                infinite_map["initVariables"],
            )

        infinite_map = maps_by_id[500101]
        self.assertEqual(
            [600108, 600109, 600110, 600111, 600112],
            infinite_map["referenceAchievementDataIds"],
        )

        thresholds = [1, 3, 5, 10, 20]
        for achievement_id, threshold in zip(infinite_map["referenceAchievementDataIds"], thresholds):
            achievement = achievements_by_id[achievement_id]
            self.assertEqual("WinWave", achievement["condition"])
            self.assertEqual(500101, achievement["conditionValue1"])
            self.assertEqual(threshold, achievement["targetProgress"])
            self.assertIn("Wave", achievement["tags"])

    def test_mushroomer_main_wave_spawns_scale_enemy_unit_level(self):
        bundles, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        units_by_id = {entry["id"]: entry for entry in bundles["unit"]}
        mushroom_hero = units_by_id[110111]
        sporeling = units_by_id[110201]
        spore_king = units_by_id[110501]

        hero_hp = next(stat for stat in mushroom_hero["addStats"] if stat.get("type", "Hp") == "Hp")
        hero_attack = next(stat for stat in mushroom_hero["addStats"] if stat.get("type", "Hp") == "Attack")
        spore_hp = next(stat for stat in sporeling["addStats"] if stat.get("type", "Hp") == "Hp")
        boss_hp = next(stat for stat in spore_king["addStats"] if stat.get("type", "Hp") == "Hp")
        self.assertEqual(900.0, hero_hp["value"][0])
        self.assertEqual(hero_hp["value"][0], hero_hp["value"][29])
        self.assertEqual(80.0, hero_attack["value"][0])
        self.assertEqual(hero_attack["value"][0], hero_attack["value"][29])
        self.assertGreaterEqual(len(spore_hp["value"]), 35)
        self.assertGreaterEqual(len(boss_hp["value"]), 35)
        self.assertGreater(spore_hp["value"][34], spore_hp["value"][0])
        self.assertGreater(boss_hp["value"][34], boss_hp["value"][0])

        wave_triggers = [
            next(trigger for trigger in triggers if trigger["name"] == name)
            for name in [
                "MAP_ONSTART_MUSHROOMFIELDWAVE1",
                "MAP_ONSTART_MUSHROOMFIELDWAVE2",
                "MAP_ONSTART_MUSHROOMFIELDWAVE3",
                "MAP_ONSTART_MUSHROOMFIELDWAVE4",
                "MAP_ONSTART_MUSHROOMFIELDBOSSWAVE",
            ]
        ]

        def iter_calls(statements):
            for statement in statements:
                if "call" in statement:
                    yield statement["call"]
                if "condition" in statement:
                    yield from iter_calls(statement["condition"].get("statements", []))

        add_unit_calls = [
            call
            for wave_trigger in wave_triggers
            for call in iter_calls(wave_trigger["statements"])
            if call.get("method", {}).get("boardMethod", {}).get("type") == "AddUnit"
        ]
        level_shapes = []
        for call in add_unit_calls:
            level_assignment = next(
                assignment
                for assignment in call["assignments"]
                if assignment["variable"]["parameter"]["type"] == "Level"
            )
            postfix = level_assignment["expression"]["postfix"]
            board_keys = [
                item["operand"]["variable"]["boardKey"]
                for item in postfix
                if "operand" in item
                and "variable" in item["operand"]
                and "boardKey" in item["operand"]["variable"]
            ]
            constants = [
                item["operand"]["constant"]["value"]
                for item in postfix
                if "operand" in item and "constant" in item["operand"]
            ]
            operators = [
                item["operator"]["type"]
                for item in postfix
                if "operator" in item
            ]
            level_shapes.append((board_keys, constants, operators))

        self.assertEqual(
            [
                ([605], [], []),
                ([605], [], []),
                ([605], [1.0], ["Add"]),
                ([605], [1.0], ["Add"]),
                ([605], [1.0], ["Add"]),
                ([605], [2.0], ["Add"]),
                ([605], [2.0], ["Add"]),
                ([605], [2.0], ["Add"]),
                ([605], [3.0], ["Add"]),
                ([606], [4.0], ["Add"]),
                ([605], [4.0], ["Add"]),
                ([605], [4.0], ["Add"]),
            ],
            level_shapes,
        )

    def test_mushroomer_behavior_seconds_compile_to_engine_ticks(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        periods = {trigger["name"]: trigger.get("period") for trigger in triggers}

        self.assertEqual(30, periods["MAP_ONUPDATE_MUSHROOMFIELDUPDATE"])
        self.assertEqual(30, periods["UNIT_ONUPDATE_MUSHROOMHEROATTACK"])
        self.assertEqual(60, periods["UNIT_ONUPDATE_SPORELINGATTACK"])
        self.assertEqual(42, periods["UNIT_ONUPDATE_SPORERANGERVOLLEY"])
        self.assertEqual(66, periods["UNIT_ONUPDATE_FUNGUSBULWARKSLAM"])
        self.assertEqual(30, periods["UNIT_ONUPDATE_SPOREKINGBATTLE"])

    def test_skill_damage_percent_compiles_to_engine_attack_ratio(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        spore_shock = next(entry for entry in bundles["skill"] if entry["id"] == 300101)
        hit_timeline = next(timeline for timeline in spore_shock["timelines"] if "hit" in timeline)
        add_damage = hit_timeline["hit"]["addDamage"]
        hit_radius = hit_timeline["hit"]["geometries"][0]["circle"]["radius"]

        self.assertNotIn("damagePercent", add_damage)
        self.assertEqual([1.1], add_damage["attackPercentDamages"])
        self.assertFalse(any("unitCharge" in timeline for timeline in spore_shock.get("timelines", [])))
        self.assertGreaterEqual(hit_radius, 4.8)

    def test_mushroomer_skills_use_instantiable_prefab_and_attack_animation(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        skill_by_id = {entry["id"]: entry for entry in bundles["skill"]}
        buff_by_id = {entry["id"]: entry for entry in bundles["buff"]}
        unit_by_id = {entry["id"]: entry for entry in bundles["unit"]}
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}

        for skill_id in [300101, 300102, 300103]:
            skill = skill_by_id[skill_id]
            self.assertEqual("FXPrefabs/VFX_LiquidHitGreen.prefab", skill["prefab"])
            self.assertFalse(
                any("playFx" in timeline for timeline in skill.get("timelines", [])),
                f"{skill_id} should use ResourceSkill.prefab, not playFx",
            )
            self.assertEqual("Attack", skill["timelines"][0]["unitPlayAnimation"]["animation"])

        self.assertEqual(
            "Cast",
            skill_by_id[300104]["timelines"][0]["unitPlayAnimation"]["animation"],
        )
        self.assertEqual("Units/Characters/PFB_HAM_Hamzzi.prefab", unit_by_id[110111]["prefab"])
        self.assertEqual("Units/Characters/Assets/Ninster3.png", unit_by_id[110111]["sprite"])
        self.assertEqual(
            {"Idle": "Idle", "Run": "Run", "Attack": "Attack", "Cast": "Attack2"},
            unit_by_id[110111]["animations"],
        )
        self.assertEqual("Attack1", unit_by_id[110201]["animations"]["Attack"])
        self.assertEqual("Attack1", unit_by_id[110501]["animations"]["Attack"])
        self.assertEqual("Attack2", unit_by_id[110501]["animations"]["SpecialAttack"])

        self.assertEqual("FXPrefabs/VFX_LiquidHitGreen.prefab", buff_by_id[400101]["prefab"])
        for item_id in [200401, 200402, 200403, 200404]:
            self.assertEqual(1.0, item_by_id[item_id]["constantDamageRatio"])

    def test_mushroomer_skill_tree_links_player_level_gates(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}
        achievement_by_id = {entry["id"]: entry for entry in bundles["achievement"]}

        grant = achievement_by_id[600107]
        self.assertEqual("LevelUpItem", grant["condition"])
        self.assertEqual(1, grant["conditionValue1"])
        self.assertTrue(grant["repeatable"])
        self.assertTrue(grant["autoReward"])
        self.assertEqual(
            1,
            sum(
                int(add["count"])
                for group in grant["rewardAddItemGroups"]
                for add in group["addItems"]
                if add["itemDataId"] == 200107
            ),
        )

        for level, achievement_id in [
            (5, 600113),
            (8, 600114),
            (12, 600115),
            (30, 600116),
            (40, 600117),
            (50, 600118),
            (60, 600119),
            (70, 600120),
            (80, 600121),
            (90, 600122),
            (100, 600123),
        ]:
            achievement = achievement_by_id[achievement_id]
            self.assertEqual("HasItemLevel", achievement["condition"])
            self.assertEqual(1, achievement["conditionValue1"])
            self.assertEqual(level, achievement["conditionValue2"])
            self.assertEqual(1, achievement["targetProgress"])
            self.assertIn("HideDisplay", achievement["tags"])

        expected_nodes = {
            200401: (1, None, 0),
            200402: (5, 600113, 200405),
            200403: (8, 600114, 200406),
            200404: (12, 600115, 200407),
            200408: (30, 600116, 200416),
            200409: (40, 600117, 200417),
            200410: (50, 600118, 200418),
            200411: (60, 600119, 200419),
            200412: (70, 600120, 200420),
            200413: (80, 600121, 200421),
            200414: (90, 600122, 200422),
            200415: (100, 600123, 200423),
        }
        for item_id, (player_level, gate_id, recipe_id) in expected_nodes.items():
            item = item_by_id[item_id]
            popup_args = item["popupArgs"]
            self.assertEqual("Mushroomer", popup_args["SkillTree"])
            self.assertEqual("200107", popup_args["LevelPointItemDataId"])
            self.assertEqual(str(player_level), popup_args["RequiredPlayerLevel"])
            self.assertEqual("5", popup_args["MaxSkillLevel"])
            if gate_id:
                self.assertIn(gate_id, item["requiredAchievementDataIds"])
                recipe = item_by_id[recipe_id]
                self.assertEqual("Recipe", recipe["category"])
                self.assertIn(gate_id, recipe["requiredAchievementDataIds"])
                self.assertEqual(str(player_level), recipe["popupArgs"]["RequiredPlayerLevel"])
                self.assertEqual(str(item_id), recipe["popupArgs"]["UnlockSkillItemDataId"])

    def test_validate_rejects_skill_tree_recipe_without_level_gate(self):
        bundles, triggers, globals_out, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)

        bundles = copy.deepcopy(bundles)
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}
        item_by_id[200405]["requiredAchievementDataIds"] = []

        warns = []
        errors = []
        idlez_compile.validate("mushroomer", bundles, triggers, globals_out, warns, errors)

        self.assertTrue(
            any(
                "skill_tree recipe 200405: requiredAchievementDataIds에 레벨 게이트 600113 누락"
                in error
                for error in errors
            ),
            errors,
        )

    def test_mushroomer_early_skill_tree_costs_only_level_points(self):
        bundles, _, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}

        for item_id in [200401, 200402, 200403, 200404]:
            skill_item = item_by_id[item_id]
            for group in skill_item["levelUpMaterialItemGroups"]:
                self.assertEqual(
                    [200107],
                    [material["id"] for material in group["materialItems"]],
                )
                self.assertEqual(
                    [1],
                    [material["count"] for material in group["materialItems"]],
                )

        for recipe_id in [200405, 200406, 200407]:
            recipe = item_by_id[recipe_id]
            for group in recipe["materialItemGroups"]:
                self.assertEqual(
                    [200107],
                    [material["id"] for material in group["materialItems"]],
                )
                self.assertEqual(
                    [1],
                    [material["count"] for material in group["materialItems"]],
                )

    def test_validate_rejects_early_skill_tree_level_without_spend_choice(self):
        bundles, triggers, globals_out, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)

        bundles = copy.deepcopy(bundles)
        item_by_id = {entry["id"]: entry for entry in bundles["item"]}
        item_by_id[200401]["levelUpMaterialItemGroups"][2]["materialItems"][0]["count"] = 2

        warns = []
        errors = []
        idlez_compile.validate("mushroomer", bundles, triggers, globals_out, warns, errors)

        self.assertTrue(
            any(
                "skill_tree Mushroomer: Lv.4 초반 스킬 선택지가 없음"
                in error
                for error in errors
            ),
            errors,
        )

    def test_mushroomer_wave_spawns_use_location(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        wave_triggers = [
            next(trigger for trigger in triggers if trigger["name"] == name)
            for name in [
                "MAP_ONSTART_MUSHROOMFIELDWAVE1",
                "MAP_ONSTART_MUSHROOMFIELDWAVE2",
                "MAP_ONSTART_MUSHROOMFIELDWAVE3",
                "MAP_ONSTART_MUSHROOMFIELDWAVE4",
                "MAP_ONSTART_MUSHROOMFIELDBOSSWAVE",
            ]
        ]

        def calls(statements):
            for statement in statements:
                if "call" in statement:
                    yield statement["call"]
                if "condition" in statement:
                    yield from calls(statement["condition"].get("statements", []))

        add_unit_calls = [
            call
            for wave_trigger in wave_triggers
            for call in calls(wave_trigger["statements"])
            if call["method"].get("boardMethod", {}).get("type") == "AddUnit"
        ]

        self.assertGreaterEqual(len(add_unit_calls), 1)
        spawn_counts = []
        for add_unit_call in add_unit_calls:
            parameter_types = {
                assignment["variable"]["parameter"]["type"]
                for assignment in add_unit_call["assignments"]
            }
            count_assignment = next(
                assignment
                for assignment in add_unit_call["assignments"]
                if assignment["variable"]["parameter"]["type"] == "Count"
            )

            self.assertIn("LocationId", parameter_types)
            spawn_counts.append(count_assignment["expression"]["postfix"][0]["operand"]["constant"]["value"])

        self.assertEqual([5, 4, 2, 1, 3, 3, 2, 4, 4, 1, 2, 3], spawn_counts)

    def test_mushroomer_four_scaling_waves_then_boss(self):
        bundles, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)

        def trigger(name):
            return next(entry for entry in triggers if entry["name"] == name)

        def calls(statements):
            for statement in statements:
                if "call" in statement:
                    yield statement["call"]
                if "condition" in statement:
                    yield from calls(statement["condition"].get("statements", []))

        def assignments(statements):
            for statement in statements:
                if "assignment" in statement:
                    yield statement["assignment"]
                if "condition" in statement:
                    yield from assignments(statement["condition"].get("statements", []))

        def param_value(call, param_type):
            assignment = next(
                item for item in call["assignments"] if item["variable"]["parameter"]["type"] == param_type
            )
            return assignment["expression"]["postfix"][0]["operand"]["constant"]["value"]

        for wave_name in [
            "MAP_ONSTART_MUSHROOMFIELDWAVE1",
            "MAP_ONSTART_MUSHROOMFIELDWAVE2",
            "MAP_ONSTART_MUSHROOMFIELDWAVE3",
            "MAP_ONSTART_MUSHROOMFIELDWAVE4",
            "MAP_ONSTART_MUSHROOMFIELDBOSSWAVE",
        ]:
            wave_trigger = trigger(wave_name)
            self.assertTrue(
                any(assignment["variable"].get("boardKey") == 604 for assignment in assignments(wave_trigger["statements"]))
            )

        wave_triggers = [
            trigger("MAP_ONSTART_MUSHROOMFIELDWAVE1"),
            trigger("MAP_ONSTART_MUSHROOMFIELDWAVE2"),
            trigger("MAP_ONSTART_MUSHROOMFIELDWAVE3"),
            trigger("MAP_ONSTART_MUSHROOMFIELDWAVE4"),
            trigger("MAP_ONSTART_MUSHROOMFIELDBOSSWAVE"),
        ]
        add_unit_calls = [
            call
            for wave_trigger in wave_triggers
            for call in calls(wave_trigger["statements"])
            if call["method"].get("boardMethod", {}).get("type") == "AddUnit"
        ]
        self.assertEqual(
            [
                (110201, 5),
                (110201, 4),
                (110202, 2),
                (110203, 1),
                (110201, 3),
                (110202, 3),
                (110203, 2),
                (110201, 4),
                (110202, 4),
                (110501, 1),
                (110203, 2),
                (110202, 3),
            ],
            [(param_value(call, "UnitDataId"), param_value(call, "Count")) for call in add_unit_calls],
        )

        boss_update = trigger("UNIT_ONUPDATE_SPOREKINGBATTLE")

        boss_calls = list(calls(boss_update["statements"]))
        self.assertFalse(
            any(call["method"].get("boardMethod", {}).get("type") == "AddUnit" for call in boss_calls)
        )
        self.assertIn(
            "UseSkillToTarget",
            [call["method"].get("unitMethod", {}).get("type") for call in boss_calls],
        )

        unit_by_id = {entry["id"]: entry for entry in bundles["unit"]}
        stat_by_type = {
            unit_id: {stat.get("type", "Hp"): stat["value"][0] for stat in unit["addStats"]}
            for unit_id, unit in unit_by_id.items()
            if unit_id in {110111, 110201, 110202, 110203, 110501}
        }

        self.assertEqual(900.0, stat_by_type[110111]["Hp"])
        self.assertEqual(80.0, stat_by_type[110111]["Attack"])
        self.assertEqual(1.0, stat_by_type[110111]["Defense"])
        self.assertEqual(45.0, stat_by_type[110201]["Hp"])
        self.assertEqual(5.0, stat_by_type[110201]["Attack"])
        self.assertEqual(90.0, stat_by_type[110202]["Hp"])
        self.assertEqual(7.0, stat_by_type[110202]["Attack"])
        self.assertEqual(260.0, stat_by_type[110203]["Hp"])
        self.assertEqual(8.0, stat_by_type[110203]["Defense"])
        self.assertEqual(420.0, stat_by_type[110501]["Hp"])
        self.assertEqual(14.0, stat_by_type[110501]["Attack"])
        self.assertEqual(0.45, unit_by_id[110201]["deadDestroyDelaySeconds"])
        self.assertEqual(0.75, unit_by_id[110501]["deadDestroyDelaySeconds"])

    def test_mushroomer_spawns_have_approach_spacing(self):
        bundles, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        mushroom_map = next(entry for entry in bundles["map"] if entry["id"] == 500101)
        locations = {location["id"]: location for location in mushroom_map["locations"]}

        self.assertLessEqual(locations[-1]["position"]["x"], -7.0)
        self.assertGreaterEqual(locations[1]["position"]["x"], 7.0)

        start_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "UNIT_ONSTART_SPORELINGWANDER"
        )
        move_call = start_trigger["statements"][0]["call"]
        parameter_types = {
            assignment["variable"]["parameter"]["type"]
            for assignment in move_call["assignments"]
        }

        self.assertEqual("SetMoveRandomDestination", move_call["method"]["unitMethod"]["type"])
        self.assertTrue(move_call["caller"])
        self.assertEqual({"PositionX", "PositionY", "PositionXrange", "PositionYrange"}, parameter_types)

        attack_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "UNIT_ONUPDATE_SPORELINGATTACK"
        )
        conditions = [statement["condition"] for statement in attack_trigger["statements"]]

        def unit_variable_types(node):
            if isinstance(node, dict):
                unit_variable = node.get("unitVariable")
                if unit_variable:
                    yield unit_variable["type"]
                for value in node.values():
                    yield from unit_variable_types(value)
            elif isinstance(node, list):
                for value in node:
                    yield from unit_variable_types(value)

        self.assertEqual(2, len(conditions))
        self.assertIn("TargetDistance", list(unit_variable_types(conditions[0]["expression"])))
        self.assertCountEqual(
            ["HasTarget", "TargetDistance"],
            list(unit_variable_types(conditions[1]["expression"])),
        )
        self.assertEqual(
            ["Stop", "UseSkillToTarget"],
            [
                statement["call"]["method"]["unitMethod"]["type"]
                for statement in conditions[1]["statements"]
            ],
        )

    def test_skill_behavior_unit_method_targets_caller_unit(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("idlez")

        self.assertEqual([], errors)
        update_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "SKILL_ONUPDATE_INCREASEGOLD"
        )
        increase_gold_call = update_trigger["statements"][0]["call"]

        self.assertEqual("IncreaseGold", increase_gold_call["method"]["unitMethod"]["type"])
        self.assertTrue(increase_gold_call["caller"])

    def test_mushroomer_wave_state_does_not_overwrite_board_state(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        wave1_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "MAP_ONSTART_MUSHROOMFIELDWAVE1"
        )
        set_board_state = next(
            statement["call"]
            for statement in wave1_trigger["statements"]
            if "call" in statement
            and statement["call"]["method"].get("boardMethod", {}).get("type") == "SetBoardState"
        )
        board_state_value = set_board_state["assignments"][0]["expression"]["postfix"][0]["operand"]["constant"]["value"]
        wave_assignment = next(
            statement["assignment"]
            for statement in wave1_trigger["statements"]
            if "assignment" in statement and statement["assignment"]["variable"].get("boardKey") == 601
        )

        self.assertEqual(2001, board_state_value)
        self.assertEqual(
            1,
            wave_assignment["expression"]["postfix"][0]["operand"]["constant"]["value"],
        )

    def test_mushroomer_wave_update_uses_transition_flag_to_prevent_same_tick_cascade(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        update_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "MAP_ONUPDATE_MUSHROOMFIELDUPDATE"
        )
        unit_count_calls = [
            statement["call"]
            for statement in update_trigger["statements"]
            if "call" in statement
            and statement["call"]["method"].get("boardMethod", {}).get("type") == "GetUnitCountByTeam"
        ]
        conditions = [statement["condition"] for statement in update_trigger["statements"] if "condition" in statement]

        def board_keys(node):
            if isinstance(node, dict):
                if "boardKey" in node:
                    yield node["boardKey"]
                for value in node.values():
                    yield from board_keys(value)
            elif isinstance(node, list):
                for value in node:
                    yield from board_keys(value)

        def constants(postfix):
            return [
                item["operand"]["constant"]["value"]
                for item in postfix
                if "operand" in item and "constant" in item["operand"]
            ]

        def predefined_variables(postfix):
            return [
                item["operand"]["variable"]["predefinedVariable"]["type"]
                for item in postfix
                if "operand" in item
                and "variable" in item["operand"]
                and "predefinedVariable" in item["operand"]["variable"]
            ]

        self.assertEqual(5, len(unit_count_calls))
        self.assertEqual(6, len(conditions))
        self.assertIn(603, list(board_keys(conditions[0]["expression"])))

        for condition, wave in zip(conditions[1:6], [1.0, 2.0, 3.0, 4.0, 5.0]):
            expression = condition["expression"]
            self.assertIn(603, list(board_keys(expression)))
            self.assertIn(601, list(board_keys(expression)))
            self.assertNotIn(604, list(board_keys(expression)))
            self.assertIn(wave, constants(expression["postfix"]))
            self.assertIn("Return", predefined_variables(expression["postfix"]))

        for condition, next_wave in zip(conditions[1:5], [2, 3, 4, 5]):
            transition_flag_assignment = condition["statements"][0]["assignment"]
            wave_assignment = condition["statements"][1]["assignment"]

            self.assertEqual(603, transition_flag_assignment["variable"]["boardKey"])
            self.assertEqual(
                1,
                transition_flag_assignment["expression"]["postfix"][0]["operand"]["constant"]["value"],
            )
            self.assertEqual(601, wave_assignment["variable"]["boardKey"])
            self.assertEqual(
                next_wave,
                wave_assignment["expression"]["postfix"][0]["operand"]["constant"]["value"],
            )

        wave4_trigger = conditions[3]["statements"][3]["call"]["method"]["runTrigger"]["name"]
        self.assertEqual("MAP_ONSTART_MUSHROOMFIELDWAVE4", wave4_trigger)

        boss_wave_trigger = conditions[4]["statements"][3]["call"]["method"]["runTrigger"]["name"]
        self.assertEqual("MAP_ONSTART_MUSHROOMFIELDBOSSWAVE", boss_wave_trigger)

        end_game_call = conditions[5]["statements"][0]["call"]
        self.assertEqual("EndGame", end_game_call["method"]["boardMethod"]["type"])

    def test_validate_rejects_add_unit_missing_unit_resource(self):
        bundles, triggers, globals_out, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)

        bundles = copy.deepcopy(bundles)
        triggers = copy.deepcopy(triggers)
        add_unit_call = next(
            call
            for trigger in triggers
            for call in idlez_compile._walk_trigger_calls(trigger.get("statements", []))
            if call.get("method", {}).get("boardMethod", {}).get("type") == "AddUnit"
        )
        unit_assignment = next(
            assignment
            for assignment in add_unit_call["assignments"]
            if assignment["variable"]["parameter"]["type"] == "UnitDataId"
        )
        unit_assignment["expression"]["postfix"][0]["operand"]["constant"]["value"] = 999999

        warns = []
        errors = []
        idlez_compile.validate("mushroomer", bundles, triggers, globals_out, warns, errors)

        self.assertTrue(
            any("AddUnit UnitDataId 999999" in error for error in errors),
            errors,
        )

    def test_validate_rejects_add_unit_location_without_geometry(self):
        bundles, triggers, globals_out, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)

        bundles = copy.deepcopy(bundles)
        mushroom_map = next(entry for entry in bundles["map"] if entry["id"] == 500101)
        enemy_location = next(location for location in mushroom_map["locations"] if location["id"] == 1)
        enemy_location["geometries"] = []

        warns = []
        errors = []
        idlez_compile.validate("mushroomer", bundles, triggers, globals_out, warns, errors)

        self.assertTrue(
            any("location 1 geometries 누락" in error for error in errors),
            errors,
        )

    def test_validate_rejects_unknown_run_trigger_name(self):
        bundles, triggers, globals_out, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)

        triggers = copy.deepcopy(triggers)
        run_trigger_call = next(
            call
            for trigger in triggers
            for call in idlez_compile._walk_trigger_calls(trigger.get("statements", []))
            if "runTrigger" in call.get("method", {})
        )
        run_trigger_call["method"]["runTrigger"]["name"] = "MAP_ONSTART_DOES_NOT_EXIST"

        warns = []
        errors = []
        idlez_compile.validate("mushroomer", bundles, triggers, globals_out, warns, errors)

        self.assertTrue(
            any("runTrigger 'MAP_ONSTART_DOES_NOT_EXIST' 미정의" in error for error in errors),
            errors,
        )

    def test_behavior_compile_rejects_unknown_action_argument(self):
        errors = []
        idlez_compile.compile_behavior_doc(
            {
                "name": "BadArgs",
                "domain": "skill",
                "on": [
                    {
                        "event": "update",
                        "do": [
                            {"increaseGold": {"target": "caller", "amount": 1}},
                        ],
                    }
                ],
            },
            "memory.behavior.yaml",
            errors,
        )

        self.assertTrue(
            any("액션 'increaseGold' 미지원 인자 ['target']" in error for error in errors),
            errors,
        )


if __name__ == "__main__":
    unittest.main()
