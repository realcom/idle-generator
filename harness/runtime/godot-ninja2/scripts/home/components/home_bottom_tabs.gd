extends Control

signal tab_selected(tab_key: String)

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")
const HOME_TAB_ROWS := [
	{"key": "sanctuary", "label": "성소", "texture": "home_tab_sanctuary"},
	{"key": "equipment", "label": "장비", "texture": "home_tab_equipment"},
	{"key": "exploration", "label": "탐험", "texture": "home_tab_exploration"},
	{"key": "missions", "label": "임무", "texture": "home_tab_mission"},
	{"key": "shop", "label": "상점", "texture": "home_tab_shop"},
]

var textures: Dictionary = {}
var tab_buttons: Dictionary = {}
var tab_edges: Dictionary = {}
var built := false


func setup(texture_table: Dictionary) -> void:
	textures = texture_table
	if not built:
		_build()
		built = true


func sync_active(active_tab: String) -> void:
	for key in tab_buttons.keys():
		var cell: PanelContainer = tab_buttons[key]
		var edges: Dictionary = tab_edges.get(key, {})
		cell.add_theme_stylebox_override("panel", HomeTheme.tab_segment_style(
			str(key) == active_tab,
			bool(edges.get("first", false)),
			bool(edges.get("last", false))
		))


func _build() -> void:
	position = Vector2(0, 700)
	size = Vector2(440, 82)

	var dock_bg := PanelContainer.new()
	dock_bg.position = Vector2.ZERO
	dock_bg.size = size
	dock_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dock_bg.add_theme_stylebox_override("panel", HomeTheme.tab_dock_style())
	add_child(dock_bg)

	var row := HBoxContainer.new()
	row.position = Vector2.ZERO
	row.size = size
	row.add_theme_constant_override("separation", 0)
	add_child(row)

	for index in range(HOME_TAB_ROWS.size()):
		var tab: Dictionary = HOME_TAB_ROWS[index]
		var key := str(tab.get("key", ""))
		var first := index == 0
		var last := index == HOME_TAB_ROWS.size() - 1
		var cell := Control.new()
		cell.custom_minimum_size = Vector2(88, 82)
		row.add_child(cell)

		var bg := PanelContainer.new()
		bg.position = Vector2.ZERO
		bg.size = Vector2(88, 82)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.add_theme_stylebox_override("panel", HomeTheme.tab_segment_style(false, first, last))
		cell.add_child(bg)

		if not first:
			var separator := ColorRect.new()
			separator.position = Vector2.ZERO
			separator.size = Vector2(1, 82)
			separator.color = Color(0.55, 0.40, 0.19, 0.38)
			separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
			cell.add_child(separator)

		var box := VBoxContainer.new()
		box.position = Vector2.ZERO
		box.size = Vector2(88, 82)
		box.alignment = BoxContainer.ALIGNMENT_CENTER
		box.add_theme_constant_override("separation", 2)
		cell.add_child(box)

		var icon := TextureRect.new()
		icon.texture = _texture(str(tab.get("texture", "")))
		icon.custom_minimum_size = Vector2(38, 36)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		box.add_child(icon)

		var label := Label.new()
		label.text = str(tab.get("label", ""))
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", Color(0.98, 0.87, 0.62))
		box.add_child(label)

		if key == "sanctuary" or key == "shop":
			var badge := Label.new()
			badge.text = "!"
			badge.position = Vector2(62, 8)
			badge.size = Vector2(18, 18)
			badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			badge.add_theme_font_size_override("font_size", 11)
			badge.add_theme_color_override("font_color", Color(1.0, 0.94, 0.70))
			badge.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.87, 0.16, 0.10, 0.96), Color(0.12, 0.05, 0.03, 0.95), 9, 2))
			cell.add_child(badge)

		var button := Button.new()
		button.position = Vector2.ZERO
		button.size = Vector2(88, 82)
		button.flat = true
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(func(): tab_selected.emit(key))
		cell.add_child(button)
		tab_buttons[key] = bg
		tab_edges[key] = {"first": first, "last": last}


func _texture(key: String) -> Texture2D:
	return textures.get(key)
