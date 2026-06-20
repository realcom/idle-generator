extends "res://scripts/home/modals/tab_modal_base.gd"


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	setup_context(content_store, housing_store, sanctuary_state, texture_table, "성소 관리", "건물 · 생산 · 확장", Vector2(390, 560))
	sync_state()


func sync_state() -> void:
	if sanctuary == null or housing == null:
		return
	setup_frame("성소 관리", "건물 · 생산 · 확장", size)
	clear_body()
	_render_summary()
	_render_selected_panel()
	_render_buildings()
	set_secondary_action("닫기", "close")
	set_primary_action("선택 건물", "selected-building", sanctuary.selected_instance().is_empty())


func _on_frame_action_requested(action: String) -> void:
	if action == "selected-building":
		var instance: Dictionary = sanctuary.selected_instance()
		if not instance.is_empty():
			modal_action_requested.emit("building_detail", {"instance_id": str(instance.get("id", ""))})
		return
	super._on_frame_action_requested(action)


func _render_summary() -> void:
	var panel := _add_panel(body, Vector2(0, 0), Vector2(body.size.x, 68), Color(0.96, 0.84, 0.62, 0.92), Color(0.24, 0.16, 0.08, 0.70), 9)
	_add_label(panel, Vector2(12, 8), Vector2(150, 20), "성소 Lv.%d" % int(sanctuary.shrine_level), 15, Color(0.13, 0.08, 0.04))
	_add_label(panel, Vector2(12, 31), Vector2(150, 16), "주민 %d/%d" % [int(sanctuary.residents), int(sanctuary.resident_capacity)], 10, Color(0.28, 0.19, 0.10))
	_add_progress(panel, Vector2(12, 53), Vector2(134, 8), float(sanctuary.shrine_light) / max(1.0, float(sanctuary.shrine_light_need)), Color(0.38, 0.78, 0.54))

	var chips := [
		["wood", "목재"],
		["stone", "석재"],
		["soul", "영혼불"],
		["gold", "골드"],
	]
	var x := 156.0
	for chip in chips:
		var key := str(chip[0])
		var label := str(chip[1])
		_add_label(panel, Vector2(x, 10), Vector2(46, 18), label, 9, Color(0.32, 0.22, 0.12), HORIZONTAL_ALIGNMENT_CENTER)
		_add_label(panel, Vector2(x, 29), Vector2(46, 20), sanctuary.format_resource(key), 12, Color(0.13, 0.08, 0.04), HORIZONTAL_ALIGNMENT_CENTER)
		_add_label(panel, Vector2(x, 49), Vector2(46, 14), sanctuary.format_rate(key), 9, Color(0.16, 0.36, 0.18), HORIZONTAL_ALIGNMENT_CENTER)
		x += 48.0


func _render_selected_panel() -> void:
	var building: Dictionary = sanctuary.selected_building(housing)
	var instance: Dictionary = sanctuary.selected_instance()
	var panel := _add_panel(body, Vector2(0, 80), Vector2(body.size.x, 86), Color(0.95, 0.82, 0.60, 0.94), Color(0.25, 0.16, 0.08, 0.70), 9)
	if building.is_empty() or instance.is_empty():
		_add_label(panel, Vector2(12, 18), Vector2(body.size.x - 24, 38), "지도에서 건물을 선택하세요.", 12, Color(0.28, 0.19, 0.10), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)
		return

	var status := str(instance.get("status", "built"))
	var level := int(instance.get("level", 1))
	var texture_key: String = housing.building_texture_key(building, instance)
	var upgrade_info: Dictionary = sanctuary.selected_upgrade_info(housing)
	var max_level: int = max(1, housing.max_level(building))
	_add_icon(panel, texture_key, Vector2(10, 10), Vector2(58, 58), "B")
	_add_label(panel, Vector2(78, 9), Vector2(162, 20), "%s Lv.%d" % [str(building.get("name", "건물")), level], 14, Color(0.13, 0.08, 0.04))
	_add_label(panel, Vector2(78, 31), Vector2(184, 15), _selected_status_text(building, level, status, upgrade_info), 9, Color(0.30, 0.20, 0.11))
	var progress: float = housing.construction_progress(instance) if status == "constructing" else float(level) / float(max_level)
	_add_progress(panel, Vector2(78, 53), Vector2(130, 8), progress, Color(0.36, 0.80, 0.54))
	_add_label(panel, Vector2(214, 50), Vector2(74, 14), "%d/%d" % [level, max_level], 8, Color(0.24, 0.16, 0.08), HORIZONTAL_ALIGNMENT_CENTER)

	var effect: String = housing.primary_effect_label(building, level)
	var production: String = housing.production_rate_label(building, level)
	_add_label(panel, Vector2(body.size.x - 100, 12), Vector2(88, 15), effect if effect != "" else "기능", 8, Color(0.18, 0.36, 0.18), HORIZONTAL_ALIGNMENT_CENTER)
	_add_label(panel, Vector2(body.size.x - 100, 31), Vector2(88, 14), production if production != "" else _selected_action_chip(upgrade_info), 8, Color(0.18, 0.36, 0.18), HORIZONTAL_ALIGNMENT_CENTER)
	_add_action_button(panel, Vector2(body.size.x - 74, 50), Vector2(62, 28), "상세", "building_detail", {"instance_id": str(instance.get("id", ""))})


