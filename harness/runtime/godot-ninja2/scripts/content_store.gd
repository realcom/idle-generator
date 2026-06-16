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


func stat_value(definition: Dictionary, stat_type: String, fallback := 0.0) -> float:
	for stat in definition.get("addStats", []):
		if typeof(stat) != TYPE_DICTIONARY:
			continue
		var current_type := str(stat.get("type", "Hp"))
		if current_type != stat_type:
			continue

		var values = stat.get("value", [])
		if typeof(values) == TYPE_ARRAY and values.size() > 0:
			return float(values[0])

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


func bundle_dir_path() -> String:
	return ProjectSettings.globalize_path("res://%s" % BUILD_DIR)


func runtime_asset_path(relative_path: String) -> String:
	return ProjectSettings.globalize_path("res://../assets/ninja2/%s" % relative_path)


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
