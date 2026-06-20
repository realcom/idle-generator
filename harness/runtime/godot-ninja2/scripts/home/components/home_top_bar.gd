extends Control

signal menu_requested
signal settings_requested

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")
const HOME_RESOURCE_KEYS := ["wood", "soul", "gold", "stone"]

var store
var sanctuary
var textures: Dictionary = {}
var status_label: Label
var shrine_level_label: Label
var resident_label: Label
var light_label: Label
var light_fill: ColorRect
var resource_labels: Dictionary = {}
var resource_rate_labels: Dictionary = {}
var built := false


func setup(content_store, sanctuary_state, texture_table: Dictionary) -> void:
	store = content_store
	sanctuary = sanctuary_state
	textures = texture_table
	if not built:
		_build()
		built = true
	sync_state()


func sync_state() -> void:
	if not built or sanctuary == null:
		return
	for key in HOME_RESOURCE_KEYS:
		if resource_labels.has(key):
			resource_labels[key].text = sanctuary.format_resource(key)
		if resource_rate_labels.has(key):
			resource_rate_labels[key].text = sanctuary.format_rate(key)

	shrine_level_label.text = str(sanctuary.shrine_level)
	resident_label.text = "%d/%d" % [int(sanctuary.residents), int(sanctuary.resident_capacity)]
	light_label.text = "%d / %d" % [int(sanctuary.shrine_light), int(sanctuary.shrine_light_need)]
	light_fill.size.x = 68.0 * clamp(float(sanctuary.shrine_light) / max(1.0, float(sanctuary.shrine_light_need)), 0.0, 1.0)
	status_label.text = "%s · %s" % [_current_map_name(), sanctuary.stage_label()]


func _build() -> void:
	position = Vector2.ZERO
	size = Vector2(440, 96)

	var portrait_box := Control.new()
	portrait_box.position = Vector2(4, 6)
	portrait_box.size = Vector2(74, 84)
	add_child(portrait_box)

	var portrait_shadow := PanelContainer.new()
	portrait_shadow.position = Vector2(4, 3)
	portrait_shadow.size = Vector2(64, 64)
	portrait_shadow.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.02, 0.05, 0.03, 0.58), Color(0.02, 0.03, 0.02, 0.0), 32, 0))
	portrait_box.add_child(portrait_shadow)

	var portrait_frame := PanelContainer.new()
	portrait_frame.position = Vector2(2, 0)
	portrait_frame.size = Vector2(64, 64)
	portrait_frame.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.30, 0.21, 0.12, 0.94), Color(0.95, 0.74, 0.38, 0.96), 32, 3))
	portrait_box.add_child(portrait_frame)

	var face := TextureRect.new()
	face.texture = HomeTheme.scaled_texture(_texture("home_profile"), Vector2i(58, 58))
	face.position = Vector2(5, 2)
	face.size = Vector2(58, 58)
	face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	face.stretch_mode = TextureRect.STRETCH_SCALE
	portrait_box.add_child(face)

	shrine_level_label = Label.new()
	shrine_level_label.position = Vector2(0, 52)
	shrine_level_label.size = Vector2(28, 22)
	shrine_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shrine_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	shrine_level_label.add_theme_font_size_override("font_size", 15)
	shrine_level_label.add_theme_color_override("font_color", Color(1.0, 0.94, 0.65))
	shrine_level_label.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.19, 0.13, 0.07, 0.92), Color(0.98, 0.77, 0.36, 0.92), 12, 2))
	portrait_box.add_child(shrine_level_label)

	var hp_bg := ColorRect.new()
	hp_bg.color = Color(0.12, 0.12, 0.07, 0.86)
	hp_bg.position = Vector2(32, 74)
	hp_bg.size = Vector2(42, 8)
	add_child(hp_bg)

	var hp_fill := ColorRect.new()
	hp_fill.color = Color(0.55, 0.9, 0.23)
	hp_fill.position = hp_bg.position
	hp_fill.size = Vector2(36, 8)
	add_child(hp_fill)

	var resource_x := 80.0
	for key in HOME_RESOURCE_KEYS:
		_add_resource_chip(key, Vector2(resource_x, 8), Vector2(80, 31))
		resource_x += 80.0

	_add_population_chip()
	_add_top_icon("home_icon_menu", Vector2(346, 48), "메뉴", "menu")
	_add_top_icon("home_icon_settings", Vector2(392, 48), "설정", "settings")

	status_label = Label.new()
	status_label.position = Vector2(94, 48)
	status_label.size = Vector2(136, 22)
	status_label.add_theme_font_size_override("font_size", 11)
	status_label.add_theme_color_override("font_color", Color(0.88, 0.97, 0.72))
	add_child(status_label)

	var light_box := Control.new()
	light_box.position = Vector2(92, 70)
	light_box.size = Vector2(146, 20)
	add_child(light_box)

	light_label = Label.new()
	light_label.position = Vector2.ZERO
	light_label.size = Vector2(70, 18)
	light_label.add_theme_font_size_override("font_size", 10)
	light_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.58))
	light_box.add_child(light_label)

	var light_bg := ColorRect.new()
	light_bg.color = Color(0.08, 0.12, 0.08, 0.8)
	light_bg.position = Vector2(72, 6)
	light_bg.size = Vector2(68, 7)
	light_box.add_child(light_bg)

	light_fill = ColorRect.new()
	light_fill.color = Color(0.64, 0.86, 0.36)
	light_fill.position = light_bg.position
	light_fill.size = light_bg.size
	light_box.add_child(light_fill)


