extends "res://scripts/home/modals/tab_modal_base.gd"

const SIDE_DUNGEONS := [
	{"id": 500201, "icon": "dungeon_wood", "reward": "목재 · 골드", "family": "자원 수집"},
	{"id": 500202, "icon": "dungeon_stone", "reward": "석재 · 목재", "family": "자원 수집"},
	{"id": 500206, "icon": "dungeon_companion", "reward": "동료 조각 · 영혼불", "family": "동료 흔적"},
]


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "탐험", "맵 선택 · 난이도 · 출격", Vector2(390, 590))
	sync_state()


func sync_state() -> void:
	if store == null or sanctuary == null:
		return
	setup_frame("탐험", "맵 선택 · 난이도 · 출격", size)
	clear_body()
	var entries: Array = _dungeon_entries()
	_render_map_strip(entries)
	_render_card_stack(entries)
	_render_selection_drawer(_selected_entry(entries))
	set_secondary_action("닫기", "close")
	set_primary_action("현재 출격", "sortie-current", false)


func _on_frame_action_requested(action: String) -> void:
	if action == "sortie-current":
		modal_action_requested.emit("sortie_map", {"map_id": int(sanctuary.current_map_id)})
		return
	super._on_frame_action_requested(action)


func _render_map_strip(entries: Array) -> void:
	var strip := _add_panel(body, Vector2(0, 0), Vector2(body.size.x, 78), Color(0.95, 0.82, 0.60, 0.92), Color(0.25, 0.16, 0.08, 0.68), 9)
	var route := ColorRect.new()
	route.color = Color(0.31, 0.22, 0.11, 0.35)
	route.position = Vector2(34, 34)
	route.size = Vector2(body.size.x - 68, 3)
	strip.add_child(route)

	var count: int = max(1, entries.size())
	for index in range(entries.size()):
		var entry: Dictionary = entries[index]
		var x := 34.0 + float(index) * ((body.size.x - 68.0) / float(max(1, count - 1)))
		_render_pin(strip, entry, index + 1, Vector2(x, 15))


func _render_pin(parent: Control, entry: Dictionary, index: int, pin_position: Vector2) -> void:
	var selected := bool(entry.get("selected", false))
	var unlocked := bool(entry.get("unlocked", false))
	var fill := Color(0.34, 0.24, 0.10, 0.98) if selected else Color(0.22, 0.14, 0.08, 0.94)
	if not unlocked:
		fill = Color(0.18, 0.15, 0.12, 0.76)
	var pin := _add_panel(parent, pin_position - Vector2(18, 2), Vector2(36, 42), fill, Color(0.88, 0.68, 0.34, 0.74), 9)
	_add_icon(pin, str(entry.get("icon", "home_tab_exploration")), Vector2(5, 3), Vector2(26, 26), str(index))
	_add_label(pin, Vector2(0, 28), Vector2(36, 12), str(index), 8, Color(1.0, 0.90, 0.60), HORIZONTAL_ALIGNMENT_CENTER)
	var button := _add_action_button(pin, Vector2(0, 0), Vector2(36, 42), "", "select_map", {"map_id": int(entry.get("id", 0))}, not unlocked)
	button.flat = true


func _render_card_stack(entries: Array) -> void:
	_add_label(body, Vector2(0, 88), Vector2(140, 18), "탐험 목록", 12, Color(0.17, 0.10, 0.05))
	var y := 110.0
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		_render_dungeon_row(entry, y)
		y += 44.0


func _render_dungeon_row(entry: Dictionary, y: float) -> void:
	var unlocked := bool(entry.get("unlocked", false))
	var selected := bool(entry.get("selected", false))
	var fill := Color(0.23, 0.15, 0.08, 0.91) if not selected else Color(0.34, 0.23, 0.11, 0.98)
	if not unlocked:
		fill = Color(0.19, 0.16, 0.12, 0.82)
	var row := _add_panel(body, Vector2(0, y), Vector2(body.size.x, 38), fill, Color(0.78, 0.60, 0.32, 0.72), 8)
	_add_icon(row, str(entry.get("icon", "home_tab_exploration")), Vector2(8, 4), Vector2(30, 30), "M")
	_add_label(row, Vector2(46, 4), Vector2(136, 16), str(entry.get("name", "맵")), 11, Color(1.0, 0.91, 0.70))
	_add_label(row, Vector2(46, 21), Vector2(168, 13), "%s · %s · %dW" % [str(entry.get("family", "")), str(entry.get("focus", "")), int(entry.get("wave_count", 1))], 8, Color(0.82, 0.74, 0.56))
	_add_label(row, Vector2(body.size.x - 142, 6), Vector2(78, 13), str(entry.get("reward", "")) if unlocked else str(entry.get("unlock", "")), 8, Color(0.66, 0.95, 0.58) if unlocked else Color(0.92, 0.58, 0.46), HORIZONTAL_ALIGNMENT_CENTER)
	_add_action_button(row, Vector2(body.size.x - 56, 5), Vector2(46, 28), "선택" if unlocked else "잠김", "select_map", {"map_id": int(entry.get("id", 0))}, not unlocked)


