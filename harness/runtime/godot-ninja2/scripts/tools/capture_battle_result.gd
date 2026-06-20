extends SceneTree

const MainScene := preload("res://scripts/main.gd")

const VIEW_SIZE := Vector2i(540, 1016)
const CAPTURES := [
	{"result": "defeat", "path": "res://screenshots/godot-ninja2-result-defeat.png"},
	{"result": "clear", "path": "res://screenshots/godot-ninja2-result-clear.png"},
]


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var root := get_root()
	root.size = VIEW_SIZE
	DisplayServer.window_set_size(VIEW_SIZE)

	for capture in CAPTURES:
		var err := await _capture_variant(str(capture.get("result", "")), str(capture.get("path", "")))
		if err != OK:
			quit(1)
			return

	quit(0)


func _capture_variant(result: String, output_path: String) -> Error:
	var root := get_root()
	for child in root.get_children():
		child.queue_free()
	await process_frame

	var main := MainScene.new()
	main.set_battle_visual_fixture(true)
	main.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(main)

	await process_frame
	await process_frame
	main._start_battle(500101)

	for _i in range(20):
		await process_frame

	_force_result(main, result)
	main._sync_battle()

	await process_frame
	await process_frame

	var viewport_texture = root.get_texture()
	if viewport_texture == null:
		_fail("capture requires a non-headless renderer")
		return FAILED

	var image: Image = viewport_texture.get_image()
	if image == null or image.is_empty():
		_fail("capture produced an empty viewport image")
		return FAILED

	var output := ProjectSettings.globalize_path(output_path)
	var err := image.save_png(output)
	if err != OK:
		_fail("capture save failed: %s" % error_string(err))
		return err

	print("godot-ninja2 result capture: %s" % output)
	main.queue_free()
	await process_frame
	return OK


func _force_result(main: Control, result: String) -> void:
	var gains := {"gold": 1261, "wood": 195, "stone": 20, "soul": 16}
	for key in gains.keys():
		main.run_state.resources[key] = int(main.sim.run_start_resources.get(key, 0)) + int(gains[key])

	main.sim.elapsed = 34.0 if result == "defeat" else 91.0
	main.sim.kill_count = 37 if result == "defeat" else 88
	main.sim.running = false
	main.sim.result = result
	if result == "clear":
		main.sim.wave_index = max(0, main.sim.wave_plan.size() - 1)


func _fail(message: String) -> void:
	push_error(message)
