extends Control

signal close_requested

const PortalMapCanvas := preload("res://scripts/ui/portal_map_canvas.gd")

const DEFAULT_SIZE := Vector2(420.0, 500.0)
const FRAME_TEXTURE := "res://assets/generated/ui/window_frame_9slice.png"
const INNER_TEXTURE := "res://assets/generated/ui/dark_inner_well_9slice.png"
const CLOSE_TEXTURE := "res://assets/generated/ui/close_icon.png"
const TAB_TEXTURE := "res://assets/generated/ui/tab_burgundy_9slice.png"

var frame_texture: Texture2D
var inner_texture: Texture2D
var close_texture: Texture2D
var tab_texture: Texture2D
var map_canvas: Control
var region_label: Label
var stage_buttons: Array[Button] = []
var act_buttons: Array[Button] = []
var selected_act := 1
var current_stage := 1
var current_map_name := "작업표시줄 동굴"


func _ready() -> void:
	size = DEFAULT_SIZE
	custom_minimum_size = DEFAULT_SIZE
	mouse_filter = Control.MOUSE_FILTER_STOP
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_load_textures()
	_build_window()
	_sync_stage_state()


func set_snapshot(snapshot: Dictionary) -> void:
	var map_id := int(snapshot.get("map_id", 500101))
	current_map_name = str(snapshot.get("map_name", current_map_name))
	var linear_index := maxi(0, map_id - 500101)
	selected_act = int(floor(float(linear_index) / 10.0)) + 1
	current_stage = int(linear_index % 10) + 1
	_sync_stage_state()


func _load_textures() -> void:
	frame_texture = _load_texture(FRAME_TEXTURE)
	inner_texture = _load_texture(INNER_TEXTURE)
	close_texture = _load_texture(CLOSE_TEXTURE)
	tab_texture = _load_texture(TAB_TEXTURE)


func _build_window() -> void:
	var shadow := ColorRect.new()
	shadow.color = Color(0, 0, 0, 0.34)
	shadow.position = Vector2(6.0, 7.0)
	shadow.size = DEFAULT_SIZE
	add_child(shadow)

	var frame := NinePatchRect.new()
	frame.name = "Panel_PortalWindowFrame"
	frame.texture = frame_texture
	frame.patch_margin_left = 30
	frame.patch_margin_right = 30
	frame.patch_margin_top = 34
	frame.patch_margin_bottom = 30
	frame.position = Vector2.ZERO
	frame.size = DEFAULT_SIZE
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(frame)

	var title_plate := ColorRect.new()
	title_plate.name = "Panel_PortalTitlePlate"
	title_plate.color = Color("#761f1f")
	title_plate.position = Vector2(36.0, 17.0)
	title_plate.size = Vector2(DEFAULT_SIZE.x - 72.0, 44.0)
	add_child(title_plate)

	var title := Label.new()
	title.name = "Text_PortalTitle"
	title.text = "포탈"
	title.position = Vector2(0.0, 18.0)
	title.size = Vector2(DEFAULT_SIZE.x, 40.0)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 25)
	title.add_theme_color_override("font_color", Color("#ffcf7a"))
	title.add_theme_color_override("font_shadow_color", Color("#050302"))
	title.add_theme_constant_override("shadow_offset_x", 2)
	title.add_theme_constant_override("shadow_offset_y", 2)
	add_child(title)

	var close_button := Button.new()
	close_button.name = "Btn_PortalClose"
	close_button.tooltip_text = "닫기"
	close_button.flat = true
	close_button.position = Vector2(DEFAULT_SIZE.x - 54.0, 20.0)
	close_button.size = Vector2(42.0, 42.0)
	close_button.focus_mode = Control.FOCUS_ALL
	close_button.pressed.connect(func():
		close_requested.emit()
	)
	add_child(close_button)
	if close_texture != null:
		var close_icon := TextureRect.new()
		close_icon.name = "Icon_PortalClose"
		close_icon.texture = close_texture
		close_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		close_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		close_icon.position = Vector2(2.0, 3.0)
		close_icon.size = Vector2(38.0, 36.0)
		close_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		close_button.add_child(close_icon)
	else:
		close_button.text = "X"

	var difficulty := _make_panel(Color("#4a2f1a"), Color("#6b4a2a"), 2)
	difficulty.name = "Panel_DifficultySelect"
	difficulty.position = Vector2(82.0, 82.0)
	difficulty.size = Vector2(256.0, 40.0)
	add_child(difficulty)

	var difficulty_text := Label.new()
	difficulty_text.text = "Normal"
	difficulty_text.position = Vector2(0.0, 6.0)
	difficulty_text.size = Vector2(256.0, 28.0)
	difficulty_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	difficulty_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	difficulty_text.add_theme_font_size_override("font_size", 16)
	difficulty_text.add_theme_color_override("font_color", Color("#f3e6c8"))
	difficulty.add_child(difficulty_text)

	var tabs := HBoxContainer.new()
	tabs.name = "Tabs_Act"
	tabs.position = Vector2(42.0, 136.0)
	tabs.size = Vector2(336.0, 42.0)
	tabs.add_theme_constant_override("separation", 8)
	add_child(tabs)
	for act in range(1, 4):
		var tab := Button.new()
		tab.name = "Btn_Act%d" % act
		tab.text = "Act %d" % act
		tab.custom_minimum_size = Vector2(104.0, 40.0)
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab.add_theme_font_size_override("font_size", 14)
		tab.pressed.connect(_select_act.bind(act))
		tabs.add_child(tab)
		act_buttons.append(tab)

	var body_frame := NinePatchRect.new()
	body_frame.name = "Panel_PortalBodyWell"
	body_frame.texture = inner_texture
	body_frame.patch_margin_left = 22
	body_frame.patch_margin_right = 22
	body_frame.patch_margin_top = 22
	body_frame.patch_margin_bottom = 22
	body_frame.position = Vector2(24.0, 190.0)
	body_frame.size = Vector2(372.0, 286.0)
	body_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(body_frame)

	map_canvas = PortalMapCanvas.new()
	map_canvas.name = "Canvas_ParchmentRouteMap"
	map_canvas.position = Vector2(36.0, 202.0)
	map_canvas.size = Vector2(348.0, 260.0)
	add_child(map_canvas)

	region_label = Label.new()
	region_label.name = "Text_PortalRegion"
	region_label.position = Vector2(56.0, 212.0)
	region_label.size = Vector2(308.0, 28.0)
	region_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	region_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	region_label.add_theme_font_size_override("font_size", 16)
	region_label.add_theme_color_override("font_color", Color("#4a3219"))
	region_label.add_theme_color_override("font_shadow_color", Color("#f6e8ba"))
	region_label.add_theme_constant_override("shadow_offset_x", 1)
	region_label.add_theme_constant_override("shadow_offset_y", 1)
	add_child(region_label)

	_build_stage_buttons()


