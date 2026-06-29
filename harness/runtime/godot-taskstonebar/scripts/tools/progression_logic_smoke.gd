extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const ProgressionState := preload("res://scripts/game/progression_state.gd")
const BasicCombatSim := preload("res://scripts/combat/basic_combat_sim.gd")


func _init() -> void:
	var store = ContentStore.new()
	if not store.load_all():
		_fail("content load failed: %s" % "; ".join(store.errors))
		return

	_smoke_stone_synthesis(store)
	_smoke_stone_equip_loadout(store)
	_smoke_stone_merge_refreshes_equipped_loadout(store)
	_smoke_unit_drop_items(store)
	_smoke_early_monster_hit_budget(store)
	_smoke_stone_direct_drop(store)
	_smoke_deterministic_equipment_drop(store)
	_smoke_combat_progression_loot(store)
	_smoke_equipment_equip_toggle(store)
	_smoke_equipment_synthesis(store)
	_smoke_dynamic_player_level_up(store)
	_smoke_skill_level_up(store)
	_smoke_learned_skill_auto_equip(store)
	_smoke_skill_unlock_requirements(store)

	print("progression logic smoke ok: stone synthesis, stone equip loadout, stone merge loadout refresh, direct loot drops, equipment equip toggle, equipment synthesis, dynamic player level-up, skill unlock/level-up, learned skill auto-equip")
	quit(0)


func _smoke_stone_synthesis(store) -> void:
	var state = ProgressionState.new(store)
	var stone_ids := []
	for _i in range(ProgressionState.STONE_SYNTHESIS_COUNT):
		var added: Dictionary = state.add_item_instance(200202)
		_assert(bool(added.get("ok", false)), "failed to add source stone")
		stone_ids.append(int(added.get("instance", {}).get("instance_id", 0)))

	var result: Dictionary = state.synthesize_stones(stone_ids)
	_assert(bool(result.get("ok", false)), "stone synthesis failed: %s" % str(result))
	_assert(int(result.get("source_item_data_id", 0)) == 200202, "unexpected source stone")
	_assert(int(result.get("result_item_data_id", 0)) == 200203, "unexpected result stone")
	_assert(int(result.get("source_stage", 0)) == 1, "unexpected source stage")
	_assert(int(result.get("result_stage", 0)) == 2, "unexpected result stage")
	_assert(int(result.get("required_count", 0)) == 2, "stone synthesis did not require 2 copies")


func _smoke_stone_equip_loadout(store) -> void:
	var state = ProgressionState.new(store)
	state.add_item_instance(200202)
	state.add_item_instance(200203)
	state.add_item_instance(200204)
	state.add_item_instance(200202)
	var equip_result: Dictionary = state.auto_equip_best_stones()
	_assert(bool(equip_result.get("ok", false)), "stone equip failed")
	var snapshot: Dictionary = state.inventory_snapshot()
	var equipped: Array = snapshot.get("equipped_stones", [])
	var skill_ids: Array = snapshot.get("equipped_skill_ids", [])
	var stats: Dictionary = snapshot.get("equipped_stats", {})
	_assert(equipped.size() == ProgressionState.STONE_EQUIP_SLOT_COUNT, "expected three equipped stones")
	_assert(skill_ids.has(300102) and skill_ids.has(300103) and skill_ids.has(300104), "equipped stone skills were not collected")
	_assert(float(stats.get("Attack", 0.0)) > 0.0, "equipped stone attack stat missing")

	var sim = BasicCombatSim.new(store)
	sim.set_player_stat_bonuses(stats)
	sim.set_player_stone_loadout(equipped)
	sim.start(500101)
	var sim_snapshot: Dictionary = sim.snapshot()
	var player: Dictionary = sim_snapshot.get("player", {})
	_assert(float(player.get("attack", 0.0)) > 42.0, "equipped stone stats did not increase player attack")
	_assert(sim.player_stone_loadout.size() == 3, "equipped stones did not reach combat stone loadout")
	var combat_skill_ids: Array = sim_snapshot.get("player_stone_skill_ids", [])
	_assert(combat_skill_ids.has(300102) and combat_skill_ids.has(300103) and combat_skill_ids.has(300104), "combat stone loadout missing equipped stone skills")

	var all_stone_instances := _stone_instances(snapshot)
	var all_stone_stats := _stone_stat_summary(all_stone_instances)
	var all_stone_sim = BasicCombatSim.new(store)
	all_stone_sim.set_player_stat_bonuses(all_stone_stats)
	all_stone_sim.set_player_stone_loadout(all_stone_instances)
	all_stone_sim.start(500101)
	var all_stone_snapshot: Dictionary = all_stone_sim.snapshot()
	_assert(int(all_stone_snapshot.get("player_stone_count", 0)) == all_stone_instances.size(), "inventory stones did not all reach combat loadout")
	var stone_skill_ids: Array = all_stone_snapshot.get("player_stone_skill_ids", [])
	_assert(stone_skill_ids.size() == all_stone_instances.size(), "stone skill ids were deduplicated instead of kept per stone instance")
	_assert(_count_value(stone_skill_ids, 300102) >= 2, "duplicate stones should keep independent duplicate throw skills")
	for _i in range(360):
		all_stone_sim.step(1.0 / 30.0)
	var cast_snapshot: Dictionary = all_stone_sim.snapshot()
	_assert(int(cast_snapshot.get("player_skill_cast_count", 0)) >= all_stone_instances.size(), "inventory stones did not cast on independent cooldowns")


