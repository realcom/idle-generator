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
        self.assertEqual(16, len(bundles["item"]))

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

    def test_mushroomer_behavior_seconds_compile_to_engine_ticks(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        periods = {trigger["name"]: trigger.get("period") for trigger in triggers}

        self.assertEqual(30, periods["MAP_ONUPDATE_MUSHROOMFIELDUPDATE"])
        self.assertEqual(30, periods["UNIT_ONUPDATE_MUSHROOMHEROATTACK"])
        self.assertEqual(60, periods["UNIT_ONUPDATE_SPORELINGATTACK"])
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

    def test_mushroomer_wave_spawns_use_location(self):
        _, triggers, _, _, errors = idlez_compile.compile_game("mushroomer")

        self.assertEqual([], errors)
        update_trigger = next(
            trigger for trigger in triggers if trigger["name"] == "MAP_ONUPDATE_MUSHROOMFIELDUPDATE"
        )

        def calls(statements):
            for statement in statements:
                if "call" in statement:
                    yield statement["call"]
                if "condition" in statement:
                    yield from calls(statement["condition"].get("statements", []))

        add_unit_calls = [
            call
            for call in calls(update_trigger["statements"])
            if call["method"].get("boardMethod", {}).get("type") == "AddUnit"
        ]

        self.assertGreaterEqual(len(add_unit_calls), 1)
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
            self.assertEqual(
                1,
                count_assignment["expression"]["postfix"][0]["operand"]["constant"]["value"],
            )

    def test_mushroomer_three_easy_waves_then_boss(self):
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
        ]:
            wave_trigger = trigger(wave_name)
            self.assertFalse(
                any(call["method"].get("boardMethod", {}).get("type") == "AddUnit" for call in calls(wave_trigger["statements"]))
            )
            self.assertTrue(
                any(assignment["variable"].get("boardKey") == 604 for assignment in assignments(wave_trigger["statements"]))
            )

        boss_wave_start = trigger("MAP_ONSTART_MUSHROOMFIELDBOSSWAVE")
        self.assertFalse(
            any(
                call["method"].get("boardMethod", {}).get("type") == "AddUnit"
                for call in calls(boss_wave_start["statements"])
            )
        )

        update_trigger = trigger("MAP_ONUPDATE_MUSHROOMFIELDUPDATE")
        add_unit_calls = [
            call
            for call in calls(update_trigger["statements"])
            if call["method"].get("boardMethod", {}).get("type") == "AddUnit"
        ]
        self.assertEqual(4, len(add_unit_calls))
        for call in add_unit_calls[:3]:
            self.assertEqual(110201, param_value(call, "UnitDataId"))
            self.assertEqual(1, param_value(call, "Count"))
        self.assertEqual(110501, param_value(add_unit_calls[3], "UnitDataId"))
        self.assertEqual(1, param_value(add_unit_calls[3], "Count"))

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
            if unit_id in {110111, 110201, 110501}
        }

        self.assertEqual(1800.0, stat_by_type[110111]["Hp"])
        self.assertEqual(90.0, stat_by_type[110111]["Attack"])
        self.assertEqual(2.0, stat_by_type[110111]["Defense"])
        self.assertEqual(60.0, stat_by_type[110201]["Hp"])
        self.assertEqual(4.0, stat_by_type[110201]["Attack"])
        self.assertEqual(900.0, stat_by_type[110501]["Hp"])
        self.assertEqual(12.0, stat_by_type[110501]["Attack"])
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

        self.assertEqual(4, len(unit_count_calls))
        self.assertIn(603, list(board_keys(conditions[0]["expression"])))

        for condition, wave in zip(conditions[1:5], [1.0, 2.0, 3.0, 4.0]):
            expression = condition["expression"]
            self.assertIn(603, list(board_keys(expression)))
            self.assertIn(601, list(board_keys(expression)))
            self.assertIn(604, list(board_keys(expression)))
            self.assertIn(wave, constants(expression["postfix"]))
            self.assertIn("Return", predefined_variables(expression["postfix"]))

        for condition, next_wave in zip(conditions[1:4], [2, 3, 4]):
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

        boss_wave_trigger = conditions[3]["statements"][3]["call"]["method"]["runTrigger"]["name"]
        self.assertEqual("MAP_ONSTART_MUSHROOMFIELDBOSSWAVE", boss_wave_trigger)

        end_game_call = conditions[4]["statements"][0]["call"]
        self.assertEqual("EndGame", end_game_call["method"]["boardMethod"]["type"])

        for condition, wave in zip(conditions[5:9], [1.0, 2.0, 3.0, 4.0]):
            expression = condition["expression"]
            self.assertIn(603, list(board_keys(expression)))
            self.assertIn(601, list(board_keys(expression)))
            self.assertIn(604, list(board_keys(expression)))
            self.assertIn(wave, constants(expression["postfix"]))
            add_unit_call = condition["statements"][0]["call"]
            spawn_count = next(
                assignment
                for assignment in add_unit_call["assignments"]
                if assignment["variable"]["parameter"]["type"] == "Count"
            )
            spawned_assignment = condition["statements"][1]["assignment"]

            self.assertEqual("AddUnit", add_unit_call["method"]["boardMethod"]["type"])
            self.assertEqual(1, spawn_count["expression"]["postfix"][0]["operand"]["constant"]["value"])
            self.assertEqual(604, spawned_assignment["variable"]["boardKey"])
            self.assertIn("Add", [item.get("operator", {}).get("type") for item in spawned_assignment["expression"]["postfix"]])

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