func _build_stage_buttons() -> void:
	for index in range(6):
		var button := Button.new()
		button.name = "Btn_StageNode%d" % (index + 1)
		button.custom_minimum_size = Vector2(50.0, 34.0)
		button.size = Vector2(50.0, 34.0)
		button.add_theme_font_size_override("font_size", 12)
		button.add_theme_color_override("font_color", Color("#f3e6c8"))
		button.add_theme_color_override("font_shadow_color", Color("#050302"))
		button.add_theme_constant_override("shadow_offset_x", 1)
		button.add_theme_constant_override("shadow_offset_y", 1)
		var point: Vector2 = map_canvas.route_points[index]
		button.position = map_canvas.position + point - Vector2(25.0, 17.0)
		add_child(button)
		stage_buttons.append(button)


func _select_act(act: int) -> void:
	selected_act = act
	current_stage = 1
	_sync_stage_state()


func _sync_stage_state() -> void:
	if region_label == null:
		return
	region_label.text = current_map_name
	var current_index := clampi(current_stage - 1, 0, stage_buttons.size() - 1)
	if map_canvas != null and map_canvas.has_method("set_current_index"):
		map_canvas.set_current_index(current_index)
	for index in range(stage_buttons.size()):
		var button := stage_buttons[index]
		button.text = "%d-%d" % [selected_act, index + 1]
		var is_current := index == current_index
		var is_locked := index > current_index + 1
		_apply_stage_button_style(button, is_current, is_locked)
	for index in range(act_buttons.size()):
		_apply_tab_button_style(act_buttons[index], index + 1 == selected_act)


func _apply_stage_button_style(button: Button, is_current: bool, is_locked: bool) -> void:
	var fill := Color("#5b3b1d")
	var border := Color("#b19155")
	var font := Color("#f3e6c8")
	if is_current:
		fill = Color("#1f7e3c")
		border = Color("#35d466")
	elif is_locked:
		fill = Color("#2e251b")
		border = Color("#6f6253")
		font = Color("#b79a72")
	button.disabled = is_locked
	button.add_theme_stylebox_override("normal", _round_style(fill, border, 3, 14))
	button.add_theme_stylebox_override("hover", _round_style(fill.lightened(0.12), Color("#ffcf7a"), 3, 14))
	button.add_theme_stylebox_override("pressed", _round_style(fill.darkened(0.12), border, 3, 14))
	button.add_theme_stylebox_override("disabled", _round_style(fill, border, 2, 14))
	button.add_theme_color_override("font_color", font)


func _apply_tab_button_style(button: Button, selected: bool) -> void:
	var fill := Color("#6b2a18") if selected else Color("#3a2215")
	var border := Color("#d18a24") if selected else Color("#6b4a2a")
	var style := _round_style(fill, border, 2, 2)
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", _round_style(fill.lightened(0.1), Color("#ffcf7a"), 2, 2))
	button.add_theme_stylebox_override("pressed", _round_style(fill.darkened(0.12), border, 2, 2))
	button.add_theme_color_override("font_color", Color("#ffcf7a") if selected else Color("#f3e6c8"))


func _make_panel(fill: Color, border: Color, border_width: int) -> Panel:
	var panel := Panel.new()
	panel.add_theme_stylebox_override("panel", _round_style(fill, border, border_width, 3))
	return panel


func _round_style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style


func _load_texture(res_path: String) -> Texture2D:
	var loaded = load(res_path)
	if loaded is Texture2D:
		return loaded
	var absolute_path := ProjectSettings.globalize_path(res_path)
	if not FileAccess.file_exists(absolute_path):
		return null
	var image := Image.new()
	if image.load(absolute_path) != OK:
		return null
	return ImageTexture.create_from_image(image)
