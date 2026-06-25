extends RefCounted

const GAME_ID := "taskstonebar"
const BUILD_DIRS := [
	"export_data/build/taskstonebar",
	"../../build/taskstonebar",
]
const BUNDLES := {
	"Maps": "maps",
	"Units": "units",
	"Items": "items",
	"Skills": "skills",
	"Buffs": "buffs",
	"Triggers": "triggers",
	"Achievements": "achievements",
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

	for bundle_name in ["Maps", "Units", "Items", "Skills", "Buffs", "Achievements"]:
		_index_bundle(bundle_name)
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
	var key: String = BUNDLES.get(bundle_name, "")
	var records = data.get(key, [])
	return records if typeof(records) == TYPE_ARRAY else []


func get_record(bundle_name: String, data_id: int) -> Dictionary:
	return by_id.get(bundle_name, {}).get(int(data_id), {})


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


func get_main_map() -> Dictionary:
	for map_def in get_records("Maps"):
		if typeof(map_def) != TYPE_DICTIONARY:
			continue
		var tags = map_def.get("tags", [])
		if typeof(tags) == TYPE_ARRAY and tags.has("Main"):
			return map_def
	var maps := get_records("Maps")
	return maps[0] if maps.size() > 0 and typeof(maps[0]) == TYPE_DICTIONARY else {}


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


func first_skill() -> Dictionary:
	var skills := get_records("Skills")
	return skills[0] if skills.size() > 0 and typeof(skills[0]) == TYPE_DICTIONARY else {}


func skill_damage_ratio(skill_def: Dictionary, skill_level := 1) -> float:
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
		var index: int = clamp(int(skill_level) - 1, 0, damages.size() - 1)
		best = maxf(best, float(damages[index]))
	return best


func skill_damage_total_ratio(skill_def: Dictionary, skill_level := 1) -> float:
	var total := 0.0
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
		var index: int = clamp(int(skill_level) - 1, 0, damages.size() - 1)
		total += float(damages[index])
	return total if total > 0.0 else skill_damage_ratio(skill_def, skill_level)


func bundle_dir_path() -> String:
	for build_dir in BUILD_DIRS:
		var path := "res://%s" % str(build_dir)
		if FileAccess.file_exists("%s/Maps.json" % path):
			return path
	return "res://%s" % str(BUILD_DIRS[0])


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
		errors.append("JSON parse failed in %s at line %d: %s" % [path, json.get_error_line(), json.get_error_message()])
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
		if typeof(trigger) == TYPE_DICTIONARY:
			triggers_by_name[str(trigger.get("name", ""))] = trigger
