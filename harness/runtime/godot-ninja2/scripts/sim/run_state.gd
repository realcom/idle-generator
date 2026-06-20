extends RefCounted

const SAVE_PATH := "user://ninja2_godot_state.json"

var resources := {
	"gold": 320,
	"wood": 0,
	"stone": 0,
	"soul": 0,
}
var stage_clears := {}
var run_history: Array = []
var last_result := {}


func reset() -> void:
	resources = {
		"gold": 320,
		"wood": 0,
		"stone": 0,
		"soul": 0,
	}
	stage_clears.clear()
	run_history.clear()
	last_result.clear()


func add_resource(key: String, amount: int) -> void:
	if not resources.has(key):
		resources[key] = 0
	resources[key] = int(resources[key]) + amount


func add_resources(delta: Dictionary) -> void:
	for key in delta.keys():
		add_resource(str(key), int(delta[key]))


func record_run(report: Dictionary) -> void:
	last_result = report.duplicate(true)
	run_history.push_front(last_result)
	while run_history.size() > 12:
		run_history.pop_back()

	if str(report.get("result", "")) == "clear":
		var map_id := int(report.get("map_id", 0))
		stage_clears[map_id] = int(stage_clears.get(map_id, 0)) + 1


func has_progress() -> bool:
	if not stage_clears.is_empty() or not run_history.is_empty():
		return true
	return int(resources.get("gold", 0)) != 320 \
		or int(resources.get("wood", 0)) != 0 \
		or int(resources.get("stone", 0)) != 0 \
		or int(resources.get("soul", 0)) != 0


func title_status_text() -> String:
	var clear_total := 0
	for count in stage_clears.values():
		clear_total += int(count)
	if has_progress():
		return "저장됨  클리어 %d  골드 %d  목재 %d" % [
			clear_total,
			int(resources.get("gold", 0)),
			int(resources.get("wood", 0)),
		]
	return "새 여정 준비 완료"


func save() -> Error:
	var payload := {
		"resources": resources,
		"stage_clears": stage_clears,
		"run_history": run_history,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(payload))
	return OK


func load() -> Error:
	if not FileAccess.file_exists(SAVE_PATH):
		return ERR_FILE_NOT_FOUND

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()

	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	if parse_error != OK or typeof(json.data) != TYPE_DICTIONARY:
		return ERR_PARSE_ERROR

	var data: Dictionary = json.data
	if typeof(data.get("resources", {})) == TYPE_DICTIONARY:
		resources = data["resources"]
	if typeof(data.get("stage_clears", {})) == TYPE_DICTIONARY:
		stage_clears = _int_key_dict(data["stage_clears"])
	if typeof(data.get("run_history", [])) == TYPE_ARRAY:
		run_history = data["run_history"]
	if run_history.size() > 0 and typeof(run_history[0]) == TYPE_DICTIONARY:
		last_result = run_history[0]
	return OK


func _int_key_dict(source: Dictionary) -> Dictionary:
	var result := {}
	for key in source.keys():
		result[int(key)] = int(source[key])
	return result
