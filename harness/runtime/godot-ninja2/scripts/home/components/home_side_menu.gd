extends VBoxContainer

signal quick_requested(view_key: String)

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")
const BUTTON_SIZE := Vector2(48, 52)
const ICON_SIZE := Vector2(28, 28)

var textures: Dictionary = {}
var built := false


func setup(texture_table: Dictionary) -> void:
	textures = texture_table
	if not built:
		_build()
		built = true


func _build() -> void:
	position = Vector2(10, 190)
	size = Vector2(50, 170)
	add_theme_constant_override("separation", 6)

	_add_side_button("home_icon_mail", "우편", "5", "mail")
	_add_side_button("home_icon_bag", "가방", "", "bag")
	_add_side_button("home_icon_pass", "패스", "", "pass")


func _add_side_button(texture_key: String, label_text: String, badge_text: String, view_key: String) -> void:
	var cell := Control.new()
	cell.custom_minimum_size = BUTTON_SIZE
	cell.size = BUTTON_SIZE
	add_child(cell)

	var panel := PanelContainer.new()
	panel.position = Vector2.ZERO
	panel.size = BUTTON_SIZE
	panel.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.87, 0.76, 0.52, 0.94), Color(0.15, 0.14, 0.09, 0.86), 8, 2))
	cell.add_child(panel)

	var icon := TextureRect.new()
	icon.texture = HomeTheme.scaled_texture(_texture(texture_key), Vector2i(28, 28))
	icon.position = Vector2(10, 4)
	icon.size = ICON_SIZE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_SCALE
	panel.add_child(icon)

	var label := Label.new()
	label.text = label_text
	label.position = Vector2(4, 34)
	label.size = Vector2(40, 14)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", Color(0.16, 0.10, 0.05))
	panel.add_child(label)

	var button := Button.new()
	button.position = Vector2.ZERO
	button.size = BUTTON_SIZE
	button.flat = true
	button.tooltip_text = label_text
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(func(): quick_requested.emit(view_key))
	cell.add_child(button)

	if badge_text == "":
		return

	var badge := Label.new()
	badge.text = badge_text
	badge.position = Vector2(35, -5)
	badge.size = Vector2(16, 16)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 9)
	badge.add_theme_color_override("font_color", Color(0.11, 0.07, 0.03))
	badge.add_theme_stylebox_override("normal", HomeTheme.style(Color(1.0, 0.78, 0.22, 1.0), Color(0.13, 0.08, 0.03), 8, 1))
	cell.add_child(badge)


func _texture(key: String) -> Texture2D:
	return textures.get(key)
