extends SceneTree

const MainScene := preload("res://scripts/main.gd")

const OUTPUT_PATH := "res://screenshots/godot-ninja2-exp-pickups.png"
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
	main.set_process(false)

	var player_pos: Vector2 = main.sim._player_position()
	main.sim.pending_spawns.clear()
	main.sim.exp_pickups.clear()
	main.sim._spawn_exp_pickup(player_pos + Vector2(-170.0, -82.0), 3)
	main.sim._spawn_exp_pickup(player_pos + Vector2(154.0, -56.0), 4)
	main.sim._spawn_exp_pickup(player_pos + Vector2(-112.0, 128.0), 2)
	main.sim._spawn_exp_pickup(player_pos + Vector2(132.0, 132.0), 5)
	for pickup in main.sim.exp_pickups:
		var pickup_def: Dictionary = pickup
		pickup_def["age"] = 0.18
		pickup_def["armed"] = false

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

	print("godot-ninja2 exp pickup capture: %s" % output)
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
