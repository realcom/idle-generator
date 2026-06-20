extends RefCounted

const HEXES := [
	{"id": 1, "q": 0, "r": -3, "state": "fog", "cost": 220, "minShrineLevel": 5},
	{"id": 2, "q": -1, "r": -2, "state": "fog", "cost": 180, "minShrineLevel": 5},
	{"id": 3, "q": 0, "r": -2, "state": "fog", "cost": 180, "minShrineLevel": 5},
	{"id": 4, "q": 1, "r": -2, "state": "fog", "cost": 100, "minShrineLevel": 3},
	{"id": 5, "q": -2, "r": -1, "state": "fog", "cost": 180, "minShrineLevel": 5},
	{"id": 6, "q": -1, "r": -1, "state": "empty", "cost": 40},
	{"id": 7, "q": 0, "r": -1, "state": "empty"},
	{"id": 8, "q": 1, "r": -1, "state": "fog", "cost": 40, "minShrineLevel": 2},
	{"id": 9, "q": 2, "r": -1, "state": "fog", "cost": 70, "minShrineLevel": 2},
	{"id": 10, "q": -2, "r": 0, "state": "fog", "cost": 150, "minShrineLevel": 4},
	{"id": 11, "q": -1, "r": 0, "state": "built"},
	{"id": 12, "q": 0, "r": 0, "state": "built", "selected": true},
	{"id": 13, "q": 1, "r": 0, "state": "fog", "cost": 40, "minShrineLevel": 2},
	{"id": 14, "q": 2, "r": 0, "state": "fog", "cost": 150, "minShrineLevel": 4},
	{"id": 15, "q": -2, "r": 1, "state": "locked", "cost": 0, "minShrineLevel": 6},
	{"id": 16, "q": -1, "r": 1, "state": "empty", "cost": 100},
	{"id": 17, "q": 0, "r": 1, "state": "built"},
	{"id": 18, "q": 1, "r": 1, "state": "fog", "cost": 70, "minShrineLevel": 2},
	{"id": 19, "q": 2, "r": 1, "state": "fog", "cost": 90, "minShrineLevel": 2},
	{"id": -1, "q": -1, "r": 2, "state": "fog", "cost": 200, "minShrineLevel": 4},
	{"id": -2, "q": 0, "r": 2, "state": "fog", "cost": 260, "minShrineLevel": 4},
	{"id": -3, "q": 1, "r": 2, "state": "fog", "cost": 320, "minShrineLevel": 4},
	{"id": -4, "q": -2, "r": 3, "state": "fog", "cost": 420, "minShrineLevel": 6},
	{"id": -5, "q": -1, "r": 3, "state": "fog", "cost": 460, "minShrineLevel": 6},
	{"id": -6, "q": 0, "r": 3, "state": "fog", "cost": 520, "minShrineLevel": 6},
	{"id": -7, "q": 1, "r": 3, "state": "fog", "cost": 560, "minShrineLevel": 6},
	{"id": -8, "q": 2, "r": 3, "state": "fog", "cost": 620, "minShrineLevel": 6},
	{"id": -9, "q": -3, "r": 2, "state": "fog", "cost": 680, "minShrineLevel": 6},
	{"id": -10, "q": -2, "r": 2, "state": "fog", "cost": 740, "minShrineLevel": 6},
]

const OPEN_TILE_IDS := [2, 3, 4, 5, 8, 9, 13, 18, 19, -1, -2, -3]
const BUILT_CITY_LEVELS := {
	"lantern_shrine": 5,
	"wood_workshop": 4,
	"stone_quarry": 2,
	"training_yard": 3,
	"soulflame_well": 2,
	"herb_garden": 1,
	"guard_lantern": 1,
}
const BUILT_CITY_KEYS := [
	"lantern_shrine",
	"wood_workshop",
	"training_yard",
	"soulflame_well",
	"herb_garden",
	"guard_lantern",
]
const RESOURCE_ALIASES := {
	"soulflame": "soul",
}

