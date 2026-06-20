extends SceneTree

const MainScene := preload("res://scripts/main.gd")

const OUTPUT_PATH := "res://screenshots/godot-ninja2-skill-fx-gallery.png"
const VIEW_SIZE := Vector2i(540, 1016)

const SKILL_IDS := [
	300101, 300102, 300103, 300104,
	300105, 300106, 300107, 300108,
	300109, 300110, 300111, 300112,
	300113, 300114, 300115, 300116,
]


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var root := get_root()
	root.size = VIEW_SIZE
	DisplayServer.window_set_size(VIEW_SIZE)

	var main := MainScene.new()
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(main)

	await process_frame
	await process_frame
	main._start_battle(500101)
	await process_frame
	_clean_battle_runtime(main)

	_spawn_gallery(main)
	for _index in range(7):
		await process_frame

	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("skill fx gallery capture requires a non-headless renderer")
		return

	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("skill fx gallery capture produced an empty viewport image")
		return

	var output := ProjectSettings.globalize_path(OUTPUT_PATH)
	var err := image.save_png(output)
	if err != OK:
		_fail("skill fx gallery capture failed: %s" % error_string(err))
		return

	print("godot-ninja2 skill fx gallery capture: %s" % output)
	quit(0)


func _spawn_gallery(main: Control) -> void:
	var left := 78.0
	var top := 166.0
	var step_x := 132.0
	var step_y := 150.0

	for index in range(SKILL_IDS.size()):
		var skill_id := int(SKILL_IDS[index])
		var col := index % 4
		var row := int(index / 4)
		var center := Vector2(left + float(col) * step_x, top + float(row) * step_y)
		var source := center + Vector2(-34.0, 18.0)
		var target := center + Vector2(34.0, -18.0)
		var family := str(main._skill_fx_family(skill_id))
		var color: Color = main._skill_fx_color(skill_id)
		var accent: Color = main._skill_fx_accent(skill_id)

		_add_label(main, center + Vector2(-48.0, 38.0), "%d" % skill_id)

		if skill_id == 300101 or family == "moonFlash" or family == "shadowClone":
			main._spawn_basic_slash_fx(source, target, color, skill_id, family)
		elif main._skill_fx_is_self_family(family):
			main._spawn_self_buff_fx_scene(center, skill_id, family, color, accent)
		elif family == "smokeBomb":
			main._spawn_projectile_fx_scene(source, [target], skill_id, family, color)
			main._spawn_ground_area_fx_scene(target, skill_id, family, 34.0, color, accent)
		elif main._skill_fx_is_ground_family(family):
			main._spawn_ground_area_fx_scene(target, skill_id, family, 34.0, color, accent)
			if family == "weakPointMark":
				main._spawn_projectile_fx_scene(source, [target], skill_id, family, color)
		elif main._skill_fx_is_projectile_family(family):
			main._spawn_projectile_fx_scene(source, [target, target + Vector2(10.0, 18.0)], skill_id, family, color)
		else:
			main._spawn_ground_area_fx_scene(target, skill_id, family, 26.0, color, accent)


func _clean_battle_runtime(main: Control) -> void:
	if main.sim != null:
		main.sim.running = false
		main.sim.entities.clear()
		main.sim.player_entity.clear()
	if main.entity_layer != null:
		main.entity_layer.visible = false
	if main.event_layer != null:
		main.event_layer.visible = false
	for line in main.threat_line_views:
		if line != null:
			line.visible = false


func _add_label(main: Control, position: Vector2, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.position = position
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.68))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.86))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	main.battle_screen.add_child(label)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
