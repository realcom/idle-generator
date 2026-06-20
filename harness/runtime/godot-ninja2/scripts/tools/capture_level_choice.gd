extends SceneTree

const MainScene := preload("res://scripts/main.gd")

const OUTPUT_PATH := "res://screenshots/godot-ninja2-level-choice.png"
const VIEW_SIZE := Vector2i(540, 1016)


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

	for _i in range(24):
		await process_frame

	main.sim.kill_count = 18
	main.sim.elapsed = 28.0
	main.sim._queue_level_choice(2)
	main._sync_battle()

	await process_frame
	await process_frame

	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("capture requires a non-headless renderer")
		return

	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("capture produced an empty viewport image")
		return

	var output := ProjectSettings.globalize_path(OUTPUT_PATH)
	var err := image.save_png(output)
	if err != OK:
		_fail("capture save failed: %s" % error_string(err))
		return

	print("godot-ninja2 level choice capture: %s" % output)
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