var resources: Dictionary = {
	"ruby": 120,
	"free_ruby": 45,
	"energy": 88,
	"wood": 12400,
	"soul": 9800,
	"gold": 36700,
	"stone": 1230,
	"tool": 24,
	"companion_shards": 14,
}
var resource_rates: Dictionary = {
	"wood": 34.0,
	"soul": 1.9,
	"gold": 84.0,
	"stone": 8.0,
}
var shrine_level := 25
var shrine_light := 286
var shrine_light_need := 320
var residents := 21
var resident_capacity := 28
var stage_clears := 3
var current_map_id := 500104
var highest_unlocked_map_id := 500104
var selected_map_id := 500104
var selected_building_key := "training_yard"
var selected_building_instance_id := "training_yard#1"
var selected_equipment_item_id := 0
var last_log := "성소의 등불이 안정적으로 타오르고 있습니다."
var tile_states: Dictionary = {}
var placed_building_instances: Dictionary = {}
var item_inventory: Dictionary = {}
var equipped_item_ids: Dictionary = {}
var claimed_mission_keys: Dictionary = {}
var shop_claims: Dictionary = {}
var cleared_side_dungeons: Dictionary = {}
var mail_claims: Dictionary = {}
var mail_read_keys: Dictionary = {}
var pass_claimed_tiers: Dictionary = {}
var settings: Dictionary = {
	"bgm": true,
	"sfx": true,
	"low_power": false,
}
var ad_removal := false


func seed_from_housing(housing_store) -> void:
	tile_states.clear()
	for tile in HEXES:
		if typeof(tile) != TYPE_DICTIONARY:
			continue
		var tile_id := int(tile.get("id", 0))
		tile_states[tile_id] = str(tile.get("state", "fog"))
	for tile_id in OPEN_TILE_IDS:
		tile_states[int(tile_id)] = "empty"

	placed_building_instances.clear()
	for key in BUILT_CITY_KEYS:
		var building: Dictionary = housing_store.get_building(str(key))
		if building.is_empty():
			continue
		_add_instance(building, int(BUILT_CITY_LEVELS.get(key, 1)), "built")

	var stone_quarry: Dictionary = housing_store.get_building("stone_quarry")
	if not stone_quarry.is_empty():
		_add_instance(stone_quarry, 2, "constructing")

	selected_building_key = "stone_quarry"
	selected_building_instance_id = "stone_quarry#1"

	for instance in placed_building_instances.values():
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		for tile_id in instance.get("tiles", []):
			tile_states[int(tile_id)] = "built"


func select_building(instance_id: String) -> void:
	if not placed_building_instances.has(instance_id):
		return
	var instance: Dictionary = placed_building_instances[instance_id]
	selected_building_instance_id = instance_id
	selected_building_key = str(instance.get("buildingKey", ""))
	last_log = "%s를 선택했습니다. 강화와 상세 정보를 확인하세요." % str(instance.get("name", "건물"))


func apply_run_resources(run_resources: Dictionary) -> void:
	for key in ["gold", "wood", "stone"]:
		if run_resources.has(key):
			resources[key] = max(int(resources.get(key, 0)), int(run_resources[key]))
	if run_resources.has("soul"):
		resources["soul"] = max(int(resources.get("soul", 0)), int(run_resources["soul"]))


func ensure_starter_equipment(content_store) -> void:
	if content_store == null:
		return
	if not item_inventory.is_empty() or not equipped_item_ids.is_empty():
		return

	var sample: Array = content_store.get_equipment_sample(18)
	for item in sample.slice(0, 11):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var item_id := int(item.get("id", 0))
		if item_id <= 0:
			continue
		item_inventory[str(item_id)] = max(1, int(item_inventory.get(str(item_id), 0)))
		if selected_equipment_item_id <= 0:
			selected_equipment_item_id = item_id

	for item in sample:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var slot := equipment_slot_key(item)
		if slot == "" or equipped_item_ids.has(slot):
			continue
		var item_id := int(item.get("id", 0))
		if item_id <= 0:
			continue
		equipped_item_ids[slot] = item_id
		if not item_inventory.has(str(item_id)):
			item_inventory[str(item_id)] = 1


func equipment_slot_key(item: Dictionary) -> String:
	var category := str(item.get("category", item.get("Category", ""))).to_lower()
	var item_type := str(item.get("type", item.get("Type", "")))
	var lower_type := item_type.to_lower()
	if category == "weapon":
		return "weapon"
	match lower_type:
		"head":
			return "head"
		"chest":
			return "chest"
		"gloves":
			return "gloves"
		"boots":
			return "boots"
		"necklace":
			return "necklace"
		"ring":
			return "ring"
	return ""