func _add_resource_chip(key: String, chip_position: Vector2, chip_size: Vector2) -> void:
	var chip := Control.new()
	chip.position = chip_position
	chip.size = chip_size
	add_child(chip)

	var skin := TextureRect.new()
	skin.texture = HomeTheme.scaled_texture(_texture("home_resource_chip"), Vector2i(int(chip_size.x), int(chip_size.y)))
	skin.position = Vector2.ZERO
	skin.size = chip_size
	skin.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	skin.stretch_mode = TextureRect.STRETCH_SCALE
	chip.add_child(skin)

	var row := HBoxContainer.new()
	row.position = Vector2(5, 4)
	row.size = chip_size - Vector2(10, 6)
	row.add_theme_constant_override("separation", 2)
	chip.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _texture("res_%s" % key)
	icon.custom_minimum_size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", -3)
	row.add_child(text_box)

	var value := Label.new()
	value.add_theme_font_size_override("font_size", 13)
	value.add_theme_color_override("font_color", Color(1.0, 0.95, 0.75))
	value.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	value.add_theme_constant_override("shadow_offset_x", 1)
	value.add_theme_constant_override("shadow_offset_y", 1)
	text_box.add_child(value)
	resource_labels[key] = value

	var rate := Label.new()
	rate.add_theme_font_size_override("font_size", 8)
	rate.add_theme_color_override("font_color", Color(0.74, 0.96, 0.71))
	text_box.add_child(rate)
	resource_rate_labels[key] = rate


func _add_population_chip() -> void:
	var chip := PanelContainer.new()
	chip.position = Vector2(238, 48)
	chip.size = Vector2(96, 28)
	chip.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.14, 0.09, 0.055, 0.86), Color(0.76, 0.52, 0.30, 0.82), 9, 1))
	add_child(chip)

	var row := HBoxContainer.new()
	row.position = Vector2(7, 3)
	row.size = Vector2(82, 22)
	chip.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _texture("home_icon_population")
	icon.custom_minimum_size = Vector2(20, 20)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	resident_label = Label.new()
	resident_label.add_theme_font_size_override("font_size", 13)
	resident_label.add_theme_color_override("font_color", Color(1.0, 0.91, 0.68))
	row.add_child(resident_label)


func _add_top_icon(texture_key: String, icon_position: Vector2, tooltip: String, action_key: String) -> void:
	var panel := PanelContainer.new()
	panel.position = icon_position
	panel.size = Vector2(38, 34)
	panel.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.17, 0.11, 0.06, 0.82), Color(0.76, 0.54, 0.34, 0.7), 9, 1))
	add_child(panel)

	var icon := TextureRect.new()
	icon.texture = _texture(texture_key)
	icon.position = Vector2(8, 6)
	icon.size = Vector2(22, 22)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	panel.add_child(icon)

	var button := Button.new()
	button.position = Vector2.ZERO
	button.size = panel.size
	button.flat = true
	button.tooltip_text = tooltip
	button.focus_mode = Control.FOCUS_NONE
	panel.add_child(button)
	match action_key:
		"menu":
			button.pressed.connect(func(): menu_requested.emit())
		"settings":
			button.pressed.connect(func(): settings_requested.emit())


func _current_map_name() -> String:
	if store == null or sanctuary == null:
		return "대나무 영지"
	var map_def: Dictionary = store.get_map(int(sanctuary.current_map_id))
	return str(map_def.get("name", "대나무 영지"))


func _texture(key: String) -> Texture2D:
	return textures.get(key)
