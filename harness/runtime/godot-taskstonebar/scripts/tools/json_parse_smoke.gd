extends SceneTree

const ContentStore := preload("res://scripts/content_store.gd")
const WavePlanner := preload("res://scripts/combat/wave_planner.gd")
const SpriteCatalog := preload("res://scripts/visual/sprite_catalog.gd")

const REQUIRED_JSON_FILES := [
	"ResourceGlobals.json",
	"Units.json",
	"Items.json",
	"Skills.json",
	"Buffs.json",
	"Maps.json",
	"Strings.json",
	"Achievements.json",
	"Audios.json",
	"Triggers.json",
]

const COLLECTION_KEYS := {
	"Units.json": "units",
	"Items.json": "items",
	"Skills.json": "skills",
	"Buffs.json": "buffs",
	"Maps.json": "maps",
	"Strings.json": "strings",
	"Achievements.json": "achievements",
	"Audios.json": "audios",
	"Triggers.json": "triggers",
}

const EXPECTED_ROLES := ["Basic", "Fast", "Ranged", "Armored", "MiniBoss", "GiantBoss"]

var failed := false


func _init() -> void:
	var store = ContentStore.new()
	var parsed := _parse_json_files(store.bundle_dir_path())
	if failed:
		return

	if not store.load_all():
		_fail("content store load failed after JSON parse: %s" % "; ".join(store.errors))
		return

	_check_content_store_indexes(store)
	if failed:
		return
	_check_taskstonebar_monster_sets(store)
	if failed:
		return
	_check_chapter_map_wave_plans(store)
	if failed:
		return
	_check_monster_sprite_paths(store)
	if failed:
		return

	print("godot-taskstonebar json parse smoke ok: files=%d maps=%d monsters=60 sets=10" % [
		parsed.size(),
		store.get_records("Maps").size(),
	])
	quit(0)


func _parse_json_files(build_dir: String) -> Dictionary:
	var parsed := {}
	for file_name in REQUIRED_JSON_FILES:
		var path := "%s/%s" % [build_dir, file_name]
		parsed[file_name] = _parse_json_file(path)
		if failed:
			return parsed
		_check_json_shape(file_name, parsed[file_name])
		if failed:
			return parsed

	var steam_preview_path := "%s/SteamItemDefs.preview.json" % build_dir
	if FileAccess.file_exists(steam_preview_path):
		parsed["SteamItemDefs.preview.json"] = _parse_json_file(steam_preview_path)
		if failed:
			return parsed
		if typeof(parsed["SteamItemDefs.preview.json"]) != TYPE_ARRAY:
			_fail("SteamItemDefs.preview.json expected array root")
			return parsed

	return parsed


func _parse_json_file(path: String):
	if not FileAccess.file_exists(path):
		_fail("missing JSON file: %s" % path)
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_fail("cannot open JSON file %s: %s" % [path, error_string(FileAccess.get_open_error())])
		return null

	var parser := JSON.new()
	var error := parser.parse(file.get_as_text())
	if error != OK:
		_fail("JSON parse failed in %s at line %d: %s" % [
			path,
			parser.get_error_line(),
			parser.get_error_message(),
		])
		return null
	return parser.data


func _check_json_shape(file_name: String, data) -> void:
	if file_name == "ResourceGlobals.json":
		if typeof(data) != TYPE_DICTIONARY or not data.has("globalData"):
			_fail("ResourceGlobals.json expected dictionary root with globalData")
		return

	if not COLLECTION_KEYS.has(file_name):
		return
	if typeof(data) != TYPE_DICTIONARY:
		_fail("%s expected dictionary root" % file_name)
		return
	var key := str(COLLECTION_KEYS[file_name])
	if not data.has(key) or typeof(data[key]) != TYPE_ARRAY:
		_fail("%s expected array key '%s'" % [file_name, key])


func _check_content_store_indexes(store) -> void:
	_expect_min_records(store, "Maps", 100)
	_expect_min_records(store, "Units", 61)
	_expect_min_records(store, "Items", 200)
	_expect_min_records(store, "Skills", 40)
	_expect_min_records(store, "Buffs", 2)
	_expect_min_records(store, "Triggers", 100)
	_expect_min_records(store, "Achievements", 20)

	if store.get_map(500101).is_empty():
		_fail("map 500101 was not indexed")
		return
	if store.get_unit(111011).is_empty():
		_fail("unit 111011 was not indexed")
		return
	if store.get_trigger("MAP_ONSTART_TASKSTONEBARSET01WAVE1").is_empty():
		_fail("trigger MAP_ONSTART_TASKSTONEBARSET01WAVE1 was not indexed")


func _expect_min_records(store, bundle_name: String, minimum: int) -> void:
	if failed:
		return
	var count: int = store.get_records(bundle_name).size()
	if count < minimum:
		_fail("%s expected at least %d records, got %d" % [bundle_name, minimum, count])


func _check_taskstonebar_monster_sets(store) -> void:
	var roles_by_set := {}
	var monster_count := 0
	for unit in store.get_records("Units"):
		if typeof(unit) != TYPE_DICTIONARY:
			continue
		var tags := _tags(unit)
		if not tags.has("Monster") or not tags.has("Taskstonebar"):
			continue
		monster_count += 1
		var set_tag := _set_tag(tags)
		var role := _role_tag(tags)
		if set_tag == "" or role == "":
			_fail("%s is missing SetXX or role tags" % str(unit.get("name", unit.get("id", ""))))
			return
		var sprite := str(unit.get("sprite", ""))
		if not sprite.begins_with("runtime/units/monsters/") or sprite.contains("/animated/") or sprite.get_file().begins_with("taskstonebar_s"):
			_fail("%s sprite must use an original runtime monster sheet for %s: %s" % [str(unit.get("name", unit.get("id", ""))), set_tag, sprite])
			return
		if not roles_by_set.has(set_tag):
			roles_by_set[set_tag] = {}
		roles_by_set[set_tag][role] = int(unit.get("id", 0))

	if monster_count != 60:
		_fail("expected 60 Taskstonebar monster units in JSON, got %d" % monster_count)
		return

	for set_index in range(1, 11):
		var set_tag := "Set%02d" % set_index
		if not roles_by_set.has(set_tag):
			_fail("missing monster set %s" % set_tag)
			return
		for role in EXPECTED_ROLES:
			if not roles_by_set[set_tag].has(role):
				_fail("%s is missing role %s" % [set_tag, role])
				return


