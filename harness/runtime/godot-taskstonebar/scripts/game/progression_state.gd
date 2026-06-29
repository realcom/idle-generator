extends RefCounted

const STONE_SYNTHESIS_COUNT := 2
const STONE_EQUIP_SLOT_COUNT := 3
const EQUIPMENT_SYNTHESIS_COUNT := 3
const SKILL_LEVEL_DAMAGE_BONUS := 0.12
const EQUIPMENT_SLOTS := ["Head", "Chest", "Gloves", "Boots", "Necklace", "Ring"]
const DIRECT_LOOT_LEVELS_PER_GRADE := 20
const DIRECT_LOOT_MAX_GRADE := 6

var store
var rng := RandomNumberGenerator.new()
var next_instance_id := 1
var materials := {}
var item_instances := {}
var equipped_stone_instance_ids := []
var equipped_equipment_instance_ids := {}
var skills := {}


func _init(resource_store = null) -> void:
	store = resource_store
	rng.randomize()


func reset() -> void:
	next_instance_id = 1
	materials.clear()
	item_instances.clear()
	equipped_stone_instance_ids.clear()
	equipped_equipment_instance_ids.clear()
	skills.clear()


func set_seed(seed_value: int) -> void:
	rng.seed = int(seed_value)


func add_material(item_data_id: int, count: int) -> Dictionary:
	var item_id := int(item_data_id)
	var safe_count := maxi(0, int(count))
	materials[item_id] = int(materials.get(item_id, 0)) + safe_count
	return {
		"ok": true,
		"item_data_id": item_id,
		"count": int(materials.get(item_id, 0)),
	}


func material_count(item_data_id: int) -> int:
	return int(materials.get(int(item_data_id), 0))


func add_item_instance(item_data_id: int, level := 1) -> Dictionary:
	var item: Dictionary = _item(item_data_id)
	if item.is_empty():
		return _fail("unknown_item", "Unknown itemDataId %d" % int(item_data_id))
	var instance := _create_item_instance(item, level, false)
	item_instances[int(instance["instance_id"])] = instance
	return {"ok": true, "instance": instance.duplicate(true)}


func inventory_snapshot() -> Dictionary:
	var items := []
	for instance_id in item_instances.keys():
		items.append(item_instances[instance_id].duplicate(true))
	return {
		"materials": materials.duplicate(true),
		"items": items,
		"equipped_stone_instance_ids": equipped_stone_instance_ids.duplicate(true),
		"equipped_equipment_instance_ids": _equipped_equipment_instance_ids(),
		"equipped_stones": _equipped_stone_instances(),
		"equipped_equipment": _equipped_equipment_instances(),
		"equipped_stats": _equipped_stat_summary(),
		"equipped_equipment_stats": _equipped_equipment_stat_summary(),
		"equipped_skill_ids": _equipped_skill_ids(),
		"learned_skill_ids": _learned_skill_ids(),
		"learned_skills": _learned_skill_summaries(),
		"skills": skills.duplicate(true),
	}


func equip_equipment(instance_id: int) -> Dictionary:
	var safe_id := int(instance_id)
	if not item_instances.has(safe_id):
		return _fail("missing_instance", "Equipment instance %d is missing" % safe_id)
	var instance: Dictionary = item_instances[safe_id]
	if not _is_equipment_instance(instance):
		return _fail("not_equipment", "Instance %d is not Equipment" % safe_id)
	var slot := str(instance.get("slot", instance.get("type", "")))
	if slot == "":
		return _fail("missing_slot", "Equipment instance %d has no slot" % safe_id)
	equipped_equipment_instance_ids[slot] = safe_id
	_compact_equipped_equipment()
	return {
		"ok": true,
		"slot": slot,
		"equipped": _equipped_equipment_instances(),
		"stats": _equipped_equipment_stat_summary(),
	}


func unequip_equipment(instance_id: int) -> Dictionary:
	var safe_id := int(instance_id)
	var removed_slot := ""
	for slot in equipped_equipment_instance_ids.keys():
		if int(equipped_equipment_instance_ids[slot]) == safe_id:
			removed_slot = str(slot)
			break
	if removed_slot != "":
		equipped_equipment_instance_ids.erase(removed_slot)
	_compact_equipped_equipment()
	return {
		"ok": true,
		"slot": removed_slot,
		"unequipped": removed_slot != "",
		"equipped": _equipped_equipment_instances(),
		"stats": _equipped_equipment_stat_summary(),
	}


func auto_equip_best_equipment() -> Dictionary:
	equipped_equipment_instance_ids.clear()
	for instance in _equipment_instances_sorted_for_equip():
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var slot := str(instance.get("slot", instance.get("type", "")))
		if slot == "" or equipped_equipment_instance_ids.has(slot):
			continue
		equipped_equipment_instance_ids[slot] = int(instance.get("instance_id", 0))
	_compact_equipped_equipment()
	return {
		"ok": true,
		"equipped": _equipped_equipment_instances(),
		"stats": _equipped_equipment_stat_summary(),
	}


func equip_stone(instance_id: int, slot_index := -1) -> Dictionary:
	var safe_id := int(instance_id)
	if not item_instances.has(safe_id):
		return _fail("missing_instance", "Stone instance %d is missing" % safe_id)
	var instance: Dictionary = item_instances[safe_id]
	if not _is_stone_instance(instance):
		return _fail("not_stone", "Instance %d is not a StoneWeapon" % safe_id)
	if equipped_stone_instance_ids.has(safe_id):
		return {
			"ok": true,
			"equipped": _equipped_stone_instances(),
			"stats": _equipped_stat_summary(),
			"skill_ids": _equipped_skill_ids(),
		}

	if int(slot_index) >= 0:
		var index := clampi(int(slot_index), 0, STONE_EQUIP_SLOT_COUNT - 1)
		while equipped_stone_instance_ids.size() <= index:
			equipped_stone_instance_ids.append(0)
		equipped_stone_instance_ids[index] = safe_id
	elif equipped_stone_instance_ids.size() < STONE_EQUIP_SLOT_COUNT:
		equipped_stone_instance_ids.append(safe_id)
	else:
		equipped_stone_instance_ids[0] = safe_id

	_compact_equipped_stones()
	return {
		"ok": true,
		"equipped": _equipped_stone_instances(),
		"stats": _equipped_stat_summary(),
		"skill_ids": _equipped_skill_ids(),
	}