func _smoke_stone_merge_refreshes_equipped_loadout(store) -> void:
	var state = ProgressionState.new(store)
	var source_ids := []
	for _i in range(3):
		var added: Dictionary = state.add_item_instance(200202)
		_assert(bool(added.get("ok", false)), "failed to add source stone for merge refresh smoke")
		source_ids.append(int(added.get("instance", {}).get("instance_id", 0)))
	for item_id in [200203, 200204, 200205]:
		var added_high: Dictionary = state.add_item_instance(int(item_id))
		_assert(bool(added_high.get("ok", false)), "failed to add high stone for merge refresh smoke")
	state.auto_equip_best_stones()

	var result: Dictionary = state.synthesize_stones(source_ids.slice(0, ProgressionState.STONE_SYNTHESIS_COUNT))
	_assert(bool(result.get("ok", false)), "stone merge refresh synthesis failed: %s" % str(result))
	var snapshot: Dictionary = state.inventory_snapshot()
	var equipped_ids: Array = snapshot.get("equipped_stone_instance_ids", [])
	for consumed_id in source_ids.slice(0, ProgressionState.STONE_SYNTHESIS_COUNT):
		_assert(not equipped_ids.has(consumed_id), "consumed stone instance remained equipped after merge")

	var sim = BasicCombatSim.new(store)
	sim.set_player_stat_bonuses(snapshot.get("equipped_stats", {}))
	sim.set_player_stone_loadout(snapshot.get("equipped_stones", []))
	sim.start(500101)
	var combat_skill_ids: Array = sim.snapshot().get("player_stone_skill_ids", [])
	_assert(not combat_skill_ids.has(300102), "unequipped source stone skill remained in combat loadout after merge")
	_assert(combat_skill_ids.has(300103) and combat_skill_ids.has(300104) and combat_skill_ids.has(300105), "equipped higher stone skills did not reach combat after merge")