func _check_chapter_map_wave_plans(store) -> void:
	var planner = WavePlanner.new(store)
	for set_index in range(1, 11):
		var start_map_id := 500101 + ((set_index - 1) * 10)
		var boss_map_id := start_map_id + 9
		var prefab_marker := "PFB_MAP_Taskstonebar_%02d" % set_index
		var expected_units := _expected_unit_ids_for_set(set_index)

		var start_map: Dictionary = store.get_map(start_map_id)
		var boss_map: Dictionary = store.get_map(boss_map_id)
		if start_map.is_empty() or boss_map.is_empty():
			_fail("missing chapter maps for set %02d: %d/%d" % [set_index, start_map_id, boss_map_id])
			return
		if not str(start_map.get("prefab", "")).contains(prefab_marker):
			_fail("map %d expected prefab marker %s, got %s" % [start_map_id, prefab_marker, str(start_map.get("prefab", ""))])
			return
		if not str(boss_map.get("prefab", "")).contains(prefab_marker):
			_fail("map %d expected prefab marker %s, got %s" % [boss_map_id, prefab_marker, str(boss_map.get("prefab", ""))])
			return

		var start_units := _plan_unit_ids(planner.build_plan(start_map))
		for i in range(5):
			if not start_units.has(expected_units[i]):
				_fail("map %d wave plan does not include unit %d" % [start_map_id, expected_units[i]])
				return

		var boss_units := _plan_unit_ids(planner.build_plan(boss_map))
		if not boss_units.has(expected_units[5]):
			_fail("map %d boss wave plan does not include boss unit %d" % [boss_map_id, expected_units[5]])
			return


func _check_monster_sprite_paths(store) -> void:
	var sprites = SpriteCatalog.new()
	if not sprites.load_all():
		_fail("sprite catalog base load failed: %s" % "; ".join(sprites.errors))
		return
	for unit in store.get_records("Units"):
		if typeof(unit) != TYPE_DICTIONARY:
			continue
		var tags := _tags(unit)
		if not tags.has("Monster") or not tags.has("Taskstonebar"):
			continue
		var texture: Texture2D = sprites.texture_for_unit(int(unit.get("id", 0)), str(unit.get("sprite", "")))
		if texture == null:
			_fail("%s has no loadable sprite %s" % [str(unit.get("name", unit.get("id", ""))), str(unit.get("sprite", ""))])
			return
		var sprite_path := str(unit.get("sprite", ""))
		if sprite_path.begins_with("runtime/units/monsters/"):
			if not sprites.has_unit_animation(sprite_path):
				_fail("%s has no animation metadata for %s" % [str(unit.get("name", unit.get("id", ""))), sprite_path])
				return
			var animation := sprites.animation_for_unit(sprite_path)
			var actions = animation.get("actions", {}) if typeof(animation) == TYPE_DICTIONARY else {}
			var move_action = actions.get("move", {}) if typeof(actions) == TYPE_DICTIONARY else {}
			var move_frames = move_action.get("frames", []) if typeof(move_action) == TYPE_DICTIONARY else []
			if typeof(move_frames) != TYPE_ARRAY or move_frames.size() < 2:
				_fail("%s sprite must have at least 2 move frames: %s" % [str(unit.get("name", unit.get("id", ""))), sprite_path])
				return
			if not sprites.region_for_unit(int(unit.get("id", 0)), sprite_path, "move", 0.2).has_area():
				_fail("%s has no valid move animation region for %s" % [str(unit.get("name", unit.get("id", ""))), sprite_path])
				return
	if not sprites.errors.is_empty():
		_fail("sprite path errors after JSON parse: %s" % "; ".join(sprites.errors))


func _expected_unit_ids_for_set(set_index: int) -> Array:
	var normal_base := 111000 + (set_index * 10)
	return [
		normal_base + 1,
		normal_base + 2,
		normal_base + 3,
		normal_base + 4,
		normal_base + 5,
		111500 + set_index,
	]


func _plan_unit_ids(plan: Array) -> Array:
	var ids := []
	for wave in plan:
		if typeof(wave) != TYPE_DICTIONARY:
			continue
		for unit in wave.get("units", []):
			if typeof(unit) != TYPE_DICTIONARY:
				continue
			var unit_id := int(unit.get("unit_id", 0))
			if unit_id > 0 and not ids.has(unit_id):
				ids.append(unit_id)
	return ids


func _tags(record: Dictionary) -> Array:
	var tags = record.get("tags", [])
	return tags if typeof(tags) == TYPE_ARRAY else []


func _set_tag(tags: Array) -> String:
	for tag in tags:
		var text := str(tag)
		if text.begins_with("Set"):
			return text
	return ""


func _role_tag(tags: Array) -> String:
	for role in EXPECTED_ROLES:
		if tags.has(role):
			return role
	return ""


func _fail(message: String) -> void:
	failed = true
	push_error(message)
	quit(1)