func auto_equip_best_stones() -> Dictionary:
	var candidates := _stone_instances_sorted_for_equip()
	equipped_stone_instance_ids.clear()
	for instance in candidates:
		if equipped_stone_instance_ids.size() >= STONE_EQUIP_SLOT_COUNT:
			break
		if typeof(instance) == TYPE_DICTIONARY:
			equipped_stone_instance_ids.append(int(instance.get("instance_id", 0)))
	_compact_equipped_stones()
	return {
		"ok": true,
		"equipped": _equipped_stone_instances(),
		"stats": _equipped_stat_summary(),
		"skill_ids": _equipped_skill_ids(),
	}


func synthesize_stones(instance_ids: Array) -> Dictionary:
	if instance_ids.size() != STONE_SYNTHESIS_COUNT:
		return _fail("stone_count", "Stone synthesis requires %d instances" % STONE_SYNTHESIS_COUNT)

	var instances := _instances_for_ids(instance_ids)
	if int(instances.get("missing", 0)) > 0:
		return _fail("missing_instance", "One or more stone instances are missing")
	var consumed: Array = instances.get("items", [])
	if consumed.size() != STONE_SYNTHESIS_COUNT:
		return _fail("stone_count", "Stone synthesis requires %d instances" % STONE_SYNTHESIS_COUNT)

	var source_item_id := int(consumed[0].get("item_data_id", 0))
	var source_item: Dictionary = _item(source_item_id)
	if not _has_tag(source_item, "StoneWeapon"):
		return _fail("not_stone", "Source item is not a StoneWeapon")

	for instance in consumed:
		if int(instance.get("item_data_id", 0)) != source_item_id:
			return _fail("mixed_stones", "Stone synthesis requires two copies of the same stone")

	var next_item := _next_stone_item(source_item)
	if next_item.is_empty():
		return _fail("terminal_stone", "Stone has no higher stage")

	var consumed_summaries := _summaries_for_instances(consumed)
	for instance in consumed:
		item_instances.erase(int(instance.get("instance_id", 0)))
	var removed_equipped := _remove_equipped_instances(consumed_summaries)

	var result_instance := _create_item_instance(next_item, 1, false)
	item_instances[int(result_instance["instance_id"])] = result_instance
	if removed_equipped or equipped_stone_instance_ids.size() < mini(STONE_EQUIP_SLOT_COUNT, _stone_instances_sorted_for_equip().size()):
		auto_equip_best_stones()

	return {
		"ok": true,
		"recipe_id": _stone_recipe_id_for(source_item_id),
		"source_item_data_id": source_item_id,
		"result_item_data_id": int(next_item.get("id", 0)),
		"source_stage": _stone_stage(source_item),
		"result_stage": _stone_stage(next_item),
		"required_count": STONE_SYNTHESIS_COUNT,
		"consumed": consumed_summaries,
		"result": result_instance.duplicate(true),
	}


func grant_monster_kill_equipment(unit_data_id: int, monster_level := 1, context := {}) -> Dictionary:
	var drop_chance := float(context.get("drop_chance_percent", 100.0))
	var chance_roll := rng.randf() * 100.0
	if chance_roll > drop_chance:
		return {
			"ok": true,
			"dropped": false,
			"unit_data_id": int(unit_data_id),
			"monster_level": int(monster_level),
			"drop_chance_percent": drop_chance,
			"chance_roll": chance_roll,
		}

	var grade := _drop_grade(monster_level, context)
	var slot := _drop_slot(context)
	var item := _equipment_item(slot, grade)
	if item.is_empty():
		return _fail("missing_equipment", "No equipment item for slot %s grade %d" % [slot, grade])

	var instance := _create_item_instance(item, 1, true)
	item_instances[int(instance["instance_id"])] = instance
	return {
		"ok": true,
		"dropped": true,
		"unit_data_id": int(unit_data_id),
		"monster_level": int(monster_level),
		"drop_chance_percent": drop_chance,
		"chance_roll": chance_roll,
		"grade": int(item.get("grade", grade)),
		"slot": slot,
		"result": instance.duplicate(true),
	}


func grant_monster_kill_stone(unit_data_id: int, monster_level := 1, context := {}) -> Dictionary:
	var drop_chance := float(context.get("drop_chance_percent", 100.0))
	var chance_roll := rng.randf() * 100.0
	if chance_roll > drop_chance:
		return {
			"ok": true,
			"dropped": false,
			"unit_data_id": int(unit_data_id),
			"monster_level": int(monster_level),
			"drop_chance_percent": drop_chance,
			"chance_roll": chance_roll,
		}

	var stage := _drop_stone_stage(monster_level, context)
	var item := _stone_item(stage)
	if item.is_empty():
		return _fail("missing_stone", "No stone item for stage %d" % stage)

	var instance := _create_item_instance(item, 1, false)
	item_instances[int(instance["instance_id"])] = instance
	return {
		"ok": true,
		"dropped": true,
		"unit_data_id": int(unit_data_id),
		"monster_level": int(monster_level),
		"drop_chance_percent": drop_chance,
		"chance_roll": chance_roll,
		"stage": _stone_stage(item),
		"result": instance.duplicate(true),
	}


