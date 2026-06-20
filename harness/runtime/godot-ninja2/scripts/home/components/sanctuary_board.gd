extends Control

signal building_selected(instance_id: String)

const HomeTheme := preload("res://scripts/home/components/home_theme.gd")
const BOARD_SIZE := Vector2(440, 782)
const BOARD_CENTER := Vector2(220, 318)
const HEX_SIZE := Vector2(86, 99)
const TILE_LAYOUT_SCALE := 0.88
const BUILDING_VISUAL_SCALE := 1.0

var housing
var sanctuary
var textures: Dictionary = {}
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
	for child in get_children():
		child.queue_free()

	var glow := ColorRect.new()
	glow.color = Color(0.83, 0.76, 0.39, 0.06)
	glow.position = BOARD_CENTER + Vector2(-160, -90) * TILE_LAYOUT_SCALE
	glow.size = Vector2(320, 230) * TILE_LAYOUT_SCALE
	add_child(glow)

	for tile in sanctuary.get_tiles():
		if typeof(tile) == TYPE_DICTIONARY:
			_add_hex(tile)

	for entry in sanctuary.building_entries(housing):
		if typeof(entry) == TYPE_DICTIONARY:
			_add_building(entry)


func _build() -> void:
	position = Vector2.ZERO
	size = BOARD_SIZE


func _add_hex(tile: Dictionary) -> void:
	var state: String = sanctuary.tile_render_state(tile)
	var texture_key := "home_hex_%s" % state
	if state == "built":
		texture_key = "home_hex_built"
	if state == "locked":
		texture_key = "home_hex_locked"
	if texture_key == "home_hex_expand":
		texture_key = "home_hex_empty"

	var center: Vector2 = _tile_center(tile)
	var hex_size := HEX_SIZE * TILE_LAYOUT_SCALE
	var hex := TextureRect.new()
	hex.texture = _texture(texture_key)
	hex.position = center - hex_size * 0.5
	hex.size = hex_size
	hex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hex.stretch_mode = TextureRect.STRETCH_SCALE
	var alpha := 0.82
	match state:
		"fog":
			alpha = 0.48
		"locked":
			alpha = 0.54
		"empty":
			alpha = 0.62
		"built":
			alpha = 0.78
	hex.modulate = Color(1, 1, 1, alpha)
	add_child(hex)

	if state == "fog" or state == "locked":
		var cost := int(tile.get("cost", 0))
		if cost > 0:
			var label := Label.new()
			label.text = str(cost)
			label.position = center + Vector2(-24, 8)
			label.size = Vector2(48, 22)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.add_theme_font_size_override("font_size", 14)
			label.add_theme_color_override("font_color", Color(0.12, 0.14, 0.08, 0.88))
			add_child(label)

	if state == "locked":
		var lock := TextureRect.new()
		lock.texture = HomeTheme.scaled_texture(_texture("home_icon_lock"), Vector2i(12, 12))
		lock.position = center + Vector2(-6, -2)
		lock.size = Vector2(12, 12)
		lock.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		lock.stretch_mode = TextureRect.STRETCH_SCALE
		lock.modulate = Color(1.0, 0.92, 0.62, 0.58)
		add_child(lock)


func _add_building(entry: Dictionary) -> void:
	var building: Dictionary = {}
	var instance: Dictionary = {}
	var raw_building = entry.get("building", {})
	var raw_instance = entry.get("instance", {})
	if typeof(raw_building) == TYPE_DICTIONARY:
		building = raw_building
	if typeof(raw_instance) == TYPE_DICTIONARY:
		instance = raw_instance

	var sprite_key := str(building.get("spriteKey", ""))
	var status := str(instance.get("status", "built"))
	var texture_key: String = housing.building_texture_key(building, instance)
	var building_size := Vector2(float(entry.get("w", 96.0)), float(entry.get("h", 96.0))) * BUILDING_VISUAL_SCALE
	var center := BOARD_CENTER + Vector2(float(entry.get("x", 0.0)), float(entry.get("y", 0.0))) * TILE_LAYOUT_SCALE
	var selected := str(instance.get("id", "")) == str(sanctuary.selected_building_instance_id)

	if selected:
		var marker := Line2D.new()
		var marker_width: float = max(54.0, building_size.x * 0.90)
		var marker_height: float = max(30.0, building_size.y * 0.46)
		var marker_center := center + Vector2(0, building_size.y * 0.18)
		marker.width = 2.0
		marker.closed = true
		marker.default_color = Color(0.26, 1.0, 0.82, 0.78)
		marker.add_point(marker_center + Vector2(-marker_width * 0.48, -marker_height * 0.10))
		marker.add_point(marker_center + Vector2(-marker_width * 0.24, -marker_height * 0.48))
		marker.add_point(marker_center + Vector2(marker_width * 0.24, -marker_height * 0.48))
		marker.add_point(marker_center + Vector2(marker_width * 0.48, -marker_height * 0.10))
		marker.add_point(marker_center + Vector2(marker_width * 0.24, marker_height * 0.48))
		marker.add_point(marker_center + Vector2(-marker_width * 0.24, marker_height * 0.48))
		add_child(marker)

	var sprite := TextureRect.new()
	sprite.texture = HomeTheme.scaled_texture(_texture(texture_key), Vector2i(int(round(building_size.x)), int(round(building_size.y))))
	sprite.position = center - building_size * 0.5
	sprite.size = building_size
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_SCALE
	sprite.modulate = Color(1, 1, 1, 0.90 if status == "constructing" else 1.0)
	add_child(sprite)

	var level := int(instance.get("level", 1))
	var bubble_text: String = housing.production_rate_label(building, level)
	if bubble_text == "":
		bubble_text = housing.primary_effect_label(building, level)
	_add_building_bubble(center + Vector2(-6, -building_size.y * 0.45), bubble_text)
	_add_level_badge(center + Vector2(0, building_size.y * 0.44), level, status, instance)

	var hit := Button.new()
	hit.position = center - building_size * 0.5
	hit.size = building_size
	hit.flat = true
	hit.focus_mode = Control.FOCUS_NONE
	hit.tooltip_text = str(building.get("name", "건물"))
	hit.pressed.connect(func(): building_selected.emit(str(instance.get("id", ""))))
	add_child(hit)


func _add_building_bubble(center: Vector2, text: String) -> void:
	if text == "":
		return
	var panel := PanelContainer.new()
	panel.position = center + Vector2(-32, -12)
	panel.size = Vector2(64, 22)
	panel.add_theme_stylebox_override("panel", HomeTheme.style(Color(0.95, 0.91, 0.72, 0.92), Color(0.18, 0.17, 0.10, 0.82), 10, 1))
	add_child(panel)

	var label := Label.new()
	label.text = text
	label.size = panel.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.13, 0.12, 0.06))
	panel.add_child(label)


func _add_level_badge(center: Vector2, level: int, status: String, instance: Dictionary) -> void:
	var label := Label.new()
	label.text = housing.construction_percent_label(instance) if status == "constructing" else "Lv.%d" % level
	label.position = center + Vector2(-23, -9)
	label.size = Vector2(46, 18)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(1.0, 0.94, 0.72))
	label.add_theme_stylebox_override("normal", HomeTheme.style(Color(0.08, 0.12, 0.08, 0.92), Color(0.05, 0.04, 0.03, 0.85), 6, 1))
	add_child(label)


func _texture(key: String) -> Texture2D:
	return textures.get(key)


func _tile_center(tile: Dictionary) -> Vector2:
	return BOARD_CENTER + sanctuary.hex_center(tile) * TILE_LAYOUT_SCALE
