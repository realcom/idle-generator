extends "res://scripts/home/modals/base_modal.gd"

signal building_action_requested(instance_id: String, action: String)

var housing
var sanctuary
var textures: Dictionary = {}
var actions_connected := false
var ornaments_added := false


func setup(housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	housing = housing_store
	sanctuary = sanctuary_state
	textures = texture_table
	setup_frame("건물 관리", "성소 건물 상세", Vector2(372, 456))
	if not ornaments_added:
		_add_frame_crest()
		ornaments_added = true
	if not actions_connected:
		action_requested.connect(_on_action_requested)
		actions_connected = true
	sync_state()


func sync_state() -> void:
	if housing == null or sanctuary == null:
		return

	var building: Dictionary = sanctuary.selected_building(housing)
	var instance: Dictionary = sanctuary.selected_instance()
	if building.is_empty() or instance.is_empty():
		setup_frame("건물 관리", "선택된 건물이 없습니다.", size)
		clear_body()
		set_primary_action("닫기", "close")
		return

	var level: int = sanctuary.selected_building_level()
	var status: String = sanctuary.selected_building_status()
	var upgrade_info: Dictionary = sanctuary.selected_upgrade_info(housing)
	setup_frame(str(building.get("name", "건물")), "Lv.%d · %s" % [level, str(building.get("output", "성소"))], size)
	clear_body()

	_add_header(building, instance, level, status)
	_add_effects(building, level, upgrade_info)
	_add_cost_block(upgrade_info)
	_sync_actions(upgrade_info)


func _add_header(building: Dictionary, instance: Dictionary, level: int, status: String) -> void:
	var icon_texture: Texture2D = _texture(housing.building_texture_key(building, instance))
	var icon := TextureRect.new()
	icon.texture = HomeTheme.scaled_texture(icon_texture, Vector2i(82, 82))
	icon.position = Vector2(0, 0)
	icon.size = Vector2(82, 82)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_SCALE
	body.add_child(icon)

	var name_label := Label.new()
	name_label.text = "%s Lv.%d" % [str(building.get("name", "건물")), level]
	name_label.position = Vector2(92, 5)
	name_label.size = Vector2(220, 22)
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.add_theme_color_override("font_color", Color(0.13, 0.08, 0.04))
	body.add_child(name_label)

	var status_label := Label.new()
	status_label.text = "상태 · %s" % ("건설 중 %s" % housing.construction_percent_label(instance) if status == "constructing" else "운영 중")
	status_label.position = Vector2(92, 30)
	status_label.size = Vector2(220, 18)
	status_label.add_theme_font_size_override("font_size", 11)
	status_label.add_theme_color_override("font_color", Color(0.30, 0.20, 0.11))
	body.add_child(status_label)

	var progress_bg := ColorRect.new()
	progress_bg.color = Color(0.18, 0.12, 0.07, 0.82)
	progress_bg.position = Vector2(92, 58)
	progress_bg.size = Vector2(180, 8)
	body.add_child(progress_bg)

	var fill := ColorRect.new()
	fill.color = Color(0.34, 0.84, 0.58)
	fill.position = progress_bg.position
	var progress: float = housing.construction_progress(instance) if status == "constructing" else clamp(float(level) / max(1.0, float(housing.max_level(building))), 0.0, 1.0)
	fill.size = Vector2(180.0 * progress, 8)
	body.add_child(fill)


func _add_effects(building: Dictionary, level: int, upgrade_info: Dictionary) -> void:
	_add_section_label(Vector2(0, 98), "현재 효과")
	_add_info_pill(Vector2(0, 122), housing.primary_effect_label(building, level), Color(0.20, 0.14, 0.08, 0.90))
	var production: String = housing.production_rate_label(building, level)
	if production != "":
		_add_info_pill(Vector2(172, 122), "생산 %s" % production, Color(0.14, 0.18, 0.10, 0.90))

	var action := str(upgrade_info.get("action", ""))
	_add_section_label(Vector2(0, 170), "다음 단계")
	if action == "upgrade":
		var next_level := int(upgrade_info.get("next_level", level + 1))
		_add_info_pill(Vector2(0, 194), housing.primary_effect_label(building, next_level), Color(0.28, 0.16, 0.08, 0.92))
		var next_production: String = housing.production_rate_label(building, next_level)
		if next_production != "":
			_add_info_pill(Vector2(172, 194), "생산 %s" % next_production, Color(0.14, 0.20, 0.11, 0.92))
	elif action == "finish":
		_add_info_pill(Vector2(0, 194), "건설을 완료하고 생산을 시작합니다.", Color(0.28, 0.16, 0.08, 0.92))
	else:
		_add_info_pill(Vector2(0, 194), "최대 레벨에 도달했습니다.", Color(0.20, 0.14, 0.08, 0.90))


func _add_cost_block(upgrade_info: Dictionary) -> void:
	_add_section_label(Vector2(0, 242), "필요 자원")
	var action := str(upgrade_info.get("action", ""))
	if action == "finish":
		_add_info_pill(Vector2(0, 266), "대기 중인 건설을 즉시 완료", Color(0.16, 0.20, 0.12, 0.92))
		return
	if action == "max":
		_add_info_pill(Vector2(0, 266), "추가 비용 없음", Color(0.20, 0.14, 0.08, 0.90))
		return

	var cost: Dictionary = upgrade_info.get("cost", {})
	var x := 0.0
	var y := 266.0
	for key in cost.keys():
		_add_cost_chip(Vector2(x, y), str(key), int(cost[key]))
		x += 82.0
		if x > 250.0:
			x = 0.0
			y += 34.0

	if not bool(upgrade_info.get("can_afford", false)):
		_add_info_pill(Vector2(0, 320), "부족 · %s" % str(upgrade_info.get("missing_label", "")), Color(0.38, 0.10, 0.06, 0.90))


func _sync_actions(upgrade_info: Dictionary) -> void:
	var action := str(upgrade_info.get("action", ""))
	set_secondary_action("닫기", "close")
	if action == "finish":
		set_primary_action("완료", "confirm", false)
	elif action == "max":
		set_primary_action("최대 레벨", "confirm", true)
	elif bool(upgrade_info.get("can_afford", false)):
		set_primary_action("강화", "confirm", false)
	else:
		set_primary_action("재료 부족", "confirm", true)


func _add_section_label(label_position: Vector2, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.position = label_position
	label.size = Vector2(180, 18)
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.17, 0.10, 0.05))
	body.add_child(label)