func synthesize_equipment(instance_ids: Array, result_slot := "") -> Dictionary:
	if instance_ids.size() != EQUIPMENT_SYNTHESIS_COUNT:
		return _fail("equipment_count", "Equipment synthesis requires %d instances" % EQUIPMENT_SYNTHESIS_COUNT)

	var instances := _instances_for_ids(instance_ids)
	if int(instances.get("missing", 0)) > 0:
		return _fail("missing_instance", "One or more equipment instances are missing")
	var consumed: Array = instances.get("items", [])
	if consumed.size() != EQUIPMENT_SYNTHESIS_COUNT:
		return _fail("equipment_count", "Equipment synthesis requires %d instances" % EQUIPMENT_SYNTHESIS_COUNT)

	var source_grade := int(consumed[0].get("grade", 1))
	var slot := str(result_slot)
	if slot == "":
		slot = str(consumed[0].get("slot", consumed[0].get("type", "")))
	if slot == "":
		return _fail("missing_slot", "Equipment synthesis needs a result slot")

	for instance in consumed:
		if str(instance.get("category", "")) != "Equipment":
			return _fail("not_equipment", "All consumed instances must be Equipment")
		if int(instance.get("grade", 0)) != source_grade:
			return _fail("mixed_equipment_grade", "All consumed equipment must share a grade")

	var result_grade := source_grade + 1
	var target_item := _equipment_item(slot, result_grade)
	if target_item.is_empty():
		return _fail("terminal_equipment", "No higher equipment for slot %s grade %d" % [slot, result_grade])

	var consumed_summaries := _summaries_for_instances(consumed)
	for instance in consumed:
		item_instances.erase(int(instance.get("instance_id", 0)))
	var removed_equipment_slot := _remove_equipped_equipment_instances(consumed_summaries)

	var result_instance := _create_item_instance(target_item, 1, true)
	item_instances[int(result_instance["instance_id"])] = result_instance
	if removed_equipment_slot != "":
		equipped_equipment_instance_ids[removed_equipment_slot] = int(result_instance["instance_id"])
		_compact_equipped_equipment()
	return {
		"ok": true,
		"recipe_id": _equipment_recipe_id_for(slot, source_grade),
		"source_grade": source_grade,
		"result_grade": result_grade,
		"required_count": EQUIPMENT_SYNTHESIS_COUNT,
		"slot": slot,
		"consumed": consumed_summaries,
		"result": result_instance.duplicate(true),
	}


func learn_skill(skill_item_data_id: int, level := 1) -> Dictionary:
	var item: Dictionary = _item(skill_item_data_id)
	if item.is_empty():
		return _fail("unknown_skill_item", "Unknown skill itemDataId %d" % int(skill_item_data_id))
	if str(item.get("category", "")) != "Skill":
		return _fail("not_skill_item", "Item is not a skill")

	var skill_item_id := int(item.get("id", skill_item_data_id))
	var safe_level := clampi(int(level), 1, _max_skill_level(item))
	var effect := _skill_effect(item, safe_level)
	skills[skill_item_id] = {
		"skill_item_data_id": skill_item_id,
		"skill_data_id": int(item.get("skillDataId", 0)),
		"name": str(item.get("name", "")),
		"level": safe_level,
		"max_level": _max_skill_level(item),
		"effect": effect,
	}
	return {
		"ok": true,
		"skill": skills[skill_item_id].duplicate(true),
	}


func skill_unlock_preview(skill_item_data_id: int, player_level := 1) -> Dictionary:
	var item: Dictionary = _item(skill_item_data_id)
	if item.is_empty():
		return _fail("unknown_skill_item", "Unknown skill itemDataId %d" % int(skill_item_data_id))
	if str(item.get("category", "")) != "Skill":
		return _fail("not_skill_item", "Item is not a skill")

	var skill_item_id := int(item.get("id", skill_item_data_id))
	var safe_player_level := maxi(1, int(player_level))
	var required_player_level := _skill_required_player_level(item)
	var required_skill_level := _skill_required_level(item)
	var required_ids := _skill_required_ids(item)
	var cost := _skill_unlock_cost(item)
	var can_afford := _can_afford(cost)
	var missing_cost := _missing_cost(cost)
	var required_skills := []
	var missing_requirements := []
	var requirements_ready := true
	var first_error := ""
	var first_message := ""

	if skills.has(skill_item_id):
		return {
			"ok": false,
			"error": "skill_already_owned",
			"message": "Skill is already owned",
			"skill_item_data_id": skill_item_id,
			"owned": true,
			"level": int(skills[skill_item_id].get("level", 1)) if typeof(skills[skill_item_id]) == TYPE_DICTIONARY else 1,
			"max_level": _max_skill_level(item),
			"player_level": safe_player_level,
			"required_player_level": required_player_level,
			"required_skill_level": required_skill_level,
			"required_skills": required_skills,
			"missing_requirements": missing_requirements,
			"cost": cost,
			"can_afford": true,
			"missing_cost": [],
			"requirements_ready": true,
		}

	if safe_player_level < required_player_level:
		requirements_ready = false
		first_error = "player_level_locked"
		first_message = "Player level %d required" % required_player_level
		missing_requirements.append({
			"type": "player_level",
			"need": required_player_level,
			"have": safe_player_level,
		})

	for required_id in required_ids:
		var required_item: Dictionary = _item(int(required_id))
		var required_entry: Dictionary = skills[int(required_id)] if skills.has(int(required_id)) and typeof(skills[int(required_id)]) == TYPE_DICTIONARY else {}
		var current_level := int(required_entry.get("level", 0))
		var ready := current_level >= required_skill_level
		var required_summary := {
			"item_data_id": int(required_id),
			"name": str(required_item.get("name", str(required_id))),
			"level": current_level,
			"required_level": required_skill_level,
			"ok": ready,
		}
		required_skills.append(required_summary)
		if ready:
			continue
		requirements_ready = false
		var missing_type := "required_skill_level" if current_level > 0 else "required_skill_missing"
		missing_requirements.append({
			"type": missing_type,
			"item_data_id": int(required_id),
			"name": str(required_item.get("name", str(required_id))),
			"need": required_skill_level,
			"have": current_level,
		})
		if first_error == "":
			first_error = missing_type
			first_message = "%s Lv.%d required" % [str(required_item.get("name", str(required_id))), required_skill_level]

	if not can_afford and first_error == "":
		first_error = "insufficient_materials"
		first_message = "Not enough skill unlock materials"

	var ok := requirements_ready and can_afford
	var result := {
		"ok": ok,
		"skill_item_data_id": skill_item_id,
		"skill_data_id": int(item.get("skillDataId", 0)),
		"name": str(item.get("name", "")),
		"owned": false,
		"level": 0,
		"max_level": _max_skill_level(item),
		"player_level": safe_player_level,
		"required_player_level": required_player_level,
		"required_skill_level": required_skill_level,
		"required_skills": required_skills,
		"missing_requirements": missing_requirements,
		"requirements_ready": requirements_ready,
		"cost": cost,
		"can_afford": can_afford,
		"missing_cost": missing_cost,
	}
	if not ok:
		result["error"] = first_error
		result["message"] = first_message
	return result