func equipment_slot_label(slot_key: String) -> String:
	var labels := {
		"weapon": "무기",
		"head": "머리",
		"chest": "갑옷",
		"gloves": "장갑",
		"boots": "신발",
		"necklace": "목걸이",
		"ring": "반지",
	}
	return str(labels.get(slot_key, "장비"))


func is_equipment_owned(item_id: int) -> bool:
	if int(item_inventory.get(str(item_id), 0)) > 0:
		return true
	for equipped_id in equipped_item_ids.values():
		if int(equipped_id) == int(item_id):
			return true
	return false


func is_equipment_equipped(item_id: int) -> bool:
	for equipped_id in equipped_item_ids.values():
		if int(equipped_id) == int(item_id):
			return true
	return false


func try_equip_item(content_store, item_id: int) -> Dictionary:
	if content_store == null:
		last_log = "장비 데이터를 찾을 수 없습니다."
		return {"ok": false, "message": last_log}
	var item: Dictionary = content_store.get_item(int(item_id))
	if item.is_empty():
		last_log = "장비 정보를 찾을 수 없습니다."
		return {"ok": false, "message": last_log}
	if not is_equipment_owned(item_id):
		last_log = "보유하지 않은 장비입니다."
		return {"ok": false, "message": last_log}
	var slot := equipment_slot_key(item)
	if slot == "":
		last_log = "장착 슬롯이 없는 아이템입니다."
		return {"ok": false, "message": last_log}
	equipped_item_ids[slot] = int(item_id)
	selected_equipment_item_id = int(item_id)
	last_log = "%s에 %s 장착." % [equipment_slot_label(slot), str(item.get("name", "장비"))]
	return {"ok": true, "message": last_log}


func select_map(map_id: int, content_store) -> Dictionary:
	if content_store == null:
		return {"ok": false, "message": "맵 데이터를 찾을 수 없습니다."}
	var map_def: Dictionary = content_store.get_map(int(map_id))
	if map_def.is_empty():
		last_log = "맵 정보를 찾을 수 없습니다."
		return {"ok": false, "message": last_log}
	if not is_map_unlocked(map_id):
		last_log = "%s 해금 조건을 먼저 만족해야 합니다." % str(map_def.get("name", "탐험"))
		return {"ok": false, "message": last_log}
	selected_map_id = int(map_id)
	current_map_id = int(map_id)
	last_log = "%s 탐험 준비 완료." % str(map_def.get("name", "탐험"))
	return {"ok": true, "message": last_log}


func is_map_unlocked(map_id: int) -> bool:
	if int(map_id) >= 500101 and int(map_id) <= 500199:
		return int(map_id) <= int(highest_unlocked_map_id)
	match int(map_id):
		500201:
			return stage_clears >= 2
		500202:
			return stage_clears >= 3
		500206:
			return stage_clears >= 6
	return true


func map_unlock_label(map_id: int) -> String:
	if is_map_unlocked(map_id):
		return "입장 가능"
	match int(map_id):
		500201:
			return "Stage 2 클리어"
		500202:
			return "Stage 3 클리어"
		500206:
			return "Stage 6 클리어"
	return "메인 진행 필요"


func mission_key(achievement: Dictionary) -> String:
	var popup_args = achievement.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY:
		var key := str(popup_args.get("RuntimeMissionKey", ""))
		if key != "":
			return key
	return str(achievement.get("id", ""))


func mission_progress(achievement: Dictionary) -> Dictionary:
	var target: int = int(achievement.get("targetProgress", achievement.get("conditionValue2", 1)))
	if target < 1:
		target = 1
	var progress := 0
	var condition := str(achievement.get("condition", ""))
	var value1 := int(achievement.get("conditionValue1", 0))
	var popup_args = achievement.get("popupArgs", {})
	var mission_group := ""
	if typeof(popup_args) == TYPE_DICTIONARY:
		mission_group = str(popup_args.get("MissionGroup", ""))

	if condition == "WinGame":
		if value1 >= 500101 and value1 <= 500199:
			var stage_number := value1 - 500100
			progress = 1 if stage_clears >= stage_number else 0
		else:
			progress = 1 if bool(cleared_side_dungeons.get(str(value1), false)) else 0
	elif condition == "AcquireItem":
		if mission_group == "building":
			progress = _building_progress_for_mission(achievement)
		else:
			var resource_key := _resource_key_for_item_id(value1)
			if resource_key != "":
				progress = int(resources.get(resource_key, 0))
			else:
				progress = int(item_inventory.get(str(value1), 0))
	elif condition == "BuyItemProduct":
		progress = 1 if _has_shop_claim_for_product(value1) else 0

	progress = clamp(progress, 0, target)
	return {
		"progress": progress,
		"target": target,
		"complete": progress >= target,
	}


