extends RefCounted

const DATA_PATH := "../data/ninja2/housing-tech.json"
const CONSTRUCTION_STAGE_NAMES := ["site", "foundation", "frame", "roofing", "finish"]
const CONSTRUCTION_STAGE_SET_BY_SPRITE_KEY := {
	"stone_quarry": "quarry",
}
const CONSTRUCTION_STAGE_NAMES_BY_SET := {
	"farm": ["site", "foundation", "frame", "roofing", "finish"],
	"quarry": ["site", "foundation", "frame", "rigging", "finish"],
}

var data: Dictionary = {}
var buildings: Array = []
var buildings_by_key: Dictionary = {}
var home_paths: Array = []
var errors: Array[String] = []


func load_all() -> bool:
	data.clear()
	buildings.clear()
	buildings_by_key.clear()
	home_paths.clear()
	errors.clear()

	var path := ProjectSettings.globalize_path("res://%s" % DATA_PATH)
	if not FileAccess.file_exists(path):
		errors.append("Missing housing tech data: %s" % path)
		return false

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("Cannot open housing tech data: %s" % error_string(FileAccess.get_open_error()))
		return false

	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	if parse_error != OK or typeof(json.data) != TYPE_DICTIONARY:
		errors.append("Housing tech JSON parse failed at line %d: %s" % [
			json.get_error_line(),
			json.get_error_message(),
		])
		return false

	data = json.data
	var raw_buildings = data.get("buildings", [])
	if typeof(raw_buildings) == TYPE_ARRAY:
		for building in raw_buildings:
			if typeof(building) != TYPE_DICTIONARY:
				continue
			buildings.append(building)
			buildings_by_key[str(building.get("key", ""))] = building

	var raw_paths = data.get("homePaths", [])
	if typeof(raw_paths) == TYPE_ARRAY:
		home_paths = raw_paths

	return errors.is_empty()


func get_building(key: String) -> Dictionary:
	return buildings_by_key.get(key, {})


func get_preview_buildings() -> Array:
	var result := []
	for building in buildings:
		if typeof(building) == TYPE_DICTIONARY and bool(building.get("homePreview", false)):
			result.append(building)
	return result


func max_level(building: Dictionary) -> int:
	var levels = building.get("levels", [])
	return levels.size() if typeof(levels) == TYPE_ARRAY else 0


func level_data(building: Dictionary, level: int) -> Dictionary:
	var levels = building.get("levels", [])
	if typeof(levels) != TYPE_ARRAY or levels.is_empty():
		return {}
	var index: int = clamp(level - 1, 0, levels.size() - 1)
	var level_entry = levels[index]
	return level_entry if typeof(level_entry) == TYPE_DICTIONARY else {}


func next_level_data(building: Dictionary, current_level: int) -> Dictionary:
	var next_level := current_level + 1
	if next_level > max_level(building):
		return {}
	return level_data(building, next_level)


func level_up_cost(building: Dictionary, current_level: int) -> Dictionary:
	var next_level := next_level_data(building, current_level)
	var level_up = next_level.get("levelUp", {})
	if typeof(level_up) != TYPE_DICTIONARY:
		return {}
	var cost = level_up.get("cost", {})
	return cost if typeof(cost) == TYPE_DICTIONARY else {}


func level_up_seconds(building: Dictionary, current_level: int) -> int:
	var next_level := next_level_data(building, current_level)
	var level_up = next_level.get("levelUp", {})
	if typeof(level_up) != TYPE_DICTIONARY:
		return 0
	return int(level_up.get("seconds", 0))


func resource_name(key: String) -> String:
	var resources = data.get("resources", {})
	if typeof(resources) != TYPE_DICTIONARY:
		return key
	var entry = resources.get(key, {})
	if typeof(entry) != TYPE_DICTIONARY:
		return key
	return str(entry.get("name", key))


func format_cost(cost: Dictionary, max_entries := 3) -> String:
	if cost.is_empty():
		return "무료"
	var parts: Array[String] = []
	for key in cost.keys():
		parts.append("%s %s" % [resource_name(str(key)), _format_amount(float(cost[key]))])
		if parts.size() >= max_entries:
			break
	if cost.size() > max_entries:
		parts.append("+%d" % (cost.size() - max_entries))
	return " · ".join(parts)


