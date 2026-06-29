extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-combat-smoke.png"
const REFERENCE_SIZE := Vector2i(1586, 992)
const COMPACT_COMBAT_SIZE := Vector2i(793, 236)
const COMPACT_COMBAT_ORIGIN := Vector2i(397, 704)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	Engine.time_scale = 4.0
	get_root().size = REFERENCE_SIZE
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(REFERENCE_SIZE)
	var scene: PackedScene = load("res://scenes/main.tscn")
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	if root_node is Control:
		var root_control := root_node as Control
		root_control.size = Vector2(REFERENCE_SIZE)
		root_control.custom_minimum_size = Vector2(REFERENCE_SIZE)
	get_root().add_child(root_node)

	for _i in range(230):
		await process_frame
		get_root().size = REFERENCE_SIZE

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var combat_image := image.get_region(Rect2i(COMPACT_COMBAT_ORIGIN, COMPACT_COMBAT_SIZE))
	var error := combat_image.save_png(absolute_path)
	Engine.time_scale = 1.0
	if error != OK:
		push_error("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		quit(1)
		return

	print("saved %s" % absolute_path)
	quit(0)
