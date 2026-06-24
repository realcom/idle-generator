extends SceneTree

const MainScene := preload("res://scripts/main.gd")
const BATTLE_OUTPUT_PATH := "res://screenshots/dokkaebi-ingame-tangtang-haeil-core.png"
const LEVEL_CHOICE_OUTPUT_PATH := "res://screenshots/dokkaebi-ingame-level-choice.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var root := get_root()
	root.size = Vector2i(540, 960)
	DisplayServer.window_set_size(Vector2i(540, 960))
	var main := MainScene.new()
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	main.set_test_mode(true)
	root.add_child(main)
	await process_frame
	main.restart_run()
	main.inject_move(Vector2(0.6, 0.25))
	for _i in range(240):
		main._process(1.0 / 30.0)
	main.inject_move(Vector2.ZERO)
	var saved_level_choice := false
	for _i in range(520):
		main._process(1.0 / 30.0)
		if bool(main.debug_snapshot().get("choice_pending", false)):
			if not saved_level_choice:
				await process_frame
				await process_frame
				if not _save_viewport(LEVEL_CHOICE_OUTPUT_PATH):
					return
				saved_level_choice = true
			main.choose_card(0)
	for _i in range(80):
		main._process(1.0 / 30.0)
		if bool(main.debug_snapshot().get("choice_pending", false)):
			main.choose_card(0)
	_seed_unit_sprite_showcase(main)
	main.inject_move(Vector2(0.72, -0.18))
	for _i in range(18):
		main._process(1.0 / 30.0)
	if bool(main.debug_snapshot().get("choice_pending", false)):
		main.choose_card(0)
		for _i in range(12):
			main._process(1.0 / 30.0)
	await process_frame
	await process_frame
	if not _save_viewport(BATTLE_OUTPUT_PATH):
		return
	quit(0)


func _seed_unit_sprite_showcase(main: Control) -> void:
	if not main.has_method("_spawn_enemy"):
		return
	main._spawn_enemy("grunt", -2.65, 310.0)
	main._spawn_enemy("ghost", -1.35, 270.0)
	main._spawn_enemy("talisman_caster", 0.14, 300.0)
	main._spawn_enemy("night_ogre", 0.42, 300.0)


func _save_viewport(output_path: String) -> bool:
	var texture := get_root().get_texture()
	if texture == null:
		_fail("capture requires a non-headless renderer")
		return false
	var image := texture.get_image()
	if image == null or image.is_empty():
		_fail("empty capture image")
		return false
	var output := ProjectSettings.globalize_path(output_path)
	var err := image.save_png(output)
	if err != OK:
		_fail("capture save failed: %s" % error_string(err))
		return false
	print("godot-dokkaebi capture: %s" % output)
	return true


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
