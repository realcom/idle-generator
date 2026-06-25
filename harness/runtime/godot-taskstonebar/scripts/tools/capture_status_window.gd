extends SceneTree

const SCENE_PATH := "res://scenes/generated/status_window.tscn"
const OUTPUT_PATH := "res://screenshots/taskstonebar-status-window.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var background := ColorRect.new()
	background.color = Color("#d97642")
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_root().add_child(background)

	var packed: PackedScene = load(SCENE_PATH)
	if not (packed is PackedScene):
		_fail("status window scene is not a PackedScene")
		return

	var root_node := packed.instantiate()
	root_node.position = Vector2(72.0, 42.0)
	get_root().add_child(root_node)
	_style_status_window(root_node)

	for _i in range(30):
		await process_frame

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	if error != OK:
		_fail("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		return

	print("saved %s" % absolute_path)
	quit(0)


func _style_status_window(node: Node) -> void:
	if node is CanvasItem:
		(node as CanvasItem).texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if node is TextureRect:
		(node as TextureRect).mouse_filter = Control.MOUSE_FILTER_IGNORE
	if node is Label:
		var label := node as Label
		var font_size := int(node.get_meta("font_size", label.get_theme_font_size("font_size")))
		var is_stat_card_label := _is_inside_named(node, "Panel_StatusStatScroll")
		label.add_theme_font_size_override("font_size", font_size)
		if is_stat_card_label and str(node.name) != "Text_ClassName":
			label.add_theme_color_override("font_color", Color("#24170d"))
			label.add_theme_color_override("font_shadow_color", Color("#e3cf9e"))
			label.add_theme_constant_override("shadow_offset_x", 1)
			label.add_theme_constant_override("shadow_offset_y", 1)
		else:
			label.add_theme_color_override("font_color", _token(str(node.get_meta("color_token", "text_cream"))))
			label.add_theme_color_override("font_shadow_color", Color("#050302"))
			label.add_theme_constant_override("shadow_offset_x", 2)
			label.add_theme_constant_override("shadow_offset_y", 2)
	if node is PanelContainer:
		var token := str(node.get_meta("color_token", "panel_inner"))
		var border := Color("#6b4a2a")
		var fill := _token(token)
		if token == "text_muted" or token == "text_cream":
			border = fill
		(node as PanelContainer).add_theme_stylebox_override("panel", _style(fill, border, 2, 2))
	if node is Button:
		var button := node as Button
		var role := str(node.get_meta("button_role", "utility_icon"))
		button.flat = false
		var fill := Color("#2a1a10")
		var border := Color("#6b4a2a")
		if role == "window_close":
			fill = Color("#4a1610")
			border = Color("#d18a24")
		elif role == "utility_icon":
			fill = Color("#4a1f12")
			border = Color("#a76536")
		button.add_theme_stylebox_override("normal", _style(fill, border, 2, 2))
		button.add_theme_stylebox_override("hover", _style(fill.lightened(0.12), Color("#ffcf7a"), 2, 2))
		button.add_theme_stylebox_override("pressed", _style(fill.darkened(0.16), border, 2, 2))
		button.add_theme_color_override("font_color", Color("#ffcf7a"))
	for child in node.get_children():
		_style_status_window(child)


func _is_inside_named(node: Node, ancestor_name: String) -> bool:
	var current := node.get_parent()
	while current != null:
		if str(current.name) == ancestor_name:
			return true
		current = current.get_parent()
	return false


func _style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
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


func _token(token: String) -> Color:
	match token:
		"panel_outer":
			return Color("#6b4a2a")
		"panel_mid":
			return Color("#4a2f1a")
		"panel_inner":
			return Color("#1a0f06")
		"title_gold":
			return Color("#ffcf7a")
		"text_cream":
			return Color("#f3e6c8")
		"text_muted":
			return Color("#b79a72")
		"coin_gold":
			return Color("#ffd877")
		"hp_red":
			return Color("#c0392b")
		"exp_blue":
			return Color("#2e8fd0")
		"ruby_red":
			return Color("#d94b74")
		"moss_green":
			return Color("#6a8f42")
		"taskbar_ground":
			return Color("#3a2a18")
		"shadow":
			return Color("#050302")
	return Color(token) if token.begins_with("#") else Color("#f3e6c8")


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