func _smoke_unit_drop_items(store) -> void:
	var boss: Dictionary = store.get_unit(111510)
	_assert(not boss.has("taskstonebarDropPolicy"), "drops must be baked into Unit.dropAddItemGroups, not taskstonebarDropPolicy")
	_assert(not store.get_map(500200).has("taskstonebarRewardPolicy"), "map rewards must not depend on taskstonebarRewardPolicy")
	var equipment_group: Dictionary = _find_drop_group_with_item(boss, 200306)
	_assert(not equipment_group.is_empty(), "boss unit missing direct equipment drops in Unit.dropAddItemGroups")
	_assert(float(equipment_group.get("probPercent", 0.0)) == 100.0, "boss equipment drop chance must come from Unit.dropAddItemGroups")
	for item_id in [200306, 200316, 200326, 200336, 200346, 200356]:
		_assert(_drop_items_include(boss, int(item_id)), "boss unit missing grade 6 equipment item %d" % int(item_id))
	_assert(not _drop_items_include(boss, 200307), "boss direct equipment exceeded grade 6 cap")
	var stone_group: Dictionary = _find_drop_group_with_item(boss, 200207)
	_assert(not stone_group.is_empty(), "boss unit missing direct stone drops in Unit.dropAddItemGroups")
	_assert(float(stone_group.get("probPercent", 0.0)) == 12.0, "boss stone drop chance must come from Unit.dropAddItemGroups")
	_assert(not _drop_items_include(boss, 200208), "boss direct stone exceeded stage 6 cap")

	var normal: Dictionary = store.get_unit(111011)
	var normal_equipment_group: Dictionary = _find_drop_group_with_item(normal, 200301)
	_assert(not normal_equipment_group.is_empty(), "normal unit missing direct equipment drops")
	_assert(float(normal_equipment_group.get("probPercent", 0.0)) == 3.0, "normal equipment drop chance must come from Unit.dropAddItemGroups")
	var normal_stone_group: Dictionary = _find_drop_group_with_item(normal, 200202)
	_assert(not normal_stone_group.is_empty(), "normal unit missing direct stone drops")
	_assert(float(normal_stone_group.get("probPercent", 0.0)) == 8.0, "early normal stone drop chance must come from Unit.dropAddItemGroups")
	var later_normal: Dictionary = store.get_unit(111021)
	var later_stone_group: Dictionary = _find_drop_group_with_item(later_normal, 200202)
	_assert(not later_stone_group.is_empty(), "later normal unit missing direct stone drops")
	_assert(float(later_stone_group.get("probPercent", 0.0)) == 0.18, "later normal stone drop chance should keep the long-tail rate")


func _smoke_early_monster_hit_budget(store) -> void:
	var state = ProgressionState.new(store)
	for _i in range(ProgressionState.STONE_SYNTHESIS_COUNT):
		state.add_item_instance(200202)
	state.add_item_instance(200203)
	state.add_item_instance(200204)
	var snapshot: Dictionary = state.inventory_snapshot()
	var stones := _stone_instances(snapshot)
	var sim = BasicCombatSim.new(store)
	sim.set_player_stat_bonuses(_stone_stat_summary(stones))
	sim.set_player_stone_loadout(stones)
	sim.start(500101)
	for _i in range(30):
		sim.step(1.0 / 30.0)
	var sim_snapshot: Dictionary = sim.snapshot()
	var player: Dictionary = sim_snapshot.get("player", {})
	var first_enemy := _first_alive_enemy(sim_snapshot)
	if first_enemy.is_empty():
		_fail("early hit budget smoke could not find the first enemy")
		return
	var attack := float(player.get("attack", 0.0))
	var enemy_hp := float(first_enemy.get("max_hp", 0.0))
	var enemy_defense := float(first_enemy.get("defense", 0.0))
	var basic_damage := maxf(1.0, attack * store.skill_damage_total_ratio(store.get_skill(300102), 1) - enemy_defense * BasicCombatSim.DAMAGE_DEFENSE_SCALE)
	var crack_damage := maxf(1.0, attack * store.skill_damage_total_ratio(store.get_skill(300104), 1) - enemy_defense * BasicCombatSim.DAMAGE_DEFENSE_SCALE)
	_assert(enemy_hp > crack_damage, "early monster should survive the strongest starter stone hit: hp=%.1f crack=%.1f" % [enemy_hp, crack_damage])
	_assert(enemy_hp <= basic_damage * 3.05, "early monster should die within roughly three basic starter hits: hp=%.1f basic=%.1f" % [enemy_hp, basic_damage])


func _smoke_stone_direct_drop(store) -> void:
	var state = ProgressionState.new(store)
	state.set_seed(20261001)
	var drop: Dictionary = state.grant_monster_kill_stone(111510, 100, {"stage": 6})
	_assert(bool(drop.get("ok", false)) and bool(drop.get("dropped", false)), "fixed stone drop failed")
	_assert(int(drop.get("stage", 0)) == 6, "expected direct stage 6 stone")
	var item: Dictionary = drop.get("result", {})
	_assert(int(item.get("item_data_id", 0)) == 200207, "stage 6 stone should be lava stone")
	_assert(_has_instance_with_item(state.inventory_snapshot(), 200207), "dropped stone did not reach inventory")


