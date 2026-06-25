extends SceneTree

const OUTPUT_PATH := "res://screenshots/taskstonebar-full-ui-overlay.png"
const SCENE_PATH := "res://scenes/main.tscn"
const CAPTURE_SIZE := Vector2i(1586, 992)


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load(SCENE_PATH)
	if not (scene is PackedScene):
		push_error("failed to load main scene: %s" % SCENE_PATH)
		quit(1)
		return
	get_root().size = CAPTURE_SIZE
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(CAPTURE_SIZE)
	var root_node: Node = scene.instantiate()
	root_node.set("generated_visual_capture_mode", true)
	get_root().add_child(root_node)
	get_root().size = CAPTURE_SIZE
	for _i in range(90):
		await process_frame

	if root_node.get_node_or_null("GeneratedFullUiOverlay") == null:
		push_error("GeneratedFullUiOverlay was not added to the main scene")
		quit(1)
		return

	var absolute_path := ProjectSettings.globalize_path(OUTPUT_PATH)
	DirAccess.make_dir_recursive_absolute(absolute_path.get_base_dir())
	var image: Image = get_root().get_texture().get_image()
	var error := image.save_png(absolute_path)
	if error != OK:
		push_error("failed to save screenshot %s: %s" % [absolute_path, error_string(error)])
		quit(1)
		return

	print("saved %s" % absolute_path)
	quit(0)