func try_claim_mission(content_store, achievement_id: int) -> Dictionary:
	var achievement: Dictionary = content_store.get_record("Achievements", int(achievement_id)) if content_store != null else {}
	if achievement.is_empty():
		last_log = "임무 데이터를 찾을 수 없습니다."
		return {"ok": false, "message": last_log}
	var key := mission_key(achievement)
	if bool(claimed_mission_keys.get(key, false)):
		last_log = "이미 받은 임무 보상입니다."
		return {"ok": false, "message": last_log}
	var progress_info: Dictionary = mission_progress(achievement)
	if not bool(progress_info.get("complete", false)):
		last_log = "아직 완료되지 않은 임무입니다."
		return {"ok": false, "message": last_log}

	var labels := _apply_reward_groups(achievement.get("rewardAddItemGroups", []), content_store)
	claimed_mission_keys[key] = true
	last_log = "%s 보상 수령 · %s" % [str(achievement.get("name", "임무")), " · ".join(labels) if not labels.is_empty() else "완료"]
	return {"ok": true, "message": last_log}


func try_claim_shop_product(content_store, product_id: int) -> Dictionary:
	var product: Dictionary = content_store.get_item(int(product_id)) if content_store != null else {}
	if product.is_empty():
		last_log = "상품 데이터를 찾을 수 없습니다."
		return {"ok": false, "message": last_log}
	var popup_args = product.get("popupArgs", {})
	var runtime_key := str(product.get("id", product_id))
	var purchase_limit := ""
	if typeof(popup_args) == TYPE_DICTIONARY:
		runtime_key = str(popup_args.get("RuntimeShopKey", runtime_key))
		purchase_limit = str(popup_args.get("PurchaseLimit", ""))
	if purchase_limit == "once" and bool(shop_claims.get(runtime_key, false)):
		last_log = "이미 보유한 1회 상품입니다."
		return {"ok": false, "message": last_log}

	var labels := _apply_reward_groups(product.get("addItemGroups", []), content_store)
	shop_claims[runtime_key] = true
	last_log = "%s 구매 처리 · %s" % [str(product.get("name", "상품")), " · ".join(labels) if not labels.is_empty() else "보상 지급"]
	return {"ok": true, "message": last_log}


func collect_idle_resources(minutes := 1) -> Dictionary:
	var gains := {}
	for key in resource_rates.keys():
		var resource_key := _resource_key(str(key))
		var rate := float(resource_rates.get(key, 0.0))
		if rate <= 0.0:
			continue
		var amount := 0
		if resource_key == "soul":
			amount = int(ceil(rate * float(minutes) / 60.0))
		else:
			amount = int(round(rate * float(minutes)))
		if amount <= 0:
			amount = 1
		resources[resource_key] = int(resources.get(resource_key, 0)) + amount
		gains[resource_key] = int(gains.get(resource_key, 0)) + amount
	if gains.is_empty():
		last_log = "수집할 자동 생산품이 없습니다."
	else:
		var labels: Array[String] = []
		for key in gains.keys():
			labels.append("%s +%d" % [_resource_name(str(key)), int(gains[key])])
		last_log = "자동 생산품 수집 · %s" % " · ".join(labels)
	return gains


func grant_reward_bundle(reward: Dictionary, _content_store = null) -> Array[String]:
	var labels: Array[String] = []
	for key in reward.keys():
		var amount := int(reward[key])
		if amount <= 0:
			continue
		var reward_key := _normalize_reward_key(str(key))
		match reward_key:
			"light":
				shrine_light = min(int(shrine_light_need), int(shrine_light) + amount)
				labels.append("%s +%d" % [_resource_name(reward_key), amount])
			_:
				resources[reward_key] = int(resources.get(reward_key, 0)) + amount
				labels.append("%s +%d" % [_resource_name(reward_key), amount])
	return labels


func set_mail_read(mail_key: String) -> void:
	if mail_key == "":
		return
	mail_read_keys[mail_key] = true


func set_mail_claimed(mail_key: String) -> void:
	if mail_key == "":
		return
	mail_claims[mail_key] = true
	mail_read_keys[mail_key] = true


func is_mail_claimed(mail_key: String) -> bool:
	return bool(mail_claims.get(mail_key, false))