func _smoke_deterministic_equipment_drop(store) -> void:
	var first = ProgressionState.new(store)
	first.set_seed(424242)
	var drop_a: Dictionary = first.grant_monster_kill_equipment(111011, 18)

	var second = ProgressionState.new(store)
	second.set_seed(424242)
	var drop_b: Dictionary = second.grant_monster_kill_equipment(111011, 18)

	_assert(bool(drop_a.get("ok", false)) and bool(drop_a.get("dropped", false)), "first equipment drop failed")
	_assert(bool(drop_b.get("ok", false)) and bool(drop_b.get("dropped", false)), "second equipment drop failed")
	var item_a: Dictionary = drop_a.get("result", {})
	var item_b: Dictionary = drop_b.get("result", {})
	_assert(int(item_a.get("item_data_id", 0)) == int(item_b.get("item_data_id", 0)), "seeded drops produced different items")
	_assert(str(item_a.get("slot", "")) == str(item_b.get("slot", "")), "seeded drops produced different slots")
	_assert(int(item_a.get("grade", 0)) == int(item_b.get("grade", 0)), "seeded drops produced different grades")
	_assert(str(item_a.get("stats", {})) == str(item_b.get("stats", {})), "seeded drops produced different stats")
	_assert(not item_a.get("stats", {}).is_empty(), "equipment drop has no stats")
	_assert(str(item_a.get("category", "")) == "Equipment", "drop result is not equipment")
	_assert(str(item_a.get("slot", "")) != "", "equipment drop has no slot")
	_assert(int(item_a.get("grade", 0)) >= 1, "equipment drop has no grade")


func _smoke_combat_progression_loot(store) -> void:
	var state = ProgressionState.new(store)
	state.set_seed(60624)
	var sim = BasicCombatSim.new(store)
	sim.set_progression_state(state)
	sim.start(500101)
	sim._add_reward_item({"itemDataId": 5, "count": 7})
	_assert(state.material_count(5) == 7, "gold reward did not reach progression materials")
	_assert(int(sim.snapshot().get("resources", {}).get("gold", 0)) == 7, "gold reward did not reach combat resources")
	sim._add_reward_item({"itemDataId": 6, "count": 11})
	_assert(state.material_count(6) == 11, "exp reward did not reach progression materials")
	_assert(int(sim.snapshot().get("resources", {}).get("exp", 0)) == 11, "exp reward did not reach combat resources")

	var boss: Dictionary = store.get_unit(111510)
	for _i in range(120):
		sim._apply_unit_rewards(boss)
	var snapshot := state.inventory_snapshot()
	var equipment_count := 0
	var stone_count := 0
	var max_equipment_grade := 0
	var max_stone_stage := 0
	for instance in snapshot.get("items", []):
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if str(instance.get("category", "")) == "Equipment":
			equipment_count += 1
			max_equipment_grade = maxi(max_equipment_grade, int(instance.get("grade", 0)))
		if _instance_has_tag(instance, "StoneWeapon"):
			stone_count += 1
			max_stone_stage = maxi(max_stone_stage, int(instance.get("stage", 0)))
	_assert(equipment_count >= 1, "combat progression loot did not create equipment")
	_assert(stone_count >= 1, "combat progression loot did not create stones")
	_assert(max_equipment_grade <= 6, "map 100 direct equipment exceeded grade 6 cap")
	_assert(max_stone_stage == 6, "map 100 direct stone did not reach stage 6")


func _smoke_equipment_synthesis(store) -> void:
	var state = ProgressionState.new(store)
	state.set_seed(9090)
	var equipment_ids := []
	for _i in range(ProgressionState.EQUIPMENT_SYNTHESIS_COUNT):
		var drop: Dictionary = state.grant_monster_kill_equipment(111011, 1, {"slot": "Head", "grade": 1})
		_assert(bool(drop.get("ok", false)) and bool(drop.get("dropped", false)), "fixed equipment drop failed")
		equipment_ids.append(int(drop.get("result", {}).get("instance_id", 0)))

	var result: Dictionary = state.synthesize_equipment(equipment_ids)
	_assert(bool(result.get("ok", false)), "equipment synthesis failed: %s" % str(result))
	_assert(int(result.get("source_grade", 0)) == 1, "unexpected source equipment grade")
	_assert(int(result.get("result_grade", 0)) == 2, "unexpected result equipment grade")
	_assert(str(result.get("slot", "")) == "Head", "unexpected result equipment slot")
	var item: Dictionary = result.get("result", {})
	_assert(int(item.get("item_data_id", 0)) == 200302, "unexpected result equipment item")
	_assert(not item.get("stats", {}).is_empty(), "synthesized equipment has no stats")


