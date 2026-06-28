extends RefCounted

signal window_registered(window_id: String)
signal window_visibility_changed(window_id: String, visible: bool)
signal window_focused(window_id: String)

const DEFAULT_BASE_Z := 80
const FOCUS_Z_STEP := 20

var records: Dictionary = {}
var focus_order: Array[String] = []
var focused_window_id := ""


func register_window(window_id: String, control: Control, native_window: Window = null, options: Dictionary = {}) -> void:
	if window_id == "" or control == null:
		return
	var previous: Dictionary = records.get(window_id, {}) if records.has(window_id) else {}
	var previous_control: Control = previous.get("control", null) as Control
	var should_assign_base_z := previous.is_empty() or previous_control != control
	var record := {
		"id": window_id,
		"control": control,
		"native": native_window,
		"title": str(options.get("title", window_id)),
		"group": str(options.get("group", "workspace")),
		"default_visible": bool(previous.get("default_visible", options.get("default_visible", control.visible))),
		"restore_visible": bool(previous.get("restore_visible", options.get("restore_visible", control.visible))),
		"base_z": int(options.get("base_z", DEFAULT_BASE_Z + records.size())),
	}
	records[window_id] = record
	if not focus_order.has(window_id):
		focus_order.append(window_id)
	control.set_meta("desktop_window_id", window_id)
	if should_assign_base_z:
		control.z_index = int(record["base_z"])
	if native_window != null:
		native_window.visible = bool(control.visible)
	window_registered.emit(window_id)


func bind_native_window(window_id: String, native_window: Window) -> void:
	if not records.has(window_id):
		return
	var record: Dictionary = records[window_id]
	record["native"] = native_window
	records[window_id] = record
	if native_window != null:
		native_window.visible = is_window_visible(window_id)


func unregister_window(window_id: String) -> void:
	records.erase(window_id)
	focus_order.erase(window_id)
	if focused_window_id == window_id:
		focused_window_id = ""


func has_window(window_id: String) -> bool:
	return records.has(window_id)


func get_control(window_id: String) -> Control:
	if not records.has(window_id):
		return null
	var control: Variant = records[window_id].get("control", null)
	if control != null and is_instance_valid(control):
		return control as Control
	return null


func get_native_window(window_id: String) -> Window:
	if not records.has(window_id):
		return null
	var native: Variant = records[window_id].get("native", null)
	if native != null and is_instance_valid(native):
		return native as Window
	return null


func is_window_visible(window_id: String) -> bool:
	var control := get_control(window_id)
	var native := get_native_window(window_id)
	if native != null:
		return native.visible
	if control != null:
		return control.visible
	return false


func show_window(window_id: String, focus := true) -> void:
	_set_window_visible(window_id, true)
	if focus:
		focus_window(window_id)


func hide_window(window_id: String) -> void:
	_set_window_visible(window_id, false)


func toggle_window(window_id: String) -> void:
	if is_window_visible(window_id):
		hide_window(window_id)
	else:
		show_window(window_id, true)


func focus_window(window_id: String) -> void:
	if not records.has(window_id):
		return
	focused_window_id = window_id
	focus_order.erase(window_id)
	focus_order.append(window_id)
	for index in range(focus_order.size()):
		var id := focus_order[index]
		var control := get_control(id)
		if control != null:
			control.z_index = int(records[id].get("base_z", DEFAULT_BASE_Z)) + index * FOCUS_Z_STEP
	var native := get_native_window(window_id)
	if native != null and native.visible:
		native.grab_focus()
	var focused_control := get_control(window_id)
	if focused_control != null and focused_control.visible:
		focused_control.move_to_front()
		if focused_control.focus_mode != Control.FOCUS_NONE:
			focused_control.grab_focus()
	window_focused.emit(window_id)


func hide_group(group: String) -> void:
	for window_id in records.keys():
		var record: Dictionary = records[window_id]
		if str(record.get("group", "")) == group:
			record["restore_visible"] = is_window_visible(str(window_id))
			records[window_id] = record
			hide_window(str(window_id))


func restore_group(group: String, visible_overrides: Dictionary = {}) -> void:
	for window_id in records.keys():
		var id := str(window_id)
		var record: Dictionary = records[id]
		if str(record.get("group", "")) != group:
			continue
		var should_show := bool(record.get("restore_visible", record.get("default_visible", true)))
		if visible_overrides.has(id):
			should_show = bool(visible_overrides[id])
		_set_window_visible(id, should_show)
	if focused_window_id != "" and is_window_visible(focused_window_id):
		focus_window(focused_window_id)


func visible_window_ids() -> Array[String]:
	var result: Array[String] = []
	for window_id in records.keys():
		var id := str(window_id)
		if is_window_visible(id):
			result.append(id)
	return result


func snapshot() -> Dictionary:
	var open_ids: Array[String] = visible_window_ids()
	return {
		"registered": records.keys(),
		"visible": open_ids,
		"focused": focused_window_id,
		"count": records.size(),
	}


func _set_window_visible(window_id: String, visible: bool) -> void:
	var control := get_control(window_id)
	var native := get_native_window(window_id)
	if control != null:
		control.visible = visible
	if native != null:
		native.visible = visible
	window_visibility_changed.emit(window_id, visible)