func is_mail_read(mail_key: String) -> bool:
	return bool(mail_read_keys.get(mail_key, false)) or is_mail_claimed(mail_key)


func is_pass_tier_claimed(tier_key: String) -> bool:
	return bool(pass_claimed_tiers.get(tier_key, false))


func set_pass_tier_claimed(tier_key: String) -> void:
	if tier_key == "":
		return
	pass_claimed_tiers[tier_key] = true


func toggle_setting(setting_key: String) -> bool:
	var next_value := not bool(settings.get(setting_key, false))
	settings[setting_key] = next_value
	last_log = "%s %s." % [_setting_label(setting_key), "켜짐" if next_value else "꺼짐"]
	return next_value


func get_tiles() -> Array:
	return HEXES


func tile_render_state(tile: Dictionary) -> String:
	var tile_id := int(tile.get("id", 0))
	if tile_states.has(tile_id):
		return str(tile_states[tile_id])
	return str(tile.get("state", "fog"))


func is_tile_occupied(tile_id: int) -> bool:
	for instance in placed_building_instances.values():
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if instance.get("tiles", []).has(int(tile_id)):
			return true
	return false


func building_entries(housing_store) -> Array:
	var entries := []
	for instance in placed_building_instances.values():
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		var building: Dictionary = housing_store.get_building(str(instance.get("buildingKey", "")))
		if building.is_empty():
			continue
		var tiles := _tiles_for_ids(instance.get("tiles", []))
		if tiles.is_empty():
			continue
		var visual = building.get("visual", {})
		if typeof(visual) != TYPE_DICTIONARY:
			visual = {}
		var average := _average_tile_position(tiles)
		var x := average.x + float(visual.get("dx", 0.0))
		var y := average.y + float(visual.get("dy", 0.0))
		entries.append({
			"building": building,
			"instance": instance,
			"x": x,
			"y": y,
			"w": float(visual.get("w", 96.0)),
			"h": float(visual.get("h", 96.0)),
		})
	entries.sort_custom(func(a, b): return float(a.get("y", 0.0)) < float(b.get("y", 0.0)))
	return entries


func selected_instance() -> Dictionary:
	return placed_building_instances.get(selected_building_instance_id, {})


func selected_building(housing_store) -> Dictionary:
	var instance := selected_instance()
	if not instance.is_empty():
		return housing_store.get_building(str(instance.get("buildingKey", selected_building_key)))
	return housing_store.get_building(selected_building_key)


func selected_building_level() -> int:
	var instance := selected_instance()
	return int(instance.get("level", 1)) if not instance.is_empty() else 1


func selected_building_status() -> String:
	var instance := selected_instance()
	return str(instance.get("status", "locked")) if not instance.is_empty() else "locked"


func selected_upgrade_info(housing_store) -> Dictionary:
	var building: Dictionary = selected_building(housing_store)
	var instance: Dictionary = selected_instance()
	if building.is_empty() or instance.is_empty():
		return {"available": false, "reason": "선택된 건물이 없습니다."}

	var level: int = selected_building_level()
	var status: String = selected_building_status()
	if status == "constructing":
		return {
			"available": true,
			"action": "finish",
			"can_afford": true,
			"level": level,
			"next_level": level,
			"cost": {},
			"cost_label": "건설 완료",
			"time_seconds": 0,
		}

	var max_level: int = housing_store.max_level(building)
	if max_level <= 0 or level >= max_level:
		return {
			"available": false,
			"action": "max",
			"can_afford": false,
			"level": level,
			"next_level": level,
			"cost": {},
			"cost_label": "최대 레벨",
			"time_seconds": 0,
		}

	var cost: Dictionary = housing_store.level_up_cost(building, level)
	var missing := _missing_cost(cost)
	return {
		"available": true,
		"action": "upgrade",
		"can_afford": missing.is_empty(),
		"level": level,
		"next_level": level + 1,
		"cost": cost,
		"cost_label": housing_store.format_cost(cost, 2),
		"missing": missing,
		"missing_label": housing_store.format_cost(missing, 2),
		"time_seconds": housing_store.level_up_seconds(building, level),
	}