func _render_buildings() -> void:
	var entries: Array = sanctuary.building_entries(housing)
	_add_label(body, Vector2(0, 182), Vector2(180, 18), "보유 건물", 12, Color(0.17, 0.10, 0.05))
	_add_label(body, Vector2(body.size.x - 74, 182), Vector2(74, 18), "%d개" % entries.size(), 10, Color(0.30, 0.20, 0.11), HORIZONTAL_ALIGNMENT_RIGHT)
	var y := 204.0
	var rendered := 0
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if rendered >= 4:
			break
		_render_building_row(entry, y)
		y += 48.0
		rendered += 1
	if rendered == 0:
		_add_label(body, Vector2(0, 216), Vector2(body.size.x, 40), "운영 중인 건물이 없습니다.", 12, Color(0.28, 0.19, 0.10), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)


func _render_building_row(entry: Dictionary, y: float) -> void:
	var building: Dictionary = entry.get("building", {})
	var instance: Dictionary = entry.get("instance", {})
	var status := str(instance.get("status", "built"))
	var level := int(instance.get("level", 1))
	var selected := str(instance.get("id", "")) == str(sanctuary.selected_building_instance_id)
	var fill := Color(0.23, 0.15, 0.08, 0.90) if not selected else Color(0.30, 0.20, 0.09, 0.96)
	var row := _add_panel(body, Vector2(0, y), Vector2(body.size.x, 42), fill, Color(0.82, 0.64, 0.34, 0.72), 8)
	var texture_key: String = housing.building_texture_key(building, instance)
	_add_icon(row, texture_key, Vector2(8, 5), Vector2(32, 32), "B")
	_add_label(row, Vector2(48, 5), Vector2(150, 16), "%s Lv.%d" % [str(building.get("name", "건물")), level], 11, Color(1.0, 0.91, 0.70))
	_add_label(row, Vector2(48, 23), Vector2(180, 13), _building_status_text(building, level, status, instance), 8, Color(0.83, 0.74, 0.55))
	_add_action_button(row, Vector2(body.size.x - 66, 7), Vector2(54, 28), "상세", "building_detail", {"instance_id": str(instance.get("id", ""))})


func _building_status_text(building: Dictionary, level: int, status: String, instance: Dictionary) -> String:
	if status == "constructing":
		return "건설 중 · %s" % housing.construction_percent_label(instance)
	var production: String = housing.production_rate_label(building, level)
	if production != "":
		return "생산 %s" % production
	var effect: String = housing.primary_effect_label(building, level)
	return effect if effect != "" else "운영 중"


func _selected_status_text(building: Dictionary, level: int, status: String, upgrade_info: Dictionary) -> String:
	if status == "constructing":
		return "건설 마무리 대기 · %s" % housing.construction_percent_label(sanctuary.selected_instance())
	if not bool(upgrade_info.get("available", false)):
		return "최대 성장 · %s" % str(building.get("output", "성소"))
	return "강화 비용 · %s" % _short_cost_label(str(upgrade_info.get("cost_label", "무료")))


func _selected_action_chip(upgrade_info: Dictionary) -> String:
	if bool(upgrade_info.get("available", false)):
		return "강화 가능"
	return str(upgrade_info.get("cost_label", "확인"))


func _short_cost_label(cost_label: String) -> String:
	var parts := cost_label.split(" · ", false, 1)
	return str(parts[0]) if parts.size() > 0 else cost_label