func all_texture_paths() -> Dictionary:
	var paths := {
		"home_bg": "home/background_forest_sanctuary.png",
		"home_profile": "ui/profile_guardian.png",
		"home_panel": "ui/panel_parchment_9slice.png",
		"home_button_sortie": "ui/button_sortie_orange.png",
		"home_resource_chip": "ui/topbar/top_resource_chip.png",
		"home_profile_card": "ui/topbar/top_profile_card.png",
		"home_status_card": "ui/topbar/top_status_card.png",
		"home_icon_population": "ui/icons/icon_population.png",
		"home_icon_menu": "ui/icons/icon_menu.png",
		"home_icon_settings": "ui/icons/icon_settings.png",
		"home_icon_mail": "ui/icons/icon_side_mail.png",
		"home_icon_bag": "ui/icons/icon_side_bag.png",
		"home_icon_pass": "ui/icons/icon_side_pass.png",
		"home_icon_collect": "ui/icons/icon_collect.png",
		"home_icon_lock": "ui/icons/icon_lock.png",
		"home_modal_crest": "ui/sanctuary-build/frame_crest.png",
		"home_modal_corner": "ui/sanctuary-build/frame_corner_leaf.png",
		"home_tab_sanctuary": "ui/icons/icon_tab_sanctuary.png",
		"home_tab_equipment": "ui/icons/icon_tab_equipment.png",
		"home_tab_exploration": "ui/icons/icon_tab_exploration.png",
		"home_tab_mission": "ui/icons/icon_tab_mission.png",
		"home_tab_shop": "ui/icons/icon_tab_shop.png",
		"home_hex_built": "home/hex/hex_ground_built.png",
		"home_hex_empty": "home/hex/hex_ground_empty.png",
		"home_hex_expand": "home/hex/hex_ground_expand.png",
		"home_hex_fog": "home/hex/hex_ground_fog.png",
		"home_hex_locked": "home/hex/hex_ground_locked.png",
		"home_hex_selected": "home/hex/hex_ground_selected.png",
		"home_building_construction": "home/buildings/construction_site.png",
	}
	for set_key in CONSTRUCTION_STAGE_NAMES_BY_SET.keys():
		var stage_names: Array = CONSTRUCTION_STAGE_NAMES_BY_SET[set_key]
		for stage_name in stage_names:
			paths["home_building_construction_%s_%s" % [set_key, stage_name]] = "home/buildings/construction/%s/%s_%s.png" % [set_key, set_key, stage_name]

	for building in buildings:
		if typeof(building) != TYPE_DICTIONARY:
			continue
		var sprite_key := str(building.get("spriteKey", ""))
		if sprite_key == "":
			continue
		paths["home_building_%s" % sprite_key] = "home/buildings/%s.png" % sprite_key

	return paths


func building_texture_key(building: Dictionary, instance: Dictionary) -> String:
	var sprite_key := str(building.get("spriteKey", instance.get("spriteKey", "")))
	if str(instance.get("status", "built")) != "constructing":
		return "home_building_%s" % sprite_key
	var stage_set := str(CONSTRUCTION_STAGE_SET_BY_SPRITE_KEY.get(sprite_key, ""))
	if stage_set != "":
		return "home_building_construction_%s_%s" % [stage_set, construction_stage_name(instance, stage_set)]
	return "home_building_construction"


func construction_progress(instance: Dictionary) -> float:
	if str(instance.get("status", "")) != "constructing":
		return 1.0
	return clamp(float(instance.get("constructionProgress", 0.41)), 0.0, 0.999)


func construction_percent_label(instance: Dictionary) -> String:
	return "%d%%" % int(round(construction_progress(instance) * 100.0))


func construction_stage_name(instance: Dictionary, stage_set := "") -> String:
	var stage_names: Array = CONSTRUCTION_STAGE_NAMES_BY_SET.get(stage_set, CONSTRUCTION_STAGE_NAMES)
	var progress := construction_progress(instance)
	var index: int = clamp(int(floor(progress * float(stage_names.size()))), 0, stage_names.size() - 1)
	return str(stage_names[index])


func production_rate_label(building: Dictionary, level: int) -> String:
	var production = building.get("production", {})
	if typeof(production) != TYPE_DICTIONARY:
		return ""

	var rates = production.get("rateByLevel", [])
	if typeof(rates) != TYPE_ARRAY or rates.is_empty():
		return ""

	var index: int = clamp(level - 1, 0, rates.size() - 1)
	var rate := float(rates[index])
	var unit := "/h" if str(production.get("rateUnit", "per_minute")) == "per_hour" else "/m"
	if rate <= 0.0:
		return ""
	if rate < 10.0 and not is_equal_approx(rate, floor(rate)):
		return "+%s%s" % [_trim_float(rate, 1), unit]
	return "+%d%s" % [int(round(rate)), unit]


func primary_effect_label(building: Dictionary, level: int) -> String:
	var levels = building.get("levels", [])
	if typeof(levels) != TYPE_ARRAY or levels.is_empty():
		return ""

	var index: int = clamp(level - 1, 0, levels.size() - 1)
	var level_data = levels[index]
	if typeof(level_data) != TYPE_DICTIONARY:
		return ""
	var effect = level_data.get("effect", {})
	if typeof(effect) != TYPE_DICTIONARY or effect.is_empty():
		return ""

	var key := str(effect.keys()[0])
	var value := float(effect[key])
	if key.ends_with("_percent"):
		return "%s %s%%" % [_effect_name(key), _trim_float(value, 1)]
	if key.ends_with("_per_min"):
		return "%s +%s/m" % [_effect_name(key), _trim_float(value, 1)]
	if key.ends_with("_per_hour"):
		return "%s +%s/h" % [_effect_name(key), _trim_float(value, 1)]
	return "%s %s" % [_effect_name(key), _trim_float(value, 1)]


func _effect_name(key: String) -> String:
	var names := {
		"gold_per_min": "골드",
		"wood_per_min": "목재",
		"stone_per_min": "석재",
		"soulflame_per_hour": "영혼불",
		"companion_attack_percent": "용병공격",
		"damage_taken_reduction_percent": "피해감소",
		"boss_damage_percent": "보스피해",
		"resident_cap_bonus": "주민",
		"all_production_percent": "생산",
	}
	return names.get(key, key)


func _format_amount(value: float) -> String:
	if value >= 100000.0:
		return "%.0fK" % (value / 1000.0)
	if value >= 2000.0:
		var text := "%.1fK" % (value / 1000.0)
		return text.replace(".0K", "K")
	if is_equal_approx(value, floor(value)):
		return str(int(value))
	return _trim_float(value, 1)


func _trim_float(value: float, digits: int) -> String:
	var text := "%.*f" % [digits, value]
	while text.ends_with("0"):
		text = text.substr(0, text.length() - 1)
	if text.ends_with("."):
		text = text.substr(0, text.length() - 1)
	return text