func try_upgrade_selected(housing_store) -> Dictionary:
	var building: Dictionary = selected_building(housing_store)
	var instance: Dictionary = selected_instance()
	if building.is_empty() or instance.is_empty():
		last_log = "먼저 건물을 선택하세요."
		return {"ok": false, "message": last_log}

	var info: Dictionary = selected_upgrade_info(housing_store)
	var action := str(info.get("action", ""))
	if action == "finish":
		instance["status"] = "built"
		instance["constructionProgress"] = 1.0
		placed_building_instances[selected_building_instance_id] = instance
		last_log = "%s 건설을 완료했습니다." % str(building.get("name", "건물"))
		return {"ok": true, "message": last_log}

	if action == "max":
		last_log = "%s은 이미 최대 레벨입니다." % str(building.get("name", "건물"))
		return {"ok": false, "message": last_log}

	if not bool(info.get("can_afford", false)):
		last_log = "재료 부족 · %s" % str(info.get("missing_label", ""))
		return {"ok": false, "message": last_log}

	var cost: Dictionary = info.get("cost", {})
	_pay_cost(cost)
	var next_level := int(info.get("next_level", selected_building_level()))
	instance["level"] = next_level
	placed_building_instances[selected_building_instance_id] = instance
	_apply_production_rate(building, next_level)
	last_log = "%s Lv.%d 강화 완료." % [str(building.get("name", "건물")), next_level]
	return {"ok": true, "message": last_log}


func hex_center(tile: Dictionary) -> Vector2:
	return Vector2(
		float(tile.get("q", 0)) * 73.0 + float(tile.get("r", 0)) * 36.5,
		float(tile.get("r", 0)) * 65.0
	)


func format_resource(key: String) -> String:
	var amount := int(resources.get(key, 0))
	if amount >= 100000:
		return "%.0fK" % (float(amount) / 1000.0)
	if amount >= 2000:
		var text := "%.1fK" % (float(amount) / 1000.0)
		return text.replace(".0K", "K")
	return str(amount)


func format_rate(key: String) -> String:
	var rate := float(resource_rates.get(key, 0.0))
	if rate <= 0.0:
		return "+0/m"
	if key == "soul":
		return "+%s/h" % _trim_float(rate, 1)
	if rate < 10.0 and not is_equal_approx(rate, floor(rate)):
		return "+%s/m" % _trim_float(rate, 1)
	return "+%d/m" % int(round(rate))


func stage_label() -> String:
	return "S%d" % max(1, stage_clears + 1)


func _resource_key(key: String) -> String:
	return str(RESOURCE_ALIASES.get(key, key))


func _normalize_reward_key(key: String) -> String:
	var normalized := _resource_key(key)
	match normalized:
		"souls":
			return "soul"
		"ruby":
			return "ruby"
		"free_ruby":
			return "free_ruby"
		"energy":
			return "energy"
		"companion_exp":
			return "companion_exp"
		"companion_shards":
			return "companion_shards"
		"light":
			return "light"
	return normalized


func _missing_cost(cost: Dictionary) -> Dictionary:
	var missing := {}
	for key in cost.keys():
		var resource_key := _resource_key(str(key))
		var need := int(cost[key])
		var have := int(resources.get(resource_key, 0))
		if have < need:
			missing[str(key)] = need - have
	return missing


func _pay_cost(cost: Dictionary) -> void:
	for key in cost.keys():
		var resource_key := _resource_key(str(key))
		resources[resource_key] = max(0, int(resources.get(resource_key, 0)) - int(cost[key]))


func _apply_production_rate(building: Dictionary, level: int) -> void:
	var production = building.get("production", {})
	if typeof(production) != TYPE_DICTIONARY:
		return
	var rates = production.get("rateByLevel", [])
	if typeof(rates) != TYPE_ARRAY or rates.is_empty():
		return
	var index: int = clamp(level - 1, 0, rates.size() - 1)
	var resource_key := _resource_key(str(production.get("resourceKey", "")))
	if resource_key == "":
		return
	resource_rates[resource_key] = float(rates[index])


func _add_instance(building: Dictionary, level: int, status: String) -> void:
	var key := str(building.get("key", ""))
	if key == "":
		return
	var instance_id := "%s#1" % key
	var tiles := []
	var raw_tiles = building.get("runtimeTiles", [])
	if typeof(raw_tiles) == TYPE_ARRAY:
		for tile_id in raw_tiles:
			tiles.append(int(tile_id))
	var anchor := int(building.get("runtimeAnchorTile", tiles[0] if not tiles.is_empty() else 0))
	var instance := {
		"id": instance_id,
		"buildingKey": key,
		"name": str(building.get("name", key)),
		"spriteKey": str(building.get("spriteKey", key)),
		"level": level,
		"status": status,
		"anchorTile": anchor,
		"tiles": tiles,
	}
	if status == "constructing":
		instance["constructionProgress"] = 0.72 if key == "stone_quarry" else 0.41
	placed_building_instances[instance_id] = instance


