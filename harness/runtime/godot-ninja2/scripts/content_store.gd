extends RefCounted

const GAME_ID := "ninja2"
const BUILD_DIR := "../../build/ninja2"
const BUNDLES := {
	"ResourceGlobals": "",
	"Maps": "maps",
	"Units": "units",
	"Items": "items",
	"Skills": "skills",
	"Buffs": "buffs",
	"Triggers": "triggers",
	"Strings": "strings",
	"Achievements": "achievements",
	"Audios": "audios",
}

var bundles := {}
var by_id := {}
var triggers_by_name := {}
var errors: Array[String] = []


func load_all() -> bool:
	bundles.clear()
	by_id.clear()
	triggers_by_name.clear()
	errors.clear()

	for bundle_name in BUNDLES.keys():
		var data = _read_json_bundle(bundle_name)
		if data != null:
			bundles[bundle_name] = data

	_index_bundle("Maps")
	_index_bundle("Units")
	_index_bundle("Items")
	_index_bundle("Skills")
	_index_bundle("Buffs")
	_index_bundle("Achievements")
	_index_triggers()

	return errors.is_empty()


func get_records(bundle_name: String) -> Array:
	if not bundles.has(bundle_name):
		return []

	var data = bundles[bundle_name]
	if typeof(data) == TYPE_ARRAY:
		return data

	if typeof(data) != TYPE_DICTIONARY:
		return []

	var key = BUNDLES.get(bundle_name, "")
	if key == "":
		return []

	var records = data.get(key, [])
	if typeof(records) == TYPE_ARRAY:
		return records

	return []


func get_record(bundle_name: String, data_id: int) -> Dictionary:
	var table = by_id.get(bundle_name, {})
	return table.get(int(data_id), {})


func get_map(data_id: int) -> Dictionary:
	return get_record("Maps", data_id)


func get_unit(data_id: int) -> Dictionary:
	return get_record("Units", data_id)


func get_item(data_id: int) -> Dictionary:
	return get_record("Items", data_id)


func get_skill(data_id: int) -> Dictionary:
	return get_record("Skills", data_id)


func get_trigger(name: String) -> Dictionary:
	return triggers_by_name.get(name, {})


func get_player_unit() -> Dictionary:
	for unit in get_records("Units"):
		if typeof(unit) == TYPE_DICTIONARY and str(unit.get("type", "")) == "Player":
			return unit
	return {}


func get_main_maps() -> Array:
	var maps := []
	for map_def in get_records("Maps"):
		if typeof(map_def) != TYPE_DICTIONARY:
			continue
		var tags = map_def.get("tags", [])
		if tags.has("Survival") and tags.has("InfiniteWaves"):
			maps.append(map_def)

	maps.sort_custom(func(a, b): return int(a.get("id", 0)) < int(b.get("id", 0)))
	return maps


func map_board_constants(map_def: Dictionary) -> Dictionary:
	var constants := {}
	var maps_bundle = bundles.get("Maps", {})
	if typeof(maps_bundle) == TYPE_DICTIONARY:
		var map_global = maps_bundle.get("mapGlobal", {})
		if typeof(map_global) == TYPE_DICTIONARY:
			_merge_dictionary(constants, map_global.get("boardConstants", {}))
	_merge_dictionary(constants, map_def.get("boardConstants", {}))
	return constants


func get_equipment_sample(limit := 7) -> Array:
	var sample := []
	for item in get_records("Items"):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var category := str(item.get("category", ""))
		if category == "Weapon" or category == "Equipment":
			sample.append(item)
			if sample.size() >= limit:
				break
	return sample


func stat_value(definition: Dictionary, stat_type: String, fallback := 0.0, level := 1) -> float:
	for stat in definition.get("addStats", []):
		if typeof(stat) != TYPE_DICTIONARY:
			continue
		var current_type := str(stat.get("type", "Hp"))
		if current_type != stat_type:
			continue

		var values = stat.get("value", [])
		if typeof(values) == TYPE_ARRAY and values.size() > 0:
			var index: int = clamp(int(level) - 1, 0, values.size() - 1)
			return float(values[index])

	return fallback