func _smoke_equipment_equip_toggle(store) -> void:
	var state = ProgressionState.new(store)
	state.set_seed(8080)
	var drop: Dictionary = state.grant_monster_kill_equipment(111011, 1, {"slot": "Head", "grade": 1})
	_assert(bool(drop.get("ok", false)) and bool(drop.get("dropped", false)), "fixed equipment drop failed for equip toggle")
	var instance_id := int(drop.get("result", {}).get("instance_id", 0))
	var equip_result: Dictionary = state.equip_equipment(instance_id)
	_assert(bool(equip_result.get("ok", false)), "equipment equip failed: %s" % str(equip_result))
	var snapshot: Dictionary = state.inventory_snapshot()
	var equipped_ids: Dictionary = snapshot.get("equipped_equipment_instance_ids", {})
	_assert(int(equipped_ids.get("Head", 0)) == instance_id, "equipped equipment id was not recorded in the Head slot")
	var equipment_stats: Dictionary = snapshot.get("equipped_equipment_stats", {})
	_assert(not equipment_stats.is_empty(), "equipped equipment stats were not collected")
	var combined_stats: Dictionary = snapshot.get("equipped_stats", {})
	for stat_key in equipment_stats.keys():
		_assert(absf(float(combined_stats.get(stat_key, 0.0)) - float(equipment_stats[stat_key])) < 0.01, "equipment stat %s did not flow into equipped_stats" % str(stat_key))
	var unequip_result: Dictionary = state.unequip_equipment(instance_id)
	_assert(bool(unequip_result.get("ok", false)), "equipment unequip failed: %s" % str(unequip_result))
	snapshot = state.inventory_snapshot()
	equipped_ids = snapshot.get("equipped_equipment_instance_ids", {})
	_assert(not equipped_ids.has("Head"), "equipment remained in Head slot after unequip")


func _smoke_dynamic_player_level_up(store) -> void:
	var state = ProgressionState.new(store)
	var sim = BasicCombatSim.new(store)
	sim.set_progression_state(state)
	sim.start(500101)

	var before: Dictionary = sim.snapshot().get("player", {})
	var attack_before := float(before.get("attack", 0.0))
	var first_required := int(before.get("required_exp", 0))
	_assert(first_required == 28, "map requiredExps[0] should drive level 1 requirement")

	var live_state = ProgressionState.new(store)
	var live_sim = BasicCombatSim.new(store)
	live_sim.set_progression_state(live_state)
	live_sim.start(500101)
	var normal_unit: Dictionary = store.get_unit(111011)
	for _i in range(6):
		live_sim._apply_unit_rewards(normal_unit)
	var live_player: Dictionary = live_sim.snapshot().get("player", {})
	_assert(int(live_player.get("level", 0)) == 2, "real monster exp drops did not level the player during combat")
	_assert(int(live_player.get("exp", -1)) == 2, "real monster exp drops did not leave the expected overflow exp")
	_assert(live_state.material_count(200501) == 1, "real monster level-up did not grant a skill point")
	_assert(live_state.material_count(200569) == 3, "real monster level-up did not grant stat points")

	sim._add_reward_item({"itemDataId": 1, "exp": first_required})
	var after_first: Dictionary = sim.snapshot().get("player", {})
	_assert(int(after_first.get("level", 0)) == 2, "player did not level dynamically from exp reward")
	_assert(int(after_first.get("exp", -1)) == 0, "level-up should consume exactly the required exp")
	_assert(float(after_first.get("attack", 0.0)) > attack_before, "level-up did not refresh player stats")
	_assert(state.material_count(200501) == 1, "level-up did not grant a skill point")
	_assert(state.material_count(200569) == 3, "level-up did not grant stat points")

	sim._add_reward_item({"itemDataId": 1, "exp": 56})
	var before_threshold: Dictionary = sim.snapshot().get("player", {})
	_assert(int(before_threshold.get("level", 0)) == 2, "player should not level before reaching level 2 requirement")
	_assert(int(before_threshold.get("exp", -1)) == 56, "player exp should accumulate within the current level")

	sim._add_reward_item({"itemDataId": 1, "exp": 1})
	var after_second: Dictionary = sim.snapshot().get("player", {})
	_assert(int(after_second.get("level", 0)) == 3, "player did not level when exp reached level 2 requirement")
	_assert(int(after_second.get("exp", -1)) == 0, "second level-up should consume the level 2 requirement")
	_assert(state.material_count(200501) == 2, "second level-up did not grant another skill point")
	_assert(state.material_count(200569) == 6, "second level-up did not grant another stat point bundle")


