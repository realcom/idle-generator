extends PanelContainer

signal details_requested(instance_id: String)
signal action_requested(instance_id: String, action: String)

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")

var housing
var sanctuary
var textures: Dictionary = {}
var selected_icon: TextureRect
var selected_title: Label
var selected_subtitle: Label
var selected_effect: Label
var selected_rate: Label
var progress_fill: ColorRect
var action_button: Button
var info_button: Button
var built := false


func setup(housing_store, sanctuary_state, texture_table: Dictionary) -> void:
	housing = housing_store
	sanctuary = sanctuary_state
	textures = texture_table
	if not built:
		_build()
		built = true
	sync_state()


func sync_state() -> void:
	if not built or sanctuary == null or housing == null:
		return
	var building: Dictionary = sanctuary.selected_building(housing)
	if building.is_empty():
		return

	var level: int = sanctuary.selected_building_level()
	var status: String = sanctuary.selected_building_status()
	var instance: Dictionary = sanctuary.selected_instance()
	var upgrade_info: Dictionary = sanctuary.selected_upgrade_info(housing)
	var max_level: int = max(1, housing.max_level(building))

	selected_icon.texture = _texture(housing.building_texture_key(building, instance))
	selected_title.text = "%s Lv.%d" % [str(building.get("name", "건물")), level]
	if str(upgrade_info.get("action", "")) == "max":
		selected_subtitle.text = "최대 성장 · %s" % str(building.get("output", "성소"))
	elif str(upgrade_info.get("action", "")) == "finish":
		selected_subtitle.text = "건설 마무리 · %s" % str(building.get("output", "성소"))
	else:
		selected_subtitle.text = "강화 비용 · %s" % str(upgrade_info.get("cost_label", ""))
	selected_effect.text = housing.primary_effect_label(building, level)
	selected_rate.text = housing.production_rate_label(building, level)
	selected_rate.visible = selected_rate.text != ""
	selected_effect.size.x = 136.0 if selected_rate.text == "" else 78.0
	var progress: float = housing.construction_progress(instance) if status == "constructing" else clamp(float(level) / float(max_level), 0.0, 1.0)
	progress_fill.size.x = 128.0 * progress

	var action := str(upgrade_info.get("action", ""))
	action_button.set_meta("action", action)
	action_button.disabled = action == "max"
	action_button.tooltip_text = str(upgrade_info.get("cost_label", ""))
	if action == "finish":
		action_button.text = "완료"
	elif action == "max":
		action_button.text = "최대"
	elif bool(upgrade_info.get("can_afford", false)):
		action_button.text = "강화"
	else:
		action_button.text = "부족"


func _build() -> void:
	position = Vector2(6, 588)
	size = Vector2(322, 108)
	add_theme_stylebox_override("panel", HomeTheme.style(Color(0.91, 0.80, 0.60, 0.97), Color(0.12, 0.16, 0.12, 0.98), 12, 3))

	var root := Control.new()
	root.size = size
	add_child(root)

	var icon_frame := PanelContainer.new()
	icon_frame.position = Vector2(10, 19)
	icon_frame.size = Vector2(62, 62)
	icon_frame.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.38, 0.45, 0.28, 0.86), Color(0.10, 0.13, 0.09, 0.92), 10, 2))
	root.add_child(icon_frame)

	selected_icon = TextureRect.new()
	selected_icon.position = Vector2(4, 4)
	selected_icon.size = Vector2(54, 54)
	selected_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	selected_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_frame.add_child(selected_icon)

	selected_title = Label.new()
	selected_title.position = Vector2(82, 12)
	selected_title.size = Vector2(142, 20)
	selected_title.add_theme_font_size_override("font_size", 14)
	selected_title.add_theme_color_override("font_color", Color(0.15, 0.10, 0.06))
	root.add_child(selected_title)

	selected_subtitle = Label.new()
	selected_subtitle.position = Vector2(82, 31)
	selected_subtitle.size = Vector2(154, 16)
	selected_subtitle.add_theme_font_size_override("font_size", 10)
	selected_subtitle.add_theme_color_override("font_color", Color(0.24, 0.18, 0.12))
	root.add_child(selected_subtitle)

	var progress_bg := ColorRect.new()
	progress_bg.color = Color(0.18, 0.12, 0.07, 0.84)
	progress_bg.position = Vector2(82, 52)
	progress_bg.size = Vector2(128, 7)
	root.add_child(progress_bg)

	progress_fill = ColorRect.new()
	progress_fill.color = Color(0.34, 0.87, 0.62)
	progress_fill.position = progress_bg.position
	progress_fill.size = Vector2(72, 7)
	root.add_child(progress_fill)

	selected_effect = Label.new()
	selected_effect.position = Vector2(82, 68)
	selected_effect.size = Vector2(78, 20)
	selected_effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selected_effect.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	selected_effect.add_theme_font_size_override("font_size", 9)
	selected_effect.add_theme_color_override("font_color", Color(0.13, 0.18, 0.09))
	selected_effect.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.70, 0.62, 0.42, 0.34), Color(0.20, 0.14, 0.08, 0.32), 8, 1))
	root.add_child(selected_effect)

	selected_rate = Label.new()
	selected_rate.position = Vector2(166, 68)
	selected_rate.size = Vector2(58, 20)
	selected_rate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selected_rate.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	selected_rate.add_theme_font_size_override("font_size", 9)
	selected_rate.add_theme_color_override("font_color", Color(0.13, 0.18, 0.09))
	selected_rate.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.70, 0.62, 0.42, 0.34), Color(0.20, 0.14, 0.08, 0.32), 8, 1))
	root.add_child(selected_rate)

	action_button = Button.new()
	action_button.text = "강화"
	action_button.position = Vector2(238, 13)
	action_button.size = Vector2(68, 48)
	action_button.focus_mode = Control.FOCUS_NONE
	action_button.add_theme_font_size_override("font_size", 13)
	action_button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.42, 0.64, 0.25, 0.96), Color(0.16, 0.18, 0.10, 0.92), 10, 2))
	action_button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.55, 0.76, 0.28, 0.98), Color(0.98, 0.86, 0.40, 0.90), 10, 2))
	action_button.add_theme_stylebox_override("disabled", HomeTheme.style(Color(0.24, 0.20, 0.16, 0.84), Color(0.56, 0.48, 0.36, 0.52), 10, 2))
	action_button.pressed.connect(_request_action)
	root.add_child(action_button)

	info_button = Button.new()
	info_button.text = "상세"
	info_button.position = Vector2(246, 67)
	info_button.size = Vector2(52, 26)
	info_button.focus_mode = Control.FOCUS_NONE
	info_button.tooltip_text = "상세"
	info_button.add_theme_font_size_override("font_size", 10)
	info_button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.38, 0.32, 0.22, 0.92), Color(0.96, 0.82, 0.52, 0.62), 8, 1))
	info_button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.48, 0.36, 0.20, 0.95), Color(1.0, 0.88, 0.58, 0.8), 8, 1))
	info_button.pressed.connect(_request_details)
	root.add_child(info_button)


func _request_action() -> void:
	if sanctuary == null:
		return
	var instance: Dictionary = sanctuary.selected_instance()
	action_requested.emit(str(instance.get("id", "")), str(action_button.get_meta("action", "")))


func _request_details() -> void:
	if sanctuary == null:
		return
	var instance: Dictionary = sanctuary.selected_instance()
	details_requested.emit(str(instance.get("id", "")))


func _texture(key: String) -> Texture2D:
	return textures.get(key)