func _render_selection_drawer(entry: Dictionary) -> void:
	if entry.is_empty():
		return
	var drawer := _add_panel(body, Vector2(0, 294), Vector2(body.size.x, 150), Color(0.95, 0.82, 0.60, 0.94), Color(0.25, 0.16, 0.08, 0.70), 9)
	_add_icon(drawer, str(entry.get("icon", "home_tab_exploration")), Vector2(12, 12), Vector2(44, 44), "D")
	_add_label(drawer, Vector2(66, 11), Vector2(172, 20), str(entry.get("name", "탐험")), 15, Color(0.13, 0.08, 0.04))
	_add_label(drawer, Vector2(66, 35), Vector2(222, 16), "%s · %s · %dW" % [str(entry.get("focus", "")), str(entry.get("reward", "")), int(entry.get("wave_count", 1))], 10, Color(0.30, 0.20, 0.11))
	var y := 66.0
	for difficulty in _difficulty_entries(entry):
		_render_difficulty_row(drawer, difficulty, y)
		y += 24.0


func _render_difficulty_row(parent: Control, entry: Dictionary, y: float) -> void:
	var unlocked := bool(entry.get("unlocked", false))
	var selected := bool(entry.get("selected", false))
	var fill := Color(0.25, 0.16, 0.08, 0.92) if selected else Color(0.20, 0.13, 0.08, 0.86)
	if not unlocked:
		fill = Color(0.18, 0.15, 0.12, 0.70)
	var row := _add_panel(parent, Vector2(12, y), Vector2(parent.size.x - 24, 21), fill, Color(0.78, 0.60, 0.32, 0.52), 6)
	_add_label(row, Vector2(8, 3), Vector2(78, 13), str(entry.get("label", "초급")), 8, Color(1.0, 0.91, 0.70))
	_add_label(row, Vector2(88, 3), Vector2(138, 13), "%s · 보상 %s" % [str(entry.get("threat", "")), str(entry.get("reward_rate", ""))], 8, Color(0.82, 0.74, 0.56))
	_add_label(row, Vector2(parent.size.x - 82, 3), Vector2(48, 13), str(entry.get("badge", "")) if unlocked else str(entry.get("unlock", "")), 8, Color(0.66, 0.95, 0.58) if unlocked else Color(0.92, 0.58, 0.46), HORIZONTAL_ALIGNMENT_CENTER)


func _dungeon_entries() -> Array:
	var entries := []
	var map_def: Dictionary = store.get_map(int(sanctuary.current_map_id))
	if not map_def.is_empty():
		entries.append(_entry_from_map(map_def, "home_tab_exploration", "메인 정화", "자동 진행", _main_reward_text(int(map_def.get("id", 0)))))
	for side in SIDE_DUNGEONS:
		var side_map: Dictionary = store.get_map(int(side.get("id", 0)))
		if side_map.is_empty():
			continue
		entries.append(_entry_from_map(side_map, str(side.get("icon", "home_tab_exploration")), str(side.get("family", "자원 수집")), "파밍", str(side.get("reward", "보상"))))
	return entries


func _entry_from_map(map_def: Dictionary, icon_key: String, family: String, focus: String, reward: String) -> Dictionary:
	var map_id := int(map_def.get("id", 0))
	return {
		"id": map_id,
		"name": str(map_def.get("name", "맵")),
		"icon": icon_key,
		"family": family,
		"focus": focus,
		"reward": reward,
		"wave_count": store.map_wave_count(map_def),
		"unlocked": sanctuary.is_map_unlocked(map_id),
		"selected": map_id == int(sanctuary.current_map_id),
		"unlock": sanctuary.map_unlock_label(map_id),
	}


func _selected_entry(entries: Array) -> Dictionary:
	for entry in entries:
		if typeof(entry) == TYPE_DICTIONARY and bool(entry.get("selected", false)):
			return entry
	return entries[0] if not entries.is_empty() and typeof(entries[0]) == TYPE_DICTIONARY else {}


func _difficulty_entries(entry: Dictionary) -> Array:
	var map_id := int(entry.get("id", 0))
	var base_unlocked := bool(entry.get("unlocked", false))
	return [
		{"key": "easy", "label": "초급", "badge": "기본", "threat": "기본 편성", "reward_rate": "x1.0", "selected": true, "unlocked": base_unlocked, "unlock": sanctuary.map_unlock_label(map_id)},
		{"key": "normal", "label": "중급", "badge": "추천", "threat": "정예 추가", "reward_rate": "x1.25", "selected": false, "unlocked": base_unlocked and sanctuary.stage_clears >= 3, "unlock": "Stage 3"},
		{"key": "hard", "label": "상급", "badge": "도전", "threat": "고위험", "reward_rate": "x1.6", "selected": false, "unlocked": base_unlocked and sanctuary.stage_clears >= 6, "unlock": "Stage 6"},
	]


func _main_reward_text(map_id: int) -> String:
	if map_id <= 500102:
		return "목재 · 골드"
	if map_id <= 500104:
		return "석재 · 목재"
	if map_id <= 500106:
		return "영혼불"
	return "희귀 재료"