func first_level_value(values, fallback := 0.0) -> float:
	if typeof(values) == TYPE_ARRAY and values.size() > 0:
		return float(values[0])
	return fallback


func build_summary() -> String:
	var lines: Array[String] = []
	lines.append("ninja2 build loaded from %s" % bundle_dir_path())
	for bundle_name in ["Units", "Items", "Skills", "Maps", "Triggers", "Achievements"]:
		lines.append("%s: %d" % [bundle_name, get_records(bundle_name).size()])

	lines.append("")
	lines.append("Main survival maps:")
	for map_def in get_main_maps().slice(0, 6):
		lines.append("  %s %s" % [str(map_def.get("id", "?")), str(map_def.get("name", ""))])

	if not errors.is_empty():
		lines.append("")
		lines.append("Load warnings:")
		for error in errors:
			lines.append("  %s" % error)

	return "\n".join(lines)


func map_init_variables(map_def: Dictionary) -> Dictionary:
	var values := {}
	for entry in map_def.get("initVariables", []):
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		values[int(entry.get("callerKey", 0))] = float(entry.get("value", 0.0))
	return values


func map_wave_count(map_def: Dictionary) -> int:
	var popup_args = map_def.get("popupArgs", {})
	if typeof(popup_args) == TYPE_DICTIONARY and popup_args.has("ClientWaveCount"):
		return int(popup_args["ClientWaveCount"])
	return 1


func skill_damage_percent(skill_def: Dictionary, skill_level := 1) -> float:
	var best := 1.0
	for timeline in skill_def.get("timelines", []):
		if typeof(timeline) != TYPE_DICTIONARY:
			continue
		var hit = timeline.get("hit", {})
		if typeof(hit) != TYPE_DICTIONARY:
			continue
		var add_damage = hit.get("addDamage", {})
		if typeof(add_damage) != TYPE_DICTIONARY:
			continue
		var damages = add_damage.get("attackPercentDamages", [])
		if typeof(damages) != TYPE_ARRAY or damages.is_empty():
			continue
		var index: int = clamp(skill_level - 1, 0, damages.size() - 1)
		best = max(best, float(damages[index]))
	return best


func skill_hit_max(skill_def: Dictionary) -> int:
	var max_hit := 1
	for timeline in skill_def.get("timelines", []):
		if typeof(timeline) != TYPE_DICTIONARY:
			continue
		var hit = timeline.get("hit", {})
		if typeof(hit) == TYPE_DICTIONARY:
			max_hit = max(max_hit, int(hit.get("maxHit", 1)))
	return max_hit


func bundle_dir_path() -> String:
	return ProjectSettings.globalize_path("res://%s" % BUILD_DIR)


func runtime_asset_path(relative_path: String) -> String:
	return ProjectSettings.globalize_path("res://../assets/ninja2/%s" % relative_path)


func _merge_dictionary(target: Dictionary, source) -> void:
	if typeof(source) != TYPE_DICTIONARY:
		return
	for key in source.keys():
		var value = source[key]
		if typeof(value) == TYPE_DICTIONARY and typeof(target.get(key, null)) == TYPE_DICTIONARY:
			_merge_dictionary(target[key], value)
		else:
			target[key] = value


func _read_json_bundle(bundle_name: String):
	var path := "%s/%s.json" % [bundle_dir_path(), bundle_name]
	if not FileAccess.file_exists(path):
		errors.append("Missing %s" % path)
		return null

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("Cannot open %s: %s" % [path, error_string(FileAccess.get_open_error())])
		return null

	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	if parse_error != OK:
		errors.append(
			"JSON parse failed in %s at line %d: %s"
			% [path, json.get_error_line(), json.get_error_message()]
		)
		return null

	return json.data


func _index_bundle(bundle_name: String) -> void:
	var table := {}
	for record in get_records(bundle_name):
		if typeof(record) == TYPE_DICTIONARY and record.has("id"):
			table[int(record["id"])] = record
	by_id[bundle_name] = table


func _index_triggers() -> void:
	for trigger in get_records("Triggers"):
		if typeof(trigger) == TYPE_DICTIONARY and trigger.has("name"):
			triggers_by_name[str(trigger["name"])] = trigger