func unlock_skill(skill_item_data_id: int, player_level := 1) -> Dictionary:
	var preview := skill_unlock_preview(skill_item_data_id, player_level)
	if not bool(preview.get("ok", false)):
		return preview
	var cost: Array = preview.get("cost", [])
	_consume_cost(cost)
	var learned := learn_skill(skill_item_data_id)
	if not bool(learned.get("ok", false)):
		return learned
	return {
		"ok": true,
		"skill": learned.get("skill", {}),
		"preview": preview,
		"cost": cost,
		"materials": materials.duplicate(true),
	}


func skill_level_up_preview(skill_item_data_id: int) -> Dictionary:
	var skill_item_id := int(skill_item_data_id)
	if not skills.has(skill_item_id):
		return _fail("skill_not_owned", "Skill is not owned")
	var item: Dictionary = _item(skill_item_id)
	var current_level := int(skills[skill_item_id].get("level", 1))
	var max_level := _max_skill_level(item)
	if current_level >= max_level:
		return _fail("skill_max_level", "Skill is already at max level")

	var cost := _skill_level_cost(item, current_level)
	var before := _skill_effect(item, current_level)
	var after := _skill_effect(item, current_level + 1)
	return {
		"ok": true,
		"skill_item_data_id": skill_item_id,
		"from_level": current_level,
		"to_level": current_level + 1,
		"max_level": max_level,
		"cost": cost,
		"can_afford": _can_afford(cost),
		"effect_before": before,
		"effect_after": after,
		"effect_delta": _effect_delta(before, after),
	}


func level_up_skill(skill_item_data_id: int) -> Dictionary:
	var preview := skill_level_up_preview(skill_item_data_id)
	if not bool(preview.get("ok", false)):
		return preview
	var cost: Array = preview.get("cost", [])
	if not _can_afford(cost):
		var missing := []
		for entry in cost:
			if typeof(entry) != TYPE_DICTIONARY:
				continue
			var item_id := int(entry.get("item_data_id", 0))
			var need := int(entry.get("count", 0))
			var have := material_count(item_id)
			if have < need:
				missing.append({
					"item_data_id": item_id,
					"name": str(entry.get("name", "")),
					"need": need,
					"have": have,
				})
		return {
			"ok": false,
			"error": "insufficient_materials",
			"message": "Not enough skill level-up materials",
			"missing": missing,
			"preview": preview,
		}

	_consume_cost(cost)
	var skill_item_id := int(skill_item_data_id)
	var item: Dictionary = _item(skill_item_id)
	var next_level := int(preview.get("to_level", 1))
	skills[skill_item_id]["level"] = next_level
	skills[skill_item_id]["effect"] = _skill_effect(item, next_level)
	return {
		"ok": true,
		"skill": skills[skill_item_id].duplicate(true),
		"cost": cost,
		"effect_before": preview.get("effect_before", {}),
		"effect_after": preview.get("effect_after", {}),
		"effect_delta": preview.get("effect_delta", {}),
		"materials": materials.duplicate(true),
	}


func _create_item_instance(item: Dictionary, level := 1, roll_options := false) -> Dictionary:
	var item_id := int(item.get("id", 0))
	var safe_level := maxi(1, int(level))
	var base_stats := _stats_from_defs(item.get("equipAddStats", []), safe_level)
	var option_stats := []
	var rolled_options := []
	if roll_options and str(item.get("category", "")) == "Equipment":
		rolled_options = _roll_equipment_options(item)
		for option in rolled_options:
			option_stats.append_array(_stats_from_defs(option.get("equipAddStats", []), 1))

	var stats := _sum_stats(base_stats, option_stats)
	var instance := {
		"instance_id": next_instance_id,
		"item_data_id": item_id,
		"name": str(item.get("name", "")),
		"category": str(item.get("category", "")),
		"type": str(item.get("type", "")),
		"slot": str(item.get("type", "")) if str(item.get("category", "")) == "Equipment" else "",
		"grade": int(item.get("grade", 1)),
		"rarity": int(item.get("rarity", 1)),
		"level": safe_level,
		"tags": _tags(item),
		"base_stats": base_stats,
		"option_stats": option_stats,
		"stats": stats,
		"equip_skill_ids": _skill_ids_from_item(item),
	}
	if not rolled_options.is_empty():
		instance["options"] = rolled_options
	var stage := _stone_stage(item)
	if stage > 0:
		instance["stage"] = stage
	next_instance_id += 1
	return instance


