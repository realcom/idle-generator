extends "res://scripts/home/modals/base_modal.gd"

signal modal_action_requested(action: String, payload: Dictionary)

var store
var housing
var sanctuary
var textures: Dictionary = {}
var actions_connected := false
var ornaments_added := false


func setup_context(content_store, housing_store, sanctuary_state, texture_table: Dictionary, title: String, subtitle: String, modal_size := Vector2(380, 500)) -> void:
	store = content_store
	housing = housing_store
	sanctuary = sanctuary_state
	textures = texture_table
	setup_frame(title, subtitle, modal_size)
	if not ornaments_added:
		_add_frame_ornaments()
		ornaments_added = true
	if not actions_connected:
		action_requested.connect(_on_frame_action_requested)
		actions_connected = true


func _on_frame_action_requested(action: String) -> void:
	modal_action_requested.emit(action, {})


func _add_panel(parent: Control, panel_position: Vector2, panel_size: Vector2, fill := Color(0.18, 0.12, 0.07, 0.88), stroke := Color(0.74, 0.56, 0.30, 0.60), radius := 8) -> Control:
	var panel := PanelContainer.new()
	panel.position = panel_position
	panel.size = panel_size
	panel.add_theme_stylebox_override("panel", HomeTheme.style(fill, stroke, radius, 1))
	parent.add_child(panel)

	var content := Control.new()
	content.position = Vector2.ZERO
	content.size = panel_size
	panel.add_child(content)
	return content


func _add_label(parent: Control, label_position: Vector2, label_size: Vector2, text: String, font_size := 11, color := Color(0.15, 0.10, 0.06), align := HORIZONTAL_ALIGNMENT_LEFT, valign := VERTICAL_ALIGNMENT_TOP) -> Label:
	var label := Label.new()
	label.text = text
	label.position = label_position
	label.size = label_size
	label.horizontal_alignment = align
	label.vertical_alignment = valign
	if label_size.y >= float(font_size) * 2.0:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label


func _add_icon(parent: Control, texture_key: String, icon_position: Vector2, icon_size: Vector2, fallback_text := "") -> void:
	var texture: Texture2D = _texture(texture_key)
	if texture != null:
		var icon := TextureRect.new()
		icon.texture = HomeTheme.scaled_texture(texture, Vector2i(int(round(icon_size.x)), int(round(icon_size.y))))
		icon.position = icon_position
		icon.size = icon_size
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_SCALE
		parent.add_child(icon)
		return
	_add_label(parent, icon_position, icon_size, fallback_text, 14, Color(1.0, 0.88, 0.58), HORIZONTAL_ALIGNMENT_CENTER, VERTICAL_ALIGNMENT_CENTER)


func _add_action_button(parent: Control, button_position: Vector2, button_size: Vector2, text: String, action: String, payload := {}, disabled := false) -> Button:
	var button := Button.new()
	button.text = text
	button.position = button_position
	button.size = button_size
	button.disabled = disabled
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.60, 0.30, 0.08, 0.96), Color(1.0, 0.78, 0.32, 0.78), 8, 1))
	button.add_theme_stylebox_override("hover", HomeTheme.style(Color(0.72, 0.37, 0.10, 0.98), Color(1.0, 0.88, 0.50, 0.88), 8, 1))
	button.add_theme_stylebox_override("disabled", HomeTheme.style(Color(0.25, 0.21, 0.16, 0.82), Color(0.56, 0.48, 0.36, 0.50), 8, 1))
	button.pressed.connect(func(): modal_action_requested.emit(action, payload))
	parent.add_child(button)
	return button


func _add_progress(parent: Control, progress_position: Vector2, progress_size: Vector2, value: float, fill := Color(0.36, 0.78, 0.52)) -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.08, 0.05, 0.78)
	bg.position = progress_position
	bg.size = progress_size
	parent.add_child(bg)

	var bar := ColorRect.new()
	bar.color = fill
	bar.position = progress_position
	bar.size = Vector2(progress_size.x * clamp(value, 0.0, 1.0), progress_size.y)
	parent.add_child(bar)


func _add_frame_ornaments() -> void:
	_add_frame_sprite("home_modal_crest", Vector2(size.x * 0.5 - 54.0, -32.0), Vector2(108, 60))


func _add_frame_sprite(texture_key: String, sprite_position: Vector2, sprite_size: Vector2, flip_h := false, flip_v := false) -> void:
	var texture: Texture2D = _texture(texture_key)
	if texture == null:
		return
	var sprite := TextureRect.new()
	sprite.texture = HomeTheme.scaled_texture(texture, Vector2i(int(sprite_size.x), int(sprite_size.y)))
	sprite.position = sprite_position
	sprite.size = sprite_size
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_SCALE
	sprite.flip_h = flip_h
	sprite.flip_v = flip_v
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if frame_root == null:
		add_child(sprite)
		move_child(sprite, 0)
	else:
		frame_root.add_child(sprite)
		frame_root.move_child(sprite, 0)


func _format_number(value: int) -> String:
	if value >= 100000:
		return "%.0fK" % (float(value) / 1000.0)
	if value >= 2000:
		var text := "%.1fK" % (float(value) / 1000.0)
		return text.replace(".0K", "K")
	return str(value)


func _item_texture_key(item: Dictionary) -> String:
	var category := str(item.get("category", "")).to_lower()
	var item_type := str(item.get("type", ""))
	if category == "weapon":
		return "equip_Weapon"
	if textures.has("equip_%s" % item_type):
		return "equip_%s" % item_type
	return "equip_Weapon"


func _texture(key: String) -> Texture2D:
	return textures.get(key)