func _building_progress_for_mission(achievement: Dictionary) -> int:
	var popup_args = achievement.get("popupArgs", {})
	var source := ""
	if typeof(popup_args) == TYPE_DICTIONARY:
		source = str(popup_args.get("RuntimeProgressSource", ""))
	var building_key := ""
	if source.begins_with("builtBuildings."):
		building_key = source.replace("builtBuildings.", "")
	if building_key == "":
		var key := mission_key(achievement)
		if key.begins_with("build_"):
			building_key = key.replace("build_", "")
	if building_key == "":
		return 0
	for instance in placed_building_instances.values():
		if typeof(instance) != TYPE_DICTIONARY:
			continue
		if str(instance.get("buildingKey", "")) == building_key and str(instance.get("status", "")) == "built":
			return 1
	return 0


func _has_shop_claim_for_product(product_id: int) -> bool:
	if shop_claims.has(str(product_id)):
		return true
	for key in shop_claims.keys():
		if str(key).ends_with(str(product_id)):
			return true
	return false


func _apply_reward_groups(groups, content_store) -> Array[String]:
	var labels: Array[String] = []
	if typeof(groups) != TYPE_ARRAY:
		return labels
	for group in groups:
		if typeof(group) != TYPE_DICTIONARY:
			continue
		var add_items = group.get("addItems", [])
		if typeof(add_items) != TYPE_ARRAY:
			continue
		for reward in add_items:
			if typeof(reward) != TYPE_DICTIONARY:
				continue
			var item_id := int(reward.get("itemDataId", 0))
			var amount := int(float(str(reward.get("count", "0"))))
			if item_id <= 0 or amount <= 0:
				continue
			labels.append(_apply_reward_item(item_id, amount, content_store))
	return labels


func _apply_reward_item(item_id: int, amount: int, content_store) -> String:
	var resource_key := _resource_key_for_item_id(item_id)
	if resource_key != "":
		resources[resource_key] = int(resources.get(resource_key, 0)) + amount
		return "%s +%d" % [_resource_name(resource_key), amount]
	item_inventory[str(item_id)] = int(item_inventory.get(str(item_id), 0)) + amount
	var item_name := "아이템 %d" % item_id
	if content_store != null:
		var item: Dictionary = content_store.get_item(item_id)
		if not item.is_empty():
			item_name = str(item.get("name", item_name))
	return "%s +%d" % [item_name, amount]


func _resource_key_for_item_id(item_id: int) -> String:
	var table := {
		3: "ruby",
		4: "free_ruby",
		5: "gold",
		8: "energy",
		200101: "wood",
		200102: "stone",
		200103: "soul",
		200111: "companion_shards",
	}
	return str(table.get(int(item_id), ""))


func _resource_name(resource_key: String) -> String:
	var names := {
		"ruby": "루비",
		"free_ruby": "무료 루비",
		"energy": "에너지",
		"gold": "골드",
		"wood": "목재",
		"stone": "석재",
		"soul": "영혼불",
		"light": "등불",
		"companion_exp": "동료 경험치",
		"companion_shards": "동료 조각",
	}
	return str(names.get(resource_key, resource_key))


func _setting_label(setting_key: String) -> String:
	var labels := {
		"bgm": "배경음",
		"sfx": "효과음",
		"low_power": "절전 모드",
	}
	return str(labels.get(setting_key, setting_key))


func _tiles_for_ids(tile_ids: Array) -> Array:
	var result := []
	for tile_id in tile_ids:
		for tile in HEXES:
			if int(tile.get("id", 0)) == int(tile_id):
				result.append(tile)
				break
	return result


func _average_tile_position(tiles: Array) -> Vector2:
	var total := Vector2.ZERO
	for tile in tiles:
		total += hex_center(tile)
	return total / max(1, tiles.size())


func _trim_float(value: float, digits: int) -> String:
	var text := "%.*f" % [digits, value]
	while text.ends_with("0"):
		text = text.substr(0, text.length() - 1)
	if text.ends_with("."):
		text = text.substr(0, text.length() - 1)
	return text
