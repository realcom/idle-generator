extends PanelContainer

signal sortie_requested

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")

var store
var housing
var sanctuary
var textures: Dictionary = {}
var built := false


func setup(content_store, housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	store = content_store
	housing = housing_store
	sanctuary = sanctuary_state
	textures = texture_table
	if not built:
		_build()
		built = true


func sync_state(active_tab: String) -> void:
	if not built:
		return
	visible = active_tab != "sanctuary"
	if not visible:
		return

	_clear()
	match active_tab:
		"equipment":
			_build_equipment()
		"exploration":
			_build_exploration()
		"missions":
			_build_missions()
		"shop":
			_build_shop()
		_:
			_build_empty(active_tab)


func _build() -> void:
	position = Vector2(14, 602)
	size = Vector2(306, 92)
	visible = false
	add_theme_stylebox_override("panel", HomeTheme.style(Color(0.90, 0.78, 0.58, 0.95), Color(0.20, 0.14, 0.08, 0.94), 9, 2))


func _build_equipment() -> void:
	_add_title("장비 세트", "수호자 기본 장비")
	var items: Array = store.get_equipment_sample(5) if store != null else []
	var x := 14.0
	for item in items:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		_add_icon_cell(Vector2(x, 42), _equipment_texture_key(item), str(item.get("name", "장비")))
		x += 47.0
	_add_value_badge(Vector2(238, 42), "전투력\n+18%")


func _build_exploration() -> void:
	_add_title(_current_map_name(), "다음 구간 %s" % sanctuary.stage_label())
	_add_line(Vector2(16, 43), "Wave 3 · 보상 골드/목재/석재")
	_add_line(Vector2(16, 62), "현재 기록 S%d · 생존 루프 준비" % int(sanctuary.stage_clears))

	var button := Button.new()
	button.text = "출격"
	button.position = Vector2(232, 18)
	button.size = Vector2(58, 56)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.70, 0.32, 0.08, 0.95), Color(1.0, 0.82, 0.36, 0.78), 8, 1))
	button.pressed.connect(func(): sortie_requested.emit())
	add_child(button)


func _build_missions() -> void:
	_add_title("임무", "오늘의 진행")
	var training_level := 1
	if sanctuary != null and sanctuary.placed_building_instances.has("training_yard#1"):
		var training_instance: Dictionary = sanctuary.placed_building_instances["training_yard#1"]
		training_level = int(training_instance.get("level", 1))
	_add_progress_row(Vector2(16, 42), "안개 정화", 2, 3)
	_add_progress_row(Vector2(16, 62), "훈련소 Lv.4", min(training_level, 4), 4)


func _build_shop() -> void:
	_add_title("상점", "ninja2 상품 슬롯")
	_add_shop_chip(Vector2(15, 42), "스타터팩", "₩ 준비")
	_add_shop_chip(Vector2(111, 42), "에너지", "무료")
	_add_shop_chip(Vector2(207, 42), "광고제거", "영구")


func _build_empty(tab_key: String) -> void:
	_add_title(tab_key, "준비 중")
	_add_line(Vector2(16, 48), "Godot Control 화면으로 분리됩니다.")


func _add_title(title: String, subtitle: String) -> void:
	var label := Label.new()
	label.text = title
	label.position = Vector2(14, 9)
	label.size = Vector2(170, 20)
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color(0.15, 0.10, 0.06))
	add_child(label)

	var sub := Label.new()
	sub.text = subtitle
	sub.position = Vector2(14, 27)
	sub.size = Vector2(190, 16)
	sub.add_theme_font_size_override("font_size", 10)
	sub.add_theme_color_override("font_color", Color(0.27, 0.19, 0.11))
	add_child(sub)


func _add_icon_cell(cell_position: Vector2, texture_key: String, tooltip: String) -> void:
	var panel := PanelContainer.new()
	panel.position = cell_position
	panel.size = Vector2(40, 40)
	panel.tooltip_text = tooltip
	panel.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.18, 0.12, 0.07, 0.88), Color(0.70, 0.52, 0.25, 0.72), 7, 1))
	add_child(panel)

	var icon := TextureRect.new()
	icon.texture = _texture(texture_key)
	icon.position = Vector2(5, 5)
	icon.size = Vector2(30, 30)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	panel.add_child(icon)


func _add_value_badge(badge_position: Vector2, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.position = badge_position
	label.size = Vector2(52, 38)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.13, 0.09, 0.05))
	label.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.98, 0.88, 0.58, 0.90), Color(0.24, 0.16, 0.08, 0.72), 8, 1))
	add_child(label)


func _add_line(line_position: Vector2, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.position = line_position
	label.size = Vector2(210, 18)
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.17, 0.12, 0.07))
	add_child(label)


func _add_progress_row(row_position: Vector2, label_text: String, value: int, target: int) -> void:
	var label := Label.new()
	label.text = "%s %d/%d" % [label_text, value, target]
	label.position = row_position
	label.size = Vector2(124, 16)
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.17, 0.12, 0.07))
	add_child(label)

	var bg := ColorRect.new()
	bg.color = Color(0.18, 0.12, 0.07, 0.78)
	bg.position = row_position + Vector2(132, 5)
	bg.size = Vector2(86, 7)
	add_child(bg)

	var fill := ColorRect.new()
	fill.color = Color(0.34, 0.77, 0.55)
	fill.position = bg.position
	fill.size = Vector2(86.0 * clamp(float(value) / max(1.0, float(target)), 0.0, 1.0), 7)
	add_child(fill)


func _add_shop_chip(chip_position: Vector2, title: String, price: String) -> void:
	var panel := PanelContainer.new()
	panel.position = chip_position
	panel.size = Vector2(84, 38)
	panel.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.18, 0.12, 0.07, 0.88), Color(0.73, 0.52, 0.24, 0.76), 7, 1))
	add_child(panel)

	var title_label := Label.new()
	title_label.text = title
	title_label.position = Vector2(4, 3)
	title_label.size = Vector2(76, 16)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 10)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.89, 0.62))
	panel.add_child(title_label)

	var price_label := Label.new()
	price_label.text = price
	price_label.position = Vector2(4, 19)
	price_label.size = Vector2(76, 14)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price_label.add_theme_font_size_override("font_size", 9)
	price_label.add_theme_color_override("font_color", Color(0.77, 0.96, 0.68))
	panel.add_child(price_label)


func _equipment_texture_key(item: Dictionary) -> String:
	var item_type := str(item.get("type", ""))
	if item_type == "":
		item_type = str(item.get("equipmentType", ""))
	if item_type == "":
		item_type = str(item.get("slot", ""))
	if textures.has("equip_%s" % item_type):
		return "equip_%s" % item_type
	return "equip_Weapon"


func _current_map_name() -> String:
	if store == null or sanctuary == null:
		return "대나무 영지"
	var map_def: Dictionary = store.get_map(int(sanctuary.current_map_id))
	return str(map_def.get("name", "대나무 영지"))


func _clear() -> void:
	for child in get_children():
		child.queue_free()


func _texture(key: String) -> Texture2D:
	return textures.get(key)
