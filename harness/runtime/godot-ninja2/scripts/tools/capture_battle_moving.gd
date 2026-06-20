extends SceneTree

const MainScene := preload("res://scripts/main.gd")

const OUTPUT_PATH := "res://screenshots/godot-ninja2-battle-moving.png"
const VIEW_SIZE := Vector2i(540, 1016)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var root := get_root()
	root.size = VIEW_SIZE
	DisplayServer.window_set_size(VIEW_SIZE)

	var main := MainScene.new()
	main.set_battle_visual_fixture(true)
	main.set_battle_visual_fixture_motion(true)
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(main)

	await process_frame
	await process_frame
	main._start_battle(500101)

	for index in range(110):
		main.joystick_vector = Vector2(0.82, 0.28)
		if index == 42:
			main._request_dash("capture")
		await process_frame

	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("moving capture requires a non-headless renderer")
		return

	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("moving capture produced an empty viewport image")
		return

	var output := ProjectSettings.globalize_path(OUTPUT_PATH)
	var err := image.save_png(output)
	if err != OK:
		_fail("moving capture save failed: %s" % error_string(err))
		return

	print("godot-ninja2 moving battle capture: %s" % output)
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
