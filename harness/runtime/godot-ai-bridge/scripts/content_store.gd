extends RefCounted

const BUNDLES := {
	"Units": "units",
	"Items": "items",
	"Skills": "skills",
	"Maps": "maps",
	"Achievements": "achievements",
	"Buffs": "buffs",
	"Triggers": "triggers",
	"Strings": "strings",
	"Audios": "audios",
	"ResourceGlobals": ""
}

var game := "idlez"
var build_dir := "../../build/idlez"
var bundles := {}
var errors: Array[String] = []


func load_all() -> bool:
	bundles.clear()
	errors.clear()

	for bundle_name in BUNDLES.keys():
		var data := _load_bundle(bundle_name)
		if data != null:
			bundles[bundle_name] = data

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


func get_counts() -> Dictionary:
	var counts := {}
	for bundle_name in BUNDLES.keys():
		counts[bundle_name] = get_records(bundle_name).size()
	return counts


func build_context_summary(max_samples := 4) -> String:
	var lines: Array[String] = []
	lines.append("Game: %s" % game)
	lines.append("Build dir: %s" % _bundle_dir_path())
	lines.append("")

	for bundle_name in ["Units", "Items", "Skills", "Maps", "Achievements"]:
		var records := get_records(bundle_name)
		lines.append("%s: %d" % [bundle_name, records.size()])
		for sample in _sample_records(records, max_samples):
			lines.append("  - %s" % sample)
		lines.append("")

	if not errors.is_empty():
		lines.append("Load errors:")
		for error in errors:
			lines.append("  - %s" % error)

	return "\n".join(lines)


func _load_bundle(bundle_name: String):
	var path := "%s/%s.json" % [_bundle_dir_path(), bundle_name]
	if not FileAccess.file_exists(path):
		errors.append("Missing %s" % path)
		return null

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("Cannot open %s: %s" % [path, error_string(FileAccess.get_open_error())])
		return null

	var text := file.get_as_text()
	var json := JSON.new()
	var parse_error := json.parse(text)
	if parse_error != OK:
		errors.append(
			"JSON parse failed in %s at line %d: %s"
			% [path, json.get_error_line(), json.get_error_message()]
		)
		return null

	return json.data


func _bundle_dir_path() -> String:
	return ProjectSettings.globalize_path("res://%s" % build_dir)


func _sample_records(records: Array, max_samples: int) -> Array[String]:
	var samples: Array[String] = []
	var limit := mini(records.size(), max_samples)

	for index in range(limit):
		var record = records[index]
		if typeof(record) != TYPE_DICTIONARY:
			samples.append(str(record))
			continue

		var id_text := str(record.get("id", "?"))
		var name_text := str(record.get("name", "(unnamed)"))
		var extra := _record_extra(record)
		if extra == "":
			samples.append("%s %s" % [id_text, name_text])
		else:
			samples.append("%s %s [%s]" % [id_text, name_text, extra])

	return samples


func _record_extra(record: Dictionary) -> String:
	var parts: Array[String] = []
	for key in ["type", "condition", "damageType", "cooldown"]:
		if record.has(key):
			parts.append("%s=%s" % [key, str(record[key])])
	return ", ".join(parts)