func _roll_equipment_options(item: Dictionary) -> Array:
	var selected := []
	var option_groups = item.get("options", [])
	var option_counts = item.get("optionCounts", [])
	if typeof(option_groups) != TYPE_ARRAY:
		return selected

	for group_index in range(option_groups.size()):
		var group = option_groups[group_index]
		if typeof(group) != TYPE_DICTIONARY:
			continue
		var candidates = group.get("options", [])
		if typeof(candidates) != TYPE_ARRAY or candidates.is_empty():
			continue
		var count := 1
		if typeof(option_counts) == TYPE_ARRAY and option_counts.size() > group_index:
			count = maxi(0, int(option_counts[group_index]))
		var picked_ids := {}
		for _i in range(count):
			var pick := _pick_weighted_option(candidates, picked_ids)
			if pick.is_empty():
				break
			picked_ids[int(pick.get("id", 0))] = true
			selected.append({
				"id": int(pick.get("id", 0)),
				"grade": int(pick.get("grade", item.get("grade", 1))),
				"group": int(pick.get("group", group_index + 1)),
				"equipAddStats": pick.get("equipAddStats", []).duplicate(true),
			})
	return selected


func _pick_weighted_option(candidates: Array, picked_ids: Dictionary) -> Dictionary:
	var total := 0.0
	for candidate in candidates:
		if typeof(candidate) != TYPE_DICTIONARY:
			continue
		if picked_ids.has(int(candidate.get("id", 0))):
			continue
		total += maxf(0.0, float(candidate.get("weight", 1.0)))
	if total <= 0.0:
		return {}

	var roll := rng.randf() * total
	var cursor := 0.0
	for candidate in candidates:
		if typeof(candidate) != TYPE_DICTIONARY:
			continue
		if picked_ids.has(int(candidate.get("id", 0))):
			continue
		cursor += maxf(0.0, float(candidate.get("weight", 1.0)))
		if roll <= cursor:
			return candidate
	return {}


func _drop_grade(monster_level: int, context: Dictionary) -> int:
	if context.has("grade"):
		return clampi(int(context.get("grade", 1)), 1, 10)
	var max_grade := clampi(int(context.get("max_grade", _direct_loot_grade_cap(monster_level))), 1, 10)
	var min_grade := clampi(int(context.get("min_grade", max(1, max_grade - 2))), 1, max_grade)
	var weight_decay := float(context.get("weight_decay", context.get("weightDecay", 0.45)))
	var total := 0.0
	for grade in range(min_grade, max_grade + 1):
		total += _drop_grade_weight(grade, max_grade, weight_decay)
	var roll := rng.randf() * total
	var cursor := 0.0
	for grade in range(min_grade, max_grade + 1):
		cursor += _drop_grade_weight(grade, max_grade, weight_decay)
		if roll <= cursor:
			return grade
	return min_grade


func _drop_stone_stage(monster_level: int, context: Dictionary) -> int:
	if context.has("stage"):
		return clampi(int(context.get("stage", 1)), 1, 10)
	var max_stage := clampi(int(context.get("max_stage", _direct_loot_grade_cap(monster_level))), 1, 10)
	var min_stage := clampi(int(context.get("min_stage", max(1, max_stage - 2))), 1, max_stage)
	var weight_decay := float(context.get("weight_decay", context.get("weightDecay", 0.45)))
	var total := 0.0
	for stage in range(min_stage, max_stage + 1):
		total += _drop_grade_weight(stage, max_stage, weight_decay)
	var roll := rng.randf() * total
	var cursor := 0.0
	for stage in range(min_stage, max_stage + 1):
		cursor += _drop_grade_weight(stage, max_stage, weight_decay)
		if roll <= cursor:
			return stage
	return min_stage


func _direct_loot_grade_cap(monster_level: int) -> int:
	var safe_level := maxi(1, int(monster_level))
	return clampi(1 + floori(float(safe_level) / float(DIRECT_LOOT_LEVELS_PER_GRADE)), 1, DIRECT_LOOT_MAX_GRADE)


func _drop_grade_weight(grade: int, max_grade: int, weight_decay := 0.45) -> float:
	var distance := max_grade - grade
	return pow(maxf(0.01, float(weight_decay)), float(distance))


func _drop_slot(context: Dictionary) -> String:
	if context.has("slot"):
		return str(context.get("slot", "Head"))
	var index := rng.randi_range(0, EQUIPMENT_SLOTS.size() - 1)
	return str(EQUIPMENT_SLOTS[index])


func _skill_level_cost(skill_item: Dictionary, current_level: int) -> Array:
	var result := []
	var groups = skill_item.get("levelUpMaterialItemGroups", [])
	if typeof(groups) != TYPE_ARRAY:
		return result
	for group in groups:
		if typeof(group) != TYPE_DICTIONARY:
			continue
		if int(group.get("level", -1)) != int(current_level):
			continue
		var material_items = group.get("materialItems", [])
		if typeof(material_items) != TYPE_ARRAY:
			continue
		for material in material_items:
			if typeof(material) != TYPE_DICTIONARY:
				continue
			var item_id := int(material.get("id", 0))
			var item := _item(item_id)
			result.append({
				"item_data_id": item_id,
				"name": str(item.get("name", "")),
				"count": int(material.get("count", 0)),
			})
		break
	return result


func _skill_unlock_cost(skill_item: Dictionary) -> Array:
	var popup := _skill_popup(skill_item)
	var point_item_id := int(str(popup.get("LevelPointItemDataId", "200501")))
	if point_item_id <= 0:
		point_item_id = 200501
	var count := maxi(0, int(str(popup.get("UnlockCostLevelPoint", "0"))))
	if count <= 0:
		return []
	var point_item := _item(point_item_id)
	return [{
		"item_data_id": point_item_id,
		"name": str(point_item.get("name", "Skill Point")),
		"count": count,
	}]