func _smoke_skill_level_up(store) -> void:
	var state = ProgressionState.new(store)
	state.add_material(200501, 3)
	var learned: Dictionary = state.learn_skill(200502)
	_assert(bool(learned.get("ok", false)), "learn skill failed")
	_assert(int(learned.get("skill", {}).get("level", 0)) == 1, "learned skill is not level 1")

	var preview: Dictionary = state.skill_level_up_preview(200502)
	_assert(bool(preview.get("ok", false)), "skill level preview failed")
	_assert(bool(preview.get("can_afford", false)), "skill level preview should be affordable")
	_assert(float(preview.get("effect_delta", {}).get("damage_ratio", 0.0)) > 0.0, "skill level-up has no damage increase")

	var upgraded: Dictionary = state.level_up_skill(200502)
	_assert(bool(upgraded.get("ok", false)), "skill level-up failed")
	_assert(int(upgraded.get("skill", {}).get("level", 0)) == 2, "skill did not reach level 2")
	_assert(state.material_count(200501) == 2, "skill point was not consumed")
	_assert(float(upgraded.get("effect_after", {}).get("damage_ratio", 0.0)) > float(upgraded.get("effect_before", {}).get("damage_ratio", 0.0)), "skill effect did not increase")


func _smoke_learned_skill_auto_equip(store) -> void:
	var state = ProgressionState.new(store)
	state.add_item_instance(200202)
	state.add_item_instance(200203)
	state.add_item_instance(200204)
	state.auto_equip_best_stones()
	state.learn_skill(200502, 2)
	var snapshot: Dictionary = state.inventory_snapshot()
	var learned_skill_ids: Array = snapshot.get("learned_skill_ids", [])
	_assert(learned_skill_ids.has(300101), "learned skill item 200502 did not expose skillDataId 300101")
	var learned_skills: Array = snapshot.get("learned_skills", [])
	_assert(not learned_skills.is_empty(), "learned skill summaries are missing")

	var sim = BasicCombatSim.new(store)
	sim.set_progression_state(state)
	sim.set_player_stat_bonuses(snapshot.get("equipped_stats", {}))
	sim.set_player_learned_skills(learned_skills)
	sim.set_player_stone_loadout(snapshot.get("equipped_stones", []))
	sim.start(500101)
	var start_snapshot: Dictionary = sim.snapshot()
	_assert((start_snapshot.get("player_learned_skill_ids", []) as Array).has(300101), "learned skill did not reach combat learned rotation")
	for _i in range(360):
		sim.step(1.0 / 30.0)
	var cast_snapshot: Dictionary = sim.snapshot()
	_assert(int(cast_snapshot.get("player_learned_skill_cast_count", 0)) > 0, "learned skill did not auto-cast while stones were equipped")
	var saw_learned_fx := false
	for event in cast_snapshot.get("fx_events", []):
		if typeof(event) == TYPE_DICTIONARY and bool((event as Dictionary).get("is_learned_skill", false)):
			saw_learned_fx = true
			break
	_assert(saw_learned_fx, "learned skill cast did not mark a visible learned-skill FX event")