func _add_info_pill(pill_position: Vector2, text: String, color: Color) -> void:
	if text == "":
		text = "효과 없음"
	var label := Label.new()
	label.text = text
	label.position = pill_position
	label.size = Vector2(160, 28)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.72))
	label.add_theme_stylebox_override("normal", HomeTheme.style(color, Color(0.76, 0.56, 0.28, 0.58), 8, 1))
	body.add_child(label)


func _add_cost_chip(chip_position: Vector2, key: String, amount: int) -> void:
	var resource_key := "soul" if key == "soulflame" else key
	var have := int(sanctuary.resources.get(resource_key, 0))
	var label := Label.new()
	label.text = "%s\n%d/%d" % [housing.resource_name(key), have, amount]
	label.position = chip_position
	label.size = Vector2(76, 30)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", Color(0.13, 0.08, 0.04))
	label.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.98, 0.88, 0.62, 0.90), Color(0.24, 0.16, 0.08, 0.72), 7, 1))
	body.add_child(label)


func _on_action_requested(action: String) -> void:
	if action != "confirm":
		return
	var instance: Dictionary = sanctuary.selected_instance()
	building_action_requested.emit(str(instance.get("id", "")), "upgrade")


func _add_frame_crest() -> void:
	var texture: Texture2D = _texture("home_modal_crest")
	if texture == null or frame_root == null:
		return
	var crest := TextureRect.new()
	crest.texture = HomeTheme.scaled_texture(texture, Vector2i(108, 60))
	crest.position = Vector2(size.x * 0.5 - 54.0, -32.0)
	crest.size = Vector2(108, 60)
	crest.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	crest.stretch_mode = TextureRect.STRETCH_SCALE
	crest.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame_root.add_child(crest)
	frame_root.move_child(crest, 0)


func _texture(key: String) -> Texture2D:
	return textures.get(key)