func _skill_required_ids(skill_item: Dictionary) -> Array:
	var popup := _skill_popup(skill_item)
	var ids := _parse_int_list(popup.get("RequiredSkillItemDataIds", ""))
	if ids.is_empty():
		ids = _parse_int_list(skill_item.get("requiredItemDataIds", []))
	return ids


func _skill_required_level(skill_item: Dictionary) -> int:
	var popup := _skill_popup(skill_item)
	return maxi(0, int(str(popup.get("RequiredSkillLevel", "0"))))


func _skill_required_player_level(skill_item: Dictionary) -> int:
	var popup := _skill_popup(skill_item)
	return maxi(1, int(str(popup.get("RequiredPlayerLevel", "1"))))


func _skill_popup(skill_item: Dictionary) -> Dictionary:
	var popup = skill_item.get("popupArgs", {})
	return popup if typeof(popup) == TYPE_DICTIONARY else {}


func _skill_effect(skill_item: Dictionary, level: int) -> Dictionary:
	var skill_id := int(skill_item.get("skillDataId", 0))
	var skill_def := _skill(skill_id)
	var base_damage_ratio := 1.0
	if store != null and not skill_def.is_empty():
		base_damage_ratio = float(store.skill_damage_total_ratio(skill_def, level))
	var constant_damage_ratio := float(skill_item.get("constantDamageRatio", 1.0))
	var level_multiplier := 1.0 + SKILL_LEVEL_DAMAGE_BONUS * float(maxi(0, int(level) - 1))
	var damage_ratio := base_damage_ratio * constant_damage_ratio * level_multiplier
	var cooldown := float(skill_def.get("cooldown", 1.0))
	var dps_ratio := damage_ratio / maxf(0.1, cooldown)
	return {
		"skill_data_id": skill_id,
		"skill_name": str(skill_def.get("name", skill_item.get("name", ""))),
		"level": int(level),
		"base_damage_ratio": base_damage_ratio,
		"level_multiplier": level_multiplier,
		"damage_ratio": damage_ratio,
		"cooldown": cooldown,
		"dps_ratio": dps_ratio,
		"policy": "base_skill_damage_times_12_percent_per_level",
	}


func _effect_delta(before: Dictionary, after: Dictionary) -> Dictionary:
	return {
		"damage_ratio": float(after.get("damage_ratio", 0.0)) - float(before.get("damage_ratio", 0.0)),
		"dps_ratio": float(after.get("dps_ratio", 0.0)) - float(before.get("dps_ratio", 0.0)),
		"level_multiplier": float(after.get("level_multiplier", 0.0)) - float(before.get("level_multiplier", 0.0)),
	}


func _max_skill_level(skill_item: Dictionary) -> int:
	var popup = skill_item.get("popupArgs", {})
	if typeof(popup) == TYPE_DICTIONARY and popup.has("MaxSkillLevel"):
		return maxi(1, int(str(popup.get("MaxSkillLevel", "1"))))
	var max_level := 1
	var groups = skill_item.get("levelUpMaterialItemGroups", [])
	if typeof(groups) == TYPE_ARRAY:
		for group in groups:
			if typeof(group) == TYPE_DICTIONARY:
				max_level = maxi(max_level, int(group.get("level", 0)) + 1)
	return max_level


func _can_afford(cost: Array) -> bool:
	for entry in cost:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if material_count(int(entry.get("item_data_id", 0))) < int(entry.get("count", 0)):
			return false
	return true


func _missing_cost(cost: Array) -> Array:
	var missing := []
	for entry in cost:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var item_id := int(entry.get("item_data_id", 0))
		var need := int(entry.get("count", 0))
		var have := material_count(item_id)
		if have < need:
			missing.append({
				"item_data_id": item_id,
				"name": str(entry.get("name", "")),
				"need": need,
				"have": have,
			})
	return missing


func _consume_cost(cost: Array) -> void:
	for entry in cost:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var item_id := int(entry.get("item_data_id", 0))
		materials[item_id] = material_count(item_id) - int(entry.get("count", 0))


func _parse_int_list(value) -> Array:
	var result := []
	if typeof(value) == TYPE_ARRAY:
		for entry in value:
			var parsed := int(entry)
			if parsed > 0:
				result.append(parsed)
		return result
	var text := str(value).strip_edges()
	if text == "":
		return result
	for token in text.split(",", false):
		var parsed := int(str(token).strip_edges())
		if parsed > 0:
			result.append(parsed)
	return result


func _instances_for_ids(instance_ids: Array) -> Dictionary:
	var result := []
	var missing := 0
	var seen := {}
	for raw_id in instance_ids:
		var instance_id := int(raw_id)
		if seen.has(instance_id):
			missing += 1
			continue
		seen[instance_id] = true
		if not item_instances.has(instance_id):
			missing += 1
			continue
		result.append(item_instances[instance_id])
	return {"items": result, "missing": missing}


func _summaries_for_instances(instances: Array) -> Array:
	var result := []
	for instance in instances:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		result.append({
			"instance_id": int(instance.get("instance_id", 0)),
			"item_data_id": int(instance.get("item_data_id", 0)),
			"name": str(instance.get("name", "")),
			"grade": int(instance.get("grade", 1)),
			"level": int(instance.get("level", 1)),
		})
	return result