func _smoke_skill_unlock_requirements(store) -> void:
	var state = ProgressionState.new(store)
	state.add_material(200501, 3)
	var low_level_preview: Dictionary = state.skill_unlock_preview(200509, 1)
	_assert(not bool(low_level_preview.get("ok", false)), "branch skill should be locked below player level gate")
	_assert(str(low_level_preview.get("error", "")) == "player_level_locked", "branch skill should report the player level gate first")

	var missing_parent_preview: Dictionary = state.skill_unlock_preview(200509, 15)
	_assert(not bool(missing_parent_preview.get("ok", false)), "branch skill should require parent skill ownership")
	_assert(str(missing_parent_preview.get("error", "")) == "required_skill_missing", "missing parent skill was not reported")

	state.learn_skill(200503, 2)
	var parent_level_preview: Dictionary = state.skill_unlock_preview(200509, 15)
	_assert(not bool(parent_level_preview.get("ok", false)), "branch skill should require parent skill level")
	_assert(str(parent_level_preview.get("error", "")) == "required_skill_level", "parent skill level gate was not reported")

	state.learn_skill(200503, 3)
	var ready_preview: Dictionary = state.skill_unlock_preview(200509, 15)
	_assert(bool(ready_preview.get("ok", false)), "branch skill should unlock when level, parent level, and SP are ready")
	_assert(int(ready_preview.get("required_player_level", 0)) == 15, "unlock preview lost the player level requirement")
	_assert(int(ready_preview.get("required_skill_level", 0)) == 3, "unlock preview lost the parent skill level requirement")
	_assert(int(ready_preview.get("cost", [])[0].get("count", 0)) == 2, "unlock preview lost the SP cost")

	var unlocked: Dictionary = state.unlock_skill(200509, 15)
	_assert(bool(unlocked.get("ok", false)), "unlock_skill failed after ready preview")
	_assert(int(unlocked.get("skill", {}).get("level", 0)) == 1, "unlocked branch skill should start at level 1")
	_assert(state.material_count(200501) == 1, "unlock_skill did not consume the branch unlock SP cost")


func _has_instance_with_item(snapshot: Dictionary, item_data_id: int) -> bool:
	for instance in snapshot.get("items", []):
		if typeof(instance) == TYPE_DICTIONARY and int(instance.get("item_data_id", 0)) == int(item_data_id):
			return true
	return false


func _instance_has_tag(instance: Dictionary, tag: String) -> bool:
	var tags = instance.get("tags", [])
	return typeof(tags) == TYPE_ARRAY and tags.has(tag)


func _stone_instances(snapshot: Dictionary) -> Array:
	var result := []
	for instance in snapshot.get("items", []):
		if typeof(instance) == TYPE_DICTIONARY and _instance_has_tag(instance, "StoneWeapon"):
			result.append(instance)
	return result


func _stone_stat_summary(stones: Array) -> Dictionary:
	var result := {}
	for instance in stones:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var stats: Dictionary = instance.get("stats", {}) if typeof(instance.get("stats", {})) == TYPE_DICTIONARY else {}
		for stat_type in stats.keys():
			result[str(stat_type)] = float(result.get(str(stat_type), 0.0)) + float(stats[stat_type])
	return result


func _count_value(values: Array, wanted: int) -> int:
	var count := 0
	for value in values:
		if int(value) == int(wanted):
			count += 1
	return count


func _drop_items_include(unit: Dictionary, item_data_id: int) -> bool:
	return not _find_drop_group_with_item(unit, item_data_id).is_empty()


func _find_drop_group_with_item(unit: Dictionary, item_data_id: int) -> Dictionary:
	for group in unit.get("dropAddItemGroups", []):
		if typeof(group) != TYPE_DICTIONARY:
			continue
		var add_items = group.get("addItems", [])
		if typeof(add_items) != TYPE_ARRAY:
			continue
		for add_item in add_items:
			if typeof(add_item) == TYPE_DICTIONARY and int(add_item.get("itemDataId", 0)) == int(item_data_id):
				return group
	return {}


func _first_alive_enemy(snapshot: Dictionary) -> Dictionary:
	for enemy in snapshot.get("enemies", []):
		if typeof(enemy) == TYPE_DICTIONARY and bool(enemy.get("alive", true)):
			return enemy
	return {}


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	_fail(message)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