func _next_stone_item(source_item: Dictionary) -> Dictionary:
	var source_id := int(source_item.get("id", 0))
	var source_stage := _stone_stage(source_item)
	for item in _items():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if not _has_tag(item, "StoneWeapon"):
			continue
		if int(item.get("parentId", 0)) == source_id:
			return item
	if source_stage > 0:
		var next_stage_tag := "StoneStage%02d" % (source_stage + 1)
		for item in _items():
			if typeof(item) == TYPE_DICTIONARY and _has_tag(item, "StoneWeapon") and _has_tag(item, next_stage_tag):
				return item
	return {}


func _stone_recipe_id_for(source_item_id: int) -> int:
	for item in _items():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("category", "")) != "Recipe" or not _has_tag(item, "StoneMergeRecipe"):
			continue
		var popup = item.get("popupArgs", {})
		if typeof(popup) == TYPE_DICTIONARY and int(str(popup.get("SourceItemDataId", "0"))) == int(source_item_id):
			return int(item.get("id", 0))
		for group in item.get("materialItemGroups", []):
			if typeof(group) != TYPE_DICTIONARY:
				continue
			for material in group.get("materialItems", []):
				if typeof(material) == TYPE_DICTIONARY and int(material.get("id", 0)) == int(source_item_id):
					return int(item.get("id", 0))
	return 0


func _equipment_recipe_id_for(slot: String, source_grade: int) -> int:
	for item in _items():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("category", "")) != "Recipe" or not _has_tag(item, "EquipmentUpgradeRecipe"):
			continue
		if not _has_tag(item, slot):
			continue
		var popup = item.get("popupArgs", {})
		if typeof(popup) == TYPE_DICTIONARY and int(str(popup.get("SourceGrade", "0"))) == int(source_grade):
			return int(item.get("id", 0))
		if int(item.get("grade", 0)) == int(source_grade) + 1:
			return int(item.get("id", 0))
	return 0


func _equipment_item(slot: String, grade: int) -> Dictionary:
	for item in _items():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("category", "")) == "Equipment" and str(item.get("type", "")) == slot and int(item.get("grade", 0)) == int(grade):
			return item
	return {}


func _stone_item(stage: int) -> Dictionary:
	var stage_tag := "StoneStage%02d" % int(stage)
	for item in _items():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if _has_tag(item, "StoneWeapon") and _has_tag(item, stage_tag):
			return item
	return {}


func _stats_from_defs(stat_defs, level: int) -> Array:
	var result := []
	if typeof(stat_defs) != TYPE_ARRAY:
		return result
	for stat_def in stat_defs:
		if typeof(stat_def) != TYPE_DICTIONARY:
			continue
		var stat_type := str(stat_def.get("type", "Hp"))
		var values = stat_def.get("value", [])
		var value := 0.0
		if typeof(values) == TYPE_ARRAY and values.size() > 0:
			var index := clampi(int(level) - 1, 0, values.size() - 1)
			value = float(values[index])
		else:
			value = float(stat_def.get("value", 0.0))
		result.append({"type": stat_type, "value": value})
	return result


func _sum_stats(base_stats: Array, option_stats: Array) -> Dictionary:
	var result := {}
	for stat in base_stats:
		if typeof(stat) != TYPE_DICTIONARY:
			continue
		var key := str(stat.get("type", "Hp"))
		result[key] = float(result.get(key, 0.0)) + float(stat.get("value", 0.0))
	for stat in option_stats:
		if typeof(stat) != TYPE_DICTIONARY:
			continue
		var key := str(stat.get("type", "Hp"))
		result[key] = float(result.get(key, 0.0)) + float(stat.get("value", 0.0))
	return result


func _skill_ids_from_item(item: Dictionary) -> Array:
	var result := []
	var skill_ids = item.get("equipSkillDataIds", [])
	if typeof(skill_ids) != TYPE_ARRAY:
		return result
	for raw_id in skill_ids:
		var skill_id := int(raw_id)
		if skill_id > 0 and not result.has(skill_id):
			result.append(skill_id)
	return result


func _is_stone_instance(instance: Dictionary) -> bool:
	return str(instance.get("category", "")) == "Weapon" and _progression_instance_has_tag(instance, "StoneWeapon")


func _is_equipment_instance(instance: Dictionary) -> bool:
	return str(instance.get("category", "")) == "Equipment"


func _progression_instance_has_tag(instance: Dictionary, tag: String) -> bool:
	var tags = instance.get("tags", [])
	return typeof(tags) == TYPE_ARRAY and tags.has(tag)


func _stone_instances_sorted_for_equip() -> Array:
	var sorted := []
	for instance_id in item_instances.keys():
		var instance: Dictionary = item_instances[instance_id]
		if not _is_stone_instance(instance):
			continue
		var inserted := false
		for i in range(sorted.size()):
			if _stone_equip_score(instance) > _stone_equip_score(sorted[i]):
				sorted.insert(i, instance)
				inserted = true
				break
		if not inserted:
			sorted.append(instance)
	return sorted


func _stone_equip_score(instance: Dictionary) -> int:
	return int(instance.get("stage", 0)) * 100000 + int(instance.get("item_data_id", 0)) * 100 + int(instance.get("level", 1))


func _equipment_instances_sorted_for_equip() -> Array:
	var sorted := []
	for instance_id in item_instances.keys():
		var instance: Dictionary = item_instances[instance_id]
		if not _is_equipment_instance(instance):
			continue
		var inserted := false
		for i in range(sorted.size()):
			if _equipment_equip_score(instance) > _equipment_equip_score(sorted[i]):
				sorted.insert(i, instance)
				inserted = true
				break
		if not inserted:
			sorted.append(instance)
	return sorted


func _equipment_equip_score(instance: Dictionary) -> int:
	return int(instance.get("grade", 0)) * 100000 + int(instance.get("level", 1)) * 1000 + int(instance.get("item_data_id", 0))


func _equipped_stone_instances() -> Array:
	_compact_equipped_stones()
	var result := []
	for instance_id in equipped_stone_instance_ids:
		var safe_id := int(instance_id)
		if item_instances.has(safe_id):
			result.append(item_instances[safe_id].duplicate(true))
	return result


func _equipped_equipment_instance_ids() -> Dictionary:
	_compact_equipped_equipment()
	return equipped_equipment_instance_ids.duplicate(true)


func _equipped_equipment_instances() -> Array:
	_compact_equipped_equipment()
	var result := []
	for slot in equipped_equipment_instance_ids.keys():
		var instance_id := int(equipped_equipment_instance_ids[slot])
		if item_instances.has(instance_id):
			result.append(item_instances[instance_id].duplicate(true))
	return result


func _equipped_stat_summary() -> Dictionary:
	var result := _equipped_stone_stat_summary()
	var equipment_stats := _equipped_equipment_stat_summary()
	for stat_type in equipment_stats.keys():
		result[str(stat_type)] = float(result.get(str(stat_type), 0.0)) + float(equipment_stats[stat_type])
	return result


func _equipped_stone_stat_summary() -> Dictionary:
	var result := {}
	for instance in _equipped_stone_instances():
		var stats = instance.get("stats", {})
		if typeof(stats) != TYPE_DICTIONARY:
			continue
		for stat_type in stats.keys():
			result[str(stat_type)] = float(result.get(str(stat_type), 0.0)) + float(stats[stat_type])
	return result


func _equipped_equipment_stat_summary() -> Dictionary:
	var result := {}
	for instance in _equipped_equipment_instances():
		var stats = instance.get("stats", {})
		if typeof(stats) != TYPE_DICTIONARY:
			continue
		for stat_type in stats.keys():
			result[str(stat_type)] = float(result.get(str(stat_type), 0.0)) + float(stats[stat_type])
	return result


func _equipped_skill_ids() -> Array:
	var result := []
	for instance in _equipped_stone_instances():
		var skill_ids = instance.get("equip_skill_ids", [])
		if typeof(skill_ids) != TYPE_ARRAY:
			continue
		for raw_id in skill_ids:
			var skill_id := int(raw_id)
			if skill_id > 0 and not result.has(skill_id):
				result.append(skill_id)
	return result


func _learned_skill_ids() -> Array:
	var result := []
	for skill_item_id in skills.keys():
		var entry: Dictionary = skills[skill_item_id] if typeof(skills[skill_item_id]) == TYPE_DICTIONARY else {}
		var skill_id := int(entry.get("skill_data_id", 0))
		if skill_id > 0 and not result.has(skill_id):
			result.append(skill_id)
	return result


func _learned_skill_summaries() -> Array:
	var result := []
	for skill_item_id in skills.keys():
		var entry: Dictionary = skills[skill_item_id] if typeof(skills[skill_item_id]) == TYPE_DICTIONARY else {}
		var skill_id := int(entry.get("skill_data_id", 0))
		if skill_id <= 0:
			continue
		result.append(entry.duplicate(true))
	return result


func _remove_equipped_equipment_instances(instances: Array) -> String:
	var removed_slot := ""
	for instance in instances:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var instance_id := int(instance.get("instance_id", 0))
		for slot in equipped_equipment_instance_ids.keys():
			if int(equipped_equipment_instance_ids[slot]) == instance_id:
				removed_slot = str(slot)
				equipped_equipment_instance_ids.erase(slot)
				break
	_compact_equipped_equipment()
	return removed_slot


func _remove_equipped_instances(instances: Array) -> bool:
	var removed := false
	for instance in instances:
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var instance_id := int(instance.get("instance_id", 0))
		while equipped_stone_instance_ids.has(instance_id):
			equipped_stone_instance_ids.erase(instance_id)
			removed = true
	_compact_equipped_stones()
	return removed


func _compact_equipped_stones() -> void:
	var compacted := []
	for raw_id in equipped_stone_instance_ids:
		var instance_id := int(raw_id)
		if instance_id <= 0 or compacted.has(instance_id) or not item_instances.has(instance_id):
			continue
		var instance: Dictionary = item_instances[instance_id]
		if not _is_stone_instance(instance):
			continue
		compacted.append(instance_id)
		if compacted.size() >= STONE_EQUIP_SLOT_COUNT:
			break
	equipped_stone_instance_ids = compacted


func _compact_equipped_equipment() -> void:
	var compacted := {}
	for raw_slot in equipped_equipment_instance_ids.keys():
		var slot := str(raw_slot)
		var instance_id := int(equipped_equipment_instance_ids[raw_slot])
		if slot == "" or instance_id <= 0 or not item_instances.has(instance_id):
			continue
		var instance: Dictionary = item_instances[instance_id]
		if not _is_equipment_instance(instance):
			continue
		var instance_slot := str(instance.get("slot", instance.get("type", "")))
		if instance_slot == "":
			continue
		compacted[instance_slot] = instance_id
	equipped_equipment_instance_ids = compacted


func _stone_stage(item: Dictionary) -> int:
	for tag in _tags(item):
		var text := str(tag)
		if text.begins_with("StoneStage"):
			return int(text.substr("StoneStage".length()))
	return 0


func _has_tag(item: Dictionary, tag: String) -> bool:
	return _tags(item).has(tag)


func _tags(item: Dictionary) -> Array:
	var tags = item.get("tags", [])
	return tags if typeof(tags) == TYPE_ARRAY else []


func _item(item_data_id: int) -> Dictionary:
	return store.get_item(int(item_data_id)) if store != null else {}


func _skill(skill_data_id: int) -> Dictionary:
	return store.get_skill(int(skill_data_id)) if store != null else {}


func _items() -> Array:
	return store.get_records("Items") if store != null else []


func _fail(error: String, message: String) -> Dictionary:
	return {
		"ok": false,
		"error": error,
		"message": message,
	}
